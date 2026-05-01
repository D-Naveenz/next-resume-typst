from __future__ import annotations

from pathlib import Path

from nextresume_tool.commands.pdf import apply_actual_text
from nextresume_tool.host.app import AppContext
from nextresume_tool.host.process import run_command


def _font_args(ctx: AppContext) -> list[str]:
    args: list[str] = []
    for font_path in ctx.config.typst.font_paths:
        args.extend(["--font-path", str(ctx.paths.repo_path(font_path))])
    return args


def build_cv(ctx: AppContext, language: str | None = None, output: str | None = None) -> Path:
    cfg = ctx.config.typst
    lang = language or cfg.default_language
    final_output = ctx.resolve_repo_output(output, cfg.cv_output)
    raw_pdf = ctx.run_info.path(ctx.paths.debug_pdf_dir, "cv-raw", ".pdf")
    manifest = ctx.run_info.path(ctx.paths.manifests_dir, "actualtext-manifest", ".json")

    run_command(
        [
            "typst",
            "compile",
            *_font_args(ctx),
            "--input",
            f"language={lang}",
            str(ctx.paths.repo_path(cfg.cv_source)),
            str(raw_pdf),
        ],
        cwd=ctx.paths.repo_root,
        logger=ctx.logger,
    )

    query = run_command(
        [
            "typst",
            "query",
            *_font_args(ctx),
            "--input",
            f"language={lang}",
            str(ctx.paths.repo_path(cfg.cv_source)),
            "<nextresume-actualtext>",
            "--pretty",
        ],
        cwd=ctx.paths.repo_root,
        logger=ctx.logger,
        log_stdout=False,
    )
    manifest.write_text(query.stdout, encoding="utf-8")
    ctx.logger.info("Wrote %s", manifest)

    apply_actual_text(raw_pdf, manifest, final_output, ctx)
    return final_output


def build_letter(ctx: AppContext, language: str | None = None, output: str | None = None) -> Path:
    cfg = ctx.config.typst
    lang = language or cfg.default_language
    final_output = ctx.resolve_repo_output(output, cfg.letter_output)

    run_command(
        [
            "typst",
            "compile",
            *_font_args(ctx),
            "--input",
            f"language={lang}",
            str(ctx.paths.repo_path(cfg.letter_source)),
            str(final_output),
        ],
        cwd=ctx.paths.repo_root,
        logger=ctx.logger,
    )
    ctx.logger.info("Wrote %s", final_output)
    return final_output


def build_all(ctx: AppContext, language: str | None = None) -> None:
    build_cv(ctx, language=language)
    build_letter(ctx, language=language)
