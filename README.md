# next-resume-typst

Typst resume and cover-letter workspace built on `@preview/brilliant-cv:3.3.0`.

## Main Files

- `cv.typ`: resume entry point
- `letter.typ`: cover-letter entry point
- `metadata.toml`: identity, layout, styling, language, ATS, and version settings
- `modules_en/*.typ`: resume section content
- `assets/`: images, signatures, logos, bibliography, and other binary inputs

Generated PDFs are build outputs. Edit the Typst, TOML, module, or asset sources instead.

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

## Agent Notes

AI/operator documentation has moved to MindVault:

`C:\Users\dashe\OneDrive\Documents\MindVault\AI\evidence\workspaces\next-resume-typst\Next Resume Typst Workspace.md`

Use `AGENTS.md` for the short local linker and MindVault for durable project knowledge.
