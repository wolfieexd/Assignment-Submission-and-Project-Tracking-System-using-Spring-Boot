@echo off
echo.
echo ========================================
echo  Starting Submission Service with Neon PostgreSQL
echo ========================================
echo.

cd /d "%~dp0backend\submission-service"

echo Loading environment variables from .env...
for /f "tokens=1,2 delims==" %%a in (..\..\..env) do (
    set "line=%%a"
    if not "!line:~0,1!"=="#" (
        set "%%a=%%b"
    )
)

echo Setting Spring profile to 'neon'...
set SPRING_PROFILES_ACTIVE=neon

echo.
echo Database Configuration:
echo   Host: %DB_HOST%
echo   Database: %DB_NAME_SUBMISSION%
echo   User: %DB_USER%
echo   Profile: neon (PostgreSQL)
echo.
echo Starting service...
echo.

mvn spring-boot:run

pause
