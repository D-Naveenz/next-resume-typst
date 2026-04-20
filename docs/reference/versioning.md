# Version Validation And PDF Metadata

This note documents the repo-local NextResume versioning workflow.

## Source Of Truth

- The canonical product version lives in the root [VERSION](C:/Users/dashe/source/repos/Typst/next-resume-typst/VERSION) file.
- [metadata.toml](C:/Users/dashe/source/repos/Typst/next-resume-typst/metadata.toml) mirrors that value in `next_resume.version`.
- Typst compilation fails if those two values do not match exactly.

## Reusable Helper

[components/versioning.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/components/versioning.typ) provides two repo-local helpers:

- `validate-next-resume-version(metadata)`
- `set-next-resume-document-metadata(metadata, next-resume-version, kind: ...)`

The validator:

- reads `../VERSION`
- trims and parses `major.minor.patch`
- reads `metadata.next_resume.version`
- asserts exact equality

This is enforced in both [cv.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/cv.typ) and [letter.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/letter.typ).

## PDF Metadata

Typst's `document(...)` metadata API is used to inject standard PDF metadata fields:

- `title`
- `author`
- `description`
- `keywords`

For this repo, the version is currently embedded into:

- `description`: `Generated with NextResume vX.Y.Z (...)`
- `keywords`: `NextResume`, `vX.Y.Z`, and the document kind

This is standard PDF metadata, not a custom PDF property.

## Limits

- The current validator expects `major.minor.patch` only.
- The compile guard enforces exact match, not range compatibility.
- Native Typst supports standard PDF metadata fields, but not arbitrary custom PDF metadata keys for a dedicated `NextResumeVersion` field.
