"""Apply PDF /ActualText entries emitted by NextResume Typst components.

Typst renders info links as normal clickable content wrapped in PDF artifacts.
This tool converts those artifact wrappers into marked /Span blocks with
/ActualText while preserving the original drawing operators and annotations.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path

try:
    import pikepdf
except ImportError:  # pragma: no cover - exercised by users without deps
    pikepdf = None


ARTIFACT_RE = re.compile(rb"/Artifact\s+BMC")
MARKED_TOKEN_RE = re.compile(rb"/[A-Za-z0-9_.-]+\s+(?:BMC|BDC)|EMC")


@dataclass(frozen=True)
class ActualTextEntry:
    actual: str


def pdf_utf16be_hex(text: str) -> bytes:
    """Return a PDF hex string for UTF-16BE text with BOM."""

    return b"<" + (b"\xfe\xff" + text.encode("utf-16-be")).hex().upper().encode("ascii") + b">"


def load_manifest(path: Path) -> list[ActualTextEntry]:
    raw = json.loads(path.read_text(encoding="utf-8-sig"))
    entries: list[ActualTextEntry] = []
    for item in raw:
        value = item.get("value", {})
        actual = value.get("actual")
        if isinstance(actual, str) and actual:
            entries.append(ActualTextEntry(actual=actual))
    return entries


def find_marked_content_end(data: bytes, start: int) -> tuple[int, int]:
    depth = 0
    for match in MARKED_TOKEN_RE.finditer(data, start):
        token = match.group(0)
        if token.endswith(b"BMC") or token.endswith(b"BDC"):
            depth += 1
            continue
        if token == b"EMC":
            depth -= 1
            if depth == 0:
                return match.start(), match.end()
    raise ValueError("unterminated marked-content block")


def iter_artifact_blocks(data: bytes):
    for match in ARTIFACT_RE.finditer(data):
        end_start, end_end = find_marked_content_end(data, match.start())
        yield match.start(), match.end(), end_start, end_end


def is_text_artifact(body: bytes) -> bool:
    # ActualText wrappers contain text drawing. Decorative SVG/footer artifacts
    # are path/XObject content and should remain untouched. Nested decorative
    # text artifacts are skipped after their outer semantic span is consumed.
    return b"BT" in body and b"ET" in body


def rewrite_stream(data: bytes, entries: list[ActualTextEntry], start_index: int) -> tuple[bytes, int]:
    if not entries or b"/Artifact" not in data:
        return data, start_index

    chunks: list[bytes] = []
    cursor = 0
    index = start_index

    for block_start, body_start, body_end, block_end in iter_artifact_blocks(data):
        if block_start < cursor:
            continue
        if index >= len(entries):
            break

        body = data[body_start:body_end]
        if not is_text_artifact(body):
            continue

        actual = pdf_utf16be_hex(entries[index].actual)
        header = b"/Span <<\n  /ActualText " + actual + b"\n>> BDC"
        chunks.append(data[cursor:block_start])
        chunks.append(header)
        chunks.append(body)
        chunks.append(data[body_end:block_end])
        cursor = block_end
        index += 1

    if not chunks:
        return data, start_index

    chunks.append(data[cursor:])
    return b"".join(chunks), index


def apply_actual_text(input_pdf: Path, manifest: Path, output_pdf: Path) -> int:
    if pikepdf is None:
        print(
            "pikepdf is required. Install with: python -m pip install -r tools/requirements.txt",
            file=sys.stderr,
        )
        return 2

    entries = load_manifest(manifest)
    if not entries:
        raise RuntimeError(f"no nextresume-actualtext entries found in {manifest}")

    rewritten = 0
    with pikepdf.Pdf.open(input_pdf) as pdf:
        for obj in pdf.objects:
            if rewritten >= len(entries):
                break
            if not isinstance(obj, pikepdf.Stream):
                continue
            try:
                data = obj.read_bytes()
            except Exception:
                continue
            new_data, rewritten = rewrite_stream(data, entries, rewritten)
            if new_data != data:
                obj.write(new_data)

        if rewritten != len(entries):
            raise RuntimeError(
                f"rewrote {rewritten} ActualText spans, but manifest contains {len(entries)} entries"
            )

        output_pdf.parent.mkdir(parents=True, exist_ok=True)
        pdf.save(output_pdf)

    return 0


def self_test() -> int:
    entries = [ActualTextEntry("Repository: https://example.com/repo")]
    source = b"/Artifact BMC\n/Artifact BMC\nBT\n(i) Tj\nET\nEMC\nBT\n(aaa) Tj\nET\nEMC\n"
    rewritten, count = rewrite_stream(source, entries, 0)
    expected = (
        b"/Span <<\n  /ActualText "
        + pdf_utf16be_hex(entries[0].actual)
        + b"\n>> BDC"
        b"\n/Artifact BMC\nBT\n(i) Tj\nET\nEMC\nBT\n(aaa) Tj\nET\nEMC\n"
    )
    if count != 1 or rewritten != expected:
        print("ActualText fixture rewrite failed", file=sys.stderr)
        print(rewritten, file=sys.stderr)
        return 1
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, help="Raw Typst PDF")
    parser.add_argument("--manifest", type=Path, help="JSON from typst query")
    parser.add_argument("--output", type=Path, help="Post-processed PDF")
    parser.add_argument("--self-test", action="store_true", help="Run the stream rewrite fixture test")
    args = parser.parse_args(argv)

    if args.self_test:
        return self_test()

    if not args.input or not args.manifest or not args.output:
        parser.error("--input, --manifest, and --output are required unless --self-test is used")

    return apply_actual_text(args.input, args.manifest, args.output)


if __name__ == "__main__":
    raise SystemExit(main())
