from __future__ import annotations

from pathlib import Path

import typer

from nextresume_tool import __version__
from nextresume_tool.commands.build import build_all, build_cv, build_letter
from nextresume_tool.commands.clean import clean_tooling
from nextresume_tool.commands.doctor import run_doctor
from nextresume_tool.commands.footer import generate_footer_assets
from nextresume_tool.commands.pdf import apply_actual_text, inspect_pdf, render_pdf_pages
from nextresume_tool.commands.watch import watch_target
from nextresume_tool.host.app import AppContext
from nextresume_tool.ui.app import NextResumeTui

app = typer.Typer(no_args_is_help=False, add_completion=False)
build_app = typer.Typer()
watch_app = typer.Typer()
footer_app = typer.Typer()
pdf_app = typer.Typer()
pdf_actualtext_app = typer.Typer()

app.add_typer(build_app, name="build")
app.add_typer(watch_app, name="watch")
app.add_typer(footer_app, name="footer")
app.add_typer(pdf_app, name="pdf")
pdf_app.add_typer(pdf_actualtext_app, name="actualtext")


def _ctx(command_name: str, cli_overrides: dict | None = None) -> AppContext:
    return AppContext.create(command_name=command_name, cli_overrides=cli_overrides)


@app.callback(invoke_without_command=True)
def root(
    ctx: typer.Context,
    version: bool = typer.Option(False, "--version", help="Show the tool version and exit."),
) -> None:
    if version:
        typer.echo(__version__)
        raise typer.Exit()
    if ctx.invoked_subcommand is None:
        NextResumeTui().run()


@app.command("doctor")
def doctor() -> None:
    run_doctor(_ctx("doctor"))


@app.command("clean")
def clean(
    logs: bool = typer.Option(False, "--logs", help="Include logs."),
    all_files: bool = typer.Option(False, "--all", help="Remove everything under .tooling."),
) -> None:
    clean_tooling(_ctx("clean"), include_logs=logs, include_all=all_files)


@app.command("tui")
def tui() -> None:
    NextResumeTui().run()


@build_app.command("cv")
def build_cv_command(
    language: str = typer.Option("en", "--language"),
    output: str | None = typer.Option(None, "--output"),
) -> None:
    build_cv(_ctx("build-cv", {"typst": {"default_language": language}}), language=language, output=output)


@build_app.command("letter")
def build_letter_command(
    language: str = typer.Option("en", "--language"),
    output: str | None = typer.Option(None, "--output"),
) -> None:
    build_letter(
        _ctx("build-letter", {"typst": {"default_language": language}}),
        language=language,
        output=output,
    )


@build_app.command("all")
def build_all_command(language: str = typer.Option("en", "--language")) -> None:
    build_all(_ctx("build-all", {"typst": {"default_language": language}}), language=language)


@watch_app.command("cv")
def watch_cv_command(language: str = typer.Option("en", "--language")) -> None:
    watch_target("cv", _ctx("watch-cv", {"typst": {"default_language": language}}), language=language)


@watch_app.command("letter")
def watch_letter_command(language: str = typer.Option("en", "--language")) -> None:
    watch_target("letter", _ctx("watch-letter", {"typst": {"default_language": language}}), language=language)


@watch_app.command("all")
def watch_all_command(language: str = typer.Option("en", "--language")) -> None:
    watch_target("all", _ctx("watch-all", {"typst": {"default_language": language}}), language=language)


@footer_app.command("generate")
def footer_generate_command() -> None:
    generate_footer_assets(_ctx("footer-generate"))


@pdf_actualtext_app.command("apply")
def pdf_apply_command(
    input_pdf: Path = typer.Option(..., "--input"),
    manifest: Path = typer.Option(..., "--manifest"),
    output_pdf: Path = typer.Option(..., "--output"),
) -> None:
    ctx = _ctx("pdf-actualtext-apply")
    apply_actual_text(input_pdf, manifest, output_pdf, ctx)


@pdf_app.command("inspect")
def pdf_inspect_command(path: Path = typer.Argument(...)) -> None:
    inspect_pdf(path, _ctx("pdf-inspect"))


@pdf_app.command("render")
def pdf_render_command(
    path: Path = typer.Argument(...),
    dpi: int = typer.Option(144, "--dpi", min=72, help="Render resolution in DPI."),
) -> None:
    ctx = _ctx("pdf-render")
    rendered = render_pdf_pages(path, ctx, dpi=dpi)
    ctx.logger.info("Rendered %s page image(s)", len(rendered))


def main() -> None:
    app()
