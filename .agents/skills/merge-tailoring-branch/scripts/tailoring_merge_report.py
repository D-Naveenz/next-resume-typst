#!/usr/bin/env python3
"""Summarize a tailoring branch handoff without printing private diffs."""

from __future__ import annotations

import argparse
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


PRIVATE_EXACT = {
    "metadata.toml",
    "cv.pdf",
    "letter.pdf",
    "letter.typ",
}

PRIVATE_PREFIXES = (
    "assets/logos/",
    "assets/profile",
    "temp/",
    ".tooling/",
)

AMBIGUOUS_PREFIXES = (
    "modules_en/",
)

REUSABLE_PREFIXES = (
    ".github/",
    ".vscode/",
    "components/",
    "core/",
    "docs/",
    "tools/",
    "assets/footer/",
    "assets/icons/",
)

REUSABLE_EXACT = {
    "AGENTS.md",
    "README.md",
    "VERSION",
}

AMBIGUOUS_EXACT = {
    "CHANGELOG.md",
    "cv.typ",
}

PRIVATE_EXACT_LOWER = {item.lower() for item in PRIVATE_EXACT}
REUSABLE_EXACT_LOWER = {item.lower() for item in REUSABLE_EXACT}
AMBIGUOUS_EXACT_LOWER = {item.lower() for item in AMBIGUOUS_EXACT}


@dataclass(frozen=True)
class ChangedPath:
    status: str
    path: str
    classification: str
    reason: str


def run_git(args: list[str], repo: Path) -> str:
    completed = subprocess.run(
        ["git", *args],
        cwd=repo,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if completed.returncode != 0:
        message = completed.stderr.strip() or completed.stdout.strip()
        raise RuntimeError(f"git {' '.join(args)} failed: {message}")
    return completed.stdout.strip()


def current_branch(repo: Path) -> str:
    return run_git(["branch", "--show-current"], repo)


def normalize_path(path: str) -> str:
    return path.replace("\\", "/")


def classify(path: str) -> tuple[str, str]:
    normalized = normalize_path(path)
    lower = normalized.lower()

    if lower in PRIVATE_EXACT_LOWER:
        return "private", "known tailoring or generated-output surface"
    if any(lower.startswith(prefix) for prefix in PRIVATE_PREFIXES):
        return "private", "person or tailoring asset/debug surface"
    if lower in AMBIGUOUS_EXACT_LOWER:
        return "ambiguous", "can mix reusable structure with tailored content"
    if any(lower.startswith(prefix) for prefix in AMBIGUOUS_PREFIXES):
        return "ambiguous", "resume module may mix layout and personal content"
    if lower in REUSABLE_EXACT_LOWER:
        return "review", "shared project file; inspect for private wording"
    if any(lower.startswith(prefix) for prefix in REUSABLE_PREFIXES):
        return "review", "likely reusable project surface; verify content"
    return "ambiguous", "unrecognized path; inspect before porting"


def changed_paths(repo: Path, base: str, tailoring: str) -> list[ChangedPath]:
    output = run_git(["diff", "--name-status", f"{base}...{tailoring}"], repo)
    paths: list[ChangedPath] = []
    for line in output.splitlines():
        if not line.strip():
            continue
        parts = line.split("\t")
        status = parts[0]
        path = parts[-1]
        kind, reason = classify(path)
        paths.append(ChangedPath(status=status, path=path, classification=kind, reason=reason))
    return paths


def ahead_commits(repo: Path, base: str, tailoring: str) -> list[tuple[str, str]]:
    output = run_git(
        ["log", "--reverse", "--no-merges", "--format=%h%x09%s", f"{base}..{tailoring}"],
        repo,
    )
    commits: list[tuple[str, str]] = []
    for line in output.splitlines():
        if not line.strip():
            continue
        sha, _, subject = line.partition("\t")
        commits.append((sha, subject))
    return commits


def print_report(repo: Path, base: str, tailoring: str) -> None:
    commits = ahead_commits(repo, base, tailoring)
    paths = changed_paths(repo, base, tailoring)

    print(f"# Tailoring Merge Report: {tailoring} -> {base}")
    print()
    print("This report is a map for local review. It does not prove a path is safe.")
    print()
    print("## Ahead Commits")
    if commits:
        for sha, subject in commits:
            print(f"- {sha} {subject}")
    else:
        print("- No ahead commits found.")
    print()
    print("## Changed Paths")
    if paths:
        for item in paths:
            print(f"- [{item.classification}] {item.status} {item.path} - {item.reason}")
    else:
        print("- No changed paths found.")
    print()
    print("## Recommended Next Step")
    print(
        "Create a temporary branch from the base branch, run "
        f"`git merge --no-commit --no-ff {tailoring}`, inspect the result, "
        "then port only reviewed reusable improvements."
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Summarize a tailoring branch before a privacy-preserving handoff."
    )
    parser.add_argument("--base", default="development", help="Target branch for the handoff.")
    parser.add_argument(
        "--tailoring",
        default=None,
        help="Source tailoring branch. Defaults to the current branch.",
    )
    parser.add_argument(
        "--repo",
        default=".",
        type=Path,
        help="Repository root. Defaults to the current directory.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    repo = args.repo.resolve()
    tailoring = args.tailoring or current_branch(repo)
    if not tailoring:
        print("Could not determine a tailoring branch. Pass --tailoring.", file=sys.stderr)
        return 2
    print_report(repo, args.base, tailoring)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        raise SystemExit(1)
