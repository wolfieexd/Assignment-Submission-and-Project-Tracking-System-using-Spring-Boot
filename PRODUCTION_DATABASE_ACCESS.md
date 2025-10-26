# 🗄️ Production Database Access Guide

## After Deployment to Railway.app

### 🎯 Quick Access Methods

#### 1. Railway Dashboard (Easiest)
```
1. Login: https://railway.app
2. Select your project
3. Click "MySQL" service
4. Go to "Data" tab
5. Browse tables directly
```

#### 2. MySQL Workbench (Best for Management)
```
Download: https://dev.mysql.com/downloads/workbench/

Connection Settings:
- Host: [From Railway DATABASE_URL]
- Port: 3306
- Database: railway
- Username: root
- Password: [From Railway]
```

#### 3. Railway CLI (Command Line)
```bash
# Install
npm i -g @railway/cli

# Connect
railway login
railway link
railway connect mysql

# Query
mysql> SHOW DATABASES;
mysql> USE railway;
mysql> SHOW TABLES;
mysql> SELECT * FROM students LIMIT 10;
```

---

## 🔗 Get Database Connection Details

### From Railway Dashboard:
1. Go to your MySQL service
2. Click "Variables" tab
3. Find these values:
   - `MYSQLHOST`
   - `MYSQLPORT`
   - `MYSQLDATABASE`
   - `MYSQLUSER`
   - `MYSQLPASSWORD`

### From DATABASE_URL:
Format: `mysql://username:password@host:port/database`

Example:
```
DATABASE_URL=mysql://root:abc123@containers-us-west-12.railway.app:3306/railway
```

Parse to:
- Username: `root`
- Password: `abc123`
- Host: `containers-us-west-12.railway.app`
- Port: `3306`
- Database: `railway`

---

## 📊 Your Production Tables

### User Service (`user_service_db` or `railway`)

#### STUDENTS Table
```sql
SELECT id, name, email, role, department, active, created_at 
FROM students 
ORDER BY created_at DESC;
```

#### FACULTY Table
```sql
SELECT id, name, email, role, department, active, created_at 
FROM faculty 
ORDER BY created_at DESC;
```

### Submission Service (`submission_service_db` or `railway`)

#### ASSIGNMENTS Table
```sql
SELECT id, title, course, faculty_name, due_date, max_points, created_at 
FROM assignments 
ORDER BY created_at DESC;
```

#### SUBMISSIONS Table
```sql
SELECT id, assignment_id, student_name, status, grade, submitted_at, graded_at 
FROM submissions 
ORDER BY submitted_at DESC;
```

#### PROJECTS Table
```sql
SELECT id, title, student_name, faculty_name, status, progress, deadline 
FROM projects 
ORDER BY created_at DESC;
```

---

## 🛠️ MySQL Workbench Setup (Step-by-Step)

### Install MySQL Workbench
1. Download from: https://dev.mysql.com/downloads/workbench/
2. Install (no MySQL Server needed, just Workbench)
3. Launch MySQL Workbench

### Create Connection
1. Click "+" next to "MySQL Connections"
2. Enter connection details:
   ```
   Connection Name: Railway Production DB
   Hostname: [Your Railway MySQL host]
   Port: 3306
   Username: root
   Password: [Click "Store in Vault" and enter password]
   Default Schema: railway
   ```
3. Click "Test Connection"
4. If successful, click "OK"

### Connect to Database
1. Double-click the connection
2. Enter password if prompted
3. You'll see the database explorer on the left

### Browse Tables
1. Expand "Schemas" in left sidebar
2. Expand your database (e.g., "railway")
3. Expand "Tables"
4. Right-click table → "Select Rows - Limit 1000"

### Run Queries
1. Click "Create a new SQL tab" (⚡ icon)
2. Write your SQL:
   ```sql
   SELECT * FROM students WHERE role = 'STUDENT';
   ```
3. Click "Execute" (⚡ icon) or press Ctrl+Enter

---

## 🌐 DBeaver Setup (Alternative)

### Install DBeaver
1. Download: https://dbeaver.io/download/
2. Install Community Edition (free)
3. Launch DBeaver

### Create Connection
1. Click "New Database Connection" (plug icon)
2. Select "MySQL"
3. Click "Next"
4. Enter connection details:
   ```
   Server Host: [Your Railway host]
   Port: 3306
   Database: railway
   Username: root
   Password: [Your password]
   ```
5. Click "Test Connection"
6. If needed, download MySQL driver
7. Click "Finish"

### Browse Data
1. Expand connection in left sidebar
2. Expand "Databases" → "railway" → "Tables"
3. Double-click table to view data
4. Use SQL Editor for custom queries

---

## 🔍 Common SQL Queries

### Check Total Users
```sql
-- Students
SELECT COUNT(*) as total_students FROM students;

-- Faculty
SELECT COUNT(*) as total_faculty FROM faculty;
```

### Recent Submissions
```sql
SELECT 
    s.id,
    s.student_name,
    a.title as assignment_title,
    s.status,
    s.grade,
    s.submitted_at
FROM submissions s
JOIN assignments a ON s.assignment_id = a.id
ORDER BY s.submitted_at DESC
LIMIT 20;
```

### Assignment Statistics
```sql
SELECT 
    a.title,
    a.max_points,
    COUNT(s.id) as total_submissions,
    AVG(s.grade) as average_grade
FROM assignments a
LEFT JOIN submissions s ON a.id = s.assignment_id
GROUP BY a.id, a.title
ORDER BY a.created_at DESC;
```

### Active Projects
```sql
SELECT 
    title,
    student_name,
    faculty_name,
    status,
    progress,
    DATEDIFF(deadline, NOW()) as days_remaining
FROM projects
WHERE status != 'COMPLETED'
ORDER BY deadline ASC;
```

---

## 🔒 Security Best Practices

### ✅ DO:
- Use read-only database user for viewing data
- Connect over SSL/TLS
- Use strong passwords
- Whitelist your IP address
- Keep connection details secure
- Use Railway's built-in security features

### ❌ DON'T:
- Don't expose H2 console in production
- Don't hardcode database passwords
- Don't use root user for application
- Don't disable SSL in production
- Don't share database credentials
- Don't commit credentials to Git

---

## 🚨 Emergency Database Access

### If Railway Dashboard is Down:
1. Use MySQL Workbench with saved connection
2. Use Railway CLI: `railway connect mysql`
3. Use DBeaver with saved connection

### If You Forgot Password:
1. Go to Railway project
2. Click MySQL service
3. Go to "Variables" tab
4. View `MYSQLPASSWORD` variable
5. Or regenerate database (⚠️ will lose data)

---

## 📱 Mobile Database Access

### Railway App (iOS/Android)
- Not available yet
- Use web dashboard on mobile browser

### Third-Party Apps:
- **iOS**: SQLPro for MySQL
- **Android**: MySQL Client
- Both require connection details from Railway

---

## 🎓 Learning Resources

### MySQL Workbench
- Official Docs: https://dev.mysql.com/doc/workbench/en/
- Video Tutorial: Search "MySQL Workbench tutorial" on YouTube

### DBeaver
- Official Docs: https://dbeaver.com/docs/
- Community Wiki: https://github.com/dbeaver/dbeaver/wiki

### Railway
- Docs: https://docs.railway.app/databases/mysql
- Discord: https://discord.gg/railway

---

## 📞 Quick Reference Card

```
╔════════════════════════════════════════════════════════════╗
║  PRODUCTION DATABASE ACCESS CHEAT SHEET                   ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  Railway Dashboard:  https://railway.app                  ║
║  MySQL Workbench:    Download + Connect with Railway creds║
║  Railway CLI:        railway connect mysql                 ║
║                                                            ║
║  Connection Info:    Railway → MySQL → Variables tab      ║
║  Tables:            students, faculty, assignments,        ║
║                     submissions, projects                  ║
║                                                            ║
║  ⚠️  H2 Console:     DISABLED in production (dev only)    ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

---

**Summary**: Use Railway Dashboard for quick checks, MySQL Workbench for serious database management, and Railway CLI for command-line access. Never expose database consoles in production!
