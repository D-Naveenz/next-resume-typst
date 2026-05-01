from __future__ import annotations

import shutil
import sys

import pikepdf

from nextresume_tool.commands.pdf import self_test
from nextresume_tool.host.app import AppContext


def run_doctor(ctx: AppContext) -> None:
    ctx.logger.info("Python: %s", sys.executable)
    ctx.logger.info("Repository: %s", ctx.paths.repo_root)
    ctx.logger.info("Tooling root: %s", ctx.paths.tooling_root)

    typst = shutil.which("typst")
    if not typst:
        raise RuntimeError("Unable to locate typst on PATH")
    ctx.logger.info("Typst: %s", typst)
    ctx.logger.info("pikepdf: %s", pikepdf.__version__)
    self_test()
    ctx.logger.info("PDF self-test passed")

