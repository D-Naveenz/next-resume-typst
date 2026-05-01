from __future__ import annotations

import logging
from pathlib import Path

from rich.logging import RichHandler

from nextresume_tool.host.artifacts import RunInfo


def configure_logging(logs_dir: Path, run_info: RunInfo, level_name: str, verbose: bool) -> logging.Logger:
    logs_dir.mkdir(parents=True, exist_ok=True)
    logger_name = f"nextresume.{run_info.command_name}.{run_info.run_id}"
    logger = logging.getLogger(logger_name)
    logger.setLevel(getattr(logging, level_name.upper(), logging.INFO))
    logger.handlers.clear()
    logger.propagate = False

    console_handler = RichHandler(rich_tracebacks=True, markup=False, show_path=verbose)
    console_handler.setFormatter(logging.Formatter("%(message)s"))

    file_path = logs_dir / run_info.file_name(f"{run_info.command_name}-log", ".log")
    file_handler = logging.FileHandler(file_path, encoding="utf-8")
    file_handler.setFormatter(
        logging.Formatter(
            "%(asctime)s | %(levelname)s | %(name)s | %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S",
        )
    )

    logger.addHandler(console_handler)
    logger.addHandler(file_handler)
    logger.debug("Log file: %s", file_path)
    return logger

