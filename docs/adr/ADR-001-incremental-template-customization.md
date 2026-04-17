# ADR-001: Prefer Incremental Template Customization

- Status: Accepted
- Date: 2026-04-17

## Context

This repository starts from the `@preview/brilliant-cv:3.3.0` Typst template and aims to become a more modern, polished resume system. The project is still early in its customization lifecycle, and most current behavior is driven by the upstream template plus local metadata and section files.

## Decision

The project will prefer incremental, local customization over forking or replacing the upstream template.

This means:

- use `metadata.toml` first for design and identity changes
- keep content changes in `modules_en/*.typ`
- add small wrapper logic in `cv.typ` or `letter.typ` when needed
- only consider a deeper template fork if repeated requirements cannot be expressed cleanly through local files

## Consequences

Positive:

- changes stay smaller and easier to verify
- PDF regressions are less likely during early modernization
- the repo remains close to the upstream data model

Tradeoffs:

- some layout ambitions may be constrained by `brilliant-cv`
- deeper visual identity work may eventually require more local Typst structure

## Revisit When

- the package blocks an important layout or typography requirement
- wrapper logic becomes hard to understand or maintain
- repeated workarounds suggest the local-extension strategy is no longer paying off
