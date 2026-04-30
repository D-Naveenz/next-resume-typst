# Changelog

All notable changes to NextResume are documented in this file.

## [Unreleased]

### Added

- Added a local CV header renderer with labeled personal-info links and canonical hyperlink targets.
- Added X and Medium personal-info keys for modern social/profile links.

### Changed

- Header icons use typed decorative PDF artifacts so readers that honor artifacts can ignore Font Awesome glyph text during copy.
- Header contact links no longer emit `/ActualText`; Adobe Reader repeats row-level or nested link ActualText across header sub-runs, so the header now relies on visible labels plus hyperlink targets while project links keep `/ActualText`.
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

[0.3.0]: https://github.com/D-Naveenz/next-resume-typst/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/D-Naveenz/next-resume-typst/compare/v0.1.3...v0.2.0
[0.1.3]: https://github.com/D-Naveenz/next-resume-typst/releases/tag/v0.1.3
