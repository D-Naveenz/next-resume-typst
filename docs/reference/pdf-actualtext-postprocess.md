# PDF `ActualText` Post-Processing

This note documents the repo-local PDF post-processing path used to add `ActualText` where native Typst markup is not enough.

## Why This Exists

- Typst can render the visible certification pills, but it does not currently give this project a direct markup-level way to attach PDF `ActualText` to that decorative content.
- For the resume, the first accessibility target is the Certifications row in the Skills section.
- The repo therefore uses a narrow post-processing step after `cv.pdf` is compiled.

## Current Scope

- Document support in v1: `cv.pdf` only
- Section support in v1: the Certifications tag row in the Skills section only
- Python runtime: the repo-local `.venv`
- PDF library: `PyMuPDF`

`letter.pdf` is intentionally out of scope for this first pass.

## Typst Metadata Contract

Metadata helpers live in [components/actual-text.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/components/actual-text.typ), and the universal visible tag-row component lives in [components/tag-row.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/components/tag-row.typ). The Skills section consumes that helper through [components/skills.typ](C:/Users/dashe/source/repos/Typst/next-resume-typst/components/skills.typ).

Each semantic tag row emits one row-level `metadata(...)` item labeled `<next-resume-actual-text>` with:

- `kind`
- `id`
- `actual`
- `anchor_id`

Each visible pill emits one target-level metadata item with:

- `kind`
- `id`
- `row_id`
- `page`
- `x`
- `y`
- `width`
- `height`

The post-processor reads both row and target entries through `typst query`, so the PDF itself no longer needs hidden text markers.

## Processing Flow

[tools/next_resume_postprocess.py](C:/Users/dashe/source/repos/Typst/next-resume-typst/tools/next_resume_postprocess.py) does the following:

1. Open the compiled `cv.pdf`.
2. Run `typst query` against `cv.typ` to retrieve the labeled metadata as JSON.
3. Convert the queried page geometry into one row bounding box per semantic tag row.
4. Rasterize the visible certification pill row from that rectangle.
5. Redact the whole row rectangle so the original visible tag text is physically removed from the PDF text layer.
6. Reinsert the raster snapshot so the visible pill row still looks the same.
7. Insert one invisible replacement text object for the whole row and wrap it with PDF `/ActualText`.
8. Tag the replacement object with a repo-local `/NextResumeID` marker for debugging and inspection.

This intentionally prioritizes library extraction correctness over deeper PDF-semantic purity: generic extractors should now see one certifications row string instead of multiple live tag spans.

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
- The current implementation is tuned specifically to the Certifications tag row in the Skills section.
- The tool now repatches every processed row on each `process` run instead of skipping previously tagged content.
- Reprocessing an already-processed PDF re-rasterizes the current visible row once, so future broader rollouts should revisit whether a higher-fidelity caching strategy is worth the extra complexity.
- If `typst query` stops returning the expected metadata payload, processing fails instead of silently guessing.
- The current implementation is optimized for the Skills certifications row only; wider adoption to other tag rows should be treated as a separate rollout step even though the Typst component is universal.
