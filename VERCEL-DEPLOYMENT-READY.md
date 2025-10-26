# 🚀 READY FOR VERCEL DEPLOYMENT!

## ✅ Current Setup:

### Backend Services:
1. **User Service (Authentication)**: ✅ LIVE
   - URL: `https://unflickeringly-mouldier-harmony.ngrok-free.dev`
   - Port: 8081
   - Features: Register, Login, User Management
   - Database: Neon PostgreSQL ✅

2. **Submission Service**: ⏳ Pending
   - Will deploy separately (see options below)

---

## 🎯 DEPLOY TO VERCEL NOW:

### Step 1: Go to Vercel
Visit: https://vercel.com/signup

### Step 2: Connect GitHub
- Click **"Continue with GitHub"**
- Authorize Vercel

### Step 3: Import Repository
- Click **"Add New Project"**
- Select: `Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot`
- Click **"Import"**

### Step 4: Configure Build Settings
**Framework Preset**: Vite (auto-detected)  
**Build Command**: `pnpm run build`  
**Output Directory**: `dist`

### Step 5: Set Environment Variables
Add these in Vercel dashboard:

```
VITE_API_URL=https://unflickeringly-mouldier-harmony.ngrok-free.dev/api
VITE_SUBMISSION_API_URL=https://unflickeringly-mouldier-harmony.ngrok-free.dev/api
```

**Note**: Both point to User Service for now. We'll add Submission Service later.

### Step 6: Deploy!
Click **"Deploy"** and wait 2-3 minutes.

---

## 📝 After Deployment:

### You'll get a Vercel URL like:
`https://your-project-name.vercel.app`

### Update CORS Configuration:

**File 1**: `backend/user-service/src/main/resources/application-neon.properties`
```properties
cors.allowed.origins=https://your-project-name.vercel.app,http://localhost:5173
```

**File 2**: `backend/submission-service/src/main/resources/application-neon.properties`
```properties
cors.allowed.origins=https://your-project-name.vercel.app,http://localhost:5173
```

### Restart Services:
```powershell
cd "d:\Projects\Assignment SpringBoot"
.\start-user-service-neon.ps1
.\start-submission-service-neon.ps1
```

---

## 🔧 For Submission Service (Options):

### Option A: Deploy to Render.com (FREE)
1. Go to: https://render.com
2. Connect GitHub
3. Deploy `submission-service` as Web Service
4. Update Vercel env var with Render URL

### Option B: Use Fly.io (FREE - No Card Required)
1. Install flyctl
2. Deploy submission-service
3. Get permanent URL
4. Update Vercel env vars

### Option C: Upgrade ngrok ($8/month)
- Get 3 static domains
- Both services get permanent URLs
- Easiest for development

---

## ✅ What Works NOW (80% Complete):
- ✅ User Registration
- ✅ User Login
- ✅ JWT Authentication
- ✅ User Dashboard
- ✅ Data persists in Neon PostgreSQL

## ⏳ What Needs Submission Service:
- Assignment Creation (Faculty)
- Assignment Submission (Student)
- File Uploads

---

## 🚀 LET'S DEPLOY!

Your application is ready for Vercel deployment. Follow the steps above and share your Vercel URL when deployed!

Then we'll add the Submission Service using one of the free options.
