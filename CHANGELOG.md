# Changelog

All notable changes to NextResume are documented in this file.

## [Unreleased]

### Changed

- Right-aligned the header profile photo within the header grid so it stays pinned to the right edge even when the text-side header content is long.

## [0.5.0] - 2026-05-01

### Added

- Added `NextResume Tools`, a centralized Python + UV tooling host for build, watch, footer generation, PDF inspection, cleaning, diagnostics, and a TUI launcher.
- Added `.tooling/` as the standard location for tool-generated logs, manifests, debug PDFs, and extracted helper artifacts.
- Added VS Code task and debug integration for the new tooling host so normal document workflows no longer depend on manual PowerShell script usage.
- Added repository guidance in `AGENTS.md`, `README.md`, and tooling docs for task-driven PDF inspection and release workflows.

### Changed

- Promoted NextResume from a customized template into a release-quality resume system with a first-class local tooling layer.
- Switched the preferred verification path from ad hoc scripts to `tools\nextresume.cmd` and VS Code tasks.
- Bumped the project version from `0.4.0` to `0.5.0` and aligned metadata-driven version checks with the new release.

### Removed

- Removed the old PowerShell-based `tools\build.ps1` and `tools\generate-footer-assets.ps1` workflow.
- Removed the standalone `tools\apply-actual-text.py` / `tools\requirements.txt` script path in favor of the centralized host.

## [0.4.0] - 2026-05-01

### Added

- Added a local stack-based CV header renderer with labeled personal-info links and canonical hyperlink targets.
- Added X and Medium personal-info keys for modern social/profile links.

### Changed

- Restored header personal-info `/ActualText` with labeled canonical values such as `GitHub: https://github.com/yunanwg`.
- Reworked the header layout around ordered `stack` compartments and a visual grid so the rendered header avoids table semantics while preserving the brilliant-CV look.
- Header icons use typed decorative PDF artifacts so readers that honor artifacts can ignore Font Awesome glyph text during copy.
- Strengthened the ActualText post-processor fixture to tolerate nested decorative artifacts inside semantic link spans.

## [0.3.0] - 2026-04-29

### Added

- Added semantic project/info links with PDF `/ActualText`, keeping polished visible labels while copy/search can recover full URLs.
- Added the `tools/build.ps1` CV build wrapper and `tools/apply-actual-text.py` PDF post-processor.
- Added reusable `info-link`, `project-link`, and `project-entry` components for richer project metadata rows.
- Added keep-together entry rendering with `allow_break` opt-in for long `cv-entry` and `project-entry` blocks.

### Changed

- Refactored the entry layer around `components/entry.typ`, with `cv-entry-header`, `cv-entry-description`, and `cv-entry` as the shared primitives.
- Updated project entries to compose the same entry primitives as professional and education entries.
- Migrated the grouped professional example away from `cv-entry-start` and `cv-entry-continued`.
- Improved project link extraction so ActualText values remain URL-only and avoid duplicated semantic labels.

### Removed

- Removed the repo-local `components/entries.typ` wrapper module and the public `cv-entry-start` / `cv-entry-continued` wrappers.

## [0.2.0] - 2026-04-29

### Added

- Added the local `core/nextresume.typ` wrapper for the CV/resume path.
- Added compile-time version validation between `VERSION` and `metadata.toml`.
- Added local PDF metadata handling through the NextResume template layer.
- Added visible artifact-based footer rendering with generated SVG assets.

### Changed

- Shifted ATS strategy away from hidden keyword injection and toward visible, truthful resume content.
- Updated the README to describe NextResume as a template derived from the brilliant-CV foundation.
- Reorganized local template structure around NextResume-owned components and core modules.

## [0.1.3] - 2026-04-29

### Added

- Added the early NextResume/brilliant-CV customization baseline with version validation and metadata support.

[0.5.0]: https://github.com/D-Naveenz/next-resume-typst/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/D-Naveenz/next-resume-typst/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/D-Naveenz/next-resume-typst/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/D-Naveenz/next-resume-typst/compare/v0.1.3...v0.2.0
[0.1.3]: https://github.com/D-Naveenz/next-resume-typst/releases/tag/v0.1.3
