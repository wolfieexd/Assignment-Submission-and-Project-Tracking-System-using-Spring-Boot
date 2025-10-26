# 🚀 RENDER.COM DEPLOYMENT - FINAL CHECKLIST

## ✅ Preparation Complete

### Code Configuration
- [x] PostgreSQL driver added to `user-service/pom.xml`
- [x] PostgreSQL driver added to `submission-service/pom.xml`
- [x] `application-prod.properties` updated for PostgreSQL (both services)
- [x] Hibernate dialect changed to `PostgreSQLDialect`
- [x] Database URL format: `jdbc:postgresql://...?sslmode=require`
- [x] Hibernate DDL auto set to `update` for schema creation

### Build Scripts
- [x] `backend/user-service/build.sh` created
- [x] `backend/submission-service/build.sh` created
- [x] `build.sh` (frontend) created
- [x] All builds tested locally - SUCCESS ✅

### Deployment Configuration
- [x] `render.yaml` blueprint created with:
  - PostgreSQL database configuration
  - User service configuration
  - Submission service configuration
  - Frontend static site configuration
- [x] Comprehensive guide: `RENDER_COMPLETE_GUIDE.md`

### Git Repository
- [x] All changes committed: `dffbfaa`
- [x] Changes pushed to GitHub: `main` branch
- [x] Repository: `wolfieexd/Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot`

---

## 🎯 DEPLOYMENT STEPS (Do This Now!)

### Option A: One-Click Deployment (Recommended - 5 minutes)

1. **Go to Render Dashboard**
   - URL: https://dashboard.render.com
   - Sign in with GitHub

2. **Create New Blueprint**
   - Click: **New** → **Blueprint**
   - Connect repository: `wolfieexd/Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot`
   - Branch: `main`
   - Render auto-detects `render.yaml`

3. **Apply Blueprint**
   - Click: **Apply**
   - Wait 8-12 minutes for deployment

4. **Configure Environment Variables**
   
   **For `user-service`:**
   ```
   CORS_ALLOWED_ORIGINS = https://assignment-frontend.onrender.com
   ```
   
   **For `submission-service`:**
   ```
   CORS_ALLOWED_ORIGINS = https://assignment-frontend.onrender.com
   JWT_SECRET = <copy-from-user-service>
   ```
   
   **For `assignment-frontend`:**
   ```
   VITE_API_USER_URL = https://user-service.onrender.com
   VITE_API_SUBMISSION_URL = https://submission-service.onrender.com
   ```

5. **Trigger Manual Redeploy**
   - After setting env vars, redeploy each service
   - Dashboard → Service → Manual Deploy

6. **Test Application**
   - Open: `https://assignment-frontend.onrender.com`
   - Register new user (Faculty role)
   - Login and test features

---

### Option B: Manual Deployment (Step-by-Step - 20 minutes)

Follow detailed steps in `RENDER_COMPLETE_GUIDE.md`

---

## 🔍 Expected Deployment Results

### Services Created
1. **assignment-db** (PostgreSQL)
   - Status: Available
   - Version: PostgreSQL 16
   - Storage: 1 GB free

2. **user-service** (Java 21)
   - Status: Live
   - URL: `https://user-service.onrender.com`
   - Health: `https://user-service.onrender.com/actuator/health`

3. **submission-service** (Java 21)
   - Status: Live
   - URL: `https://submission-service.onrender.com`
   - Health: `https://submission-service.onrender.com/actuator/health`

4. **assignment-frontend** (Static)
   - Status: Live
   - URL: `https://assignment-frontend.onrender.com`

---

## ⚠️ Important Notes

### Free Tier Behavior
- **Cold Starts:** Services sleep after 15 min inactivity
- **First Request:** May take 30-60 seconds to wake up
- **Database:** Always running (no sleep)

### JWT Secret Sync
⚠️ **CRITICAL:** Both backend services MUST use the same `JWT_SECRET`!

Steps:
1. User service generates JWT_SECRET automatically
2. Copy that value from user-service environment variables
3. Paste it into submission-service `JWT_SECRET` env var
4. Redeploy submission-service

### Database Tables
Tables will be created automatically on first run:
- `users` (user-service)
- `assignments` (submission-service)
- `submissions` (submission-service)

### File Uploads
⚠️ Files stored in `/opt/render/project/uploads` are **ephemeral**
- Lost during redeploys
- Consider AWS S3 for persistent storage

---

## 🧪 Testing Checklist

After deployment completes:

### Backend Health Checks
```bash
# User Service
curl https://user-service.onrender.com/actuator/health

# Submission Service
curl https://submission-service.onrender.com/actuator/health
```

Expected Response:
```json
{"status":"UP"}
```

### Frontend Tests
1. ✅ Open frontend URL
2. ✅ Register new Faculty user
3. ✅ Login successfully
4. ✅ Create new assignment
5. ✅ Logout

6. ✅ Register new Student user
7. ✅ Login as student
8. ✅ View assignments
9. ✅ Submit assignment (with file)
10. ✅ Verify submission appears

### Database Verification
Check Render Dashboard → Database → Connections
- Should see active connections from both services

---

## 🐛 Troubleshooting

### If User Service Fails to Start
1. Check logs: Dashboard → user-service → Logs
2. Common issues:
   - Database connection timeout → Check DATABASE_URL
   - Missing JWT_SECRET → Add env var
   - Build failed → Check Java version is 21

### If Submission Service Fails
1. Check JWT_SECRET matches user-service
2. Verify DATABASE_URL is correct
3. Check file upload directory exists

### If Frontend Shows Errors
1. Check browser console for CORS errors
2. Verify API URLs in environment variables
3. Ensure backends are running

### CORS Errors
Update `CORS_ALLOWED_ORIGINS` with actual frontend URL (no trailing slash):
```
https://assignment-frontend.onrender.com
```

---

## 📊 Monitoring

### View Live Logs
Dashboard → Service → Logs

### Check Metrics
Dashboard → Service → Metrics
- CPU usage
- Memory usage
- Response times

### Database Stats
Dashboard → assignment-db → Info
- Connections
- Storage used
- Query performance

---

## 🔄 Updates & Redeployment

### Auto Deploy (Enabled by Default)
```bash
git add .
git commit -m "Your changes"
git push origin main
```
Render auto-detects and redeploys.

### Manual Deploy
Dashboard → Service → Manual Deploy → Deploy latest commit

### Rollback
Dashboard → Service → Events → Redeploy previous version

---

## 🎉 SUCCESS CRITERIA

Your deployment is successful when:

1. ✅ All 4 services show "Live" status
2. ✅ Health endpoints return `{"status":"UP"}`
3. ✅ Frontend loads without errors
4. ✅ User registration works
5. ✅ Login generates JWT token
6. ✅ Faculty can create assignments
7. ✅ Students can submit assignments
8. ✅ Database persists data across restarts

---

## 📞 Support

- **Render Docs:** https://render.com/docs
- **Community:** https://community.render.com
- **Status:** https://status.render.com

---

## 🚀 READY TO DEPLOY!

**Your GitHub repository is configured and ready.**

**Next Action:** Go to https://dashboard.render.com and deploy using Blueprint!

---

**Good luck! 🎯**
