# Railway.app Environment Variables Setup Script
# Copy these variables to your Railway dashboard

Write-Host "`n╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         RAILWAY.APP ENVIRONMENT VARIABLES SETUP                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Read JWT Secret
$jwtSecret = Get-Content "JWT_SECRET.txt" -ErrorAction SilentlyContinue
if (-not $jwtSecret) {
    # Generate new if not exists
    $jwtSecret = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(-join ((65..90) + (97..122) + (48..57) | Get-Random -Count 64 | ForEach-Object {[char]$_})))
    $jwtSecret | Out-File -FilePath "JWT_SECRET.txt" -Encoding UTF8
}

Write-Host "📋 USER SERVICE ENVIRONMENT VARIABLES:" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

$userServiceVars = @"

# JWT Configuration (CRITICAL - Must be same for both services)
JWT_SECRET=$jwtSecret
JWT_EXPIRATION=3600000

# Spring Profile
SPRING_PROFILES_ACTIVE=prod

# Database (Railway auto-provides DATABASE_URL for MySQL/PostgreSQL addon)
SPRING_DATASOURCE_URL=`${DATABASE_URL}

# For Railway MySQL addon, also set:
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect

# CORS (UPDATE WITH YOUR FRONTEND URL)
CORS_ALLOWED_ORIGINS=https://your-frontend.up.railway.app

# JPA Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false

# Logging
LOGGING_LEVEL_ROOT=WARN
LOGGING_LEVEL_COM_ASSIGNMENT_USERSERVICE=INFO

# H2 Console (Disabled)
spring.h2.console.enabled=false

# Server Configuration
server.port=`${PORT:8081}

# Actuator
management.endpoints.web.exposure.include=health,info,metrics
management.endpoint.health.show-details=when-authorized

"@

Write-Host $userServiceVars -ForegroundColor White

Write-Host "`n`n📋 SUBMISSION SERVICE ENVIRONMENT VARIABLES:" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

$submissionServiceVars = @"

# JWT Configuration (MUST BE SAME AS USER SERVICE)
JWT_SECRET=$jwtSecret
JWT_EXPIRATION=3600000

# Spring Profile
SPRING_PROFILES_ACTIVE=prod

# Database (Railway auto-provides DATABASE_URL)
SPRING_DATASOURCE_URL=`${DATABASE_URL}

# For Railway MySQL addon, also set:
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect

# CORS (UPDATE WITH YOUR FRONTEND URL)
CORS_ALLOWED_ORIGINS=https://your-frontend.up.railway.app

# User Service URL (UPDATE AFTER USER SERVICE IS DEPLOYED)
USER_SERVICE_URL=https://user-service.up.railway.app

# File Upload
FILE_UPLOAD_DIR=/app/uploads
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB

# JPA Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false

# Logging
LOGGING_LEVEL_ROOT=WARN
LOGGING_LEVEL_COM_ASSIGNMENT_SUBMISSIONSERVICE=INFO

# H2 Console (Disabled)
spring.h2.console.enabled=false

# Server Configuration
server.port=`${PORT:8082}

# Actuator
management.endpoints.web.exposure.include=health,info,metrics
management.endpoint.health.show-details=when-authorized

"@

Write-Host $submissionServiceVars -ForegroundColor White

# Save to files for easy copy
$userServiceVars | Out-File -FilePath "RAILWAY_ENV_USER_SERVICE.txt" -Encoding UTF8
$submissionServiceVars | Out-File -FilePath "RAILWAY_ENV_SUBMISSION_SERVICE.txt" -Encoding UTF8

Write-Host "`n`n✅ ENVIRONMENT VARIABLES SAVED TO FILES:" -ForegroundColor Green
Write-Host "   • RAILWAY_ENV_USER_SERVICE.txt" -ForegroundColor Cyan
Write-Host "   • RAILWAY_ENV_SUBMISSION_SERVICE.txt" -ForegroundColor Cyan
Write-Host "   • JWT_SECRET.txt" -ForegroundColor Cyan

Write-Host "`n`n🎯 NEXT STEPS:" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "1. Go to Railway Dashboard: https://railway.app" -ForegroundColor White
Write-Host "2. Select your User Service → Settings → Variables" -ForegroundColor White
Write-Host "3. Copy variables from RAILWAY_ENV_USER_SERVICE.txt" -ForegroundColor White
Write-Host "4. Select your Submission Service → Settings → Variables" -ForegroundColor White
Write-Host "5. Copy variables from RAILWAY_ENV_SUBMISSION_SERVICE.txt" -ForegroundColor White
Write-Host "6. Update CORS_ALLOWED_ORIGINS with your actual frontend URL" -ForegroundColor White
Write-Host "7. Redeploy both services`n" -ForegroundColor White

Write-Host "⚠️  IMPORTANT NOTES:" -ForegroundColor Red
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "• Both services MUST use the SAME JWT_SECRET!" -ForegroundColor Yellow
Write-Host "• Update CORS_ALLOWED_ORIGINS with your actual frontend URL" -ForegroundColor Yellow
Write-Host "• Railway auto-provides DATABASE_URL from MySQL addon" -ForegroundColor Yellow
Write-Host "• Update USER_SERVICE_URL after user-service is deployed" -ForegroundColor Yellow
Write-Host "• For file uploads, add Railway Volume: /app/uploads`n" -ForegroundColor Yellow

Write-Host "✅ JWT Secret: " -NoNewline -ForegroundColor Green
Write-Host $jwtSecret -ForegroundColor Cyan
Write-Host "`n"
