# NextResume Tooling

This folder contains the centralized Python tooling host for NextResume.

Primary interfaces:

- VS Code tasks
- `tools\nextresume.cmd`
- `uv run --project tools nextresume ...`

The UV-managed virtual environment lives in `tools/.venv`, and generated tool
artifacts live under the repository `.tooling/` folder.
