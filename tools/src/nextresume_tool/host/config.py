from __future__ import annotations

import os
import tomllib
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from nextresume_tool.host.paths import ToolPaths


def _deep_merge(base: dict[str, Any], overlay: dict[str, Any]) -> dict[str, Any]:
    merged = dict(base)
    for key, value in overlay.items():
        if isinstance(value, dict) and isinstance(merged.get(key), dict):
            merged[key] = _deep_merge(merged[key], value)
        else:
            merged[key] = value
    return merged


def _parse_bool(raw: str) -> bool:
    return raw.strip().lower() in {"1", "true", "yes", "on"}


@dataclass(frozen=True)
class TypstConfig:
    default_language: str
    font_paths: list[str]
    cv_source: str
    letter_source: str
    cv_output: str
    letter_output: str
    metadata_path: str
    footer_output_dir: str


@dataclass(frozen=True)
class LoggingConfig:
    level: str
    verbose: bool


@dataclass(frozen=True)
class CleanConfig:
    preserve_logs: bool
    preserve_config: bool


@dataclass(frozen=True)
class WatchConfig:
    paths: list[str]
    debounce_ms: int


@dataclass(frozen=True)
class ToolConfig:
    typst: TypstConfig
    logging: LoggingConfig
    clean: CleanConfig
    watch: WatchConfig


def _load_toml(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {}
    return tomllib.loads(path.read_text(encoding="utf-8"))


def _env_overrides() -> dict[str, Any]:
    overrides: dict[str, Any] = {}

    if value := os.getenv("NEXTRESUME_TOOL_LOG_LEVEL"):
        overrides.setdefault("logging", {})["level"] = value
    if value := os.getenv("NEXTRESUME_TOOL_VERBOSE"):
        overrides.setdefault("logging", {})["verbose"] = _parse_bool(value)
    if value := os.getenv("NEXTRESUME_TOOL_LANGUAGE"):
        overrides.setdefault("typst", {})["default_language"] = value

    return overrides


def load_config(paths: ToolPaths, cli_overrides: dict[str, Any] | None = None) -> ToolConfig:
    defaults_path = paths.tool_path("config/default.toml")
    merged: dict[str, Any] = _load_toml(defaults_path)
    merged = _deep_merge(merged, _load_toml(paths.local_config_path))
    merged = _deep_merge(merged, _env_overrides())
    if cli_overrides:
        merged = _deep_merge(merged, cli_overrides)

    typst = TypstConfig(**merged["typst"])
    logging = LoggingConfig(**merged["logging"])
    clean = CleanConfig(**merged["clean"])
    watch = WatchConfig(**merged["watch"])
    return ToolConfig(typst=typst, logging=logging, clean=clean, watch=watch)

