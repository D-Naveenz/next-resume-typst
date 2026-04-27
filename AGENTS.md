# AGENTS.md

This workspace uses MindVault as the canonical AI memory. Keep this file short: it is a linker and quick reference, not the knowledge base.

## MindVault

- Vault: `C:\Users\dashe\OneDrive\Documents\MindVault`
- Start with: `AI\atlas\Home.md`
- Reusable principles: `AI\atlas\Principle Index.md`
- Structural search: `AI\atlas\Structural Similarity Index.md`
- Workspace evidence: `AI\evidence\workspaces\<workspace>\<Workspace Name> Workspace.md` if it exists

Store durable lessons and cross-workspace abstractions in MindVault. Keep only local setup, commands, and hard repository guardrails here.

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
