from __future__ import annotations

from pathlib import Path

from watchfiles import DefaultFilter, watch

from nextresume_tool.commands.build import build_all, build_cv, build_letter
from nextresume_tool.host.app import AppContext


class ToolWatchFilter(DefaultFilter):
    def __call__(self, change, path: str) -> bool:
        if ".tooling" in path or "\\.git\\" in path or "\\tools\\.venv\\" in path:
            return False
        return super().__call__(change, path)


def _watch_roots(ctx: AppContext) -> list[Path]:
    return [ctx.paths.repo_path(value) for value in ctx.config.watch.paths]


def _run_target(kind: str, ctx: AppContext, language: str | None = None) -> None:
    if kind == "cv":
        build_cv(ctx, language=language)
    elif kind == "letter":
        build_letter(ctx, language=language)
    else:
        build_all(ctx, language=language)


def watch_target(kind: str, ctx: AppContext, language: str | None = None) -> None:
    _run_target(kind, ctx, language=language)
    ctx.logger.info("Watching for changes...")

    for changes in watch(
        *_watch_roots(ctx),
        watch_filter=ToolWatchFilter(),
        debounce=ctx.config.watch.debounce_ms,
        raise_interrupt=False,
    ):
        changed = sorted({Path(path).resolve() for _, path in changes})
        for path in changed:
            ctx.logger.info("Changed: %s", path)
        try:
            _run_target(kind, ctx, language=language)
        except Exception as exc:  # pragma: no cover - interactive loop
            ctx.logger.exception("Watch rebuild failed: %s", exc)

