@echo off
setlocal
cd /d "%~dp0"

set IMAGE=ghcr.io/sergeitarasov/phenoscript-cuiaba-2026:latest
set MAIN_DIR=%~dp0main

echo === Pulling Docker image ===
docker pull %IMAGE%
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Could not pull image. Is Docker Desktop running and do you have internet access?
    pause
    exit /b 1
)

echo.
echo === Running pipeline ===
docker run --rm -v "%MAIN_DIR%:/main" %IMAGE%
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Pipeline failed. See output above for details.
    pause
    exit /b 1
)

echo.
echo === Pipeline complete ===
echo Output : %MAIN_DIR%\output
echo Logs   : %MAIN_DIR%\log
echo.
pause
