# AGENTS.md

This repository uses a repo-local knowledge system for Codex and other coding agents. Treat this file as the entry point, not the full knowledge base.

## Read This First

1. [docs/ai/index.md](docs/ai/index.md) for the knowledge map and reading order.
2. [docs/ai/project-guidelines.md](docs/ai/project-guidelines.md) for project goals, guardrails, and implementation defaults.
3. [docs/ai/continuous-learning.md](docs/ai/continuous-learning.md) for lessons learned during real work.
4. `docs/reference/` for source-of-truth notes about the current template and repo layout.
5. `docs/adr/` for durable architectural or workflow decisions.

## Project Snapshot

- Typst-based resume and cover-letter system built on `@preview/brilliant-cv:3.3.0`
- Main source files: `cv.typ`, `letter.typ`, `metadata.toml`, and `modules_en/*.typ`
- Generated PDFs are outputs only and must not be edited directly

## Agent Defaults

- Prefer small, compile-safe changes over broad refactors.
- Start with presentation-only changes unless the user explicitly asks for content rewrites.
- Favor local wrappers and `metadata.toml` configuration before forking the upstream template model.
- Recompile affected documents after meaningful Typst or layout edits.

## Verification

Run from the repository root:

```powershell
typst compile cv.typ cv.pdf
typst compile letter.typ letter.pdf
```

If language-specific rendering matters:

```powershell
typst compile --input language=en cv.typ cv.pdf
typst compile --input language=en letter.typ letter.pdf
```
