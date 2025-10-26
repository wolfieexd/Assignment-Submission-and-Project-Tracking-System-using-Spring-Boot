# 🚀 Production Deployment Guide

Complete step-by-step guide to deploy the Assignment Submission System to production using **100% FREE** services.

## 📋 Architecture Overview

- **Frontend**: Vercel (Free - No Credit Card Required)
- **Backend Services**: Local + ngrok tunnels (Free)
- **Database**: Neon PostgreSQL (Free - Already Configured ✅)
- **Repository**: GitHub (Already Pushed ✅)

---

## ✅ Prerequisites (Already Completed)

- [x] Java 21 LTS installed
- [x] Maven configured
- [x] Neon PostgreSQL database created (user_service_db, submission_service_db)
- [x] GitHub repository: `wolfieexd/Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot`
- [x] Frontend code with environment variable support
- [x] Backend services running on Neon PostgreSQL

---

## 📦 Step 1: Install ngrok (5 minutes)

### Download ngrok:
1. Go to: https://ngrok.com/download
2. Download Windows version (ZIP file)
3. Extract to: `C:\ngrok\` (create folder)
4. Add to PATH: `C:\ngrok`

### Create Free Account:
1. Sign up: https://dashboard.ngrok.com/signup (FREE - No Credit Card)
2. Get your authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken

### Configure ngrok:
```powershell
# Set authtoken (one-time setup)
ngrok config add-authtoken YOUR_AUTHTOKEN_HERE

# Verify installation
ngrok version
```

---

## 🌐 Step 2: Create ngrok Tunnels for Backend Services (2 minutes)

### Start User Service Tunnel (Port 8081):
Open **PowerShell Window 1**:
```powershell
cd "d:\Projects\Assignment SpringBoot"
ngrok http 8081 --domain=your-domain.ngrok-free.app
```

**Note the URL**: `https://your-user-service.ngrok-free.app`

### Start Submission Service Tunnel (Port 8082):
Open **PowerShell Window 2**:
```powershell
cd "d:\Projects\Assignment SpringBoot"
ngrok http 8082 --domain=your-domain.ngrok-free.app
```

**Note the URL**: `https://your-submission-service.ngrok-free.app`

### 💡 Free ngrok tunnels will generate random URLs like:
- User Service: `https://abc123.ngrok-free.app`
- Submission Service: `https://xyz789.ngrok-free.app`

**IMPORTANT**: Keep these PowerShell windows open while deployed!

---

## 🎨 Step 3: Deploy Frontend to Vercel via GitHub (3 minutes)

### Connect GitHub to Vercel:
1. Go to: https://vercel.com/signup
2. Click **"Continue with GitHub"** (FREE - No Credit Card)
3. Authorize Vercel to access your repositories

### Import Project:
1. Click **"Add New Project"**
2. Select repository: `Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot`
3. Click **"Import"**

### Configure Build Settings:
- **Framework Preset**: Vite
- **Root Directory**: `./` (leave as is)
- **Build Command**: `pnpm run build` (auto-detected)
- **Output Directory**: `dist` (auto-detected)

### Set Environment Variables:
Click **"Environment Variables"** and add:

| Name | Value | Example |
|------|-------|---------|
| `VITE_API_URL` | `https://YOUR-USER-NGROK-URL.ngrok-free.app/api` | `https://abc123.ngrok-free.app/api` |
| `VITE_SUBMISSION_API_URL` | `https://YOUR-SUBMISSION-NGROK-URL.ngrok-free.app/api` | `https://xyz789.ngrok-free.app/api` |

**Replace with your actual ngrok URLs from Step 2!**

### Deploy:
1. Click **"Deploy"**
2. Wait 2-3 minutes for build to complete
3. **Note your Vercel URL**: `https://your-project.vercel.app`

---

## 🔧 Step 4: Update Backend CORS Configuration (5 minutes)

### Update User Service CORS:

**File**: `backend/user-service/src/main/resources/application-neon.properties`

Add your Vercel URL to allowed origins:
```properties
# CORS Configuration for Production
cors.allowed.origins=https://your-project.vercel.app,http://localhost:5173
```

### Update Submission Service CORS:

**File**: `backend/submission-service/src/main/resources/application-neon.properties`

Add your Vercel URL:
```properties
# CORS Configuration for Production
cors.allowed.origins=https://your-project.vercel.app,http://localhost:5173
```

### Commit and Push Changes:
```powershell
cd "d:\Projects\Assignment SpringBoot"
git add .
git commit -m "Add Vercel CORS configuration for production"
git push origin main
```

### Restart Backend Services:
1. **Stop**: Press Ctrl+C in both service windows (if running)
2. **Start User Service**:
   ```powershell
   cd "d:\Projects\Assignment SpringBoot"
   .\start-user-service-neon.ps1
   ```
3. **Start Submission Service** (new window):
   ```powershell
   cd "d:\Projects\Assignment SpringBoot"
   .\start-submission-service-neon.ps1
   ```

---

## 🧪 Step 5: Test Production Deployment (5 minutes)

### Test Sequence:
1. Open your Vercel URL: `https://your-project.vercel.app`
2. **Register a new user** (Student or Faculty)
3. **Login** with credentials
4. **Faculty**: Create an assignment
5. **Student**: Submit an assignment
6. **Verify**: Check Neon database for persisted data

### Check Neon Database:
1. Go to: https://console.neon.tech
2. Select your project
3. Click **SQL Editor**
4. Run queries:
   ```sql
   -- Check users
   SELECT * FROM users;
   
   -- Check assignments
   SELECT * FROM assignments;
   
   -- Check submissions
   SELECT * FROM submissions;
   ```

---

## 📊 Production URLs Summary

After deployment, save these URLs:

| Service | URL | Status |
|---------|-----|--------|
| **Frontend (Vercel)** | `https://your-project.vercel.app` | ✅ Auto-deploy from GitHub |
| **User Service (ngrok)** | `https://abc123.ngrok-free.app` | 🔄 Requires local machine running |
| **Submission Service (ngrok)** | `https://xyz789.ngrok-free.app` | 🔄 Requires local machine running |
| **Database (Neon)** | `ep-tiny-salad-a1gkhuf0-pooler...` | ✅ Always online |

---

## 🛠️ Daily Startup Commands

### Quick Start (3 commands):
```powershell
# 1. Start User Service (Window 1)
cd "d:\Projects\Assignment SpringBoot"
.\start-user-service-neon.ps1

# 2. Start Submission Service (Window 2)
cd "d:\Projects\Assignment SpringBoot"
.\start-submission-service-neon.ps1

# 3. Start User Service Tunnel (Window 3)
ngrok http 8081

# 4. Start Submission Service Tunnel (Window 4)
ngrok http 8082
```

**Frontend on Vercel**: Updates automatically when you push to GitHub!

---

## 🔄 Update Process

### Frontend Changes:
```powershell
git add .
git commit -m "Update frontend"
git push origin main
```
✅ Vercel auto-deploys in 2-3 minutes!

### Backend Changes:
```powershell
git add .
git commit -m "Update backend"
git push origin main

# Restart services
.\start-user-service-neon.ps1
.\start-submission-service-neon.ps1
```
✅ Changes live immediately!

---

## 💰 Cost Breakdown (100% FREE)

| Service | Plan | Cost | Limits |
|---------|------|------|--------|
| **Vercel** | Hobby | $0/month | 100 GB bandwidth, unlimited deployments |
| **ngrok** | Free | $0/month | 1 agent online, random URLs (restarts reset URL) |
| **Neon** | Free | $0/month | 512 MB storage, 10 projects |
| **GitHub** | Free | $0/month | Unlimited public repos |
| **Total** | | **$0/month** | No credit card required! |

---

## ⚠️ Important Notes

### ngrok URLs:
- ⚠️ Free ngrok URLs change every time you restart ngrok
- 💡 To get static URLs, upgrade to ngrok paid plan ($8/month)
- 🔄 After restart, update Vercel environment variables with new URLs

### Backend Availability:
- 🖥️ Backend services run on your local machine
- 💡 Must keep computer on and services running
- 🌐 ngrok tunnels must be active

### Alternative: Upgrade to Permanent Free Backend Hosting:
If you want 24/7 backend without local machine:
- **Railway.app**: $5/month (500 hours free first month)
- **Render.com**: Free tier (requires credit card, not charged for free tier)
- **Fly.io**: Free tier (3 VMs free, no card required)

---

## 🐛 Troubleshooting

### Frontend can't connect to backend:
1. Check ngrok tunnels are running
2. Verify environment variables in Vercel dashboard
3. Check CORS configuration in application-neon.properties

### ngrok "Too Many Connections":
1. Close old ngrok windows
2. Restart ngrok tunnels

### Database connection failed:
1. Check Neon database is active (console.neon.tech)
2. Verify .env file has correct credentials
3. Check SPRING_PROFILES_ACTIVE=neon is set

---

## 📞 Support

- **Neon Dashboard**: https://console.neon.tech
- **Vercel Dashboard**: https://vercel.com/dashboard
- **ngrok Dashboard**: https://dashboard.ngrok.com
- **GitHub Repository**: https://github.com/wolfieexd/Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot

---

## ✅ Deployment Checklist

- [ ] ngrok installed and configured with authtoken
- [ ] User service tunnel running (note URL)
- [ ] Submission service tunnel running (note URL)
- [ ] Vercel connected to GitHub
- [ ] Environment variables set in Vercel (VITE_API_URL, VITE_SUBMISSION_API_URL)
- [ ] Frontend deployed successfully
- [ ] CORS updated with Vercel URL
- [ ] Backend services restarted with new CORS config
- [ ] End-to-end testing completed
- [ ] All production URLs documented

---

**🎉 Your application is now live and accessible worldwide!**
