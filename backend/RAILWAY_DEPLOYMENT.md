# Railway.app Deployment Guide

## 🚄 Quick Deployment to Railway.app

Your Spring Boot application is ready for Railway deployment!

---

## ✅ Pre-Deployment Checklist

- [x] Java 21 LTS configured
- [x] Production configs created
- [x] JWT secret generated
- [x] Security hardened
- [ ] Railway account created
- [ ] Database addon added
- [ ] Environment variables set

---

## 📋 STEP-BY-STEP DEPLOYMENT

### Step 1: Prepare Railway Project (5 min)

1. **Go to Railway Dashboard**: https://railway.app
2. **Create New Project** or use existing
3. **Add MySQL/PostgreSQL Database**
   - Click "New" → "Database" → "MySQL" or "PostgreSQL"
   - Railway will auto-generate connection credentials

### Step 2: Configure Environment Variables (3 min)

In Railway Dashboard → Your Service → Variables, add:

#### User Service Variables:
```bash
# JWT Secret (CRITICAL - Use the generated one)
JWT_SECRET=TVlQMDFJcXZLTm1PbmNVQnM5eEN1a2gzckxKdDhUZnA0d2xqSDdHUzUyRGlhQXpFZGVnUVpGYm9SWDZXVnk=

# Spring Profile
SPRING_PROFILES_ACTIVE=prod

# Database (Railway auto-provides DATABASE_URL)
# Railway will automatically inject MYSQLHOST, MYSQLPORT, MYSQLDATABASE, MYSQLUSER, MYSQLPASSWORD
# Or use:
SPRING_DATASOURCE_URL=${DATABASE_URL}

# CORS (Update with your frontend URL)
CORS_ALLOWED_ORIGINS=https://your-frontend-url.up.railway.app

# JWT Expiration (1 hour)
JWT_EXPIRATION=3600000

# Logging
LOGGING_LEVEL_ROOT=WARN
LOGGING_LEVEL_COM_ASSIGNMENT_USERSERVICE=INFO
```

#### Submission Service Variables:
```bash
# Same JWT Secret (MUST BE IDENTICAL)
JWT_SECRET=TVlQMDFJcXZLTm1PbmNVQnM5eEN1a2gzckxKdDhUZnA0d2xqSDdHUzUyRGlhQXpFZGVnUVpGYm9SWDZXVnk=

# Spring Profile
SPRING_PROFILES_ACTIVE=prod

# Database
SPRING_DATASOURCE_URL=${DATABASE_URL}

# CORS (Update with your frontend URL)
CORS_ALLOWED_ORIGINS=https://your-frontend-url.up.railway.app

# User Service URL (Update after user-service is deployed)
USER_SERVICE_URL=https://user-service.up.railway.app

# File Upload
FILE_UPLOAD_DIR=/app/uploads

# JWT Expiration
JWT_EXPIRATION=3600000

# Logging
LOGGING_LEVEL_ROOT=WARN
LOGGING_LEVEL_COM_ASSIGNMENT_SUBMISSIONSERVICE=INFO
```

### Step 3: Update application-prod.properties for Railway (2 min)

Railway automatically provides database connection through `DATABASE_URL`, so we need to configure Spring to use it:

**For Railway, the database URL format is**:
- MySQL: `mysql://user:password@host:port/database`
- PostgreSQL: `postgresql://user:password@host:port/database`

Spring Boot will automatically parse `${DATABASE_URL}` if using Railway's database addon.

### Step 4: Deploy Services (5 min)

#### Option A: Using Railway CLI (Recommended)
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link to your project
railway link

# Deploy user-service
cd backend/user-service
railway up

# Deploy submission-service
cd ../submission-service
railway up
```

#### Option B: Using GitHub Integration (Easier)
1. **Push to GitHub** (if not already)
2. **In Railway**: New → "Deploy from GitHub repo"
3. **Select your repository**
4. **Configure**:
   - Root Directory: `backend/user-service`
   - Build Command: `mvn clean package -DskipTests`
   - Start Command: `java -jar target/user-service-1.0.0.jar`
5. **Repeat for submission-service**

### Step 5: Configure Build Settings (2 min)

In Railway → Settings → Build:

**User Service**:
```
Build Command: mvn clean package -DskipTests
Start Command: java -Dserver.port=$PORT -jar target/user-service-1.0.0.jar
```

**Submission Service**:
```
Build Command: mvn clean package -DskipTests
Start Command: java -Dserver.port=$PORT -jar target/submission-service-1.0.0.jar
```

### Step 6: Initialize Database (3 min)

Railway doesn't run SQL scripts automatically, so you have two options:

#### Option A: Manual (Quick)
1. In Railway → Database → "Data" tab
2. Click "Connect" to get connection details
3. Use MySQL client to run:
```bash
mysql -h railway-host -u root -p < db-init-user-service.sql
mysql -h railway-host -u root -p < db-init-submission-service.sql
```

#### Option B: Automatic (Better)
Let Spring JPA create tables automatically:
- Set `spring.jpa.hibernate.ddl-auto=update` for first deployment
- After first run, change to `validate`

### Step 7: Verify Deployment (2 min)

Check health endpoints:
```bash
# User Service
curl https://your-user-service.up.railway.app/actuator/health

# Submission Service
curl https://your-submission-service.up.railway.app/actuator/health
```

Both should return: `{"status":"UP"}`

### Step 8: Update Frontend CORS (1 min)

Update the `CORS_ALLOWED_ORIGINS` variable with your actual frontend URL:
```
CORS_ALLOWED_ORIGINS=https://your-actual-frontend.up.railway.app
```

---

## 🔧 RAILWAY-SPECIFIC CONFIGURATIONS

### Database Connection

Railway provides database connection via environment variables:

**For MySQL**:
```bash
MYSQLHOST=containers-us-west-123.railway.app
MYSQLPORT=1234
MYSQLDATABASE=railway
MYSQLUSER=root
MYSQLPASSWORD=generated-password
DATABASE_URL=mysql://root:password@host:port/railway
```

**For PostgreSQL**:
```bash
PGHOST=containers-us-west-123.railway.app
PGPORT=5432
PGDATABASE=railway
PGUSER=postgres
PGPASSWORD=generated-password
DATABASE_URL=postgresql://postgres:password@host:port/railway
```

Spring Boot will automatically use `DATABASE_URL` if you configure:
```properties
spring.datasource.url=${DATABASE_URL}
```

### Port Configuration

Railway automatically assigns a port via `$PORT` environment variable. Your app should bind to:
```properties
server.port=${PORT:8080}
```

### File Upload

Railway's filesystem is ephemeral. For file uploads, you have options:

#### Option 1: Use Railway Volume (Persistent)
1. In Railway → Settings → Volumes
2. Add volume: `/app/uploads`
3. Files will persist across deployments

#### Option 2: Use Cloud Storage (Recommended for Production)
- AWS S3
- Google Cloud Storage
- Cloudinary
- Azure Blob Storage

---

## ⚠️ IMPORTANT: Railway-Specific Notes

### 1. Database Auto-Configuration
Railway's database addon automatically sets:
- `DATABASE_URL`
- Connection credentials

**Your application-prod.properties should use**:
```properties
spring.datasource.url=${DATABASE_URL}
# No need to set username/password separately
```

### 2. Port Binding
Railway assigns a random port. **Always use**:
```properties
server.port=${PORT:8080}
```

### 3. Health Checks
Railway checks if your app responds on the assigned port. Ensure:
```properties
management.endpoints.web.exposure.include=health
```

### 4. Build Time
- First build: ~3-5 minutes (downloads Maven dependencies)
- Subsequent builds: ~1-2 minutes (cached)

### 5. Logs
View logs in Railway Dashboard → Your Service → Deployments → Click deployment → Logs

---

## 🔍 TROUBLESHOOTING

### Issue: "Application failed to start"
**Check**:
1. Railway logs for error messages
2. Environment variables are set correctly
3. Database connection is working
4. Port binding uses `${PORT}`

### Issue: "Database connection failed"
**Fix**:
1. Verify database addon is provisioned
2. Check `DATABASE_URL` is available
3. Ensure Spring DataSource uses `${DATABASE_URL}`
4. Check database is running in Railway dashboard

### Issue: "JWT signature does not match"
**Fix**:
1. **CRITICAL**: Both services MUST use the SAME `JWT_SECRET`
2. Verify in Railway → Variables
3. Redeploy both services

### Issue: "CORS error"
**Fix**:
1. Update `CORS_ALLOWED_ORIGINS` with actual frontend URL
2. Remove trailing slashes
3. Include both http and https if needed
4. Redeploy service

### Issue: "File upload fails"
**Fix**:
1. Add Railway Volume for `/app/uploads`
2. Or switch to cloud storage (S3, etc.)

---

## ✅ POST-DEPLOYMENT CHECKLIST

After deployment, verify:

- [ ] User Service health endpoint responds
- [ ] Submission Service health endpoint responds
- [ ] Can register new user
- [ ] Can login and receive JWT token
- [ ] JWT token works across both services
- [ ] Can create assignment (faculty)
- [ ] Can submit assignment (student)
- [ ] File uploads work
- [ ] CORS allows frontend requests
- [ ] Database persists data
- [ ] Logs show no errors
- [ ] Environment variables are set
- [ ] Both services use same JWT_SECRET

---

## 📊 MONITORING

### Railway Built-in Monitoring
- **Metrics**: CPU, Memory, Network
- **Logs**: Real-time application logs
- **Deployments**: Deployment history and status

### Custom Monitoring
Your app exposes:
- `/actuator/health` - Health status
- `/actuator/metrics` - Application metrics
- `/actuator/info` - App information

---

## 🚀 UPDATING YOUR APP

### Method 1: Git Push (Automatic)
```bash
git add .
git commit -m "Update application"
git push origin main
```
Railway auto-deploys on push.

### Method 2: Railway CLI
```bash
railway up
```

### Method 3: Manual Deploy
In Railway Dashboard → Deployments → "Deploy"

---

## 💰 RAILWAY PRICING NOTES

**Hobby Plan** (Free):
- $5 free credit/month
- Perfect for testing
- Sleeps after inactivity (cold starts)

**Developer Plan** ($5/month):
- $5 credit + usage-based pricing
- No sleeping
- Better for production

**Team Plan** ($20/month):
- More resources
- Team collaboration

---

## 📚 USEFUL COMMANDS

### View Logs
```bash
railway logs
```

### Check Variables
```bash
railway variables
```

### Connect to Database
```bash
railway connect mysql
# or
railway connect postgresql
```

### Run Command in Railway
```bash
railway run <command>
```

---

## 🎯 FINAL RAILWAY DEPLOYMENT COMMAND

Once everything is configured:

```bash
# User Service
cd backend/user-service
railway up

# Submission Service  
cd ../submission-service
railway up
```

Or let Railway auto-deploy from GitHub!

---

## ✅ YOUR RAILWAY DEPLOYMENT IS READY!

Follow these steps and your Spring Boot application will be live on Railway.app with:
- ✅ Secure JWT authentication
- ✅ Production MySQL database
- ✅ Auto-scaling
- ✅ HTTPS by default
- ✅ Easy monitoring and logs
- ✅ Zero-downtime deployments

**Good luck!** 🚀

---

**Need Help?**
- Railway Docs: https://docs.railway.app
- Railway Discord: https://discord.gg/railway
- Project Guides: See other .md files in `backend/` folder
