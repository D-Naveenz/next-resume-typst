from __future__ import annotations

from importlib.metadata import PackageNotFoundError, version

PACKAGE_NAME = "nextresume-tool"

try:
    __version__ = version(PACKAGE_NAME)
except PackageNotFoundError:  # pragma: no cover - editable/dev fallback
    __version__ = "0.5.0"
