<div align="center">
  <h1>NextResume</h1>
  <p><strong>The CV/Resume template</strong></p>

[![Version][version-shield]][version-file]
[![License][licence-shield]][licence-file]
[![Typst][typst-shield]][typst]
[![ATS Friendly][ats-shield]][ats-notes]
[![Changelog][changelog-shield]][changelog-file]
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

See [CHANGELOG.md][changelog-file] for the full release history.

- ATS-conscious PDF output: hidden keyword injection is disabled by default,
  semantic project links use `/ActualText`, and visual footer text stays out of
  copied resume content.
- NextResume-owned rendering layer: the CV path now runs through local core and
  entry components while preserving the compact brilliant-CV visual language.
- Stronger authoring model: version validation, shared entry primitives,
  project metadata rows, keep-together entries, and build tooling make the
  template easier to maintain and extend.

## Main Files

- `cv.typ`: CV/resume entry point using the local NextResume wrapper.
- `letter.typ`: cover-letter entry point.
- `metadata.toml`: identity, layout, styling, language, ATS, footer, and
  version settings.
- `modules_en/*.typ`: English resume section content.
- `core/nextresume.typ`: local CV/resume template wrapper.
- `components/entry.typ`: shared entry header, description, and full-entry
  primitives.
- `components/info-link.typ`: semantic info/project links with ActualText
  metadata.
- `components/project-entry.typ`: project and association entry renderer.
- `components/artifact-footer.typ`: artifact footer renderer.
- `tools/build.ps1`: CV build wrapper that compiles and applies ActualText.
- `tools/apply-actual-text.py`: PDF post-processor for semantic link text.
- `tools/generate-footer-assets.ps1`: footer SVG asset generator.
- `assets/`: profile images, signatures, logos, generated footer SVGs, and
  other binary inputs.

Generated PDFs are build outputs. Edit the Typst, TOML, module, tool, or asset
sources instead.

## Build

For the CV/resume, use the build wrapper so semantic project links are
post-processed with PDF `/ActualText`:

```powershell
powershell -ExecutionPolicy Bypass -File tools\build.ps1
```

For quick raw Typst output without post-processing:

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

[version-shield]: https://img.shields.io/badge/version-0.3.0-blue
[version-file]: ./VERSION
[licence-shield]: https://img.shields.io/badge/licence-MIT-green
[licence-file]: ./LICENSE
[typst-shield]: https://img.shields.io/badge/language-Typst-239DAD?logo=typst&logoColor=white
[typst]: https://typst.app/
[ats-shield]: https://img.shields.io/badge/ATS-friendly-2ea44f
[ats-notes]: #ats-notes
[changelog-shield]: https://img.shields.io/badge/changelog-keep%20a%20changelog-orange
[changelog-file]: ./CHANGELOG.md
[foundation-shield]: https://img.shields.io/badge/foundation-brilliant--CV-8a63d2
[brilliant-cv]: https://github.com/yunanwg/brilliant-CV
[yunan-wang]: https://github.com/yunanwg
