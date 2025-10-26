# Production Security & Deployment Guide

## ⚠️ CRITICAL SECURITY ISSUES FOUND & FIXED

This document outlines the security vulnerabilities found in the project and the fixes applied for production deployment.

---

## 🔴 CRITICAL ISSUES IDENTIFIED

### 1. **Hardcoded JWT Secret**
- **Risk Level**: CRITICAL
- **Issue**: JWT secret is hardcoded in `application.properties`
- **Impact**: Anyone with access to the codebase can forge authentication tokens
- **Fix Applied**: ✅ Created `application-prod.properties` with environment variable references

### 2. **In-Memory H2 Database**
- **Risk Level**: HIGH
- **Issue**: Using H2 in-memory database in production
- **Impact**: Data loss on application restart
- **Fix Applied**: ✅ Production config uses MySQL with persistent storage

### 3. **Debug Logging Enabled**
- **Risk Level**: MEDIUM
- **Issue**: Debug logging exposes sensitive information
- **Impact**: SQL queries and security details logged
- **Fix Applied**: ✅ Production logging set to WARN/INFO level

### 4. **H2 Console Exposed**
- **Risk Level**: CRITICAL
- **Issue**: H2 console accessible without authentication
- **Impact**: Direct database access via web interface
- **Fix Applied**: ✅ H2 console disabled in production config

### 5. **Unrestricted CORS Origins**
- **Risk Level**: HIGH
- **Issue**: CORS allows localhost and development IPs
- **Impact**: Vulnerable to CSRF attacks
- **Fix Applied**: ✅ Production CORS restricted to specific domains via environment variables

### 6. **Detailed Error Messages**
- **Risk Level**: MEDIUM
- **Issue**: Stack traces and error details exposed to clients
- **Impact**: Information disclosure
- **Fix Applied**: ✅ Error details disabled in production

### 7. **No SSL/TLS Configuration**
- **Risk Level**: HIGH
- **Issue**: No HTTPS enforcement
- **Impact**: Man-in-the-middle attacks, credential interception
- **Fix Applied**: ✅ SSL/TLS configuration template provided

### 8. **Weak Session Configuration**
- **Risk Level**: MEDIUM
- **Issue**: Session cookies not secure
- **Impact**: Session hijacking
- **Fix Applied**: ✅ Secure, HttpOnly, SameSite cookies enabled

---

## ✅ SECURITY FEATURES ALREADY IMPLEMENTED

### Password Security
- ✅ BCrypt password hashing with salt
- ✅ Minimum password length validation (6 characters)
- ✅ Password encoding in AuthService

### Input Validation
- ✅ @Valid annotations on all DTOs
- ✅ Bean validation (@NotBlank, @Email, @Size)
- ✅ File upload validation (type, size, extension)

### Authentication & Authorization
- ✅ JWT-based stateless authentication
- ✅ Role-based access control (STUDENT, FACULTY)
- ✅ Token expiration mechanism

### SQL Injection Prevention
- ✅ Spring Data JPA (parameterized queries)
- ✅ No native SQL queries with string concatenation
- ✅ Repository pattern used throughout

### File Upload Security
- ✅ File type whitelist validation
- ✅ File size limits (10MB max)
- ✅ Unique filename generation (prevents path traversal)
- ✅ Safe file storage with timestamps

---

## 🚀 PRODUCTION DEPLOYMENT CHECKLIST

### Before Deployment

#### 1. Database Setup
```sql
-- Create production databases
CREATE DATABASE user_service_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE submission_service_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create dedicated database users with minimal privileges
CREATE USER 'user_service_user'@'localhost' IDENTIFIED BY 'STRONG_PASSWORD_HERE';
CREATE USER 'submission_service_user'@'localhost' IDENTIFIED BY 'STRONG_PASSWORD_HERE';

-- Grant only necessary privileges
GRANT SELECT, INSERT, UPDATE, DELETE ON user_service_db.* TO 'user_service_user'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON submission_service_db.* TO 'submission_service_user'@'localhost';

FLUSH PRIVILEGES;
```

#### 2. Generate Secure JWT Secret
```bash
# Generate a strong 512-bit secret
openssl rand -base64 64

# Or use UUID approach
uuidgen | sha256sum | base64
```

#### 3. Environment Variables Setup
```bash
# Copy the example file
cp backend/.env.example backend/.env

# Edit .env with production values
nano backend/.env
```

**Required Environment Variables:**
- `JWT_SECRET` - Use the generated secret (minimum 256 bits)
- `DB_URL` - MySQL connection string with SSL
- `DB_USERNAME` - Database user (not root!)
- `DB_PASSWORD` - Strong database password
- `CORS_ALLOWED_ORIGINS` - Your production domain(s)

#### 4. SSL/TLS Certificate Setup
```bash
# Generate self-signed certificate for testing (NOT for production)
keytool -genkeypair -alias tomcat -keyalg RSA -keysize 2048 \
  -storetype PKCS12 -keystore keystore.p12 -validity 3650

# For production, use Let's Encrypt or a commercial CA
```

#### 5. Database Migration
```bash
# Run Flyway or Liquibase migrations
# Create initial schema using JPA

# Set hibernate.ddl-auto to 'validate' after initial setup
spring.jpa.hibernate.ddl-auto=validate
```

#### 6. File Upload Directory
```bash
# Create upload directory with proper permissions
sudo mkdir -p /var/app/uploads
sudo chown -R app-user:app-user /var/app/uploads
sudo chmod 750 /var/app/uploads

# Create log directories
sudo mkdir -p /var/log/user-service
sudo mkdir -p /var/log/submission-service
sudo chown -R app-user:app-user /var/log/user-service
sudo chown -R app-user:app-user /var/log/submission-service
```

#### 7. Build Production JARs
```bash
# Navigate to each service
cd backend/user-service
mvn clean package -DskipTests -Pprod

cd ../submission-service
mvn clean package -DskipTests -Pprod
```

#### 8. Run with Production Profile
```bash
# User Service
java -jar -Dspring.profiles.active=prod \
  -DJWT_SECRET=$JWT_SECRET \
  -DDB_URL=$DB_URL_USER \
  -DDB_USERNAME=$DB_USERNAME_USER \
  -DDB_PASSWORD=$DB_PASSWORD_USER \
  user-service/target/user-service-1.0.0.jar

# Submission Service
java -jar -Dspring.profiles.active=prod \
  -DJWT_SECRET=$JWT_SECRET \
  -DDB_URL=$DB_URL_SUBMISSION \
  -DDB_USERNAME=$DB_USERNAME_SUBMISSION \
  -DDB_PASSWORD=$DB_PASSWORD_SUBMISSION \
  submission-service/target/submission-service-1.0.0.jar
```

---

## 🔒 ADDITIONAL SECURITY RECOMMENDATIONS

### 1. Password Policy Enhancement
```java
// Recommendation: Add password strength validation
// Require: uppercase, lowercase, number, special character
@Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$",
         message = "Password must contain at least 8 characters, including uppercase, lowercase, number, and special character")
```

### 2. Rate Limiting
```java
// Recommendation: Add rate limiting to prevent brute force attacks
// Use Spring Security's RateLimiter or implement with Redis
```

### 3. Account Lockout
```java
// Recommendation: Implement account lockout after failed login attempts
// Lock account for 30 minutes after 5 failed attempts
```

### 4. Audit Logging
```java
// Recommendation: Log all authentication attempts, failed logins, and sensitive operations
// Use Spring AOP for audit logging
```

### 5. API Rate Limiting
```
# Use nginx or API Gateway for rate limiting
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
```

### 6. Database Connection Encryption
```properties
# Add to production config
spring.datasource.url=jdbc:mysql://localhost:3306/db?useSSL=true&requireSSL=true
```

### 7. Regular Security Updates
```bash
# Check for dependency vulnerabilities
mvn dependency-check:check

# Update Spring Boot and dependencies regularly
mvn versions:display-dependency-updates
```

### 8. Backup Strategy
```bash
# Automate database backups
0 2 * * * /usr/local/bin/backup-mysql.sh

# Backup uploaded files
0 3 * * * rsync -av /var/app/uploads /backup/uploads/
```

---

## 🔍 MONITORING & HEALTH CHECKS

### Actuator Endpoints (Secured)
- `/actuator/health` - Service health status
- `/actuator/metrics` - Application metrics
- `/actuator/prometheus` - Prometheus metrics

### Recommended Monitoring Tools
- **Prometheus** + **Grafana** for metrics
- **ELK Stack** (Elasticsearch, Logstash, Kibana) for log aggregation
- **Spring Boot Admin** for service monitoring

---

## 🧪 SECURITY TESTING CHECKLIST

Before going to production, perform:

- [ ] Penetration testing
- [ ] SQL injection testing
- [ ] XSS testing
- [ ] CSRF testing
- [ ] Authentication bypass testing
- [ ] Authorization testing
- [ ] File upload vulnerability testing
- [ ] Dependency vulnerability scanning
- [ ] SSL/TLS configuration testing

---

## 📋 POST-DEPLOYMENT VERIFICATION

1. **Verify H2 Console is Disabled**
   ```bash
   curl https://yourdomain.com/h2-console
   # Should return 404 or redirect
   ```

2. **Verify HTTPS Enforcement**
   ```bash
   curl -I http://yourdomain.com
   # Should redirect to https://
   ```

3. **Verify JWT Secret**
   ```bash
   # Check that the old hardcoded secret doesn't work
   # Attempt to create a token with the old secret
   ```

4. **Verify CORS**
   ```bash
   curl -H "Origin: http://malicious-site.com" https://yourdomain.com/api/auth/login
   # Should be blocked
   ```

5. **Test Database Connectivity**
   ```bash
   # Check actuator health endpoint
   curl https://yourdomain.com/actuator/health
   ```

---

## 🚨 INCIDENT RESPONSE

If a security breach is detected:

1. **Immediately rotate JWT secret**
2. **Force logout all users**
3. **Review access logs**
4. **Check for unauthorized database access**
5. **Notify affected users**
6. **Update passwords for compromised accounts**

---

## 📚 COMPLIANCE & BEST PRACTICES

### OWASP Top 10 Coverage
- ✅ A01:2021 - Broken Access Control (JWT + Role-based)
- ✅ A02:2021 - Cryptographic Failures (BCrypt, SSL/TLS)
- ✅ A03:2021 - Injection (JPA parameterized queries)
- ✅ A04:2021 - Insecure Design (Security by design)
- ✅ A05:2021 - Security Misconfiguration (Production configs)
- ✅ A06:2021 - Vulnerable Components (Updated dependencies)
- ✅ A07:2021 - Identification and Authentication Failures (JWT + BCrypt)
- ✅ A08:2021 - Software and Data Integrity Failures (Validation)
- ✅ A09:2021 - Security Logging and Monitoring (Actuator + Logs)
- ✅ A10:2021 - Server-Side Request Forgery (Input validation)

---

## 📞 SUPPORT & MAINTENANCE

For security issues or questions:
- Review Spring Security documentation
- Check OWASP guidelines
- Monitor CVE databases for dependency vulnerabilities
- Subscribe to Spring Boot security mailing list

**Last Updated**: October 26, 2025
**Java Version**: 21 LTS
**Spring Boot Version**: 3.2.0
