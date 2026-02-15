# Run Flutter web locally with Google Maps API key injected from env or .env.local.
# Restores web/index.html on exit so the key is never committed.
# Usage: .\scripts\serve_web.ps1   or   .\scripts\serve_web.ps1 -Device chrome

param([string]$Device = "chrome")

$ErrorActionPreference = "Stop"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$indexPath = Join-Path $projectRoot "web\index.html"

# Load key: env var wins, then .env in project root
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
    Write-Host "GOOGLE_MAPS_API_KEY not set. Either:" -ForegroundColor Yellow
    Write-Host "  1. Set env: `$env:GOOGLE_MAPS_API_KEY = 'your-key'" -ForegroundColor Yellow
    Write-Host "  2. Or create .env in project root with: GOOGLE_MAPS_API_KEY=your-key" -ForegroundColor Yellow
    exit 1
}

$originalHtml = Get-Content $indexPath -Raw
try {
    $originalHtml -replace '__GOOGLE_MAPS_API_KEY__', $key | Set-Content $indexPath -NoNewline
    Set-Location $projectRoot
    flutter run -d $Device
} finally {
    Set-Content $indexPath -Value $originalHtml -NoNewline
    Write-Host "Restored web/index.html (placeholder only)." -ForegroundColor Green
}
