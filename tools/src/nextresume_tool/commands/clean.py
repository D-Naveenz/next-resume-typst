from __future__ import annotations

import shutil
from pathlib import Path

from nextresume_tool.host.app import AppContext


def _remove_path(path: Path, ctx: AppContext) -> None:
    if not path.exists():
        return
    if path.is_dir():
        shutil.rmtree(path)
    else:
        path.unlink()
    ctx.logger.info("Removed %s", path)


def clean_tooling(ctx: AppContext, include_logs: bool = False, include_all: bool = False) -> None:
    if include_all:
        for child in ctx.paths.tooling_root.iterdir():
            _remove_path(child, ctx)
        return

    for target in (ctx.paths.data_dir, ctx.paths.debug_dir, ctx.paths.extracted_dir):
        _remove_path(target, ctx)

    if include_logs:
        _remove_path(ctx.paths.logs_dir, ctx)

    ctx.paths.ensure_tooling_dirs()
    if ctx.config.clean.preserve_config:
        ctx.logger.info("Preserved %s", ctx.paths.local_config_path)

