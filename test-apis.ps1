# ============================================
# API Testing Script for Assignment Submission System
# ============================================

Write-Host "`n╔════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  🧪 API Testing - Assignment System           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Test 1: Health Checks
Write-Host "━━━ TEST 1: Health Checks ━━━" -ForegroundColor Yellow
try {
    $userHealth = Invoke-RestMethod -Uri "http://localhost:8081/actuator/health" -Method GET
    Write-Host "✅ User Service: $($userHealth.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ User Service: FAILED - $($_.Exception.Message)" -ForegroundColor Red
}

try {
    $submissionHealth = Invoke-RestMethod -Uri "http://localhost:8082/actuator/health" -Method GET
    Write-Host "✅ Submission Service: $($submissionHealth.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ Submission Service: FAILED - $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Register Faculty
Write-Host "`n━━━ TEST 2: Register Faculty ━━━" -ForegroundColor Yellow
$facultyData = @{
    name = "Dr. John Smith"
    email = "john.smith@university.edu"
    password = "Faculty@123"
    role = "FACULTY"
    department = "Computer Science"
} | ConvertTo-Json

try {
    $facultyReg = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $facultyData -ContentType "application/json"
    Write-Host "✅ Faculty Registered: $($facultyReg.name)" -ForegroundColor Green
} catch {
    Write-Host "❌ Faculty Registration FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Register Student
Write-Host "`n━━━ TEST 3: Register Student ━━━" -ForegroundColor Yellow
$studentData = @{
    name = "Alice Johnson"
    email = "alice.johnson@student.edu"
    password = "Student@123"
    role = "STUDENT"
    department = "Computer Science"
} | ConvertTo-Json

try {
    $studentReg = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $studentData -ContentType "application/json"
    Write-Host "✅ Student Registered: $($studentReg.name)" -ForegroundColor Green
} catch {
    Write-Host "❌ Student Registration FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Faculty Login
Write-Host "`n━━━ TEST 4: Faculty Login (JWT Auth) ━━━" -ForegroundColor Yellow
$facultyLogin = @{
    email = "john.smith@university.edu"
    password = "Faculty@123"
} | ConvertTo-Json

try {
    $facultyAuth = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $facultyLogin -ContentType "application/json"
    $facultyToken = $facultyAuth.token
    Write-Host "✅ Faculty Login SUCCESS" -ForegroundColor Green
    Write-Host "   Token: $($facultyToken.Substring(0, 50))..." -ForegroundColor DarkGray
} catch {
    Write-Host "❌ Faculty Login FAILED: $($_.Exception.Message)" -ForegroundColor Red
    $facultyToken = $null
}

# Test 5: Student Login
Write-Host "`n━━━ TEST 5: Student Login (JWT Auth) ━━━" -ForegroundColor Yellow
$studentLogin = @{
    email = "alice.johnson@student.edu"
    password = "Student@123"
} | ConvertTo-Json

try {
    $studentAuth = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $studentLogin -ContentType "application/json"
    $studentToken = $studentAuth.token
    $studentId = $studentAuth.id
    Write-Host "✅ Student Login SUCCESS" -ForegroundColor Green
    Write-Host "   Token: $($studentToken.Substring(0, 50))..." -ForegroundColor DarkGray
    Write-Host "   Student ID: $studentId" -ForegroundColor DarkGray
} catch {
    Write-Host "❌ Student Login FAILED: $($_.Exception.Message)" -ForegroundColor Red
    $studentToken = $null
}

# Test 6: Create Assignment (Faculty)
Write-Host "`n━━━ TEST 6: Create Assignment (Faculty Only) ━━━" -ForegroundColor Yellow
if ($facultyToken) {
    $assignmentData = @{
        title = "Data Structures Assignment 1"
        description = "Implement Binary Search Tree with insert, delete, and search operations"
        course = "CS201 - Data Structures"
        dueDate = (Get-Date).AddDays(7).ToString("yyyy-MM-ddTHH:mm:ss")
        maxPoints = 100
    } | ConvertTo-Json
    
    $headers = @{ "Authorization" = "Bearer $facultyToken" }
    
    try {
        $assignment = Invoke-RestMethod -Uri "http://localhost:8082/api/assignments" -Method POST -Body $assignmentData -ContentType "application/json" -Headers $headers
        $assignmentId = $assignment.id
        Write-Host "✅ Assignment Created: $($assignment.title)" -ForegroundColor Green
        Write-Host "   Assignment ID: $assignmentId" -ForegroundColor DarkGray
    } catch {
        Write-Host "❌ Create Assignment FAILED: $($_.Exception.Message)" -ForegroundColor Red
        $assignmentId = $null
    }
} else {
    Write-Host "⚠️  Skipped - No faculty token" -ForegroundColor Yellow
}

# Test 7: Get All Assignments
Write-Host "`n━━━ TEST 7: Get All Assignments ━━━" -ForegroundColor Yellow
if ($facultyToken) {
    $headers = @{ "Authorization" = "Bearer $facultyToken" }
    try {
        $assignments = Invoke-RestMethod -Uri "http://localhost:8082/api/assignments" -Method GET -Headers $headers
        Write-Host "✅ Retrieved $($assignments.Count) assignment(s)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Get Assignments FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  Skipped - No faculty token" -ForegroundColor Yellow
}

# Test 8: Submit Assignment (Student)
Write-Host "`n━━━ TEST 8: Submit Assignment (Student) ━━━" -ForegroundColor Yellow
if ($studentToken -and $assignmentId) {
    # Create test submission file
    $submissionDir = "D:\Projects\Assignment SpringBoot\backend\submission-service\uploads"
    if (-not (Test-Path $submissionDir)) {
        New-Item -ItemType Directory -Path $submissionDir -Force | Out-Null
    }
    
    $testFile = "$submissionDir\test-submission.txt"
    "This is a test submission for the assignment. All operations implemented successfully." | Out-File -FilePath $testFile -Encoding UTF8
    
    $submissionData = @{
        assignmentId = $assignmentId
        fileUrl = "uploads/test-submission.txt"
        fileName = "test-submission.txt"
        comments = "Completed all required operations. Tested with JUnit."
    } | ConvertTo-Json
    
    $headers = @{ "Authorization" = "Bearer $studentToken" }
    
    try {
        $submission = Invoke-RestMethod -Uri "http://localhost:8082/api/submissions" -Method POST -Body $submissionData -ContentType "application/json" -Headers $headers
        $submissionId = $submission.id
        Write-Host "✅ Assignment Submitted" -ForegroundColor Green
        Write-Host "   Submission ID: $submissionId" -ForegroundColor DarkGray
        Write-Host "   Status: $($submission.status)" -ForegroundColor DarkGray
    } catch {
        Write-Host "❌ Submit Assignment FAILED: $($_.Exception.Message)" -ForegroundColor Red
        $submissionId = $null
    }
} else {
    Write-Host "⚠️  Skipped - No student token or assignment ID" -ForegroundColor Yellow
}

# Test 9: Get Student's Submissions
Write-Host "`n━━━ TEST 9: Get My Submissions (Student) ━━━" -ForegroundColor Yellow
if ($studentToken) {
    $headers = @{ "Authorization" = "Bearer $studentToken" }
    try {
        $mySubmissions = Invoke-RestMethod -Uri "http://localhost:8082/api/submissions/my" -Method GET -Headers $headers
        Write-Host "✅ Retrieved $($mySubmissions.Count) submission(s)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Get My Submissions FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  Skipped - No student token" -ForegroundColor Yellow
}

# Test 10: Grade Submission (Faculty)
Write-Host "`n━━━ TEST 10: Grade Submission (Faculty Only) ━━━" -ForegroundColor Yellow
if ($facultyToken -and $submissionId) {
    $gradeData = @{
        grade = 95
        feedback = "Excellent work! All test cases passed. Code is well-structured and documented."
    } | ConvertTo-Json
    
    $headers = @{ "Authorization" = "Bearer $facultyToken" }
    
    try {
        $gradedSubmission = Invoke-RestMethod -Uri "http://localhost:8082/api/submissions/$submissionId/grade" -Method PUT -Body $gradeData -ContentType "application/json" -Headers $headers
        Write-Host "✅ Submission Graded" -ForegroundColor Green
        Write-Host "   Grade: $($gradedSubmission.grade)/$($gradedSubmission.assignment.maxPoints)" -ForegroundColor DarkGray
        Write-Host "   Status: $($gradedSubmission.status)" -ForegroundColor DarkGray
    } catch {
        Write-Host "❌ Grade Submission FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  Skipped - No faculty token or submission ID" -ForegroundColor Yellow
}

# Test 11: Create Project (Faculty)
Write-Host "`n━━━ TEST 11: Create Project (Faculty) ━━━" -ForegroundColor Yellow
if ($facultyToken -and $studentId) {
    $projectData = @{
        title = "E-Commerce Website Development"
        description = "Build a full-stack e-commerce application with authentication, payment gateway, and admin panel"
        studentId = $studentId
        deadline = (Get-Date).AddDays(30).ToString("yyyy-MM-ddTHH:mm:ss")
        milestones = "Phase 1: Database Design|Phase 2: Backend API|Phase 3: Frontend|Phase 4: Testing|Phase 5: Deployment"
        deliverables = "Source Code|Documentation|Test Reports|Deployment Link"
        totalMilestones = 5
        completedMilestones = 0
        progress = 0
        status = "NOT_STARTED"
    } | ConvertTo-Json
    
    $headers = @{ "Authorization" = "Bearer $facultyToken" }
    
    try {
        $project = Invoke-RestMethod -Uri "http://localhost:8082/api/projects" -Method POST -Body $projectData -ContentType "application/json" -Headers $headers
        Write-Host "✅ Project Created: $($project.title)" -ForegroundColor Green
        Write-Host "   Project ID: $($project.id)" -ForegroundColor DarkGray
        Write-Host "   Status: $($project.status)" -ForegroundColor DarkGray
    } catch {
        Write-Host "❌ Create Project FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  Skipped - No faculty token or student ID" -ForegroundColor Yellow
}

# Final Summary
Write-Host "`n╔════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           ✅ TESTING COMPLETE                  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "📌 Service Endpoints:" -ForegroundColor Cyan
Write-Host "   User Service:       http://localhost:8081" -ForegroundColor White
Write-Host "   Submission Service: http://localhost:8082" -ForegroundColor White

Write-Host "`n🔐 Test Credentials:" -ForegroundColor Cyan
Write-Host "   Faculty: john.smith@university.edu / Faculty@123" -ForegroundColor White
Write-Host "   Student: alice.johnson@student.edu / Student@123" -ForegroundColor White

Write-Host "`n✅ Java Version: 21 LTS" -ForegroundColor Green
Write-Host "✅ Spring Boot: 3.2.0" -ForegroundColor Green
Write-Host "✅ Security: JWT + BCrypt`n" -ForegroundColor Green
