# Project Guidelines

## Purpose

This repository evolves the `@preview/brilliant-cv:3.3.0` Typst template into a more modern, polished resume and cover-letter system without losing Typst simplicity or breaking PDF output.

Short-term goal: safe customization.
Medium-term goal: a distinct visual identity with stronger typography, spacing, and hierarchy.

## Current Implementation Mode

The project is still close to the upstream template and should favor incremental customization over structural rewrites.

- Use `metadata.toml` first for styling, identity, fonts, colors, spacing, and header behavior.
- Keep `modules_en/*.typ` focused on content sections.
- Prefer light wrapper logic in local Typst files before considering a full template fork.
- Preserve Typst `0.14.x` compatibility unless there is a clear reason to move beyond it.

## Repository Layout

- `cv.typ`: main resume entry point
- `letter.typ`: main cover-letter entry point
- `metadata.toml`: personal data, global layout settings, fonts, colors, language, and ATS injection fields
- `modules_en/*.typ`: resume section content
- `assets/`: profile photo, signature, logos, bibliography, and other binaries
- `cv.pdf`, `letter.pdf`: generated artifacts only

## Render Flow

- `cv.typ` imports `@preview/brilliant-cv:3.3.0` and renders with `#show: cv.with(...)`
- `letter.typ` imports the same package and renders with `#show: letter.with(...)`
- Both entry points load `metadata.toml`
- `cv.typ` can swap language-specific module folders through `--input language=...`

## Working Rules

- Keep changes incremental and reviewable.
- Do not edit generated PDFs directly.
- Keep asset paths stable unless a change clearly requires otherwise.
- After layout or Typst changes, validate compile health before moving on.
- When unsure whether to adjust content or presentation, prefer presentation-only changes unless the user asks for rewriting.

## Modernization Direction

Prefer:

- sharper typography and stronger visual hierarchy
- more intentional whitespace and section rhythm
- cleaner header and contact presentation
- better balance between human readability and ATS-friendly extraction
- minimal ornamentation

Avoid:

- dense layouts that hurt scanability
- visual gimmicks that compete with the content
- breaking the upstream data model without clear payoff
- large one-shot refactors without verifying output

## Verification

Use these commands from the repo root:

```powershell
typst compile cv.typ cv.pdf
typst compile letter.typ letter.pdf
```

If language-specific rendering matters:

```powershell
typst compile --input language=en cv.typ cv.pdf
typst compile --input language=en letter.typ letter.pdf
```

Check for:

- Typst compile errors
- layout overflow or cramped spacing
- broken image paths
- poor page balance after styling changes
