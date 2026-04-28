<div align="center">
  <h1>NextResume</h1>
  <p><strong>The CV/Resume template</strong></p>

[![Version][version-shield]][version-file]
[![License][licence-shield]][licence-file]
[![Typst][typst-shield]][typst]
[![ATS Friendly][ats-shield]][ats-notes]
[![brilliant-CV Foundation][foundation-shield]][brilliant-cv]

</div>

NextResume is a modern Typst CV/resume template that keeps a polished
professional layout while improving ATS-friendly text extraction, configurable
rendering, and maintainable resume composition.

## Why NextResume

Most CV and resume templates lean too far in one direction: they either look
good but copy poorly, or they parse cleanly but feel visually plain. NextResume
exists to balance both sides: a refined resume that still behaves well when a
PDF reader, recruiter, or Applicant Tracking System extracts the text.

NextResume began with [`brilliant-CV`][brilliant-cv] by
[Yunan Wang][yunan-wang] and its contributors as the foundation. That template
already had a strong visual direction and a practical Typst structure, so it
was the right place to start. From there, NextResume has been replacing and
wrapping pieces with local NextResume components, improving layout behavior,
modernizing assets, and making the generated PDF friendlier to copy, reflow,
and ATS parsing.

The goal is to preserve the original brilliant-CV look with subtle visual
changes, while heavily improving how the document is rendered and maintained.
NextResume is now confident enough to stand as its own Typst template, with
more frequent updates planned around modern resume, ATS, PDF accessibility, and
Typst ecosystem practices.

## What Changed

- Added a local `components/nextresume.typ` wrapper for the CV/resume path.
- Added compile-time version validation between `VERSION` and
  `metadata.toml`.
- Added PDF metadata handling through the local template layer.
- Reworked the footer as a visible PDF artifact rendered from outlined SVG
  assets, so it can appear on the page without polluting copied resume text.
- Added `tools/generate-footer-assets.ps1` to generate language-keyed footer
  SVGs from resume metadata.
- Removed hidden keyword injection from the default metadata flow and moved ATS
  strategy toward visible, truthful skills and experience content.
- Added reusable local components for entries, skills, tags, profile photos,
  and versioning.
- Updated local font and icon assets, including newer Font Awesome support.
- Kept the cover-letter path compatible with the brilliant-CV foundation while
  the resume path evolves through NextResume components.

## Main Files

- `cv.typ`: CV/resume entry point using the local NextResume wrapper.
- `letter.typ`: cover-letter entry point.
- `metadata.toml`: identity, layout, styling, language, ATS, footer, and
  version settings.
- `modules_en/*.typ`: English resume section content.
- `components/nextresume.typ`: local CV/resume template wrapper.
- `components/artifact-footer.typ`: artifact footer renderer.
- `tools/generate-footer-assets.ps1`: footer SVG asset generator.
- `assets/`: profile images, signatures, logos, generated footer SVGs, and
  other binary inputs.

Generated PDFs are build outputs. Edit the Typst, TOML, module, tool, or asset
sources instead.

## Build

```powershell
typst compile cv.typ cv.pdf
typst compile letter.typ letter.pdf
```

For explicit English rendering:

```powershell
typst compile --input language=en cv.typ cv.pdf
typst compile --input language=en letter.typ letter.pdf
```

## Footer Assets

The CV footer is controlled by the normal footer setting and the active
language block:

```toml
[layout.footer]
display_footer = true

[lang.en]
cv_footer = "Curriculum vitae"
```

After changing the personal name, `cv_footer`, footer font, footer color, or
adding another `[lang.xx]` block, regenerate the footer SVGs:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools\generate-footer-assets.ps1
```

The generator writes assets like `assets/footer/footer-en.svg`, keyed by the
language code.

## ATS Notes

NextResume avoids hidden keyword stuffing. Keywords should appear naturally in
visible content, especially the Skills section and experience bullets. PDF
metadata is still useful for document properties, but it should not be treated
as the main ATS keyword strategy.

## Credits

NextResume is built on the excellent foundation of
[`brilliant-CV`][brilliant-cv] by [Yunan Wang][yunan-wang] and contributors.
Their work provided the visual and structural starting point that made this
template possible.

[version-shield]: https://img.shields.io/badge/version-0.2.0-blue
[version-file]: ./VERSION
[licence-shield]: https://img.shields.io/badge/licence-MIT-green
[licence-file]: ./LICENSE
[typst-shield]: https://img.shields.io/badge/language-Typst-239DAD?logo=typst&logoColor=white
[typst]: https://typst.app/
[ats-shield]: https://img.shields.io/badge/ATS-friendly-2ea44f
[ats-notes]: #ats-notes
[foundation-shield]: https://img.shields.io/badge/foundation-brilliant--CV-8a63d2
[brilliant-cv]: https://github.com/yunanwg/brilliant-CV
[yunan-wang]: https://github.com/yunanwg
