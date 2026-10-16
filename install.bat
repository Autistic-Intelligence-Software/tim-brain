@echo off
REM Tim Brain Bundle - one-click installer (Windows)
REM Installs Ollama (if missing), downloads your chosen AI model, and sets up
REM the start script. Your PC becomes Tim's free local "brain" - no API key,
REM no per-message cost.
setlocal EnableDelayedExpansion

echo ==============================================
echo   Tim Brain Bundle - installer
echo ==============================================
echo.

REM ---- 1. Ollama ----
where ollama >nul 2>nul
if %errorlevel%==0 (
  echo [1/3] Ollama already installed.
) else (
  echo [1/3] Installing Ollama via winget...
  winget install -e --id Ollama.Ollama --accept-source-agreements --accept-package-agreements
  if %errorlevel% neq 0 (
    echo.
    echo Ollama install failed. Install it manually from https://ollama.com/download
    echo then re-run this installer.
    pause
    exit /b 1
  )
  echo       Ollama installed. You may need to restart this window once.
)

REM ---- 2. Model choice ----
echo.
echo [2/3] Choose your brain model:
echo   1^) dolphin-llama3  - uncensored, best quality (~4.7 GB)  [recommended]
echo   2^) dolphin-phi     - uncensored, light, weaker PCs (~1.6 GB)
echo   3^) llama3.1        - standard (has safety guardrails) (~4.7 GB)
echo   4^) qwen2.5:3b      - standard, light, weaker PCs (~1.9 GB)
set /p choice="Pick 1-4 [1]: "
if "%choice%"=="" set choice=1
if "%choice%"=="1" set MODEL=dolphin-llama3
if "%choice%"=="2" set MODEL=dolphin-phi
if "%choice%"=="3" set MODEL=llama3.1
if "%choice%"=="4" set MODEL=qwen2.5:3b
if not defined MODEL (
  echo Invalid choice.
  pause
  exit /b 1
)

echo       Downloading model: %MODEL% (this takes a while on first run)...
call ollama pull %MODEL%
echo %MODEL%>.tomo-model
echo       Model ready.

REM ---- 3. Start script ----
(
echo @echo off
echo REM Starts your Tim brain (Ollama serving the installed model).
echo set /p MODEL=^<.tomo-model
echo echo Starting Tim brain (model: %%MODEL%%^)...
echo echo Local API: http://localhost:11434
echo echo.
echo echo NEXT STEPS (one time^):
echo echo   1. Expose this PC to the internet, e.g.:  ngrok http 11434
echo echo   2. In the Tim dashboard, set AI provider = Custom endpoint,
echo echo      model = %%MODEL%%, endpoint URL = your tunnel URL.
echo echo   3. Keep this window open while you want Tim to use your brain.
echo echo.
echo ollama serve
) > start-brain.bat

echo.
echo [3/3] Done! Run start-brain.bat whenever you want Tim to use your PC.
echo       First-time setup continues in the README (tunnel + dashboard step).
pause
