@echo off
setlocal

set "TOOL_DIR=%~dp0"
set "VENV_PYTHON=%TOOL_DIR%.venv\Scripts\python.exe"

if exist "%VENV_PYTHON%" goto run

set "UV_BIN="
if defined NEXTRESUME_UV_PATH if exist "%NEXTRESUME_UV_PATH%" set "UV_BIN=%NEXTRESUME_UV_PATH%"
if not defined UV_BIN for /f "delims=" %%I in ('where uv 2^>nul') do (
  set "UV_BIN=%%I"
  goto found_uv
)
if not defined UV_BIN if exist "%USERPROFILE%\.cargo\bin\uv.exe" set "UV_BIN=%USERPROFILE%\.cargo\bin\uv.exe"
if not defined UV_BIN if exist "%USERPROFILE%\.local\bin\uv.exe" set "UV_BIN=%USERPROFILE%\.local\bin\uv.exe"
if not defined UV_BIN if exist "%LOCALAPPDATA%\Programs\uv\uv.exe" set "UV_BIN=%LOCALAPPDATA%\Programs\uv\uv.exe"
if not defined UV_BIN if exist "%LOCALAPPDATA%\Microsoft\WinGet\Links\uv.exe" set "UV_BIN=%LOCALAPPDATA%\Microsoft\WinGet\Links\uv.exe"

:found_uv
if not defined UV_BIN (
  echo nextresume: unable to locate uv. Set NEXTRESUME_UV_PATH or install uv on PATH.
  exit /b 1
)

"%UV_BIN%" sync --project "%TOOL_DIR%"
if errorlevel 1 exit /b %errorlevel%

:run
"%VENV_PYTHON%" -m nextresume_tool %*
exit /b %errorlevel%
