# 🗄️ FREE PRODUCTION DATABASE OPTIONS (No Payment Required)

You're right - H2 is NOT for production! Here are free PostgreSQL/MySQL options without payment info.

---

## ✅ RECOMMENDED: Neon (PostgreSQL - Best Free Option)

### **Why Neon:**
- ✅ **No credit card required**
- ✅ PostgreSQL (production-grade)
- ✅ 512MB storage free
- ✅ Auto-scaling
- ✅ Serverless (sleeps when inactive)
- ✅ Easy setup

### **Setup Steps:**

#### 1. Create Neon Account
- Go to: https://neon.tech
- Click **"Sign up"**
- Use GitHub authentication (no card)

#### 2. Create Database
1. Click **"Create a project"**
2. Name: `assignment-system`
3. Region: Choose closest to you
4. PostgreSQL version: 16
5. Click **"Create project"**

#### 3. Get Connection String
After creation, you'll see:
```
postgres://username:password@host.neon.tech/dbname?sslmode=require
```

#### 4. Update Backend Configuration

**File:** `backend/user-service/src/main/resources/application.properties`
```properties
# Production Database (Neon PostgreSQL)
spring.datasource.url=jdbc:postgresql://your-host.neon.tech:5432/assignment_system?sslmode=require
spring.datasource.username=your-username
spring.datasource.password=your-password
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA Configuration
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
```

**File:** `backend/submission-service/src/main/resources/application.properties`
```properties
# Production Database (Neon PostgreSQL)
spring.datasource.url=jdbc:postgresql://your-host.neon.tech:5432/assignment_system?sslmode=require
spring.datasource.username=your-username
spring.datasource.password=your-password
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA Configuration
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
```

#### 5. Verify PostgreSQL Driver
Both `pom.xml` files already have PostgreSQL driver (we added it earlier):
```xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

---

## 🔄 ALTERNATIVE FREE OPTIONS

### **Option 2: Supabase (PostgreSQL)**

**Features:**
- ✅ No credit card required
- ✅ 500MB storage free
- ✅ PostgreSQL + REST API
- ✅ Real-time capabilities

**Setup:**
1. Go to: https://supabase.com
2. Sign up with GitHub
3. Create new project
4. Get connection string from Settings → Database

**Connection String Format:**
```
postgres://postgres.[project-ref].supabase.co:5432/postgres
```

### **Option 3: ElephantSQL (PostgreSQL)**

**Features:**
- ✅ No credit card required
- ✅ 20MB storage free (tiny but enough for testing)
- ✅ Dedicated PostgreSQL instance

**Setup:**
1. Go to: https://www.elephantsql.com
2. Sign up (free)
3. Create "Tiny Turtle" instance (free)
4. Copy URL

### **Option 4: Aiven (PostgreSQL/MySQL)**

**Features:**
- ✅ $300 free credit (30 days)
- ✅ Production-grade
- ⚠️ Credit card required (but not charged)

---

## 📋 DATABASE COMPARISON

| Service | Type | Free Storage | Card Required | Best For |
|---------|------|--------------|---------------|----------|
| **Neon** | PostgreSQL | 512MB | ❌ NO | **Recommended** |
| **Supabase** | PostgreSQL | 500MB | ❌ NO | Alternative |
| **ElephantSQL** | PostgreSQL | 20MB | ❌ NO | Tiny projects |
| **Aiven** | PostgreSQL/MySQL | Unlimited* | ⚠️ Yes | 30-day trials |

*During trial period

---

## 🎯 RECOMMENDED PRODUCTION SETUP

### **Architecture:**
```
Frontend (Vercel)
    ↓
Backend User Service (ngrok/Oracle)
    ↓
Backend Submission Service (ngrok/Oracle)
    ↓
PostgreSQL Database (Neon)
```

### **Why This Setup:**
1. ✅ **Vercel** - Professional frontend hosting
2. ✅ **ngrok** - Public backend access (or Oracle VM for 24/7)
3. ✅ **Neon** - Production-grade PostgreSQL
4. ✅ **Total Cost:** $0
5. ✅ **No Payment Info:** Required anywhere

---

## 🚀 QUICK SETUP GUIDE

### **1. Set Up Neon Database** (2 minutes)
```
1. Go to https://neon.tech
2. Sign up with GitHub
3. Create project
4. Copy connection string
```

### **2. Update Backend Properties** (3 minutes)
```
1. Edit application.properties files
2. Add Neon connection string
3. Set PostgreSQL dialect
4. Save files
```

### **3. Test Locally** (2 minutes)
```powershell
cd backend/user-service
mvnw spring-boot:run

cd backend/submission-service
mvnw spring-boot:run
```

### **4. Deploy to Production**
```
1. Deploy frontend to Vercel
2. Start backends with ngrok tunnels
3. Connected to Neon PostgreSQL
```

---

## ⚠️ IMPORTANT: Separate Databases

For better isolation, create **2 separate databases** on Neon:

### **Database 1: user_service_db**
```sql
CREATE DATABASE user_service_db;
```
Connection for user-service:
```
jdbc:postgresql://host.neon.tech:5432/user_service_db?sslmode=require
```

### **Database 2: submission_service_db**
```sql
CREATE DATABASE submission_service_db;
```
Connection for submission-service:
```
jdbc:postgresql://host.neon.tech:5432/submission_service_db?sslmode=require
```

**Or use Neon's branching feature** to create separate database instances.

---

## 🔐 SECURITY BEST PRACTICES

### **1. Use Environment Variables**
Don't hardcode database credentials!

**Create:** `.env` file (add to .gitignore)
```properties
DB_HOST=your-host.neon.tech
DB_NAME=assignment_system
DB_USER=your-username
DB_PASSWORD=your-password
```

**Update:** `application.properties`
```properties
spring.datasource.url=jdbc:postgresql://${DB_HOST}:5432/${DB_NAME}?sslmode=require
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}
```

### **2. Enable SSL**
Always use `sslmode=require` in production!

### **3. Connection Pooling**
Already configured in your application:
```properties
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=2
```

---

## 📊 FREE TIER LIMITS (Neon)

- **Storage:** 512MB (enough for ~100K records)
- **Compute:** Shared CPU
- **Connections:** 100 concurrent
- **Auto-pause:** After 5 min inactivity (free tier)
- **Branches:** 10 (for dev/staging/prod separation)

---

## 🎉 FINAL PRODUCTION STACK (100% Free)

```
┌─────────────────────────────────────┐
│   Frontend (Vercel)                 │
│   - React + Vite                    │
│   - Global CDN                      │
│   - Auto HTTPS                      │
└──────────────┬──────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│   User Service (Local + ngrok)      │
│   - Spring Boot 3.2.0               │
│   - Java 21                         │
│   - JWT Auth                        │
└──────────────┬──────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│   PostgreSQL (Neon)                 │
│   - Production-grade                │
│   - Auto-scaling                    │
│   - SSL enabled                     │
└─────────────────────────────────────┘
```

**✅ No H2 in production**
**✅ No payment info required**
**✅ Production-ready architecture**

---

## 🚀 NEXT STEPS

1. **Sign up for Neon:** https://neon.tech
2. **Create PostgreSQL database**
3. **Update application.properties** with Neon credentials
4. **Test locally** to ensure connection works
5. **Deploy** using Vercel + ngrok setup

**Your application will be production-ready with a real database!** 🎯
