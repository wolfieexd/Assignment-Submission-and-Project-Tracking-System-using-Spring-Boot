# Submission Service - Assignment Submission and Project Tracking

A Spring Boot microservice for managing assignments, submissions, and project tracking in an academic environment.

## 📋 Overview

The Submission Service handles:
- **Assignment Management** - Faculty can create, update, and manage assignments
- **Submission Workflow** - Students submit assignments, faculty grades them
- **Project Tracking** - Track project progress with milestones and deliverables
- **File Uploads** - Support for document uploads (PDF, DOC, images, etc.)

## 🚀 Quick Start

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- Running User Service (Port 8081) for authentication

### Running the Service

```bash
# Clone the repository
cd backend/submission-service

# Build the project
mvn clean install

# Run the service
mvn spring-boot:run
```

The service will start on **http://localhost:8082**

## 🔧 Configuration

### application.properties

```properties
# Server Configuration
server.port=8082
spring.application.name=submission-service

# Database Configuration (H2 - Development)
spring.datasource.url=jdbc:h2:mem:submissiondb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

# H2 Console
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# File Upload Configuration
spring.servlet.multipart.enabled=true
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
file.upload.dir=uploads
file.upload.max-size=10485760

# JWT Configuration
jwt.secret=your-secret-key-min-256-bits
jwt.expiration=86400000

# CORS Configuration
cors.allowed.origins=http://localhost:8080,http://localhost:5173,http://localhost:3000,http://192.168.0.105:8080
```

## 📚 API Documentation

### Base URL
```
http://localhost:8082/api
```

---

### 📝 Assignment Endpoints

#### Create Assignment
```http
POST /api/assignments
Content-Type: application/json

{
  "title": "Web Development Project",
  "description": "Build a full-stack web application",
  "course": "CS101",
  "facultyId": 1,
  "facultyName": "Dr. Smith",
  "dueDate": "2025-12-31T23:59:59",
  "maxPoints": 100,
  "attachmentUrl": "http://example.com/instructions.pdf"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Assignment created successfully",
  "assignment": {
    "id": 1,
    "title": "Web Development Project",
    "course": "CS101",
    "active": true,
    "createdAt": "2025-10-26T00:00:00"
  }
}
```

#### Get All Assignments
```http
GET /api/assignments
```

#### Get Assignment by ID
```http
GET /api/assignments/{id}
```

#### Get Assignments by Faculty
```http
GET /api/assignments/faculty/{facultyId}
```

#### Get Overdue Assignments
```http
GET /api/assignments/overdue
```

#### Get Upcoming Assignments
```http
GET /api/assignments/upcoming?startDate=2025-01-01T00:00:00&endDate=2025-12-31T23:59:59
```

#### Update Assignment
```http
PUT /api/assignments/{id}
Content-Type: application/json

{
  "title": "Updated Title",
  "description": "Updated description",
  "course": "CS101",
  "facultyId": 1,
  "facultyName": "Dr. Smith",
  "dueDate": "2025-12-31T23:59:59",
  "maxPoints": 150
}
```

#### Delete Assignment (Soft Delete)
```http
DELETE /api/assignments/{id}
```

---

### 📤 Submission Endpoints

#### Submit Assignment
```http
POST /api/submissions
Content-Type: application/json

{
  "assignmentId": 1,
  "studentId": 1,
  "studentName": "John Doe",
  "studentEmail": "john@example.com",
  "fileUrl": "/uploads/submissions/20251026_120000_abc123.pdf",
  "fileName": "my-project.pdf",
  "comments": "Completed all requirements"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Assignment submitted successfully",
  "submission": {
    "id": 1,
    "assignmentId": 1,
    "studentId": 1,
    "status": "SUBMITTED",
    "submittedAt": "2025-10-26T12:00:00"
  }
}
```

#### Get Submission by ID
```http
GET /api/submissions/{id}
```

#### Get Submissions by Assignment
```http
GET /api/submissions/assignment/{assignmentId}
```

#### Get Submissions by Student
```http
GET /api/submissions/student/{studentId}
```

#### Get Specific Student Submission
```http
GET /api/submissions/assignment/{assignmentId}/student/{studentId}
```

#### Count Submissions
```http
GET /api/submissions/assignment/{assignmentId}/count
```

#### Resubmit Assignment
```http
PUT /api/submissions/{id}/resubmit
Content-Type: application/json

{
  "assignmentId": 1,
  "studentId": 1,
  "studentName": "John Doe",
  "studentEmail": "john@example.com",
  "fileUrl": "/uploads/submissions/20251027_150000_xyz789.pdf",
  "fileName": "my-project-revised.pdf",
  "comments": "Fixed the issues mentioned in feedback"
}
```

#### Grade Submission
```http
PUT /api/submissions/{id}/grade
Content-Type: application/json

{
  "grade": 95,
  "feedback": "Excellent work! Very well structured code.",
  "status": "GRADED"
}
```

---

### 📊 Project Endpoints

#### Create Project
```http
POST /api/projects
Content-Type: application/json

{
  "title": "E-Commerce Platform",
  "description": "Build a scalable e-commerce system",
  "facultyId": 1,
  "facultyName": "Dr. Smith",
  "studentId": 1,
  "deadline": "2025-12-31T23:59:59",
  "totalMilestones": 5,
  "milestones": "Design, Backend, Frontend, Testing, Deployment",
  "deliverables": "Source code, Documentation, Demo video"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Project created successfully",
  "project": {
    "id": 1,
    "title": "E-Commerce Platform",
    "progress": 0,
    "status": "NOT_STARTED",
    "createdAt": "2025-10-26T00:00:00"
  }
}
```

#### Update Project Progress
```http
PUT /api/projects/{id}/progress?progress=60
```

**Auto-Status Update:**
- `0%` → `NOT_STARTED`
- `1-99%` → `IN_PROGRESS`
- `100%` → `COMPLETED`

#### Update Project Status
```http
PUT /api/projects/{id}/status?status=IN_PROGRESS
```

**Valid Statuses:** `NOT_STARTED`, `IN_PROGRESS`, `COMPLETED`, `ON_HOLD`, `CANCELLED`

#### Get All Projects
```http
GET /api/projects
```

#### Get Project by ID
```http
GET /api/projects/{id}
```

#### Get Projects by Faculty
```http
GET /api/projects/faculty/{facultyId}
```

#### Get Projects by Student
```http
GET /api/projects/student/{studentId}
```

#### Get Projects by Status
```http
GET /api/projects/status/IN_PROGRESS
```

#### Delete Project
```http
DELETE /api/projects/{id}
```

---

## 🗄️ Database Schema

### Tables

#### assignments
| Column | Type | Description |
|--------|------|-------------|
| id | BIGINT | Primary key |
| title | VARCHAR(200) | Assignment title |
| description | TEXT | Detailed description |
| course | VARCHAR(100) | Course code |
| faculty_id | BIGINT | Faculty who created it |
| faculty_name | VARCHAR(100) | Faculty name |
| due_date | TIMESTAMP | Submission deadline |
| max_points | INTEGER | Maximum points |
| active | BOOLEAN | Soft delete flag |
| attachment_url | TEXT | Supporting materials |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update |

#### submissions
| Column | Type | Description |
|--------|------|-------------|
| id | BIGINT | Primary key |
| assignment_id | BIGINT | Reference to assignment |
| student_id | BIGINT | Student who submitted |
| student_name | VARCHAR(100) | Student name |
| student_email | VARCHAR(100) | Student email |
| file_url | TEXT | Submitted file path |
| file_name | VARCHAR(200) | Original filename |
| comments | TEXT | Student comments |
| status | VARCHAR(20) | SUBMITTED/GRADED/REJECTED/RESUBMITTED |
| grade | INTEGER | Points awarded |
| feedback | TEXT | Faculty feedback |
| graded_at | TIMESTAMP | When graded |
| submitted_at | TIMESTAMP | Submission time |
| updated_at | TIMESTAMP | Last update |

#### projects
| Column | Type | Description |
|--------|------|-------------|
| id | BIGINT | Primary key |
| title | VARCHAR(200) | Project title |
| description | TEXT | Project description |
| faculty_id | BIGINT | Supervising faculty |
| faculty_name | VARCHAR(100) | Faculty name |
| student_id | BIGINT | Assigned student |
| student_name | VARCHAR(100) | Student name |
| deadline | TIMESTAMP | Project deadline |
| progress | INTEGER | Completion % (0-100) |
| status | VARCHAR(20) | Current status |
| total_milestones | INTEGER | Total milestones |
| completed_milestones | INTEGER | Completed count |
| milestones | TEXT | Milestone details |
| deliverables | TEXT | Expected outputs |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Last update |

---

## 📁 File Upload

### Supported File Types
- **Documents:** PDF, DOC, DOCX, TXT
- **Archives:** ZIP, RAR
- **Images:** JPG, JPEG, PNG
- **Presentations:** PPT, PPTX

### Size Limits
- **Max file size:** 10MB
- **Max request size:** 10MB

### Upload Directory
- **Default:** `uploads/` (relative to project root)
- **Configurable:** Set `file.upload.dir` in application.properties

### File Naming
Files are automatically renamed with timestamp and unique ID:
```
Format: YYYYMMDD_HHmmss_uniqueid.ext
Example: 20251026_120000_a1b2c3d4.pdf
```

---

## 🔒 Security

### CORS Configuration
Allowed origins:
- `http://localhost:8080`
- `http://localhost:5173`
- `http://localhost:3000`
- `http://192.168.0.105:8080`

### JWT Authentication
- Uses same JWT secret as User Service
- Token validation on protected endpoints
- All `/api/**` endpoints are currently public (for development)

---

## 🧪 Testing

### Run All Tests
```bash
mvn test
```

### Test Coverage
- Service layer tests
- Controller layer tests
- Repository tests
- Integration tests

---

## 🐛 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Find process using port 8082
netstat -ano | findstr :8082

# Kill the process (Windows)
taskkill /PID <process-id> /F
```

#### Database Connection Issues
- Check H2 console: http://localhost:8082/h2-console
- JDBC URL: `jdbc:h2:mem:submissiondb`
- Username: `sa`
- Password: *(leave empty)*

#### File Upload Fails
- Check file size (max 10MB)
- Verify file type is allowed
- Ensure `uploads/` directory exists

---

## 📊 Monitoring

### Actuator Endpoints
- **Health:** http://localhost:8082/actuator/health
- **Info:** http://localhost:8082/actuator/info
- **Metrics:** http://localhost:8082/actuator/metrics

---

## 🔄 Integration with User Service

This service integrates with the User Service (Port 8081) for:
- User authentication (JWT tokens)
- Student/Faculty profile information
- Role-based access control

**User Service URL:** http://localhost:8081

---

## 📦 Dependencies

### Core
- Spring Boot 3.2.0
- Spring Data JPA
- Spring Security
- Spring Web

### Database
- H2 Database (development)
- MySQL Connector (production ready)

### Security
- JWT (JJWT 0.12.3)
- BCrypt password encoding

### File Handling
- Commons FileUpload 1.5
- Commons IO 2.15.1

### Utilities
- Lombok
- Jakarta Validation

---

## 🚀 Production Deployment

### MySQL Configuration
1. Update `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/submissiondb
spring.datasource.username=your_username
spring.datasource.password=your_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
```

2. Build production JAR:
```bash
mvn clean package -DskipTests
```

3. Run:
```bash
java -jar target/submission-service-1.0.0.jar
```

---

## 📈 Future Enhancements

- [ ] Unit tests (15% remaining)
- [ ] Email notifications for deadlines
- [ ] Plagiarism detection
- [ ] Bulk assignment creation
- [ ] Analytics dashboard
- [ ] Cloud storage integration (AWS S3, Azure Blob)
- [ ] WebSocket for real-time updates

---

## 👥 Authors

- **Your Team** - Initial work

---

## 📄 License

This project is licensed under the MIT License.

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📞 Support

For issues and questions:
- Create an issue on GitHub
- Contact: support@example.com

---

**Built with ❤️ using Spring Boot**
