#!/usr/bin/env python
"""Post-process Typst-generated PDFs for resume-specific accessibility fixes.

This tool keeps the Typst-side metadata contract and replaces the original
certification pill row with a row-level overlay workflow:

1. Query row metadata from Typst.
2. Snapshot the visible certification pills.
3. Redact the original row content from the PDF text layer.
4. Reinsert the visible pills as an image.
5. Insert one invisible replacement string for extraction and wrap it with
   PDF `/ActualText`.
"""

from __future__ import annotations

import argparse
import json
import logging
import re
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path

import fitz


LOGGER = logging.getLogger("next_resume_postprocess")

ACTUAL_TEXT_SELECTOR = "<next-resume-actual-text>"
WATCH_POLL_SECONDS = 1.0
ROW_RENDER_DPI = 300
ROW_PADDING_PT = 1.0
REPLACEMENT_FONT_SIZE = 6.0
PT_SUFFIX = "pt"
EMPTY_PATCH_WRAPPER_RE = re.compile(
    r"/Span\s*<<\s*/ActualText\s*<[^>]*>\s*/NextResumeID\s*\([^)]*\)\s*>>\s*BDC\s*q\s*Q\s*EMC\s*",
    re.DOTALL,
)


@dataclass(frozen=True)
class ActualTextRow:
    page_number: int
    row_id: str
    actual_text: str
    anchor_id: str


@dataclass(frozen=True)
class ActualTextTarget:
    page_number: int
    target_id: str
    row_id: str
    x: float
    y: float
    width: float
    height: float


class PostProcessError(RuntimeError):
    """Raised when the PDF cannot be processed safely."""


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Post-process a Typst-generated resume PDF for ActualText.",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Enable debug logging.",
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    process_parser = subparsers.add_parser(
        "process",
        help="Process an already-built PDF once.",
    )
    _add_shared_pdf_arguments(process_parser)
    process_parser.add_argument(
        "--in-place",
        action="store_true",
        help="Overwrite the input PDF in place. Required in v1.",
    )

    watch_parser = subparsers.add_parser(
        "watch",
        help="Watch a built PDF and rerun post-processing when it changes.",
    )
    _add_shared_pdf_arguments(watch_parser)

    return parser


def _add_shared_pdf_arguments(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--document",
        required=True,
        choices=("cv",),
        help="Named document profile. Only 'cv' is supported in v1.",
    )
    parser.add_argument(
        "--pdf",
        required=True,
        type=Path,
        help="Path to the built PDF to mutate.",
    )
    parser.add_argument(
        "--input",
        action="append",
        default=[],
        metavar="key=value",
        help="Forward a Typst sys.input value to `typst query`. Repeat as needed.",
    )


def configure_logging(verbose: bool) -> None:
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(level=level, format="%(levelname)s %(message)s")


def workspace_root() -> Path:
    return Path(__file__).resolve().parent.parent


def typst_source_for(document: str) -> Path:
    if document == "cv":
        return workspace_root() / "cv.typ"
    raise PostProcessError(f"Unsupported document profile: {document}")


def parse_pt(value: object, field_name: str) -> float:
    if not isinstance(value, str) or not value.endswith(PT_SUFFIX):
        raise PostProcessError(f"Expected `{field_name}` in pt units, got {value!r}.")

    try:
        return float(value[: -len(PT_SUFFIX)])
    except ValueError as error:
        raise PostProcessError(f"Expected `{field_name}` in pt units, got {value!r}.") from error


def query_actual_text_metadata(
    document: str,
    typst_inputs: list[str],
) -> tuple[list[ActualTextRow], dict[str, ActualTextTarget]]:
    source_path = typst_source_for(document)
    root = workspace_root()
    font_path = root / "fonts"

    command = [
        "typst",
        "query",
        str(source_path),
        ACTUAL_TEXT_SELECTOR,
        "--format",
        "json",
        "--root",
        str(root),
    ]

    if font_path.exists():
        command.extend(["--font-path", str(font_path)])

    for item in typst_inputs:
        command.extend(["--input", item])

    LOGGER.debug("Running Typst query: %s", command)
    result = subprocess.run(
        command,
        capture_output=True,
        text=True,
        check=False,
    )

    if result.returncode != 0:
        raise PostProcessError(
            "typst query failed:\n"
            + (result.stderr.strip() or result.stdout.strip() or "Unknown Typst error.")
        )

    try:
        payload = json.loads(result.stdout)
    except json.JSONDecodeError as error:
        raise PostProcessError(f"Failed to parse typst query output: {error}") from error

    rows: list[ActualTextRow] = []
    targets: dict[str, ActualTextTarget] = {}
    for entry in payload:
        value = entry.get("value")
        if not isinstance(value, dict):
            raise PostProcessError("Expected metadata query results to contain dictionary values.")

        kind = value.get("kind")
        if kind == "actual-text-row":
            row_id = value.get("id")
            actual_text = value.get("actual")
            anchor_id = value.get("anchor_id")
            if not isinstance(row_id, str) or not isinstance(actual_text, str) or not isinstance(anchor_id, str):
                raise PostProcessError(
                    "Each actual-text row metadata entry must include string `id`, `actual`, and `anchor_id`."
                )

            rows.append(
                ActualTextRow(
                    page_number=-1,
                    row_id=row_id,
                    actual_text=actual_text,
                    anchor_id=anchor_id,
                )
            )
            continue

        if kind != "actual-text-target":
            continue

        target_id = value.get("id")
        row_id = value.get("row_id")
        page = value.get("page")
        if not isinstance(target_id, str) or not isinstance(row_id, str):
            raise PostProcessError("Each actual-text target metadata entry must include string `id` and `row_id`.")
        if not isinstance(page, int):
            raise PostProcessError("Each actual-text target metadata entry must include integer `page`.")

        targets[target_id] = ActualTextTarget(
            page_number=page - 1,
            target_id=target_id,
            row_id=row_id,
            x=parse_pt(value.get("x"), "x"),
            y=parse_pt(value.get("y"), "y"),
            width=parse_pt(value.get("width"), "width"),
            height=parse_pt(value.get("height"), "height"),
        )

    for index, row in enumerate(rows):
        anchor = targets.get(row.anchor_id)
        if anchor is None:
            raise PostProcessError(
                f"Missing anchor target {row.anchor_id!r} for actual-text row {row.row_id!r}."
            )
        rows[index] = ActualTextRow(
            page_number=anchor.page_number,
            row_id=row.row_id,
            actual_text=row.actual_text,
            anchor_id=row.anchor_id,
        )

    if not rows:
        LOGGER.info("No actual-text metadata targets were returned by `typst query`.")

    return rows, targets


def actual_text_hex(value: str) -> str:
    encoded = value.encode("utf-16-be")
    return ("FEFF" + encoded.hex()).upper()


def pdf_literal_string(value: str) -> str:
    return value.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)")


def row_targets_for(
    *,
    page_number: int,
    row_id: str,
    targets: dict[str, ActualTextTarget],
) -> list[ActualTextTarget]:
    row_targets = [
        target
        for target in targets.values()
        if target.page_number == page_number and target.row_id == row_id
    ]
    if not row_targets:
        raise PostProcessError(
            f"No visible targets were returned for actual-text row {row_id!r} on page {page_number + 1}."
        )
    return sorted(row_targets, key=lambda target: (target.y, target.x))


def row_rect_for_targets(page: fitz.Page, row_targets: list[ActualTextTarget]) -> fitz.Rect:
    x0 = min(target.x for target in row_targets) - ROW_PADDING_PT
    y0 = min(target.y - target.height for target in row_targets) - ROW_PADDING_PT
    x1 = max(target.x + target.width for target in row_targets) + ROW_PADDING_PT
    y1 = max(target.y for target in row_targets) + ROW_PADDING_PT

    rect = fitz.Rect(x0, y0, x1, y1)
    page_rect = page.rect
    return fitz.Rect(
        max(rect.x0, page_rect.x0),
        max(rect.y0, page_rect.y0),
        min(rect.x1, page_rect.x1),
        min(rect.y1, page_rect.y1),
    )


def render_row_snapshot(page: fitz.Page, row_rect: fitz.Rect) -> bytes:
    pixmap = page.get_pixmap(clip=row_rect, dpi=ROW_RENDER_DPI, alpha=False)
    return pixmap.tobytes("png")


def redact_row(page: fitz.Page, row_rect: fitz.Rect) -> None:
    page.add_redact_annot(
        row_rect,
        fill=(1, 1, 1),
        cross_out=False,
    )
    page.apply_redactions(
        images=fitz.PDF_REDACT_IMAGE_NONE,
        graphics=fitz.PDF_REDACT_LINE_ART_NONE,
        text=fitz.PDF_REDACT_TEXT_REMOVE,
    )


def cleanup_empty_patch_wrappers(doc: fitz.Document, page: fitz.Page) -> None:
    for xref in page.get_contents():
        stream_bytes = doc.xref_stream(xref)
        if not stream_bytes:
            continue

        stream = stream_bytes.decode("latin1")
        cleaned_stream, count = EMPTY_PATCH_WRAPPER_RE.subn("", stream)
        if count > 0:
            doc.update_stream(xref, cleaned_stream.encode("latin1"))


def insert_row_snapshot(page: fitz.Page, row_rect: fitz.Rect, image_bytes: bytes) -> None:
    page.insert_image(row_rect, stream=image_bytes, overlay=True)


def insert_replacement_stream(
    doc: fitz.Document,
    page: fitz.Page,
    row_rect: fitz.Rect,
    actual_text: str,
    row_id: str,
) -> None:
    before = list(page.get_contents())
    baseline = fitz.Point(row_rect.x0 + 0.5, row_rect.y1 - 1.5)
    page.insert_text(
        baseline,
        actual_text,
        fontsize=REPLACEMENT_FONT_SIZE,
        fontname="helv",
        render_mode=3,
        overlay=True,
    )
    after = list(page.get_contents())

    new_xrefs = [xref for xref in after if xref not in before]
    if len(new_xrefs) != 1:
        raise PostProcessError(
            f"Expected one new replacement text stream on page {page.number + 1}, found {len(new_xrefs)}."
        )

    xref = new_xrefs[0]
    stream_bytes = doc.xref_stream(xref)
    if not stream_bytes:
        raise PostProcessError(f"Inserted replacement stream xref {xref} is empty.")

    stream = stream_bytes.decode("latin1").rstrip()
    wrapped_stream = (
        "/Span << /ActualText <"
        + actual_text_hex(actual_text)
        + "> /NextResumeID ("
        + pdf_literal_string(row_id)
        + ") >> BDC\n"
        + stream
        + "\nEMC\n"
    )
    doc.update_stream(xref, wrapped_stream.encode("latin1"))


def process_row(
    doc: fitz.Document,
    page: fitz.Page,
    row: ActualTextRow,
    targets: dict[str, ActualTextTarget],
) -> None:
    row_targets = row_targets_for(
        page_number=page.number,
        row_id=row.row_id,
        targets=targets,
    )
    row_rect = row_rect_for_targets(page, row_targets)
    snapshot_bytes = render_row_snapshot(page, row_rect)

    redact_row(page, row_rect)
    cleanup_empty_patch_wrappers(doc, page)
    insert_row_snapshot(page, row_rect, snapshot_bytes)
    insert_replacement_stream(doc, page, row_rect, row.actual_text, row.row_id)


def process_pdf(document: str, pdf_path: Path, typst_inputs: list[str]) -> bool:
    if not pdf_path.exists():
        raise PostProcessError(f"PDF not found: {pdf_path}")

    rows, targets = query_actual_text_metadata(document, typst_inputs)
    if not rows:
        return False

    fitz.TOOLS.set_small_glyph_heights(True)

    with fitz.open(pdf_path) as doc:
        for row in rows:
            if not 0 <= row.page_number < doc.page_count:
                raise PostProcessError(
                    f"Row {row.row_id!r} references page {row.page_number + 1}, "
                    f"but the PDF only has {doc.page_count} page(s)."
                )

        pages_to_rows: dict[int, list[ActualTextRow]] = {}
        for row in rows:
            pages_to_rows.setdefault(row.page_number, []).append(row)

        for page_number, page_rows in sorted(pages_to_rows.items()):
            page = doc[page_number]
            LOGGER.info("Processing %s actual-text row(s) on page %s.", len(page_rows), page_number + 1)
            for row in sorted(page_rows, key=lambda item: item.row_id):
                process_row(doc, page, row, targets)

        doc.saveIncr()
        return True


def wait_for_ready_file(pdf_path: Path) -> None:
    last_error: OSError | None = None
    for _ in range(20):
        try:
            with pdf_path.open("rb"):
                return
        except OSError as error:
            last_error = error
            time.sleep(0.25)

    raise PostProcessError(f"PDF is not ready for reading: {pdf_path} ({last_error})")


def watch_pdf(document: str, pdf_path: Path, typst_inputs: list[str]) -> None:
    LOGGER.info("Watching %s for updates.", pdf_path)
    last_signature: tuple[int, int] | None = None

    while True:
        try:
            stat = pdf_path.stat()
            signature = (stat.st_mtime_ns, stat.st_size)
            if signature != last_signature:
                last_signature = signature
                wait_for_ready_file(pdf_path)
                changed = process_pdf(document, pdf_path, typst_inputs)
                if changed:
                    postprocess_stat = pdf_path.stat()
                    last_signature = (postprocess_stat.st_mtime_ns, postprocess_stat.st_size)
                    LOGGER.info("Post-processed %s.", pdf_path.name)
        except KeyboardInterrupt:
            LOGGER.info("Stopping watch mode.")
            return
        except FileNotFoundError:
            LOGGER.debug("Waiting for %s to appear.", pdf_path)
        except PostProcessError as error:
            LOGGER.error("%s", error)
        except Exception:
            LOGGER.exception("Unexpected failure while watching %s.", pdf_path)

        time.sleep(WATCH_POLL_SECONDS)


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)
    configure_logging(args.verbose)

    pdf_path = args.pdf.resolve()

    try:
        if args.command == "process":
            if not args.in_place:
                raise PostProcessError("v1 only supports --in-place output.")
            changed = process_pdf(args.document, pdf_path, args.input)
            return 0 if changed or pdf_path.exists() else 1

        if args.command == "watch":
            watch_pdf(args.document, pdf_path, args.input)
            return 0
    except PostProcessError as error:
        LOGGER.error("%s", error)
        return 1

    parser.error(f"Unsupported command: {args.command}")
    return 2


if __name__ == "__main__":
    sys.exit(main())
