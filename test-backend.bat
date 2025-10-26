@echo off
echo ========================================
echo  Assignment System - User Service Test
echo ========================================
echo.

echo [1/3] Starting User Service...
cd backend\user-service
start cmd /k "mvn spring-boot:run"
timeout /t 15 /nobreak >nul

echo.
echo [2/3] Testing Registration Endpoint...
curl -X POST http://localhost:8081/api/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"Test Student\",\"email\":\"test@student.com\",\"password\":\"password123\",\"department\":\"Computer Science\",\"role\":\"student\"}"

echo.
echo.
echo [3/3] Testing Login Endpoint...
curl -X POST http://localhost:8081/api/auth/login ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"test@student.com\",\"password\":\"password123\"}"

echo.
echo.
echo ========================================
echo  Test Complete!
echo  User Service is running on port 8081
echo  H2 Console: http://localhost:8081/h2-console
echo ========================================
pause
