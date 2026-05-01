from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path


def _find_repo_root(start: Path) -> Path:
    current = start.resolve()
    for candidate in [current, *current.parents]:
        if (candidate / ".git").exists():
            return candidate
    raise RuntimeError(f"Unable to locate repository root from {start}")


@dataclass(frozen=True)
class ToolPaths:
    repo_root: Path
    tools_root: Path
    tooling_root: Path
    logs_dir: Path
    data_dir: Path
    manifests_dir: Path
    debug_dir: Path
    debug_pdf_dir: Path
    extracted_dir: Path
    extracted_images_dir: Path
    extracted_text_dir: Path
    local_config_path: Path

    @classmethod
    def discover(cls, tooling_dir_name: str = ".tooling") -> "ToolPaths":
        package_root = Path(__file__).resolve()
        repo_root = _find_repo_root(package_root)
        tools_root = repo_root / "tools"
        tooling_root = repo_root / tooling_dir_name
        return cls(
            repo_root=repo_root,
            tools_root=tools_root,
            tooling_root=tooling_root,
            logs_dir=tooling_root / "logs",
            data_dir=tooling_root / "data",
            manifests_dir=tooling_root / "data" / "manifests",
            debug_dir=tooling_root / "debug",
            debug_pdf_dir=tooling_root / "debug" / "pdf",
            extracted_dir=tooling_root / "extracted",
            extracted_images_dir=tooling_root / "extracted" / "images",
            extracted_text_dir=tooling_root / "extracted" / "text",
            local_config_path=tooling_root / "config.toml",
        )

    def ensure_tooling_dirs(self) -> None:
        for path in (
            self.tooling_root,
            self.logs_dir,
            self.data_dir,
            self.manifests_dir,
            self.debug_dir,
            self.debug_pdf_dir,
            self.extracted_dir,
            self.extracted_images_dir,
            self.extracted_text_dir,
        ):
            path.mkdir(parents=True, exist_ok=True)

    def repo_path(self, value: str | Path) -> Path:
        path = Path(value)
        return path if path.is_absolute() else (self.repo_root / path).resolve()

    def tool_path(self, value: str | Path) -> Path:
        path = Path(value)
        return path if path.is_absolute() else (self.tools_root / path).resolve()

