# AI Knowledge Map

This folder is the working knowledge base for the `next-resume-typst` project. Use it to understand how the repo is organized, what constraints matter, and where to record new project memory.

## Reading Order

1. Start with `AGENTS.md` for quick routing and default behavior.
2. Read [project-guidelines.md](project-guidelines.md) for project intent, constraints, and working style.
3. Check [continuous-learning.md](continuous-learning.md) for lessons that came from real changes or regressions.
4. Use `../reference/` when you need source material about the current baseline or repo conventions.
5. Use `../adr/` when a question touches a durable design or workflow decision.

## Knowledge Map

- [project-guidelines.md](project-guidelines.md): Canonical project purpose, repository layout, modernization direction, and verification expectations.
- [continuous-learning.md](continuous-learning.md): Running log of project-specific lessons and repeat patterns worth remembering.
- `../reference/template-baseline.md`: Reference note describing how the current `brilliant-cv` setup is wired together.
- `../adr/ADR-001-incremental-template-customization.md`: Initial architectural decision to prefer incremental local customization over a template fork.

## What Goes Where

- Put active working guidance and repo-specific operating rules in `docs/ai/`.
- Put source or baseline descriptions in `docs/reference/`.
- Put durable decisions with tradeoffs in `docs/adr/`.
- Promote knowledge to a global skill only if it would still be useful outside this resume project.

## Maintenance Workflow

1. Add new lessons to `continuous-learning.md` when work reveals something non-obvious.
2. Split recurring themes into new topic files under `docs/ai/` when the log starts repeating itself.
3. Capture long-lived decisions in a new ADR.
4. Keep `AGENTS.md` short by linking here instead of growing it into a full manual.
