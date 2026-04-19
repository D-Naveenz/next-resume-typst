#!/usr/bin/env python
"""Post-process Typst-generated PDFs for resume-specific accessibility fixes.

This v1 tool only supports the CV output and only rewrites the certification
pill row in the Skills section. Geometry and replacement text are queried from
Typst metadata, and the processor patches `/ActualText` directly onto the
original certification text spans in the PDF content stream.
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
REGION_PADDING = 0.75
WATCH_POLL_SECONDS = 1.0
PT_RE = re.compile(r"^(?P<value>-?\d+(?:\.\d+)?)pt$")
NEXT_RESUME_ID_RE = re.compile(rb"/NextResumeID\s*\((?P<id>(?:\\.|[^\\)])*)\)")
SPAN_BLOCK_RE = re.compile(
    r"(?P<full>"
    r"/Span\s*<<(?P<dict_body>.*?)>>\s*BDC"
    r"(?P<body>.*?)"
    r"EMC)",
    re.DOTALL,
)


@dataclass(frozen=True)
class ActualTextRegion:
    page_number: int
    marker_id: str
    actual_text: str
    rect: fitz.Rect
    marker_x: float
    marker_y: float
    marker_height: float


class PostProcessError(RuntimeError):
    """Raised when the PDF cannot be processed safely."""


def required_str_group(match: re.Match[str], name: str) -> str:
    value = match.group(name)
    if value is None:
        raise PostProcessError(f"Expected regex group {name!r} to be present.")
    return value


def required_bytes_group(match: re.Match[bytes], name: str) -> bytes:
    value = match.group(name)
    if value is None:
        raise PostProcessError(f"Expected regex group {name!r} to be present.")
    return value


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
    if not isinstance(value, str):
        raise PostProcessError(f"Expected `{field_name}` to be a Typst length string.")

    match = PT_RE.match(value)
    if not match:
        raise PostProcessError(f"Expected `{field_name}` in pt units, got {value!r}.")

    return float(match.group("value"))


def query_actual_text_regions(document: str, typst_inputs: list[str]) -> list[ActualTextRegion]:
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

    regions: list[ActualTextRegion] = []
    for entry in payload:
        value = entry.get("value")
        if not isinstance(value, dict):
            raise PostProcessError("Expected metadata query results to contain dictionary values.")

        if value.get("kind") != "actual-text":
            continue

        marker_id = value.get("id")
        actual_text = value.get("actual")
        page = value.get("page")
        if not isinstance(marker_id, str) or not isinstance(actual_text, str):
            raise PostProcessError("Each actual-text metadata entry must include string `id` and `actual`.")
        if not isinstance(page, int):
            raise PostProcessError("Each actual-text metadata entry must include integer `page`.")

        x = parse_pt(value.get("x"), "x")
        y = parse_pt(value.get("y"), "y")
        width = parse_pt(value.get("width"), "width")
        height = parse_pt(value.get("height"), "height")
        rect = fitz.Rect(
            x - REGION_PADDING,
            y - height - REGION_PADDING,
            x + width + REGION_PADDING,
            y + REGION_PADDING,
        )

        regions.append(
            ActualTextRegion(
                page_number=page - 1,
                marker_id=marker_id,
                actual_text=actual_text,
                rect=rect,
                marker_x=x,
                marker_y=y,
                marker_height=height,
            )
        )

    if not regions:
        LOGGER.info("No actual-text metadata targets were returned by `typst query`.")

    return regions


def actual_text_hex(value: str) -> str:
    encoded = value.encode("utf-16-be")
    return ("FEFF" + encoded.hex()).upper()


def pdf_literal_string(value: str) -> bytes:
    escaped = value.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)")
    return escaped.encode("utf-8")


def decode_pdf_literal(value: bytes) -> str:
    text = value.decode("utf-8")
    return text.replace("\\)", ")").replace("\\(", "(").replace("\\\\", "\\")


def existing_processed_ids(doc: fitz.Document) -> set[str]:
    found: set[str] = set()
    for xref in range(1, doc.xref_length()):
        try:
            data = doc.xref_stream(xref)
        except Exception:
            continue
        if not data:
            continue
        for match in NEXT_RESUME_ID_RE.finditer(data):
            found.add(decode_pdf_literal(required_bytes_group(match, "id")))
    return found


def wrap_original_text_spans(doc: fitz.Document, page: fitz.Page, regions: list[ActualTextRegion]) -> bool:
    content_xrefs = list(page.get_contents())
    if len(content_xrefs) != 1:
        raise PostProcessError(
            f"Expected one raw content stream on page {page.number + 1}, found {len(content_xrefs)}."
        )

    xref = content_xrefs[0]
    original_bytes = doc.xref_stream(xref)
    if not original_bytes:
        raise PostProcessError(f"Content stream xref {xref} is empty.")

    stream = original_bytes.decode("latin1")
    matches = list(SPAN_BLOCK_RE.finditer(stream))
    if not matches:
        raise PostProcessError(f"No candidate text spans found on page {page.number + 1}.")

    page_height = float(page.rect.height)
    replacements: list[tuple[int, int, str]] = []
    used_match_indexes: set[int] = set()

    for region in regions:
        expected_x = region.marker_x + 4.5
        expected_y_min = page_height - region.marker_y - 1.0
        expected_y_max = page_height - region.marker_y + region.marker_height + 1.0

        best_index: int | None = None
        best_distance: float | None = None

        for index, match in enumerate(matches):
            if index in used_match_indexes:
                continue
            dict_body = required_str_group(match, "dict_body")
            if "/ActualText" in dict_body or "/NextResumeID" in dict_body:
                continue
            body = required_str_group(match, "body")
            if " TJ" not in body and "\nTJ" not in body:
                continue

            position_match = re.search(
                r"1 0 0 -1\s+(?P<x>\d+\.\d+)\s+(?P<y>\d+\.\d+)\s+cm",
                body,
            )
            if position_match is None:
                continue

            x = float(required_str_group(position_match, "x"))
            y = float(required_str_group(position_match, "y"))
            if not (expected_y_min <= y <= expected_y_max):
                continue

            distance = abs(x - expected_x)
            if distance > 2.0:
                continue

            if best_distance is None or distance < best_distance:
                best_index = index
                best_distance = distance

        if best_index is None:
            raise PostProcessError(
                f"Could not find the original text span for marker {region.marker_id!r} "
                f"on page {page.number + 1}."
            )

        used_match_indexes.add(best_index)
        match = matches[best_index]
        dict_body = required_str_group(match, "dict_body").rstrip()
        if dict_body and not dict_body.endswith("/"):
            dict_body = dict_body + " "

        replacement = required_str_group(match, "full").replace(
            required_str_group(match, "dict_body"),
            dict_body
            + "/ActualText <"
            + actual_text_hex(region.actual_text)
            + "> /NextResumeID ("
            + pdf_literal_string(region.marker_id).decode("utf-8")
            + ") ",
            1,
        )
        replacements.append((match.start("full"), match.end("full"), replacement))

    if not replacements:
        return False

    updated_parts: list[str] = []
    cursor = 0
    for start, end, replacement in sorted(replacements, key=lambda item: item[0]):
        updated_parts.append(stream[cursor:start])
        updated_parts.append(replacement)
        cursor = end
    updated_parts.append(stream[cursor:])

    updated_stream = "".join(updated_parts).encode("latin1")
    doc.update_stream(xref, updated_stream)
    return True


def process_pdf(document: str, pdf_path: Path, typst_inputs: list[str]) -> bool:
    if not pdf_path.exists():
        raise PostProcessError(f"PDF not found: {pdf_path}")

    regions = query_actual_text_regions(document, typst_inputs)
    if not regions:
        return False

    temp_path: Path | None = None
    with fitz.open(pdf_path) as doc:
        processed_ids = existing_processed_ids(doc)
        pending = [region for region in regions if region.marker_id not in processed_ids]
        if not pending:
            LOGGER.info("No pending actual-text regions found; assuming the PDF is already processed.")
            return False

        for region in pending:
            if not 0 <= region.page_number < doc.page_count:
                raise PostProcessError(
                    f"Marker {region.marker_id!r} references page {region.page_number + 1}, "
                    f"but the PDF only has {doc.page_count} page(s)."
                )
        changed = False
        pages_to_regions: dict[int, list[ActualTextRegion]] = {}
        for region in pending:
            pages_to_regions.setdefault(region.page_number, []).append(region)

        for page_number, page_regions in pages_to_regions.items():
            page = doc[page_number]
            LOGGER.info("Processing %s marker(s) on page %s.", len(page_regions), page_number + 1)
            changed = wrap_original_text_spans(doc, page, page_regions) or changed

        if changed:
            doc.saveIncr()
        return changed
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
