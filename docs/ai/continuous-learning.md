# Continuous Learning

Use this file to record project-specific lessons learned during real work. Keep entries short, concrete, and actionable.

## How To Use

1. Add a dated note when a change reveals a non-obvious constraint or useful pattern.
2. Promote repeated themes into a dedicated `docs/ai/*.md` topic file.
3. Write an ADR when the lesson becomes a durable project decision.

## Entries

### 2026-04-17

- The safest customization surface is `metadata.toml`; styling and identity work should begin there before editing package-facing Typst logic.
- The resume and cover letter are both thin wrappers over `brilliant-cv`, so local wrapper logic is lower risk than forking the template.
- PDF files in the repo are output artifacts, not sources of truth. Verify layout changes by recompiling rather than editing generated files.
- Language selection flows through `--input language=...`, so any future localized content should preserve the `modules_<lang>/` convention instead of hardcoding `modules_en/`.
- The upstream `cv-skill` helpers use a rigid table layout and negative vertical pull, so section-level alignment issues can require replacing just that helper locally instead of fighting the module content.

### 2026-04-19

- For decorative tag rows in this repo, a Typst-only hidden delimiter is the preferred first step before reaching for PDF post-processing.
- A `1pt` hidden delimiter inside a `0pt` width wrapper survives extraction more reliably than a `0pt` hidden delimiter, while staying visually inert in the rendered PDF.
- If PDF post-processing ever comes back for this repo, it should stay narrowly scoped to clearly bounded decorative regions instead of becoming the default extraction strategy.
