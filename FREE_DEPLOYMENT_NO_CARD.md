# 🆓 FREE DEPLOYMENT - NO PAYMENT INFO REQUIRED

This guide shows how to deploy your Assignment Submission System **completely free** without providing any credit card or payment information.

---

## 🎯 DEPLOYMENT STRATEGY (100% Free)

### **Frontend: Vercel** (No card required)
- ✅ Unlimited personal projects
- ✅ 100GB bandwidth/month
- ✅ Automatic HTTPS
- ✅ Global CDN

### **Backend: Keep Local** (Development)
- ✅ Run Spring Boot services on your machine
- ✅ Use ngrok/localtunnel for public URLs
- ✅ Full control and debugging

### **Database: H2 In-Memory** (Built-in)
- ✅ Already configured
- ✅ No external database needed
- ✅ Perfect for testing/demo

---

## 📦 PART 1: Deploy Frontend to Vercel

### Step 1: Create Vercel Account
1. Go to: https://vercel.com/signup
2. Click **"Continue with GitHub"**
3. Authorize Vercel (no payment info needed)

### Step 2: Import Project
1. Click **"Add New..."** → **"Project"**
2. Import: `wolfieexd/Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot`
3. Vercel auto-detects settings from `vercel.json`

### Step 3: Configure Environment Variables
Before deploying, add these in Vercel dashboard:

```
VITE_API_USER_URL = http://localhost:8081
VITE_API_SUBMISSION_URL = http://localhost:8082
```

*We'll update these to public URLs in Part 2*

### Step 4: Deploy
1. Click **"Deploy"**
2. Wait 2-3 minutes
3. Get your URL: `https://your-project.vercel.app`

---

## 🔧 PART 2: Make Backends Publicly Accessible

### Option A: Using ngrok (Recommended - Free)

#### Step 1: Install ngrok
1. Download: https://ngrok.com/download
2. Extract and run: `ngrok.exe`
3. Sign up (free, no card): https://dashboard.ngrok.com/signup
4. Get auth token from dashboard

#### Step 2: Configure ngrok
```powershell
ngrok config add-authtoken YOUR_AUTH_TOKEN
```

#### Step 3: Start Your Backend Services
```powershell
# Terminal 1 - User Service
cd "d:\Projects\Assignment SpringBoot\backend\user-service"
mvnw spring-boot:run

# Terminal 2 - Submission Service
cd "d:\Projects\Assignment SpringBoot\backend\submission-service"
mvnw spring-boot:run
```

#### Step 4: Create Public Tunnels
```powershell
# Terminal 3 - ngrok for user-service
ngrok http 8081

# Terminal 4 - ngrok for submission-service
ngrok http 8082
```

#### Step 5: Get Public URLs
ngrok will show URLs like:
```
Forwarding  https://abc123.ngrok-free.app -> http://localhost:8081
Forwarding  https://xyz456.ngrok-free.app -> http://localhost:8082
```

#### Step 6: Update Vercel Environment Variables
1. Go to Vercel project → Settings → Environment Variables
2. Update:
   ```
   VITE_API_USER_URL = https://abc123.ngrok-free.app
   VITE_API_SUBMISSION_URL = https://xyz456.ngrok-free.app
   ```
3. Redeploy: Deployments → Click "..." → Redeploy

### Option B: Using LocalTunnel (Alternative - Free)

#### Step 1: Install
```powershell
npm install -g localtunnel
```

#### Step 2: Start Backend Services (same as Option A)

#### Step 3: Create Tunnels
```powershell
# Terminal 3
lt --port 8081 --subdomain user-service-yourname

# Terminal 4
lt --port 8082 --subdomain submission-service-yourname
```

#### Step 4: Update Vercel (same as Option A)

---

## 🎯 PART 3: Update Backend CORS

Update CORS to allow your Vercel frontend URL:

### File: `backend/user-service/src/main/resources/application.properties`
```properties
cors.allowed.origins=https://your-project.vercel.app
```

### File: `backend/submission-service/src/main/resources/application.properties`
```properties
cors.allowed.origins=https://your-project.vercel.app
```

Restart both backend services after updating.

---

## ✅ COMPLETE SETUP EXAMPLE

After everything is configured:

```
Frontend (Vercel):     https://assignment-system.vercel.app
User Service (ngrok):  https://abc123.ngrok-free.app
Submit Service (ngrok): https://xyz456.ngrok-free.app
Database:              H2 in-memory (built-in)
```

---

## 🧪 TESTING YOUR DEPLOYMENT

1. Open: `https://your-project.vercel.app`
2. Register a new Faculty user
3. Login successfully
4. Create an assignment
5. Logout and register as Student
6. Login and submit assignment

---

## 📊 FREE TIER LIMITS

### Vercel:
- ✅ Unlimited deployments
- ✅ 100GB bandwidth/month
- ✅ Automatic SSL
- ✅ Git integration

### ngrok Free:
- ✅ 1 online ngrok process
- ✅ 4 tunnels/ngrok process  
- ✅ 40 connections/minute
- ⚠️ Random URL each restart (paid: static URLs)

### LocalTunnel Free:
- ✅ Unlimited tunnels
- ✅ Custom subdomain (if available)
- ⚠️ Less reliable than ngrok

---

## 🔄 ALTERNATIVE: Keep Everything Local

If you don't want to expose backends publicly:

### Step 1: Update Frontend Environment
```properties
VITE_API_USER_URL = http://localhost:8081
VITE_API_SUBMISSION_URL = http://localhost:8082
```

### Step 2: Run Frontend Locally
```powershell
pnpm install
pnpm run dev
```

### Step 3: Access at
```
http://localhost:8080
```

**Pros:**
- ✅ Full privacy
- ✅ No tunneling needed
- ✅ Fast development

**Cons:**
- ❌ Only accessible on your machine
- ❌ Can't share with others

---

## 🚀 PRODUCTION-READY ALTERNATIVE (Still Free)

### Oracle Cloud (Always Free Tier - No Card Expires)

Oracle Cloud offers **truly free** VPS instances:

1. Sign up: https://www.oracle.com/cloud/free/
2. Create VM (ARM - Always Free)
3. Install Java 21
4. Deploy both backends
5. Install PostgreSQL
6. Keep running 24/7

**Setup Guide:**
```bash
# SSH into Oracle VM
ssh ubuntu@your-vm-ip

# Install Java 21
sudo apt update
sudo apt install openjdk-21-jdk -y

# Install PostgreSQL
sudo apt install postgresql postgresql-contrib -y

# Upload JARs and run
java -jar user-service-1.0.0.jar &
java -jar submission-service-1.0.0.jar &
```

---

## 📌 RECOMMENDED SETUP

**For Demo/Portfolio:**
- ✅ Frontend: Vercel
- ✅ Backends: ngrok tunnels
- ✅ Database: H2 in-memory
- **Total Cost: $0**
- **No Card Required: ✅**

**For Production:**
- ✅ Frontend: Vercel
- ✅ Backends: Oracle Cloud VM
- ✅ Database: PostgreSQL on Oracle VM
- **Total Cost: $0**
- **Card Required: Yes (but never charged)**

---

## 🎉 YOU'RE ALL SET!

Choose your preferred deployment option and follow the steps above. All options are **100% free** and perfect for:
- ✅ Student projects
- ✅ Portfolio demonstrations
- ✅ Learning and testing
- ✅ Small-scale production

**No credit card, no hidden fees, no surprises!** 🚀
