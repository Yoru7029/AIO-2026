$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

Write-Host "=== Activate virtual environment ===" -ForegroundColor Cyan
& .\.venv\Scripts\Activate.ps1

Write-Host "=== dbt debug ===" -ForegroundColor Cyan
dbt debug

Write-Host "=== dbt seed ===" -ForegroundColor Cyan
dbt seed --full-refresh

Write-Host "=== dbt compile ===" -ForegroundColor Cyan
dbt compile

Write-Host "=== dbt run ===" -ForegroundColor Cyan
dbt run

Write-Host "=== dbt test ===" -ForegroundColor Cyan
dbt test

Write-Host "=== dbt docs generate ===" -ForegroundColor Cyan
dbt docs generate

Write-Host "=== Done ===" -ForegroundColor Green
Write-Host "Optional: run 'dbt docs serve' to view docs in browser."
