from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from uuid import uuid4


@dataclass
class RunInfo:
    command_name: str
    timestamp: str = field(default_factory=lambda: datetime.now().strftime("%Y%m%d-%H%M%S"))
    run_id: str = field(default_factory=lambda: uuid4().hex[:8])

    def file_name(self, kind: str, extension: str) -> str:
        suffix = extension if extension.startswith(".") else f".{extension}"
        return f"nextresume-{kind}-{self.timestamp}-{self.run_id}{suffix}"

    def path(self, directory: Path, kind: str, extension: str) -> Path:
        return directory / self.file_name(kind, extension)

