@echo off
openapi-generator-cli generate -i api/openapi.json -g dart -o lib/models
