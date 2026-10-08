param(
    [string]$DbtProfileName = "sql_transform_practice",
    [string]$PgHost = "localhost",
    [int]$PgPort = 5432,
    [string]$PgUser = "postgres",
    [string]$PgPassword = "postgres",
    [string]$PgDatabase = "sql_transform_practice",
    [string]$PgSchema = "analytics"
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

Write-Host "=== STEP 1: Check Python ===" -ForegroundColor Cyan
python --version

Write-Host "=== STEP 2: Create virtual environment ===" -ForegroundColor Cyan
if (!(Test-Path ".venv")) {
    python -m venv .venv
}

Write-Host "=== STEP 3: Activate virtual environment ===" -ForegroundColor Cyan
& .\.venv\Scripts\Activate.ps1

Write-Host "=== STEP 4: Install dbt-postgres ===" -ForegroundColor Cyan
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

Write-Host "=== STEP 5: Check dbt version ===" -ForegroundColor Cyan
dbt --version

Write-Host "=== STEP 6: Create ~/.dbt/profiles.yml ===" -ForegroundColor Cyan
$DbtDir = Join-Path $HOME ".dbt"
if (!(Test-Path $DbtDir)) {
    New-Item -ItemType Directory -Path $DbtDir | Out-Null
}

$ProfilesPath = Join-Path $DbtDir "profiles.yml"
$SafePassword = $PgPassword.Replace("'", "''")

$Yaml = @"
$DbtProfileName:
  target: dev
  outputs:
    dev:
      type: postgres
      host: $PgHost
      user: $PgUser
      password: '$SafePassword'
      port: $PgPort
      dbname: $PgDatabase
      schema: $PgSchema
      threads: 4
"@

Set-Content -Path $ProfilesPath -Value $Yaml -Encoding UTF8
Write-Host "profiles.yml created at: $ProfilesPath" -ForegroundColor Green

Write-Host "=== NEXT STEPS ===" -ForegroundColor Green
Write-Host "1. Create database/schema using scripts/init_database.sql and scripts/init_schemas.sql if not created yet."
Write-Host "2. Run: .\scripts\run_dbt.ps1"
