# PDF `ActualText` Post-Processing

This note documents the repo-local PDF post-processing path used to add `ActualText` where native Typst markup is not enough.

## Why This Exists

- Typst can render the visible certification pills, but it does not currently give this project a direct markup-level way to attach PDF `ActualText` to that decorative content.
- For the resume, the first accessibility target is the Certifications row in the Skills section.
- The repo therefore uses a narrow post-processing step after `cv.pdf` is compiled.

## Current Scope

- Document support in v1: `cv.pdf` only
- Section support in v1: certification pills in the Skills section only
- Python runtime: the repo-local `.venv`
- PDF library: `PyMuPDF`

`letter.pdf` is intentionally out of scope for this first pass.

## Typst Metadata Contract

Metadata is emitted in [components/actual-text.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/components/actual-text.typ) and consumed by [components/skills.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/components/skills.typ).

Each wrapped certification pill emits one `metadata(...)` item labeled `<next-resume-actual-text>` with:

- `kind`
- `id`
- `actual`
- `page`
- `x`
- `y`
- `width`
- `height`

The post-processor reads those entries through `typst query`, so the PDF itself no longer needs hidden text markers.

## Processing Flow

[tools/next_resume_postprocess.py](C:/Users/dashe/source/repos/Typst/next-resume-typst/tools/next_resume_postprocess.py) does the following:

1. Open the compiled `cv.pdf`.
2. Run `typst query` against `cv.typ` to retrieve the labeled metadata as JSON.
3. Convert the queried page geometry into PyMuPDF rectangles.
4. Find the original certification text spans in the raw PDF content stream.
5. Patch those original spans in place by adding PDF `/ActualText`.
6. Tag the patched spans with a repo-local `/NextResumeID` so repeat runs stay idempotent.

This keeps the visual output stable while preserving the row's natural reading order.

## CLI Usage

One-shot processing:

```powershell
.\.venv\Scripts\python.exe tools\next_resume_postprocess.py process --document cv --pdf cv.pdf --input language=en --in-place
```

Watch mode:

```powershell
.\.venv\Scripts\python.exe tools\next_resume_postprocess.py watch --document cv --pdf cv.pdf --input language=en
```

VS Code tasks mirror that CLI:

- `Postprocess: CV`
- `Postprocess: Watch CV`
- `Build: CV Final`
- `Watch: CV Final`

## Limitations

- v1 is intentionally narrow and should not be treated as a general PDF accessibility engine.
- The current implementation is tuned specifically to the Certifications pill row in the Skills section.
- The tool is idempotent for already-processed PDFs: it skips any region whose `/NextResumeID` is already present in the PDF.
- If `typst query` stops returning the expected metadata payload, processing fails instead of silently guessing.
- Generic PDF text-extraction libraries do not always honor `/ActualText`, so low-level stream inspection is a more reliable automated verification step than plain extracted text.
