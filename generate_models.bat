@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo Using batch file: "%~f0"
echo Working directory: "%CD%"
echo.

where node >nul 2>&1
if errorlevel 1 (
  echo ERROR: node is not in PATH. Add Node.js to PATH and try again.
  exit /b 1
)

echo Generating Dart API client...
call openapi-generator-cli generate -i api/openapi.json -g dart -o lib/api -c openapi-config.yaml
if errorlevel 1 exit /b 1

echo.
echo Applying post-generation patch (multipart files list)...
cd /d "%~dp0"
if not exist "scripts\patch_photos_api_multipart.js" (
  echo ERROR: Patch script not found at "%~dp0scripts\patch_photos_api_multipart.js"
  exit /b 1
)
echo Running: node "%~dp0scripts\patch_photos_api_multipart.js"
node scripts\patch_photos_api_multipart.js
if errorlevel 1 (
  echo Patch failed. Run "node scripts\patch_photos_api_multipart.js" manually to see the error.
  exit /b 1
)
echo Patch complete.

echo.
echo Running flutter pub get...
call flutter pub get

echo.
echo Done!
pause