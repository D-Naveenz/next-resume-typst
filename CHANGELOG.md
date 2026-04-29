# Changelog

All notable changes to NextResume are documented in this file.

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

[0.3.0]: https://github.com/D-Naveenz/next-resume-typst/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/D-Naveenz/next-resume-typst/compare/v0.1.3...v0.2.0
[0.1.3]: https://github.com/D-Naveenz/next-resume-typst/releases/tag/v0.1.3
