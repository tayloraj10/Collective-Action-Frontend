@echo off
echo Generating Dart API client...
openapi-generator-cli generate -i api/openapi.json -g dart -o lib/api -c openapi-config.yaml

echo.
echo Running flutter pub get...
flutter pub get

echo.
echo Done!
pause