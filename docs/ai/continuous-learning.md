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

- Native Typst metadata plus `typst query` is enough to expose page geometry and replacement text for narrow PDF post-processing without embedding hidden marker text into the PDF itself.
- For decorative tag rows where generic extraction matters more than PDF purity, a row-level redaction plus raster snapshot plus one invisible replacement string is more reliable than trying to patch each original visible text span in place.
- CV-only PDF post-processing should stay narrow and marker-driven; broadening it beyond clearly bounded decorative regions would need a separate design pass.
