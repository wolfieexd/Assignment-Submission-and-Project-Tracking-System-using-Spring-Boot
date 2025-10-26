# Start User Service with Neon PostgreSQL
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Starting User Service with Neon PostgreSQL" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Set-Location "$PSScriptRoot\backend\user-service"

Write-Host "Loading environment variables from .env..." -ForegroundColor Yellow
Get-Content "$PSScriptRoot\.env" | ForEach-Object {
    if ($_ -match '^([^=#]+)=(.*)$') {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()
        [Environment]::SetEnvironmentVariable($key, $value, 'Process')
        if ($key -eq 'DB_HOST') {
            Write-Host "  Database Host: $value" -ForegroundColor Green
        }
        if ($key -eq 'DB_NAME_USER') {
            Write-Host "  Database Name: $value" -ForegroundColor Green
        }
        if ($key -eq 'DB_USER') {
            Write-Host "  Database User: $value" -ForegroundColor Green
        }
    }
}

$env:SPRING_PROFILES_ACTIVE = "neon"
Write-Host "`nSpring Profile: neon (PostgreSQL)" -ForegroundColor Green
Write-Host "`nStarting service...`n" -ForegroundColor Yellow

mvn spring-boot:run
