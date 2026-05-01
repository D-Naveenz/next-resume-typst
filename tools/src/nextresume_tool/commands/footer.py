from __future__ import annotations

import re

from nextresume_tool.host.app import AppContext
from nextresume_tool.host.process import run_command


LANG_HEADER_RE = re.compile(r"^\s*\[lang\.([^\]]+)\]\s*$")
FOOTER_RE = re.compile(r'^\s*cv_footer\s*=\s*"([^"]+)"')
FIELD_RE = {
    "first_name": re.compile(r'^\s*first_name\s*=\s*"([^"]+)"'),
    "last_name": re.compile(r'^\s*last_name\s*=\s*"([^"]+)"'),
}


def generate_footer_assets(ctx: AppContext) -> None:
    cfg = ctx.config.typst
    metadata_path = ctx.paths.repo_path(cfg.metadata_path)
    output_dir = ctx.paths.repo_path(cfg.footer_output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    lines = metadata_path.read_text(encoding="utf-8").splitlines()
    values = {}
    for name, pattern in FIELD_RE.items():
        for line in lines:
            match = pattern.match(line)
            if match:
                values[name] = match.group(1)
                break

    full_name = f"{values.get('first_name', '').strip()} {values.get('last_name', '').strip()}".strip()
    current_lang: str | None = None
    footer_by_lang: dict[str, str] = {}

    for line in lines:
        header = LANG_HEADER_RE.match(line)
        if header:
            current_lang = header.group(1)
            continue
        if current_lang:
            footer = FOOTER_RE.match(line)
            if footer:
                footer_by_lang[current_lang] = footer.group(1)

    for lang, footer_label in footer_by_lang.items():
        source = f"""#set page(width: 182mm, height: 12pt, margin: 0pt, fill: none)
#set text(font: "Source Sans 3", size: 8pt, fill: rgb("999999"))
#table(
  columns: (1fr, auto),
  stroke: none,
  inset: 0pt,
  smallcaps("{full_name}"),
  smallcaps("{footer_label}"),
)
"""
        output_path = output_dir / f"footer-{lang}.svg"
        run_command(
            ["typst", "compile", "-", str(output_path), "--format", "svg"],
            cwd=ctx.paths.repo_root,
            logger=ctx.logger,
            input_text=source,
        )
        ctx.logger.info("Wrote %s", output_path)

