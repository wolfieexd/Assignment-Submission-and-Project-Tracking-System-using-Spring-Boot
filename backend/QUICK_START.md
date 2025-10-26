# 🚀 Quick Start Guide - Production Deployment

## Assignment Submission System - Deploy in 10 Steps

---

## ⚡ QUICK REFERENCE

### System Info
- **Java Version**: 21 LTS ✅
- **Spring Boot**: 3.2.0 ✅
- **Services**: user-service (8081), submission-service (8082)
- **Database**: MySQL (production), H2 (development only)

---

## 📋 10-STEP PRODUCTION DEPLOYMENT

### Step 1: Generate JWT Secret (1 min)
```bash
openssl rand -base64 64
# Save output - you'll need this!
```

### Step 2: Setup MySQL (5 min)
```bash
# Login to MySQL
mysql -u root -p

# Run initialization scripts
source backend/db-init-user-service.sql
source backend/db-init-submission-service.sql
```

### Step 3: Create Environment File (2 min)
```bash
cd backend
cp .env.example .env
nano .env
```
**Edit these values**:
- `JWT_SECRET=<your-generated-secret-from-step-1>`
- `DB_URL_USER=jdbc:mysql://localhost:3306/user_service_db`
- `DB_USERNAME_USER=user_service_user`
- `DB_PASSWORD_USER=<strong-password>`
- `DB_URL_SUBMISSION=jdbc:mysql://localhost:3306/submission_service_db`
- `DB_USERNAME_SUBMISSION=submission_service_user`
- `DB_PASSWORD_SUBMISSION=<strong-password>`
- `CORS_ALLOWED_ORIGINS=https://yourdomain.com`

### Step 4: Create Upload Directories (1 min)
```bash
sudo mkdir -p /var/app/uploads
sudo mkdir -p /var/log/user-service
sudo mkdir -p /var/log/submission-service
sudo chown -R $USER:$USER /var/app /var/log/user-service /var/log/submission-service
```

### Step 5: Build User Service (2 min)
```bash
cd backend/user-service
mvn clean package -DskipTests
```

### Step 6: Build Submission Service (2 min)
```bash
cd ../submission-service
mvn clean package -DskipTests
```

### Step 7: Setup SSL (Optional - 5 min)
```bash
# For Let's Encrypt
sudo certbot certonly --standalone -d yourdomain.com

# OR for testing
keytool -genkeypair -alias tomcat -keyalg RSA -keysize 2048 \
  -storetype PKCS12 -keystore keystore.p12 -validity 365
```

### Step 8: Start User Service (1 min)
```bash
cd backend/user-service

java -jar \
  -Dspring.profiles.active=prod \
  -DJWT_SECRET="<your-jwt-secret>" \
  -DDB_URL="jdbc:mysql://localhost:3306/user_service_db?useSSL=true" \
  -DDB_USERNAME="user_service_user" \
  -DDB_PASSWORD="<your-password>" \
  -DCORS_ALLOWED_ORIGINS="https://yourdomain.com" \
  target/user-service-1.0.0.jar > /var/log/user-service/app.log 2>&1 &

echo "User Service started on port 8081"
```

### Step 9: Start Submission Service (1 min)
```bash
cd ../submission-service

java -jar \
  -Dspring.profiles.active=prod \
  -DJWT_SECRET="<your-jwt-secret>" \
  -DDB_URL="jdbc:mysql://localhost:3306/submission_service_db?useSSL=true" \
  -DDB_USERNAME="submission_service_user" \
  -DDB_PASSWORD="<your-password>" \
  -DCORS_ALLOWED_ORIGINS="https://yourdomain.com" \
  -DUSER_SERVICE_URL="http://localhost:8081" \
  target/submission-service-1.0.0.jar > /var/log/submission-service/app.log 2>&1 &

echo "Submission Service started on port 8082"
```

### Step 10: Verify Deployment (1 min)
```bash
# Check User Service
curl http://localhost:8081/actuator/health
# Should return: {"status":"UP"}

# Check Submission Service
curl http://localhost:8082/actuator/health
# Should return: {"status":"UP"}
```

---

## ✅ VERIFICATION CHECKLIST

After deployment, verify:

- [ ] User Service responds on port 8081
- [ ] Submission Service responds on port 8082
- [ ] Health endpoints return "UP"
- [ ] Can register a new student
- [ ] Can register a new faculty
- [ ] Can login and receive JWT token
- [ ] JWT token works across services
- [ ] Can create a project (faculty)
- [ ] Can create an assignment (faculty)
- [ ] Can submit assignment (student)
- [ ] Can upload files
- [ ] Can grade submission (faculty)
- [ ] H2 console is NOT accessible
- [ ] Logs are being written
- [ ] Database connections work
- [ ] CORS only allows configured origins

---

## 🔥 COMMON ISSUES & FIXES

### Issue: "Cannot connect to database"
```bash
# Check MySQL is running
sudo systemctl status mysql

# Check database exists
mysql -u root -p -e "SHOW DATABASES;"

# Check user privileges
mysql -u root -p -e "SHOW GRANTS FOR 'user_service_user'@'localhost';"
```

### Issue: "JWT signature does not match"
```bash
# Ensure SAME JWT_SECRET for both services
# Check environment variable is set correctly
echo $JWT_SECRET
```

### Issue: "File upload directory not found"
```bash
# Create directory
sudo mkdir -p /var/app/uploads
sudo chown -R $USER:$USER /var/app
```

### Issue: "Port already in use"
```bash
# Check what's using the port
netstat -tlnp | grep 8081

# Kill process
kill -9 <PID>
```

### Issue: "Access denied for user"
```bash
# Reset database password
mysql -u root -p
ALTER USER 'user_service_user'@'localhost' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
```

---

## 🛠️ USEFUL COMMANDS

### Check Service Status
```bash
# Check if services are running
ps aux | grep java

# Check logs
tail -f /var/log/user-service/app.log
tail -f /var/log/submission-service/app.log
```

### Stop Services
```bash
# Find process ID
ps aux | grep user-service
ps aux | grep submission-service

# Kill gracefully
kill <PID>

# Force kill if needed
kill -9 <PID>
```

### Restart Services
```bash
# Stop
kill <PID>

# Wait a moment
sleep 5

# Start again (use commands from Step 8 & 9)
```

### View Metrics
```bash
# Health
curl http://localhost:8081/actuator/health

# Metrics
curl http://localhost:8081/actuator/metrics

# Info
curl http://localhost:8081/actuator/info
```

### Database Backup
```bash
# Backup user service database
mysqldump -u root -p user_service_db > backup_user_$(date +%Y%m%d).sql

# Backup submission service database
mysqldump -u root -p submission_service_db > backup_submission_$(date +%Y%m%d).sql

# Backup uploaded files
tar -czf uploads_backup_$(date +%Y%m%d).tar.gz /var/app/uploads
```

---

## 📊 MONITORING

### Log Locations
- User Service: `/var/log/user-service/app.log`
- Submission Service: `/var/log/submission-service/app.log`
- MySQL: `/var/log/mysql/error.log`

### Important Endpoints
- User Service Health: `http://localhost:8081/actuator/health`
- Submission Service Health: `http://localhost:8082/actuator/health`
- User Service Metrics: `http://localhost:8081/actuator/metrics`
- Submission Service Metrics: `http://localhost:8082/actuator/metrics`

### Watch Logs in Real-Time
```bash
# Both services
tail -f /var/log/user-service/app.log /var/log/submission-service/app.log

# Errors only
tail -f /var/log/user-service/app.log | grep ERROR
```

---

## 🔒 SECURITY REMINDERS

### ⚠️ NEVER DO THIS IN PRODUCTION:
- ❌ Use the development JWT secret
- ❌ Enable H2 console
- ❌ Use DEBUG logging
- ❌ Expose stack traces
- ❌ Allow unrestricted CORS
- ❌ Use weak passwords
- ❌ Commit .env file to git
- ❌ Run as root user
- ❌ Skip SSL/TLS
- ❌ Use default credentials

### ✅ ALWAYS DO THIS:
- ✅ Use environment variables for secrets
- ✅ Generate unique JWT secret
- ✅ Use strong database passwords
- ✅ Enable HTTPS/SSL
- ✅ Restrict CORS to your domain
- ✅ Keep dependencies updated
- ✅ Monitor logs regularly
- ✅ Backup data daily
- ✅ Use production profile
- ✅ Test before deploying

---

## 📞 EMERGENCY CONTACTS

### If Something Goes Wrong:

1. **Check logs immediately**
   ```bash
   tail -100 /var/log/user-service/app.log
   tail -100 /var/log/submission-service/app.log
   ```

2. **Check service status**
   ```bash
   curl http://localhost:8081/actuator/health
   curl http://localhost:8082/actuator/health
   ```

3. **Restart services if needed**
   ```bash
   # Stop and restart (see commands above)
   ```

4. **Check database**
   ```bash
   mysql -u root -p -e "SHOW PROCESSLIST;"
   ```

5. **Review security guide**
   ```bash
   cat backend/SECURITY_DEPLOYMENT_GUIDE.md
   ```

---

## 📚 FULL DOCUMENTATION

For detailed information, see:
- `backend/SECURITY_DEPLOYMENT_GUIDE.md` - Complete security guide
- `backend/PRODUCTION_TESTING_CHECKLIST.md` - Testing procedures
- `backend/SECURITY_AUDIT_REPORT.md` - Security audit
- `backend/PRODUCTION_READINESS_SUMMARY.md` - Complete summary

---

## ✅ SUCCESS!

If all checks pass, your system is:
- ✅ Secure
- ✅ Running
- ✅ Production-ready
- ✅ Monitored

**Congratulations! You're live!** 🎉

---

**Need Help?**
Review the comprehensive guides in the `backend/` directory.

**Last Updated**: October 26, 2025
