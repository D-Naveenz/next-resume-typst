from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import logging

from nextresume_tool.host.artifacts import RunInfo
from nextresume_tool.host.config import ToolConfig, load_config
from nextresume_tool.host.logging import configure_logging
from nextresume_tool.host.paths import ToolPaths


@dataclass
class AppContext:
    paths: ToolPaths
    config: ToolConfig
    run_info: RunInfo
    logger: logging.Logger

    @classmethod
    def create(cls, command_name: str, cli_overrides: dict | None = None) -> "AppContext":
        paths = ToolPaths.discover()
        config = load_config(paths, cli_overrides=cli_overrides)
        paths.ensure_tooling_dirs()
        run_info = RunInfo(command_name=command_name)
        logger = configure_logging(paths.logs_dir, run_info, config.logging.level, config.logging.verbose)
        return cls(paths=paths, config=config, run_info=run_info, logger=logger)

    def resolve_repo_output(self, path_value: str | None, default_value: str) -> Path:
        return self.paths.repo_path(path_value or default_value)

