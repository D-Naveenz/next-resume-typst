# Typst Tag-Row Copy Delimiters

This note documents the repo-local Typst-only strategy for making decorative tag rows more copy-friendly without mutating `cv.pdf` after compilation.

## Why This Exists

- The visible pill rows in Skills, Projects, Education, and Professional Experience read well for humans but do not naturally copy as pipe-delimited plain text.
- A previous Python `ActualText` post-processing path was more complex than this repo now needs.
- The project now prefers a Typst-only, best-effort solution that keeps the visible layout unchanged while improving extracted text for common viewer-style and spatially sorted copy flows.

## Current Scope

- Document support: `cv.typ`
- Visible row types using this strategy:
  - Skills certifications
  - Entry tag rows rendered through the repo-local `cv-entry` wrappers
- Implementation surface:
  - [components/tag-row.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/components/tag-row.typ)
  - [components/skills.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/components/skills.typ)
  - [components/entries.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/components/entries.typ)

`letter.typ` currently has no tag-row use case and is unaffected.

## Typst Strategy

The shared `tag-row` helper inserts a hidden plain-text delimiter before each tag after the first:

- delimiter wrapper width: `0pt`
- delimiter text size: `1pt`
- delimiter color: white
- default copy delimiter: `" | "`

The delimiter stays in the text flow for extraction, but the visible layout still comes only from the rendered pills and normal `h(gap)` spacing.

## Interface Notes

The shared helper uses:

- `tags`
- `copy-delimiter`
- visual style inputs such as `gap`, `fill`, `radius`, `inset`, `outset`, and `text-size`

`copy-delimiter` is plain text only. It is not meant to accept visual content helpers like `#h-bar()`.

## Limitations

- This is a best-effort Typst-only extraction aid, not exact PDF-semantic control.
- Different extractors may still disagree:
  - spatially sorted or viewer-style extraction is expected to be the best case
  - raw stream-order extraction may still split rows differently
- The hidden delimiter improves copy behavior without changing the visible layout, but it does not guarantee identical results across every PDF tool.
