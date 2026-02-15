# Injects GOOGLE_MAPS_API_KEY from .env into web/index.html (for IDE run/debug).
# Use with preLaunchTask in launch.json.

$ErrorActionPreference = "Stop"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$indexPath = Join-Path $projectRoot "web\index.html"

$key = $env:GOOGLE_MAPS_API_KEY
if (-not $key) {
    $envFile = Join-Path $projectRoot ".env"
    if (Test-Path $envFile) {
        Get-Content $envFile -Raw | ForEach-Object {
            if ($_ -match 'GOOGLE_MAPS_API_KEY\s*=\s*(.+)') { $key = $matches[1].Trim() }
        }
    }
}

if (-not $key) {
    Write-Host "GOOGLE_MAPS_API_KEY not set. Add it to .env or set the env var." -ForegroundColor Yellow
    exit 1
}

(Get-Content $indexPath -Raw) -replace '__GOOGLE_MAPS_API_KEY__', $key | Set-Content $indexPath -NoNewline
Write-Host "Injected Google Maps API key into web/index.html" -ForegroundColor Green
exit 0
