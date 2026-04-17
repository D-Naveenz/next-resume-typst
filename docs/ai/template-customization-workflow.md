# Template Customization Workflow

Use this workflow when a section in the upstream `@preview/brilliant-cv:3.3.0` template looks wrong or becomes hard to modernize cleanly.

## Escalation Path

1. Start at the safest surface.
   Prefer `metadata.toml`, section content in `modules_<lang>/`, and light wrapper logic in `cv.typ` or `letter.typ`.
2. Inspect the upstream helper before rewriting anything.
   If a section still feels structurally wrong, read the relevant `brilliant-cv` implementation and identify whether the issue comes from content, layout assumptions, or hardcoded spacing.
3. Replace only the affected helper locally.
   Create a repo-local component when the upstream helper blocks a concrete requirement, and switch the local module to use that helper instead of forking the whole package.
4. Fork the upstream template only if local overrides start repeating across multiple subsystems or become hard to maintain.

## Current Example: Skills Section

- `modules_en/skills.typ` looked misaligned even with reasonable content.
- The upstream `cv-skill` and `cv-skill-with-level` helpers in `brilliant-cv` use a rigid table layout and a negative vertical pull after each row.
- The fix should therefore live in a repo-local helper instead of trying to force the section content to compensate for those layout choices.

## Working Rules

- Keep local replacements narrow and section-specific.
- Preserve the upstream package for everything that is still working well.
- Prefer native text over decorative proficiency widgets in ATS-sensitive sections.
- Recompile affected documents after any Typst layout change.

## Investigation Track

There is a possible future path for ATS-safe decorative components using PDF post-processing after Typst compilation, for example by tagging marked content with alternate extraction text.

For now, keep that idea as investigation only:

- Typst's current PDF reference does not expose a clean `accsupp`-style `ActualText` hook directly in markup: [Typst PDF reference](https://typst.app/docs/reference/pdf/)
- Typst's accessibility guidance emphasizes semantic content and artifacts, but not alternate extraction text for decorative inline replacements: [Typst accessibility guide](https://typst.app/docs/guides/accessibility/)
- Any post-processing workflow should remain optional until it proves reliable and does not complicate the default resume build.
