@echo off
setlocal
cd /d "%~dp0"

set IMAGE_NAME=phenoscript-pipeline
set MAIN_DIR=%~dp0main

echo === Building Docker image: %IMAGE_NAME% ===
docker build -t %IMAGE_NAME% "%MAIN_DIR%"
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Docker build failed. Is Docker Desktop running?
    pause
    exit /b 1
)

echo.
echo === Running pipeline ===
docker run --rm -v "%MAIN_DIR%:/main" %IMAGE_NAME%
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
