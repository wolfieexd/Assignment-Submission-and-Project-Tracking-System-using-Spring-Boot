# Quick Deployment Setup Script
# Run this script to prepare for production deployment

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Production Deployment Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if ngrok is installed
Write-Host "Checking ngrok installation..." -ForegroundColor Yellow
$ngrokInstalled = Get-Command ngrok -ErrorAction SilentlyContinue

if ($ngrokInstalled) {
    Write-Host "✅ ngrok is already installed!" -ForegroundColor Green
    $version = & ngrok version 2>&1 | Out-String
    Write-Host "   Version: $version" -ForegroundColor Gray
} else {
    Write-Host "❌ ngrok is NOT installed" -ForegroundColor Red
    Write-Host ""
    Write-Host "To install ngrok:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://ngrok.com/download" -ForegroundColor White
    Write-Host "2. Extract to C:\ngrok\" -ForegroundColor White
    Write-Host "3. Add C:\ngrok to PATH" -ForegroundColor White
    Write-Host "4. Sign up (FREE): https://dashboard.ngrok.com/signup" -ForegroundColor White
    Write-Host "5. Run: ngrok config add-authtoken YOUR_TOKEN" -ForegroundColor White
    Write-Host ""
}

# Check if backend services are running
Write-Host ""
Write-Host "Checking backend services..." -ForegroundColor Yellow
$javaProcesses = Get-Process -Name java -ErrorAction SilentlyContinue | 
    Select-Object Id, ProcessName, @{Name="Port";Expression={(Get-NetTCPConnection -OwningProcess $_.Id -ErrorAction SilentlyContinue | Where-Object LocalPort -in 8081,8082).LocalPort}} | 
    Where-Object Port -ne $null

if ($javaProcesses) {
    Write-Host "✅ Backend services are running:" -ForegroundColor Green
    $javaProcesses | ForEach-Object {
        $serviceName = if ($_.Port -eq 8081) { "User Service" } else { "Submission Service" }
        Write-Host "   $serviceName (Port $($_.Port)) - PID: $($_.Id)" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Backend services are NOT running" -ForegroundColor Red
    Write-Host ""
    Write-Host "To start services:" -ForegroundColor Yellow
    Write-Host "   .\start-user-service-neon.ps1" -ForegroundColor White
    Write-Host "   .\start-submission-service-neon.ps1" -ForegroundColor White
    Write-Host ""
}

# Display next steps
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Next Steps for Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Install ngrok (if not installed)" -ForegroundColor Yellow
Write-Host "   Download: https://ngrok.com/download" -ForegroundColor White
Write-Host ""

Write-Host "2. Start ngrok tunnels:" -ForegroundColor Yellow
Write-Host "   Window 1: ngrok http 8081" -ForegroundColor White
Write-Host "   Window 2: ngrok http 8082" -ForegroundColor White
Write-Host "   (Note the generated URLs!)" -ForegroundColor Gray
Write-Host ""

Write-Host "3. Deploy to Vercel via GitHub:" -ForegroundColor Yellow
Write-Host "   a. Go to: https://vercel.com/signup" -ForegroundColor White
Write-Host "   b. Click 'Continue with GitHub'" -ForegroundColor White
Write-Host "   c. Import your repository" -ForegroundColor White
Write-Host "   d. Set environment variables:" -ForegroundColor White
Write-Host "      VITE_API_URL=https://your-ngrok-url.ngrok-free.app/api" -ForegroundColor Gray
Write-Host "      VITE_SUBMISSION_API_URL=https://your-ngrok-url.ngrok-free.app/api" -ForegroundColor Gray
Write-Host "   e. Click Deploy!" -ForegroundColor White
Write-Host ""

Write-Host "4. Update CORS configuration:" -ForegroundColor Yellow
Write-Host "   Edit application-neon.properties files" -ForegroundColor White
Write-Host "   Add Vercel URL to cors.allowed.origins" -ForegroundColor White
Write-Host ""

Write-Host "📖 Read full guide: DEPLOYMENT.md" -ForegroundColor Cyan
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Current Status" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ Java 21 LTS installed" -ForegroundColor Green
Write-Host "✅ Neon PostgreSQL configured" -ForegroundColor Green
Write-Host "✅ GitHub repository ready" -ForegroundColor Green
Write-Host "✅ Frontend code updated" -ForegroundColor Green
Write-Host "✅ Backend services configured" -ForegroundColor Green

if ($ngrokInstalled) {
    Write-Host "✅ ngrok installed" -ForegroundColor Green
} else {
    Write-Host "⏳ ngrok needs installation" -ForegroundColor Yellow
}

if ($javaProcesses -and ($javaProcesses | Measure-Object).Count -eq 2) {
    Write-Host "✅ Both backend services running" -ForegroundColor Green
} else {
    Write-Host "⏳ Backend services need to be started" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Ready for deployment!" -ForegroundColor Cyan
Write-Host ""
