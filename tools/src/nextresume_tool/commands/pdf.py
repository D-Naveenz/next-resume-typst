"""PDF helpers for NextResume."""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path

import pikepdf

from nextresume_tool.host.app import AppContext

ARTIFACT_RE = re.compile(rb"/Artifact\s+BMC")
MARKED_TOKEN_RE = re.compile(rb"/[A-Za-z0-9_.-]+\s+(?:BMC|BDC)|EMC")


@dataclass(frozen=True)
class ActualTextEntry:
    actual: str


def pdf_utf16be_hex(text: str) -> bytes:
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


def apply_actual_text(input_pdf: Path, manifest: Path, output_pdf: Path, ctx: AppContext) -> None:
    entries = load_manifest(manifest)
    if not entries:
        raise RuntimeError(f"No nextresume-actualtext entries found in {manifest}")

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
                f"Rewrote {rewritten} ActualText spans, but manifest contains {len(entries)} entries"
            )

        output_pdf.parent.mkdir(parents=True, exist_ok=True)
        pdf.save(output_pdf)

    ctx.logger.info("Wrote %s", output_pdf)


def inspect_pdf(path: Path, ctx: AppContext) -> None:
    with pikepdf.Pdf.open(path) as pdf:
        ctx.logger.info("PDF: %s", path)
        ctx.logger.info("Pages: %s", len(pdf.pages))
        ctx.logger.info("Objects: %s", len(pdf.objects))


def self_test() -> None:
    entries = [ActualTextEntry("Repository: https://example.com/repo")]
    source = b"/Artifact BMC\n/Artifact BMC\nBT\n(i) Tj\nET\nEMC\nBT\n(aaa) Tj\nET\nEMC\n"
    rewritten, count = rewrite_stream(source, entries, 0)
    expected = (
        b"/Span <<\n  /ActualText "
        + pdf_utf16be_hex(entries[0].actual)
        + b"\n>> BDC"
        b"\n/Artifact BMC\nBT\n(i) Tj\nET\nEMC\nBT\n(aaa) Tj\nET\nEMC\n"
    )
    if rewritten != expected or count != 1:
        raise RuntimeError("ActualText fixture rewrite failed")

