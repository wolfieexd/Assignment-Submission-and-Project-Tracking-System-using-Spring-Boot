# 🚀 QUICK START: Deploy to Render.com (5 Minutes)

## 📌 What You Need

- Render.com account (free, no credit card)
- GitHub repository already connected
- Neon PostgreSQL credentials from `.env` file

---

## ⚡ Step-by-Step Deployment

### 1️⃣ Sign Up for Render

1. Go to: **https://render.com/**
2. Click **"Get Started for Free"**
3. **Sign up with GitHub** (fastest way)
4. Authorize Render to access: `wolfieexd/Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot`

---

### 2️⃣ Deploy User Service

1. In Render Dashboard, click **"New +"** → **"Web Service"**

2. **Select your repository**:
   - Repository: `Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot`
   - Click **"Connect"**

3. **Configure the service**:
   ```
   Name:              user-service
   Region:            Singapore (or closest to you)
   Branch:            main
   Root Directory:    backend/user-service
   Runtime:           Java
   Build Command:     mvn clean package -DskipTests
   Start Command:     java -jar target/user-service-1.0.0.jar --spring.profiles.active=neon
   Instance Type:     Free
   ```

4. **Click "Advanced"** and add **Environment Variables**:

   Copy these from your `.env` file:
   ```
   SPRING_PROFILES_ACTIVE=neon
   DB_HOST=ep-tiny-salad-a1gkhuf0-pooler.ap-southeast-1.aws.neon.tech
   DB_USER=neondb_owner
   DB_PASSWORD=<paste-from-your-.env-file>
   DB_NAME=user_service_db
   JWT_SECRET=TVlQMDFJcXZLTm1PbmNVQnM5eEN1a2gzckxKdDhUZnA0d2xqSDdHUzUyRGlhQXpFZGVnUVpGYm9SWDZXVnk=
   CORS_ALLOWED_ORIGINS=https://assig-sub.vercel.app,http://localhost:5173
   JAVA_TOOL_OPTIONS=-Xmx512m -Xms256m
   ```

   > ⚠️ **IMPORTANT**: Get `DB_PASSWORD` from your `.env` file, don't type it manually!

5. Click **"Create Web Service"**

6. ⏳ **Wait 8-10 minutes** for build and deployment

7. ✅ Once deployed, you'll see: **"Your service is live at https://user-service-xxxx.onrender.com"**

8. 🧪 **Test it**: Visit `https://user-service-xxxx.onrender.com/api/auth/health`
   - Should show: Health check page or "UP" message

---

### 3️⃣ Deploy Submission Service

**Repeat the same process**, but with these changes:

```
Name:              submission-service
Root Directory:    backend/submission-service
Start Command:     java -jar target/submission-service-1.0.0.jar --spring.profiles.active=neon
```

**Environment Variables**: Same as User Service, but change:
```
DB_NAME=submission_service_db
```

---

### 4️⃣ Update Vercel with Render URLs

1. Go to: **https://vercel.com/dashboard**
2. Select project: **assig-sub**
3. Go to: **Settings** → **Environment Variables**
4. **Add/Update** these variables:

   ```
   VITE_API_URL=https://user-service-xxxx.onrender.com
   VITE_SUBMISSION_API_URL=https://submission-service-xxxx.onrender.com
   ```

   > Replace `xxxx` with your actual Render service subdomain!

5. Click **"Save"**
6. Go to **Deployments** tab
7. Click **"..."** on latest deployment → **"Redeploy"**
8. Select **"Use existing Build Cache"**
9. Click **"Redeploy"**

---

### 5️⃣ Update CORS in Render Services

For **BOTH** services (user-service and submission-service):

1. Go to Render Dashboard → Select the service
2. Click **"Environment"** tab
3. Find: `CORS_ALLOWED_ORIGINS`
4. **Update** to:
   ```
   https://assig-sub.vercel.app,http://localhost:5173,https://user-service-xxxx.onrender.com,https://submission-service-xxxx.onrender.com
   ```
   (Replace `xxxx` with your actual URLs)

5. Click **"Save Changes"**
6. Service will **auto-redeploy** (~2-3 minutes)

---

## 🧪 Final Testing

### Test Health Endpoints

Open these URLs in your browser:

1. **User Service**: `https://user-service-xxxx.onrender.com/api/auth/health`
   - ✅ Should show health status

2. **Submission Service**: `https://submission-service-xxxx.onrender.com/api/assignments/health`
   - ✅ Should show health status

### Test Full Application

1. Open: **https://assig-sub.vercel.app/**

2. **Register a new user**:
   - Username: testuser
   - Password: Test123!
   - Role: Student

3. **Login** with the credentials

4. **Switch to Faculty** (if needed):
   - Logout → Register as Faculty → Login

5. **Create Assignment**:
   - Title: "Test Assignment"
   - Description: "Testing production deployment"
   - Submit

6. **Submit Assignment** (as student):
   - Select assignment
   - Add GitHub link
   - Submit

7. ✅ **Verify in Neon**:
   - Go to: https://console.neon.tech/
   - Select: `user_service_db` → SQL Editor
   - Run: `SELECT * FROM users;`
   - Should see your registered users

---

## 🎯 Your Production URLs

After deployment, save these:

```
Frontend:           https://assig-sub.vercel.app/
User Service:       https://user-service-xxxx.onrender.com
Submission Service: https://submission-service-xxxx.onrender.com
Database:           Neon PostgreSQL (2 databases)
```

---

## ⚠️ Important Notes

### Free Tier Behavior

- **First request after 15 min inactivity**: Takes 30-60 seconds (service wakes up)
- **Subsequent requests**: Fast (normal speed)
- **Auto-sleep**: Services sleep after 15 minutes of no traffic
- **750 hours/month**: Split between both services (~375 hours each)

### Keep Services Awake (Optional)

Use a free uptime monitor to ping services every 5 minutes:

- **UptimeRobot**: https://uptimerobot.com/ (free)
- Ping URLs:
  - `https://user-service-xxxx.onrender.com/api/auth/health`
  - `https://submission-service-xxxx.onrender.com/api/assignments/health`

---

## 🆘 Troubleshooting

### "Service Failed to Start"

1. Check **Logs** in Render dashboard
2. Verify all environment variables are set correctly
3. Check `DB_PASSWORD` matches your Neon password exactly

### "Database Connection Failed"

1. Verify Neon database is running: https://console.neon.tech/
2. Check `DB_HOST` is correct in environment variables
3. Ensure Neon didn't auto-suspend (free tier suspends after 7 days of inactivity)

### "CORS Error" in Frontend

1. Verify `CORS_ALLOWED_ORIGINS` includes Vercel URL
2. Wait for service to auto-redeploy after environment variable changes
3. Clear browser cache and hard reload (Ctrl+Shift+R)

### "Login Failed"

1. Wait 60 seconds (service might be waking up)
2. Check browser console for errors (F12)
3. Verify Vercel environment variables are set correctly
4. Check Render service logs for errors

---

## ✅ Success!

**Your application is now running 100% FREE in production!**

- ✅ No credit card required
- ✅ No warning pages
- ✅ Auto-deployment on git push
- ✅ PostgreSQL database (Neon)
- ✅ Full Spring Boot + React application

**Total Setup Time**: ~15-20 minutes ⚡

---

## 📚 Next Steps

1. **Test all features** thoroughly
2. **Monitor** services in Render dashboard
3. **Check database** in Neon console
4. **Share** your app: https://assig-sub.vercel.app/
5. **Keep developing**: Any git push auto-deploys!

🎉 **Congratulations on deploying to production!** 🎉
