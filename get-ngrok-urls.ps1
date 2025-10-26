# Get ngrok tunnel URLs from the API
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Fetching ngrok Tunnel URLs" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Try port 4040 first (default)
    $tunnels = (Invoke-WebRequest -Uri "http://localhost:4040/api/tunnels" -UseBasicParsing -ErrorAction Stop).Content | ConvertFrom-Json
    
    Write-Host "✅ Found tunnels:" -ForegroundColor Green
    Write-Host ""
    
    foreach ($tunnel in $tunnels.tunnels) {
        if ($tunnel.public_url -like "https://*") {
            $port = $tunnel.config.addr -replace '.*:(\d+)', '$1'
            $serviceName = if ($port -eq "8081") { "User Service" } else { "Submission Service" }
            
            Write-Host "🔗 $serviceName (Port $port):" -ForegroundColor Yellow
            Write-Host "   $($tunnel.public_url)" -ForegroundColor White
            Write-Host ""
        }
    }
    
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Next Steps:" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Copy the URLs above" -ForegroundColor Yellow
    Write-Host "2. Go to: https://vercel.com/signup" -ForegroundColor Yellow
    Write-Host "3. Click 'Continue with GitHub'" -ForegroundColor Yellow
    Write-Host "4. Import your repository" -ForegroundColor Yellow
    Write-Host "5. Set environment variables:" -ForegroundColor Yellow
    Write-Host "   VITE_API_URL = [User Service URL]/api" -ForegroundColor White
    Write-Host "   VITE_SUBMISSION_API_URL = [Submission Service URL]/api" -ForegroundColor White
    Write-Host ""
    
} catch {
    # Try port 4041 if 4040 failed
    try {
        $tunnels = (Invoke-WebRequest -Uri "http://localhost:4041/api/tunnels" -UseBasicParsing -ErrorAction Stop).Content | ConvertFrom-Json
        
        Write-Host "✅ Found tunnels on port 4041:" -ForegroundColor Green
        Write-Host ""
        
        foreach ($tunnel in $tunnels.tunnels) {
            if ($tunnel.public_url -like "https://*") {
                $port = $tunnel.config.addr -replace '.*:(\d+)', '$1'
                $serviceName = if ($port -eq "8081") { "User Service" } else { "Submission Service" }
                
                Write-Host "🔗 $serviceName (Port $port):" -ForegroundColor Yellow
                Write-Host "   $($tunnel.public_url)" -ForegroundColor White
                Write-Host ""
            }
        }
    } catch {
        Write-Host "❌ Could not connect to ngrok API" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please check the CMD windows for the tunnel URLs" -ForegroundColor Yellow
        Write-Host "Look for lines like:" -ForegroundColor Yellow
        Write-Host "  Forwarding    https://xxxxx.ngrok-free.app -> http://localhost:8081" -ForegroundColor White
        Write-Host ""
    }
}
