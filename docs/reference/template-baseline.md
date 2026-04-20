# Template Baseline Reference

This note describes the current baseline wiring of the resume system so future changes can be measured against it.

## Upstream Package

- The project currently imports `@preview/brilliant-cv:3.3.0`

## Entry Points

### `cv.typ`

- Imports `cv` from `brilliant-cv`
- Loads `metadata.toml`
- Optionally overrides `metadata.language` from `sys.inputs`
- Validates `metadata.toml next_resume.version` against the repo root `VERSION` file
- Injects standard PDF metadata with the NextResume version
- Renders with `#show: cv.with(...)`
- Includes section modules from `modules_<language>/`
- Passes a repo-local cropped photo into the upstream header photo slot
- Reads `personal.profile_photo` from `metadata.toml`, derives the natural image ratio with Typst measurement, and applies metadata controls for crop scale-up and crop offsets

### `letter.typ`

- Imports `letter` from `brilliant-cv`
- Loads `metadata.toml`
- Optionally overrides `metadata.language` from `sys.inputs`
- Validates `metadata.toml next_resume.version` against the repo root `VERSION` file
- Injects standard PDF metadata with the NextResume version
- Renders with `#show: letter.with(...)`
- Currently passes `assets/signature.png` as `signature`

## Main Customization Surfaces

- `metadata.toml` for layout, fonts, colors, personal data, footer text, and ATS injection
- `VERSION` plus `components/versioning.typ` for product-version enforcement and PDF metadata injection
- `modules_en/*.typ` for resume section content
- `cv.typ` and `letter.typ` for light wrapper behavior around the package

## Operational Notes

- Generated PDFs should be treated as validation output only.
- Asset paths are already wired into the template and should remain stable when possible.
- The current design direction favors incremental modernization rather than replacing the package model outright.
