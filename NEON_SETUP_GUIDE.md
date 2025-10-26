# 🎯 NEON POSTGRESQL SETUP GUIDE

## ✅ Step 1: Create Neon Account (DONE or IN PROGRESS)

Go to: https://neon.tech and sign up with GitHub

---

## 📦 Step 2: Create Project in Neon

1. **Click:** "Create a project"
2. **Fill in:**
   - **Project name:** `assignment-system`
   - **PostgreSQL version:** 16 (recommended)
   - **Region:** Choose closest to you
3. **Click:** "Create project"

---

## 🗄️ Step 3: Create Two Databases

After project creation, create two separate databases:

### In Neon Dashboard:

1. Go to **SQL Editor** (left sidebar)
2. Run this SQL:

```sql
-- Create database for user service
CREATE DATABASE user_service_db;

-- Create database for submission service
CREATE DATABASE submission_service_db;
```

3. Click **Run** or press Ctrl+Enter

---

## 📋 Step 4: Get Connection Details

1. Go to **Dashboard** (left sidebar)
2. You'll see connection details like:

```
Host: ep-xxxxx-xxxxx.region.aws.neon.tech
Database: neondb (default)
User: username
Password: ************
Port: 5432
```

**Important:** Note down these values!

---

## 🔧 Step 5: Update Local Configuration

### Create `.env` file in project root:

```powershell
cd "d:\Projects\Assignment SpringBoot"
copy .env.template .env
```

### Edit `.env` file with your Neon details:

```properties
# Replace these with your actual Neon values
DB_HOST=ep-xxxxx-xxxxx.region.aws.neon.tech
DB_PORT=5432
DB_NAME_USER=user_service_db
DB_NAME_SUBMISSION=submission_service_db
DB_USER=your-neon-username
DB_PASSWORD=your-neon-password

# Keep these as-is
JWT_SECRET=TVlQMDFJcXZLTm1PbmNVQnM5eEN1a2gzckxKdDhUZnA0d2xqSDdHUzUyRGlhQXpFZGVnUVpGYm9SWDZXVnk=
JWT_EXPIRATION=3600000
CORS_ALLOWED_ORIGINS=http://localhost:8080
FILE_UPLOAD_DIR=./uploads
```

---

## 🚀 Step 6: Test Connection

### Terminal 1 - User Service:
```powershell
cd "d:\Projects\Assignment SpringBoot\backend\user-service"
$env:SPRING_PROFILES_ACTIVE="neon"
Get-Content "../../.env" | ForEach-Object { if($_ -match '^([^=]+)=(.*)$') { [Environment]::SetEnvironmentVariable($matches[1], $matches[2]) } }
mvnw spring-boot:run
```

### Terminal 2 - Submission Service:
```powershell
cd "d:\Projects\Assignment SpringBoot\backend\submission-service"
$env:SPRING_PROFILES_ACTIVE="neon"
Get-Content "../../.env" | ForEach-Object { if($_ -match '^([^=]+)=(.*)$') { [Environment]::SetEnvironmentVariable($matches[1], $matches[2]) } }
mvnw spring-boot:run
```

---

## ✅ Step 7: Verify Tables Created

1. Go back to **Neon SQL Editor**
2. Select `user_service_db` database
3. Run:
```sql
\dt
```
You should see `users` table

4. Select `submission_service_db` database
5. Run:
```sql
\dt
```
You should see `assignments` and `submissions` tables

---

## 🎯 Step 8: Test Registration & Login

1. **Start frontend:**
```powershell
cd "d:\Projects\Assignment SpringBoot"
pnpm run dev
```

2. **Open:** http://localhost:8080
3. **Register** a new Faculty user
4. **Login** successfully
5. **Check Neon Dashboard** - you'll see data in the database!

---

## 🌐 Step 9: Deploy to Production

### Update Vercel Environment Variables:
```
VITE_API_USER_URL = https://your-ngrok-url-for-user-service
VITE_API_SUBMISSION_URL = https://your-ngrok-url-for-submission-service
```

### Update ngrok/Backend Environment Variables:
```powershell
# Set environment variables before starting backends
$env:DB_HOST="ep-xxxxx-xxxxx.region.aws.neon.tech"
$env:DB_USER="your-neon-username"
$env:DB_PASSWORD="your-neon-password"
$env:SPRING_PROFILES_ACTIVE="neon"
$env:CORS_ALLOWED_ORIGINS="https://your-vercel-app.vercel.app"
```

---

## 🔐 Security Notes

- ✅ `.env` file is in `.gitignore` (never committed)
- ✅ SSL is enabled (`sslmode=require`)
- ✅ Connection pooling is optimized
- ✅ Passwords are never hardcoded

---

## 🎉 SUCCESS!

Your application now uses **production-grade PostgreSQL** from Neon:
- ✅ No H2 database
- ✅ Persistent data storage
- ✅ Production-ready
- ✅ 100% free
- ✅ No payment info required

---

## 📊 Neon Free Tier Limits

- **Storage:** 512 MB
- **Compute:** 0.25 vCPU shared
- **Active time:** Unlimited
- **Auto-pause:** After 5 min inactivity (instant resume)
- **Branches:** 10 (for dev/staging/prod)

Perfect for student projects and portfolios! 🚀
