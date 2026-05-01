from __future__ import annotations

import logging
import subprocess
from pathlib import Path
from typing import Sequence


def run_command(
    args: Sequence[str],
    cwd: Path,
    logger: logging.Logger,
    input_text: str | None = None,
    log_stdout: bool = True,
    log_stderr: bool = True,
) -> subprocess.CompletedProcess[str]:
    logger.info("Running: %s", " ".join(args))
    completed = subprocess.run(
        list(args),
        cwd=cwd,
        text=True,
        input=input_text,
        capture_output=True,
        check=False,
    )
    if log_stdout and completed.stdout.strip():
        logger.info(completed.stdout.strip())
    if log_stderr and completed.stderr.strip():
        logger.warning(completed.stderr.strip())
    if completed.returncode != 0:
        raise RuntimeError(f"Command failed with exit code {completed.returncode}: {' '.join(args)}")
    return completed
