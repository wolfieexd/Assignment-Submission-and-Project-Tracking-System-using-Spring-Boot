# PowerShell Script to Start Submission Service with Neon PostgreSQL
# This script loads environment variables from .env and starts the submission service
# with the 'neon' profile to connect to Neon PostgreSQL database

# Set error action preference
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Submission Service with Neon PostgreSQL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Load environment variables from .env file
$envFile = "$PSScriptRoot\.env"
if (Test-Path $envFile) {
    Write-Host "Loading environment variables from .env..." -ForegroundColor Yellow
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]*)\s*=\s*(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
        }
    }
    
    # Display loaded database configuration
    Write-Host "  Database Host: $env:DB_HOST" -ForegroundColor Green
    Write-Host "  Database Name: $env:DB_NAME_SUBMISSION" -ForegroundColor Green
    Write-Host "  Database User: $env:DB_USER" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "ERROR: .env file not found at: $envFile" -ForegroundColor Red
    Write-Host "Please create .env file from .env.template" -ForegroundColor Red
    exit 1
}

# Set Spring profile to use Neon PostgreSQL
$env:SPRING_PROFILES_ACTIVE = "neon"
Write-Host "Spring Profile: $env:SPRING_PROFILES_ACTIVE (PostgreSQL)" -ForegroundColor Magenta
Write-Host ""

# Navigate to submission-service directory
Set-Location "$PSScriptRoot\backend\submission-service"

# Start the service
Write-Host "Starting service..." -ForegroundColor Yellow
Write-Host ""
& mvn spring-boot:run
