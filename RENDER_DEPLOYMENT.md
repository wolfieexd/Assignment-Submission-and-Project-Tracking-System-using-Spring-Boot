# 🆓 Free Deployment Guide - Render.com

## ✅ Why Render.com?

- **100% FREE** tier (no credit card required for free tier)
- **PostgreSQL database** included (free forever)
- **Easy GitHub integration** (auto-deploy on push)
- **Java 21 support** ✅
- **No cold starts** on free tier (unlike some competitors)
- **750 hours/month** free compute time

---

## 🚀 Quick Deployment Steps

### **Step 1: Sign Up for Render**

1. Go to https://render.com
2. Click **"Get Started for Free"**
3. Sign up with GitHub (recommended)
4. Authorize Render to access your repositories

---

### **Step 2: Create PostgreSQL Database**

1. From Render Dashboard, click **"New +"**
2. Select **"PostgreSQL"**
3. Configure:
   ```
   Name: assignment-system-db
   Database: assignment_db
   User: assignment_user
   Region: Choose closest to you
   PostgreSQL Version: 16 (latest)
   Plan: Free
   ```
4. Click **"Create Database"**
5. **Save these details** (shown on database page):
   - Internal Database URL
   - External Database URL
   - Username
   - Password

---

### **Step 3: Deploy User Service (Backend)**

1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Configure:

```yaml
Name: user-service
Region: Same as database
Branch: main
Root Directory: backend/user-service
Runtime: Java
Build Command: mvn clean package -DskipTests
Start Command: java -Dserver.port=$PORT -jar target/user-service-1.0.0.jar --spring.profiles.active=prod
Plan: Free
```

4. **Environment Variables** (click "Advanced" → "Add Environment Variable"):

```env
# Spring Profile
SPRING_PROFILES_ACTIVE=prod

# Database (use values from your Render PostgreSQL)
DATABASE_URL=${DATABASE_URL}
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_NAME=assignment_db
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}

# JWT Secret (from backend/JWT_SECRET.txt)
JWT_SECRET=TVlQMDFJcXZLTm1PbmNVQnM5eEN1a2gzckxKdDhUZnA0d2xqSDdHUzUyRGlhQXpFZGVnUVpGYm9SWDZXVnk=

# CORS (will update after frontend deployment)
CORS_ALLOWED_ORIGINS=*

# Port (Render provides this)
PORT=10000
```

5. Click **"Create Web Service"**

---

### **Step 4: Deploy Submission Service (Backend)**

1. Click **"New +"** → **"Web Service"**
2. Connect same GitHub repository
3. Configure:

```yaml
Name: submission-service
Region: Same as database
Branch: main
Root Directory: backend/submission-service
Runtime: Java
Build Command: mvn clean package -DskipTests
Start Command: java -Dserver.port=$PORT -jar target/submission-service-1.0.0.jar --spring.profiles.active=prod
Plan: Free
```

4. **Environment Variables**:

```env
# Spring Profile
SPRING_PROFILES_ACTIVE=prod

# Database (same PostgreSQL instance)
DATABASE_URL=${DATABASE_URL}
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_NAME=assignment_db
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}

# JWT Secret (MUST be same as User Service!)
JWT_SECRET=TVlQMDFJcXZLTm1PbmNVQnM5eEN1a2gzckxKdDhUZnA0d2xqSDdHUzUyRGlhQXpFZGVnUVpGYm9SWDZXVnk=

# CORS
CORS_ALLOWED_ORIGINS=*

# File Upload
FILE_UPLOAD_DIR=/opt/render/project/uploads

# Port
PORT=10000
```

5. Click **"Create Web Service"**

---

### **Step 5: Deploy Frontend (React)**

1. Click **"New +"** → **"Static Site"**
2. Connect same GitHub repository
3. Configure:

```yaml
Name: assignment-frontend
Branch: main
Root Directory: (leave empty - root of repo)
Build Command: npm install && npm run build
Publish Directory: dist
```

4. **Environment Variables**:

```env
# Backend URLs (update with YOUR Render URLs)
VITE_USER_SERVICE_URL=https://user-service.onrender.com
VITE_SUBMISSION_SERVICE_URL=https://submission-service.onrender.com
```

5. Click **"Create Static Site"**

---

### **Step 6: Update CORS Settings**

After frontend deploys, update backend CORS:

1. Go to **User Service** → **Environment**
2. Update `CORS_ALLOWED_ORIGINS`:
   ```
   https://your-frontend-name.onrender.com
   ```
3. Repeat for **Submission Service**
4. Both services will auto-redeploy

---

### **Step 7: Initialize Database**

#### Option A: Render Shell (Recommended)

1. Go to your **PostgreSQL** database
2. Click **"Shell"** tab (or "Connect")
3. Run these commands:

```sql
-- Create tables (Hibernate will do this automatically on first run)
-- But you can verify:
\l                    -- List databases
\c assignment_db      -- Connect to database
\dt                   -- List tables

-- Tables should be auto-created:
-- students, faculty, assignments, submissions, projects
```

#### Option B: Using External Connection

Download a PostgreSQL client:
- **pgAdmin**: https://www.pgadmin.org/
- **DBeaver**: https://dbeaver.io/

Connect using **External Database URL** from Render.

---

## 🔧 Configuration Files Needed

### Update `application-prod.properties` for PostgreSQL

Both services need PostgreSQL config instead of MySQL:

**backend/user-service/src/main/resources/application-prod.properties**:
```properties
# Database - PostgreSQL
spring.datasource.url=jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME:assignment_db}
spring.datasource.username=${DB_USER:postgres}
spring.datasource.password=${DB_PASSWORD:password}
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.properties.hibernate.format_sql=true

# Other configs remain same...
```

**backend/submission-service/src/main/resources/application-prod.properties**:
```properties
# Database - PostgreSQL
spring.datasource.url=jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME:assignment_db}
spring.datasource.username=${DB_USER:postgres}
spring.datasource.password=${DB_PASSWORD:password}
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.properties.hibernate.format_sql=true

# Other configs remain same...
```

### Add PostgreSQL Dependency to pom.xml

Both services need PostgreSQL driver:

**backend/user-service/pom.xml** & **backend/submission-service/pom.xml**:
```xml
<!-- Add this dependency -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

---

## 📝 Render.yaml (Optional - Auto Configuration)

Create `render.yaml` in project root for one-click deployment:

```yaml
services:
  # PostgreSQL Database
  - type: pserv
    name: assignment-db
    plan: free
    region: oregon
    databaseName: assignment_db
    databaseUser: assignment_user
    ipAllowList: []

  # User Service
  - type: web
    name: user-service
    runtime: java
    plan: free
    region: oregon
    rootDir: backend/user-service
    buildCommand: mvn clean package -DskipTests
    startCommand: java -Dserver.port=$PORT -jar target/user-service-1.0.0.jar --spring.profiles.active=prod
    envVars:
      - key: SPRING_PROFILES_ACTIVE
        value: prod
      - key: JWT_SECRET
        value: TVlQMDFJcXZLTm1PbmNVQnM5eEN1a2gzckxKdDhUZnA0d2xqSDdHUzUyRGlhQXpFZGVnUVpGYm9SWDZXVnk=
      - key: DATABASE_URL
        fromDatabase:
          name: assignment-db
          property: connectionString

  # Submission Service
  - type: web
    name: submission-service
    runtime: java
    plan: free
    region: oregon
    rootDir: backend/submission-service
    buildCommand: mvn clean package -DskipTests
    startCommand: java -Dserver.port=$PORT -jar target/submission-service-1.0.0.jar --spring.profiles.active=prod
    envVars:
      - key: SPRING_PROFILES_ACTIVE
        value: prod
      - key: JWT_SECRET
        value: TVlQMDFJcXZLTm1PbmNVQnM5eEN1a2gzckxKdDhUZnA0d2xqSDdHUzUyRGlhQXpFZGVnUVpGYm9SWDZXVnk=
      - key: DATABASE_URL
        fromDatabase:
          name: assignment-db
          property: connectionString

  # Frontend
  - type: web
    name: assignment-frontend
    runtime: static
    plan: free
    region: oregon
    buildCommand: npm install && npm run build
    staticPublishPath: dist
    envVars:
      - key: VITE_USER_SERVICE_URL
        value: https://user-service.onrender.com
      - key: VITE_SUBMISSION_SERVICE_URL
        value: https://submission-service.onrender.com
```

---

## ⚡ Quick Deployment Checklist

- [ ] Sign up on Render.com (free)
- [ ] Create PostgreSQL database
- [ ] Update pom.xml with PostgreSQL dependency
- [ ] Update application-prod.properties for PostgreSQL
- [ ] Commit and push changes to GitHub
- [ ] Deploy User Service
- [ ] Deploy Submission Service
- [ ] Deploy Frontend
- [ ] Set environment variables for all services
- [ ] Update CORS with frontend URL
- [ ] Test registration endpoint
- [ ] Test login endpoint
- [ ] Verify database tables created

---

## 🎯 Your Service URLs (Fill after deployment)

```
Frontend:           https://________________.onrender.com
User Service:       https://________________.onrender.com
Submission Service: https://________________.onrender.com
PostgreSQL:         (Internal Render URL)
```

---

## 🆚 Render vs Railway Comparison

| Feature | Render (Free) | Railway (Paid) |
|---------|---------------|----------------|
| **Cost** | 100% Free | $5/month minimum |
| **Database** | PostgreSQL (free) | MySQL (paid) |
| **Compute** | 750 hrs/month | Limited free trial |
| **Cold Starts** | No | Yes (on free tier) |
| **Build Time** | Medium | Fast |
| **Java 21** | ✅ Supported | ✅ Supported |

---

## 🎉 Next Steps

1. I can help you update the code for PostgreSQL
2. Then push to GitHub
3. Deploy on Render.com

**Ready to switch to PostgreSQL and deploy on Render?** 🚀
