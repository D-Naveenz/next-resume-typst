<div align="center">
  <h1>NextResume</h1>
  <p><strong>The release-quality CV/Resume system</strong></p>

[![Version][version-shield]][version-file]
[![License][licence-shield]][licence-file]
[![Typst][typst-shield]][typst]
[![ATS Friendly][ats-shield]][ats-notes]
[![Changelog][changelog-shield]][changelog-file]
[![brilliant-CV Foundation][foundation-shield]][brilliant-cv]

</div>

NextResume is a modern Typst CV/resume system that balances polished visual
presentation with ATS-friendly PDF structure, semantic contact/project links,
maintainable resume composition, and a centralized release-quality tooling host.

## Why NextResume

Most CV and resume templates lean too far in one direction: they either look
good but copy poorly, or they parse cleanly but feel visually plain. NextResume
exists to balance both sides: a refined resume that still behaves well when a
PDF reader, recruiter, or Applicant Tracking System extracts the text.

NextResume began with [`brilliant-CV`][brilliant-cv] by
[Yunan Wang][yunan-wang] and its contributors as the foundation. That template
provided a strong visual direction, useful metadata conventions, and a compact
professional style worth preserving.

NextResume now owns much of the rendering path itself. It uses brilliant-CV
mainly as a style and metadata base while local NextResume components handle
the CV wrapper, header, entries, project rows, semantic links, footer behavior,
version checks, and build-time PDF post-processing. The intention is still to
keep the overall brilliant-CV look familiar, but the structure underneath is
increasingly NextResume's own.

## What Changed

See [CHANGELOG.md][changelog-file] for the full release history.

- ATS-conscious PDF output: hidden keyword injection is disabled by default,
  header contact links and project links use `/ActualText`, and visual footer
  text stays out of copied resume content.
- NextResume-owned rendering layer: the CV path now runs through local core,
  header, entry, project, and footer components while preserving the compact
  brilliant-CV visual language.
- Stronger authoring model: version validation, shared entry primitives,
  project metadata rows, keep-together entries, and centralized tooling make
  the template easier to maintain, inspect, and release.

## Main Files

- `cv.typ`: CV/resume entry point using the local NextResume wrapper.
- `letter.typ`: cover-letter entry point.
- `metadata.toml`: identity, layout, styling, language, ATS, footer, and
  version settings.
- `modules_en/*.typ`: English resume section content.
- `core/nextresume.typ`: local CV/resume template wrapper.
- `components/entry.typ`: shared entry header, description, and full-entry
  primitives.
- `components/info-link.typ`: reusable info/project links with optional
  ActualText metadata.
- `components/header.typ`: local stack-based CV header renderer with labeled,
  hyperlink-backed personal info and semantic ActualText.
- `components/project-entry.typ`: project and association entry renderer.
- `components/artifact-footer.typ`: artifact footer renderer.
- `tools/`: centralized Python + UV tooling host for build, watch, footer,
  PDF helper, clean, and TUI workflows.
- `tools/nextresume.cmd`: Windows launcher used by VS Code tasks and terminal
  workflows without requiring PowerShell.
- `.tooling/`: generated logs, manifests, debug PDFs, extracted assets, and
  other tool outputs.
- `assets/`: profile images, signatures, logos, generated footer SVGs, and
  other binary inputs.

Generated PDFs are build outputs. Edit the Typst, TOML, module, tool, or asset
sources instead.

## Build

The main developer workflow is now VS Code task-driven. Open the command
palette and run the `Tasks: Run Task` actions such as `Tool: Build CV Final`,
`Tool: Watch CV Final`, or `Tool: Open TUI`.

For terminal usage, the centralized tool host handles build, watch, footer,
PDF helpers, and cleaning. The CV/resume build still post-processes header and
project links with PDF `/ActualText`:

```powershell
tools\nextresume.cmd build cv --language en
```

To build both documents:

```powershell
tools\nextresume.cmd build all --language en
```

To inspect a PDF through the centralized tool host:

```powershell
tools\nextresume.cmd pdf inspect cv.pdf
```

For quick raw Typst output without the centralized tooling host:

```powershell
typst compile cv.typ cv.pdf
typst compile letter.typ letter.pdf
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
tools\nextresume.cmd footer generate
```

The generator writes assets like `assets/footer/footer-en.svg`, keyed by the
language code.

## Release Tooling

NextResume Tools is now part of the normal project surface rather than an
optional helper layer.

- Use VS Code tasks for everyday build/watch workflows.
- Use `tools\nextresume.cmd doctor` to verify the toolchain before release work.
- Use `tools\nextresume.cmd pdf inspect <file>` when inspecting generated PDFs.
- Expect `.tooling/` to hold logs, manifests, extracted artifacts, and debug PDFs.

## ATS Notes

NextResume avoids hidden keyword stuffing. Keywords should appear naturally in
visible content, especially the Skills section and experience bullets. PDF
metadata is still useful for document properties, but it should not be treated
as the main ATS keyword strategy.

## Credits

NextResume builds on the excellent style and metadata foundation of
[`brilliant-CV`][brilliant-cv] by [Yunan Wang][yunan-wang] and contributors.
Their work provided the starting point that made this template possible.

[version-shield]: https://img.shields.io/badge/version-0.5.0-blue
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
