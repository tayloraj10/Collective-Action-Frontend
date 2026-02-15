# Restores web/index.html so the Maps key is the placeholder again (for postDebugTask).

$ErrorActionPreference = "Stop"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$indexPath = Join-Path $projectRoot "web\index.html"

$content = Get-Content $indexPath -Raw
# Replace any Google API key in the script tag with the placeholder
$content = $content -replace 'key=AIzaSy[^&"\s]+', 'key=__GOOGLE_MAPS_API_KEY__'
Set-Content $indexPath -Value $content -NoNewline
Write-Host "Restored web/index.html (Maps key placeholder)." -ForegroundColor Green
