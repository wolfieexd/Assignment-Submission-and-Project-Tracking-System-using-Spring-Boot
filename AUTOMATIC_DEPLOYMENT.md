# 🚀 AUTOMATIC BLUEPRINT DEPLOYMENT - QUICK GUIDE

## ✅ What Was Fixed

The `render.yaml` has been simplified to work with Render's Blueprint:
- ✅ Removed `plan: free` (Render auto-assigns free tier)
- ✅ Removed `region: oregon` (Render auto-selects best region)
- ✅ Removed `healthCheckPath` (optional for Blueprint)
- ✅ Simplified database configuration
- ✅ Changed frontend build command to use pnpm directly

---

## 🔄 DEPLOY NOW - AUTOMATIC BLUEPRINT

### Step 1: Go to Render Dashboard
https://dashboard.render.com

### Step 2: Create Blueprint
1. Click **"New +"** (top right)
2. Select **"Blueprint"**
3. Connect repository: `wolfieexd/Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot`
4. Branch: `main`
5. Render detects `render.yaml`

### Step 3: Fill Required Environment Variables

**Blueprint Name:** (any name you like)
```
Assignment Submission System
```

**user-service → CORS_ALLOWED_ORIGINS:**
```
https://assignment-frontend.onrender.com
```

**submission-service → CORS_ALLOWED_ORIGINS:**
```
https://assignment-frontend.onrender.com
```

**assignment-frontend → VITE_API_USER_URL:**
```
https://user-service.onrender.com
```

**assignment-frontend → VITE_API_SUBMISSION_URL:**
```
https://submission-service.onrender.com
```

### Step 4: Click "Apply"

Render will automatically:
- ✅ Create PostgreSQL database (2 min)
- ✅ Build & deploy user-service Docker (5-6 min)
- ✅ Build & deploy submission-service Docker (5-6 min)
- ✅ Build & deploy frontend static site (3 min)

**Total time: ~15 minutes**

---

## 🎯 AFTER DEPLOYMENT - UPDATE URLS

The placeholder URLs won't match the real ones. After deployment:

### 1. Get Real URLs
Go to Render Dashboard and note the actual URLs:
- `user-service`: e.g., `https://user-service-abc123.onrender.com`
- `submission-service`: e.g., `https://submission-service-xyz456.onrender.com`
- `assignment-frontend`: e.g., `https://assignment-frontend-def789.onrender.com`

### 2. Update Backend CORS
For **both** user-service and submission-service:
1. Go to service → **Environment**
2. Edit `CORS_ALLOWED_ORIGINS`
3. Change to: `https://assignment-frontend-def789.onrender.com` (use your real frontend URL)
4. Click **Save** (auto-redeploys)

### 3. Update Frontend API URLs
For **assignment-frontend**:
1. Go to service → **Environment**
2. Edit `VITE_API_USER_URL`: `https://user-service-abc123.onrender.com`
3. Edit `VITE_API_SUBMISSION_URL`: `https://submission-service-xyz456.onrender.com`
4. Click **Save**
5. Go to **Manual Deploy** → **Deploy latest commit**

---

## 🧪 TEST YOUR APPLICATION

After all services are live and URLs updated:

1. **Open frontend URL** in browser
2. **Register** a new Faculty user
3. **Login** with credentials
4. **Create** an assignment
5. **Logout** and register as Student
6. **Login** as student
7. **Submit** an assignment

---

## 🔍 TROUBLESHOOTING

### If Docker Build Fails
Check logs → Ensure Dockerfile exists in correct path:
- `backend/user-service/Dockerfile`
- `backend/submission-service/Dockerfile`

### If Database Connection Fails
- Database URL is auto-populated by Render
- Ensure `fromDatabase` references work correctly
- Check database is in "Available" status

### If CORS Errors Occur
- Update `CORS_ALLOWED_ORIGINS` with exact frontend URL
- No trailing slash in URL
- Redeploy backend services after updating

### If Frontend Shows API Errors
- Check backend services are "Live"
- Verify `VITE_API_*` environment variables are correct
- Check browser console for exact error

---

## 📊 WHAT GETS DEPLOYED

```
📦 assignment-db (PostgreSQL 16)
   ├── Tables auto-created by Hibernate
   ├── 1GB storage (free)
   └── Internal connection string

📦 user-service (Docker - Java 21)
   ├── Eclipse Temurin JRE
   ├── Spring Boot 3.2.0
   ├── JWT Authentication
   └── PostgreSQL connection

📦 submission-service (Docker - Java 21)
   ├── Eclipse Temurin JRE
   ├── Spring Boot 3.2.0
   ├── File upload handling
   └── PostgreSQL connection

📦 assignment-frontend (Static Site)
   ├── React 18
   ├── Vite production build
   ├── Shadcn UI components
   └── TypeScript
```

---

## ⚡ FREE TIER LIMITATIONS

- **Cold Starts:** Services sleep after 15 min inactivity
- **First Request:** Takes 30-60 seconds to wake up
- **Database:** Always running (no sleep)
- **Storage:** Ephemeral (files lost on redeploy)
- **Bandwidth:** 100GB/month per static site

---

## 🎉 SUCCESS!

Once all 4 services show "Live" status and URLs are updated, your application is **production-ready**!

**Your Assignment Submission System is now deployed on Render.com! 🚀**
