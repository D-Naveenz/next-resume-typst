---
name: merge-tailoring-branch
description: Safely hand off reusable improvements from this repository's private tailoring branches into development. Use when Codex needs to review, merge, cherry-pick, or port changes from branches named tailoring/* while preventing person-specific resume data, profile assets, employer/school details, generated private PDFs, or other tailoring content from leaking into development.
---

# Merge Tailoring Branch

## Purpose

Use this skill to turn improvements discovered during a person-specific resume tailoring branch into a clean development-branch change. Treat privacy as the primary requirement: the tailoring branch may be inspected locally, but personal data must not be copied, committed, published, summarized in public PR text, or moved into shared documentation.

## Quick Report

Before merging, run the helper from the repository root:

```powershell
python .agents\skills\merge-tailoring-branch\scripts\tailoring_merge_report.py --base development --tailoring tailoring/<name>
```

Use the report as a starting map only. It intentionally lists file paths and commit subjects without printing full diffs.

## Controlled Workflow

1. Confirm the branch shape.
   - Start from a clean worktree. If unrelated user changes exist, stop and preserve them.
   - Identify the private source branch, normally `tailoring/<name>`, and the target branch, normally `development`.
   - Review only commits ahead of development: `git log --reverse --no-merges development..tailoring/<name>`.

2. Open a no-fast-forward merge for inspection.
   - Create a temporary integration branch from `development`, for example `codex/merge-tailoring-<name>-improvements`.
   - Run `git merge --no-commit --no-ff tailoring/<name>`.
   - Inspect `git status --short`, `git diff --name-status --cached`, and targeted diffs. Do not commit this raw merge.

3. Classify every change.
   - Reusable improvements: template logic, reusable components, generic layout controls, tooling, generic docs, generic icons, footer/post-processing infrastructure, CI/release metadata.
   - Private tailoring content: `metadata.toml`, profile images, person names, contact details, career history, employer or school evidence, generated private PDFs, cover-letter content, and person-specific resume modules.
   - Ambiguous changes: files that mix template improvements with personal content, especially `cv.typ`, `modules_en/*.typ`, `CHANGELOG.md`, and assets added during tailoring.

4. Use commit history to resolve ambiguity.
   - Inspect the ahead commits one by one with `git show --stat <sha>` and, only as needed, targeted patches.
   - Use verbose commit messages to understand intent.
   - Prefer re-creating reusable behavior cleanly on the development branch when a commit mixes reusable code and private data.

5. Port only safe improvements.
   - Abort or discard the raw merge after inspection.
   - Apply clean changes onto the integration branch using reviewed patches, selective checkout of safe paths, or manual reimplementation.
   - Never copy a whole file from the tailoring branch if it contains private content. Extract the generic behavior instead.
   - Keep version bumps and changelog wording development-facing. If the tailoring branch proves a version-worthy improvement, prepare the bump on development without mentioning the tailored person.

6. Verify from development data.
   - Run the project checks after meaningful Typst or layout edits:

```powershell
tools\nextresume.cmd doctor
tools\nextresume.cmd build cv --language en
tools\nextresume.cmd build letter --language en
tools\nextresume.cmd pdf render cv.pdf
```

7. Publish the handoff.
   - Commit the sanitized integration branch.
   - Open the PR into `development`, not from the private tailoring branch.
   - In the PR description, describe reusable improvements and validation. Do not include personal facts, private file excerpts, or screenshots from the tailored resume.

## Privacy Review

Before finalizing, run `git diff development...HEAD` on the integration branch and actively search for private data. Treat these as blocking until removed:

- Person names, email addresses, phone numbers, locations, links, summaries, skills, employment history, education history, certifications, project claims, or references from the tailored resume.
- Profile images and person-specific logos or organization assets added only to support the tailored resume.
- Generated PDFs, rendered page images, extracted text, logs, or debug artifacts that contain tailored content.
- Commit messages or PR text that identify the tailored person or expose their resume details.

If unsure whether a hunk is personal or reusable, keep it out of the development handoff and ask for a decision.
