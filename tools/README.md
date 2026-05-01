# NextResume Tooling

This folder contains the centralized Python tooling host for NextResume.

Current project release: `0.5.0`

Primary interfaces:

- VS Code tasks
- `tools\nextresume.cmd`
- `uv run --project tools nextresume ...`

The UV-managed virtual environment lives in `tools/.venv`, and generated tool
artifacts live under the repository `.tooling/` folder.

The required PDF inspection and page-rendering dependencies are provided by
this managed tool environment. Normal repository workflows should not require
manual dependency installation or ad hoc helper runs.

Common commands:

- `tools\nextresume.cmd doctor`
- `tools\nextresume.cmd build cv --language en`
- `tools\nextresume.cmd build letter --language en`
- `tools\nextresume.cmd footer generate`
- `tools\nextresume.cmd pdf inspect cv.pdf`
- `tools\nextresume.cmd pdf render cv.pdf --dpi 144`
