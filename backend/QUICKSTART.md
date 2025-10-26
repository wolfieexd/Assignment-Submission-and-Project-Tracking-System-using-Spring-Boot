# 🚀 Quick Start Guide

## Assignment Submission & Project Tracking System

### Prerequisites
```powershell
java -version    # Should be Java 17+
mvn -version     # Should be Maven 3.6+
```

### Step 1: Start User Service

```powershell
cd "d:\Projects\Assignment SpringBoot\backend\user-service"
mvn clean install
mvn spring-boot:run
```

✅ **User Service Running**: http://localhost:8081
📊 **H2 Console**: http://localhost:8081/h2-console
   - JDBC URL: `jdbc:h2:mem:userdb`
   - Username: `sa`
   - Password: (leave empty)

### Step 2: Test User Service API

**Register a Student:**
```powershell
curl -X POST http://localhost:8081/api/auth/register `
  -H "Content-Type: application/json" `
  -d '{\"name\":\"John Doe\",\"email\":\"john@student.com\",\"password\":\"password123\",\"department\":\"Computer Science\",\"role\":\"student\"}'
```

**Register a Faculty:**
```powershell
curl -X POST http://localhost:8081/api/auth/register `
  -H "Content-Type: application/json" `
  -d '{\"name\":\"Prof. Smith\",\"email\":\"smith@faculty.com\",\"password\":\"password123\",\"department\":\"Computer Science\",\"role\":\"faculty\"}'
```

**Login:**
```powershell
curl -X POST http://localhost:8081/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{\"email\":\"john@student.com\",\"password\":\"password123\"}'
```

### Step 3: Start Frontend

```powershell
cd "d:\Projects\Assignment SpringBoot"
pnpm run dev
```

✅ **Frontend Running**: http://localhost:8080

### Step 4: Test Complete Flow

1. Open http://localhost:8080
2. Click "Register"
3. Create a student account
4. Login with your credentials
5. You'll see the Student Dashboard!

### Running Tests

```powershell
# User Service Tests
cd backend/user-service
mvn test

# You should see:
# ✅ AuthServiceTest - 7 tests passed
# ✅ AuthControllerTest - 5 tests passed
```

### Postman Collection

Import this JSON for quick API testing:

```json
{
  "info": {
    "name": "Assignment System API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "User Service",
      "item": [
        {
          "name": "Register Student",
          "request": {
            "method": "POST",
            "header": [{"key": "Content-Type", "value": "application/json"}],
            "body": {
              "mode": "raw",
              "raw": "{\"name\":\"Test Student\",\"email\":\"student@test.com\",\"password\":\"password123\",\"department\":\"CS\",\"role\":\"student\"}"
            },
            "url": {
              "raw": "http://localhost:8081/api/auth/register",
              "protocol": "http",
              "host": ["localhost"],
              "port": "8081",
              "path": ["api", "auth", "register"]
            }
          }
        },
        {
          "name": "Login",
          "request": {
            "method": "POST",
            "header": [{"key": "Content-Type", "value": "application/json"}],
            "body": {
              "mode": "raw",
              "raw": "{\"email\":\"student@test.com\",\"password\":\"password123\"}"
            },
            "url": {
              "raw": "http://localhost:8081/api/auth/login",
              "protocol": "http",
              "host": ["localhost"],
              "port": "8081",
              "path": ["api", "auth", "login"]
            }
          }
        }
      ]
    }
  ]
}
```

### Common Issues & Solutions

**Port 8081 already in use:**
```powershell
netstat -ano | findstr :8081
taskkill /PID <process_id> /F
```

**Maven build fails:**
```powershell
mvn clean
mvn clean install -U
```

**Tests failing:**
- Make sure no other instance is running
- Check Java version is 17+
- Run `mvn clean test` individually

### Project Structure Overview

```
✅ Frontend (React + Vite)  → Port 8080
✅ User Service (Spring Boot) → Port 8081
🚧 Submission Service (Spring Boot) → Port 8082 (Next phase)

Frontend calls User Service for:
- Registration (/api/auth/register)
- Login (/api/auth/login)
- JWT token generation
```

### Next Steps

1. ✅ User Service is complete and tested
2. 🚧 Next: Create Submission Service for assignments and projects
3. 🚧 Next: Integrate frontend with backend APIs

### Need Help?

Check the logs in the terminal where services are running!
