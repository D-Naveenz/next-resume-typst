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
