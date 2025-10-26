# 🚀 GitHub & Railway Deployment Guide

## ✅ Current Status
- ✅ Git repository initialized
- ✅ All files committed (162 files, 22,308 insertions)
- ✅ Java 21 LTS running locally
- ✅ Security audit completed
- ✅ Production configs ready
- ⏳ **Next: Push to GitHub & Deploy to Railway**

---

## 📋 Step-by-Step Deployment Process

### **Step 1: Create GitHub Repository**

#### Option A: New Repository
1. **Go to**: https://github.com/new
2. **Repository name**: `assignment-submission-system`
3. **Description**: "Full-stack Assignment Submission System with Java 21 LTS, Spring Boot 3.2, React 18, JWT Auth"
4. **Visibility**: Choose Public or Private
5. **⚠️ IMPORTANT**: 
   - ❌ DO NOT check "Initialize with README"
   - ❌ DO NOT add .gitignore
   - ❌ DO NOT choose a license (we already have these)
6. Click **"Create repository"**

#### Option B: Use Existing Repository
If you already have a repo, just get its URL:
- Format: `https://github.com/YOUR_USERNAME/YOUR_REPO.git`

---

### **Step 2: Connect Git to GitHub**

Open PowerShell in your project directory and run:

```powershell
# Add GitHub remote (replace with YOUR URL)
git remote add origin https://github.com/YOUR_USERNAME/assignment-submission-system.git

# Rename branch to main
git branch -M main

# Push to GitHub
git push -u origin main
```

**Example with actual username**:
```powershell
git remote add origin https://github.com/johndoe/assignment-submission-system.git
git branch -M main
git push -u origin main
```

You'll be prompted to login to GitHub. Follow the authentication prompts.

---

### **Step 3: Deploy to Railway.app**

#### A. Sign Up / Login to Railway
1. Go to: https://railway.app
2. Click **"Login"** or **"Start a New Project"**
3. Sign in with GitHub (recommended for auto-deployment)

#### B. Create New Project
1. Click **"New Project"**
2. Select **"Deploy from GitHub repo"**
3. Select your repository: `assignment-submission-system`
4. Railway will detect your services automatically

#### C. Add Services

Railway should detect 3 services:

##### **Service 1: User Service**
```
Root Directory: /backend/user-service
Build Command: mvn clean package -DskipTests
Start Command: java -jar target/user-service-1.0.0.jar --spring.profiles.active=prod
Port: 8081
```

##### **Service 2: Submission Service**
```
Root Directory: /backend/submission-service
Build Command: mvn clean package -DskipTests
Start Command: java -jar target/submission-service-1.0.0.jar --spring.profiles.active=prod
Port: 8082
```

##### **Service 3: Frontend**
```
Root Directory: /
Build Command: npm install && npm run build
Start Command: npm run preview (or serve dist folder)
Port: 8080
```

#### D. Add MySQL Database
1. Click **"+ New"** → **"Database"** → **"Add MySQL"**
2. Railway will create a MySQL instance
3. Note the connection details

---

### **Step 4: Configure Environment Variables**

#### User Service Environment Variables

Click on User Service → **Variables** → Add these:

```env
# Spring Profile
SPRING_PROFILES_ACTIVE=prod

# JWT Secret (from backend/JWT_SECRET.txt)
JWT_SECRET=TVlQMDFJcXZLTm1PbmNVQnM5eEN1a2gzckxKdDhUZnA0d2xqSDdHUzUyRGlhQXpFZGVnUVpGYm9SWDZXVnk=

# Database (Railway will provide these automatically)
DATABASE_URL=${MYSQL_URL}
MYSQLHOST=${MYSQLHOST}
MYSQLPORT=${MYSQLPORT}
MYSQLDATABASE=user_service_db
MYSQLUSER=${MYSQLUSER}
MYSQLPASSWORD=${MYSQLPASSWORD}

# CORS (use your Railway frontend URL)
CORS_ALLOWED_ORIGINS=https://your-frontend-url.up.railway.app

# Server Port
PORT=8081
```

#### Submission Service Environment Variables

Click on Submission Service → **Variables** → Add these:

```env
# Spring Profile
SPRING_PROFILES_ACTIVE=prod

# JWT Secret (MUST be the same as User Service)
JWT_SECRET=TVlQMDFJcXZLTm1PbmNVQnM5eEN1a2gzckxKdDhUZnA0d2xqSDdHUzUyRGlhQXpFZGVnUVpGYm9SWDZXVnk=

# Database
DATABASE_URL=${MYSQL_URL}
MYSQLHOST=${MYSQLHOST}
MYSQLPORT=${MYSQLPORT}
MYSQLDATABASE=submission_service_db
MYSQLUSER=${MYSQLUSER}
MYSQLPASSWORD=${MYSQLPASSWORD}

# CORS
CORS_ALLOWED_ORIGINS=https://your-frontend-url.up.railway.app

# Server Port
PORT=8082

# File Upload
FILE_UPLOAD_DIR=/app/uploads
```

#### Frontend Environment Variables

Click on Frontend → **Variables** → Add these:

```env
# API URLs (use your Railway backend URLs)
VITE_USER_SERVICE_URL=https://your-user-service.up.railway.app
VITE_SUBMISSION_SERVICE_URL=https://your-submission-service.up.railway.app
```

---

### **Step 5: Initialize Database**

Once deployed, you need to create the databases:

#### Option A: Railway CLI

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Link to project
railway link

# Connect to MySQL
railway connect mysql

# Create databases
CREATE DATABASE user_service_db;
CREATE DATABASE submission_service_db;
```

#### Option B: Railway Dashboard

1. Go to MySQL service
2. Click **"Data"** tab
3. Run SQL:
```sql
CREATE DATABASE user_service_db;
CREATE DATABASE submission_service_db;
```

#### Option C: Use Init Scripts

Railway can run SQL scripts on deployment. Add these files to your project root:

**init-databases.sql**:
```sql
-- Create databases
CREATE DATABASE IF NOT EXISTS user_service_db;
CREATE DATABASE IF NOT EXISTS submission_service_db;

-- Use user service database
USE user_service_db;

-- Tables will be auto-created by Hibernate
-- But you can add initial data here

-- Use submission service database
USE submission_service_db;

-- Tables will be auto-created by Hibernate
```

---

### **Step 6: Deploy & Monitor**

1. **Trigger Deployment**:
   - Railway auto-deploys on git push
   - Or click **"Deploy"** in Railway dashboard

2. **Monitor Build Logs**:
   - Click on each service
   - View **"Deployments"** tab
   - Check build logs for errors

3. **Check Service Status**:
   - All services should show **"Active"**
   - Green checkmark indicates running

4. **Get Service URLs**:
   - Click on each service
   - Go to **"Settings"** → **"Domains"**
   - Railway provides URLs like:
     - `https://user-service-production-xxxx.up.railway.app`
     - `https://submission-service-production-xxxx.up.railway.app`
     - `https://frontend-production-xxxx.up.railway.app`

---

### **Step 7: Test Deployment**

#### Test Backend Services

```bash
# Test User Service Health
curl https://your-user-service.up.railway.app/actuator/health

# Test Registration
curl -X POST https://your-user-service.up.railway.app/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@test.com",
    "password": "Test@123",
    "role": "STUDENT",
    "department": "CS"
  }'
```

#### Test Frontend

Open your frontend URL in browser:
```
https://your-frontend.up.railway.app
```

---

### **Step 8: Custom Domain (Optional)**

1. Go to Frontend service → **Settings** → **Domains**
2. Click **"Add Domain"**
3. Enter your custom domain (e.g., `assignments.yourdomain.com`)
4. Update your DNS records:
   ```
   Type: CNAME
   Name: assignments
   Value: your-frontend.up.railway.app
   ```

---

## 🔧 Common Issues & Solutions

### Issue 1: Build Fails
**Solution**: Check build logs, ensure:
- Java 21 is specified in `railway.json`
- Maven dependencies are correct
- No compilation errors

### Issue 2: Database Connection Failed
**Solution**: 
- Verify database is created
- Check DATABASE_URL format
- Ensure service can access MySQL

### Issue 3: CORS Errors
**Solution**:
- Add frontend URL to `CORS_ALLOWED_ORIGINS`
- Format: `https://your-frontend.up.railway.app` (no trailing slash)

### Issue 4: JWT Token Invalid
**Solution**:
- Ensure JWT_SECRET is EXACTLY the same in both services
- Check for extra spaces or line breaks

### Issue 5: File Upload Fails
**Solution**:
- Ensure `FILE_UPLOAD_DIR` is set to `/app/uploads`
- Railway provides persistent storage

---

## 📊 Deployment Checklist

Use this checklist to ensure everything is configured:

- [ ] GitHub repository created
- [ ] Code pushed to GitHub
- [ ] Railway account created
- [ ] Project created in Railway
- [ ] User Service deployed
- [ ] Submission Service deployed
- [ ] Frontend deployed
- [ ] MySQL database added
- [ ] Databases created (user_service_db, submission_service_db)
- [ ] Environment variables set for User Service
- [ ] Environment variables set for Submission Service
- [ ] Environment variables set for Frontend
- [ ] JWT_SECRET is identical in both backend services
- [ ] CORS_ALLOWED_ORIGINS configured
- [ ] All services show "Active" status
- [ ] Health endpoints responding
- [ ] User registration working
- [ ] User login working
- [ ] Frontend can connect to backend
- [ ] Database tables auto-created by Hibernate

---

## 🎯 Quick Command Reference

### Git Commands
```bash
# Check status
git status

# Add all changes
git add .

# Commit changes
git commit -m "Your message"

# Push to GitHub
git push origin main

# Pull latest changes
git pull origin main
```

### Railway CLI Commands
```bash
# Login
railway login

# Link to project
railway link

# View logs
railway logs

# Connect to database
railway connect mysql

# Run command in service
railway run <command>

# Open service in browser
railway open
```

---

## 🌐 Your Project URLs (After Deployment)

Fill these in after deployment:

```
User Service:       https://_____________________.up.railway.app
Submission Service: https://_____________________.up.railway.app
Frontend:          https://_____________________.up.railway.app
MySQL Database:     (Internal Railway URL)

GitHub Repository:  https://github.com/___________/___________
```

---

## 📞 Support Resources

- **Railway Docs**: https://docs.railway.app
- **Railway Discord**: https://discord.gg/railway
- **GitHub Help**: https://docs.github.com
- **Spring Boot Docs**: https://docs.spring.io/spring-boot/docs/current/reference/html/

---

## 🎉 Success Criteria

Your deployment is successful when:

✅ All 3 services show "Active" in Railway
✅ Frontend URL loads the React application
✅ User registration works from frontend
✅ User login returns JWT token
✅ Faculty can create assignments
✅ Students can submit assignments
✅ No CORS errors in browser console
✅ All database tables created automatically
✅ File uploads work (if implemented)

---

**Ready to deploy? Let me know your GitHub repository URL and I'll help you push the code!**
