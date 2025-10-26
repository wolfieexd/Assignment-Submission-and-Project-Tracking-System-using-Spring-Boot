# ============================================
# Comprehensive API Testing Script
# Tests all endpoints for User & Submission Services
# ============================================

Write-Host "`n" -NoNewline
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  🧪 COMPREHENSIVE API TESTING - ASSIGNMENT SUBMISSION SYSTEM   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "`n"

# Test counters
$script:totalTests = 0
$script:passedTests = 0
$script:failedTests = 0

# Global variables for storing data
$script:facultyToken = $null
$script:studentToken = $null
$script:assignmentId = $null
$script:submissionId = $null

function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Method,
        [string]$Url,
        [string]$Body = $null,
        [hashtable]$Headers = @{},
        [string]$ExpectedStatus = "200"
    )
    
    $script:totalTests++
    
    Write-Host "`n[$script:totalTests] Testing: " -NoNewline -ForegroundColor Yellow
    Write-Host "$Name" -ForegroundColor White
    Write-Host "    Method: $Method" -ForegroundColor Gray
    Write-Host "    URL: $Url" -ForegroundColor Gray
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            ContentType = "application/json"
            Headers = $Headers
        }
        
        if ($Body) {
            $params.Body = $Body
            Write-Host "    Body: $($Body.Substring(0, [Math]::Min(100, $Body.Length)))..." -ForegroundColor Gray
        }
        
        $response = Invoke-WebRequest @params -UseBasicParsing
        
        if ($response.StatusCode -eq $ExpectedStatus) {
            Write-Host "    ✅ PASS - Status: $($response.StatusCode)" -ForegroundColor Green
            $script:passedTests++
            
            # Parse and display response
            try {
                $jsonResponse = $response.Content | ConvertFrom-Json
                Write-Host "    Response: " -NoNewline -ForegroundColor Gray
                Write-Host ($jsonResponse | ConvertTo-Json -Compress) -ForegroundColor DarkGray
                return $jsonResponse
            } catch {
                Write-Host "    Response: $($response.Content)" -ForegroundColor DarkGray
                return $response.Content
            }
        } else {
            Write-Host "    ❌ FAIL - Expected: $ExpectedStatus, Got: $($response.StatusCode)" -ForegroundColor Red
            $script:failedTests++
            return $null
        }
        
    } catch {
        Write-Host "    ❌ FAIL - Error: $($_.Exception.Message)" -ForegroundColor Red
        $script:failedTests++
        return $null
    }
}

# ============================================
# TEST SUITE 1: USER SERVICE HEALTH CHECK
# ============================================
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  TEST SUITE 1: Service Health Checks" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

Test-Endpoint -Name "User Service Health" -Method "GET" -Url "http://localhost:8081/actuator/health"
Test-Endpoint -Name "Submission Service Health" -Method "GET" -Url "http://localhost:8082/actuator/health"

# ============================================
# TEST SUITE 2: USER REGISTRATION
# ============================================
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  TEST SUITE 2: User Registration" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

$facultyData = @{
    name = "Dr. John Smith"
    email = "john.smith@university.edu"
    password = "Faculty@123"
    role = "FACULTY"
    department = "Computer Science"
} | ConvertTo-Json

$studentData = @{
    name = "Alice Johnson"
    email = "alice.johnson@student.edu"
    password = "Student@123"
    role = "STUDENT"
    department = "Computer Science"
} | ConvertTo-Json

$facultyReg = Test-Endpoint -Name "Register Faculty" -Method "POST" -Url "http://localhost:8081/api/auth/register" -Body $facultyData
$studentReg = Test-Endpoint -Name "Register Student" -Method "POST" -Url "http://localhost:8081/api/auth/register" -Body $studentData

# ============================================
# TEST SUITE 3: USER LOGIN & JWT TOKENS
# ============================================
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  TEST SUITE 3: User Authentication (JWT)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

$facultyLogin = @{
    email = "john.smith@university.edu"
    password = "Faculty@123"
} | ConvertTo-Json

$studentLogin = @{
    email = "alice.johnson@student.edu"
    password = "Student@123"
} | ConvertTo-Json

$facultyAuth = Test-Endpoint -Name "Faculty Login" -Method "POST" -Url "http://localhost:8081/api/auth/login" -Body $facultyLogin
$studentAuth = Test-Endpoint -Name "Student Login" -Method "POST" -Url "http://localhost:8081/api/auth/login" -Body $studentLogin

if ($facultyAuth -and $facultyAuth.token) {
    $script:facultyToken = $facultyAuth.token
    Write-Host "`n    🔑 Faculty JWT Token: $($script:facultyToken.Substring(0, 50))..." -ForegroundColor Magenta
}

if ($studentAuth -and $studentAuth.token) {
    $script:studentToken = $studentAuth.token
    Write-Host "    🔑 Student JWT Token: $($script:studentToken.Substring(0, 50))..." -ForegroundColor Magenta
}
}

# ============================================
# TEST SUITE 4: ASSIGNMENT MANAGEMENT
# ============================================
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  TEST SUITE 4: Assignment Management (Faculty Only)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

if ($script:facultyToken) {
    $assignmentData = @{
        title = "Data Structures Assignment 1"
        description = "Implement Binary Search Tree with insert, delete, and search operations"
        course = "CS201 - Data Structures"
        dueDate = (Get-Date).AddDays(7).ToString("yyyy-MM-ddTHH:mm:ss")
        maxPoints = 100
    } | ConvertTo-Json
    
    $headers = @{ "Authorization" = "Bearer $script:facultyToken" }
    
    $assignment = Test-Endpoint -Name "Create Assignment" -Method "POST" -Url "http://localhost:8082/api/assignments" -Body $assignmentData -Headers $headers
    
    if ($assignment -and $assignment.id) {
        $script:assignmentId = $assignment.id
        Write-Host "`n    📝 Assignment ID: $script:assignmentId" -ForegroundColor Magenta
        
        # Get all assignments
        Test-Endpoint -Name "Get All Assignments" -Method "GET" -Url "http://localhost:8082/api/assignments" -Headers $headers
        
        # Get specific assignment
        Test-Endpoint -Name "Get Assignment by ID" -Method "GET" -Url "http://localhost:8082/api/assignments/$script:assignmentId" -Headers $headers
    }
} else {
    Write-Host "    ⚠️  Skipping - No faculty token available" -ForegroundColor Yellow
}

# ============================================
# TEST SUITE 5: STUDENT SUBMISSIONS
# ============================================
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  TEST SUITE 5: Assignment Submissions (Student)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

if ($script:studentToken -and $script:assignmentId) {
    # Create a sample submission file
    $submissionDir = "D:\Projects\Assignment SpringBoot\backend\submission-service\uploads"
    if (-not (Test-Path $submissionDir)) {
        New-Item -ItemType Directory -Path $submissionDir -Force | Out-Null
    }
    
    $testFile = "$submissionDir\test-submission.txt"
    "This is a test submission for the assignment." | Out-File -FilePath $testFile -Encoding UTF8
    
    $submissionData = @{
        assignmentId = $script:assignmentId
        fileUrl = "uploads/test-submission.txt"
        fileName = "test-submission.txt"
        comments = "Completed all required operations. Tested with JUnit."
    } | ConvertTo-Json
    
    $headers = @{ "Authorization" = "Bearer $script:studentToken" }
    
    $submission = Test-Endpoint -Name "Submit Assignment" -Method "POST" -Url "http://localhost:8082/api/submissions" -Body $submissionData -Headers $headers
    
    if ($submission -and $submission.id) {
        $script:submissionId = $submission.id
        Write-Host "`n    📤 Submission ID: $script:submissionId" -ForegroundColor Magenta
        
        # Get student's submissions
        Test-Endpoint -Name "Get My Submissions" -Method "GET" -Url "http://localhost:8082/api/submissions/my" -Headers $headers
    }
} else {
    Write-Host "    ⚠️  Skipping - No student token or assignment ID available" -ForegroundColor Yellow
}

# ============================================
# TEST SUITE 6: GRADING (FACULTY)
# ============================================
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  TEST SUITE 6: Grading Submissions (Faculty)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

if ($script:facultyToken -and $script:submissionId) {
    $gradeData = @{
        grade = 95
        feedback = "Excellent work! All test cases passed. Code is well-structured and documented."
    } | ConvertTo-Json
    
    $headers = @{ "Authorization" = "Bearer $script:facultyToken" }
    
    Test-Endpoint -Name "Grade Submission" -Method "PUT" -Url "http://localhost:8082/api/submissions/$script:submissionId/grade" -Body $gradeData -Headers $headers
    
    # Get submissions for grading
    if ($script:assignmentId) {
        Test-Endpoint -Name "Get Submissions for Assignment" -Method "GET" -Url "http://localhost:8082/api/submissions/assignment/$script:assignmentId" -Headers $headers
    }
} else {
    Write-Host "    ⚠️  Skipping - No faculty token or submission ID available" -ForegroundColor Yellow
}

# ============================================
# TEST SUITE 7: PROJECT MANAGEMENT
# ============================================
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  TEST SUITE 7: Project Management" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

if ($script:facultyToken -and $studentAuth -and $studentAuth.id) {
    $projectData = @{
        title = "E-Commerce Website Development"
        description = "Build a full-stack e-commerce application with authentication, payment gateway, and admin panel"
        studentId = $studentAuth.id
        deadline = (Get-Date).AddDays(30).ToString("yyyy-MM-ddTHH:mm:ss")
        milestones = "Phase 1: Database Design|Phase 2: Backend API|Phase 3: Frontend|Phase 4: Testing|Phase 5: Deployment"
        deliverables = "Source Code|Documentation|Test Reports|Deployment Link"
        totalMilestones = 5
        completedMilestones = 0
        progress = 0
        status = "NOT_STARTED"
    } | ConvertTo-Json
    
    $headers = @{ "Authorization" = "Bearer $script:facultyToken" }
    
    $project = Test-Endpoint -Name "Create Project" -Method "POST" -Url "http://localhost:8082/api/projects" -Body $projectData -Headers $headers
    
    if ($project -and $project.id) {
        Write-Host "`n    📋 Project ID: $($project.id)" -ForegroundColor Magenta
        
        # Get all projects
        Test-Endpoint -Name "Get All Projects" -Method "GET" -Url "http://localhost:8082/api/projects" -Headers $headers
    }
} else {
    Write-Host "    ⚠️  Skipping - No faculty token or student ID available" -ForegroundColor Yellow
}

# ============================================
# FINAL SUMMARY
# ============================================
Write-Host "`n"
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                       TEST SUMMARY                             ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "`n"

Write-Host "  Total Tests:  " -NoNewline
Write-Host "$script:totalTests" -ForegroundColor White
Write-Host "  Passed:       " -NoNewline
Write-Host "$script:passedTests" -ForegroundColor Green
Write-Host "  Failed:       " -NoNewline
Write-Host "$script:failedTests" -ForegroundColor Red

$successRate = [math]::Round(($script:passedTests / $script:totalTests) * 100, 2)
Write-Host "`n  Success Rate: " -NoNewline
if ($successRate -ge 90) {
    Write-Host "$successRate%" -ForegroundColor Green
} elseif ($successRate -ge 70) {
    Write-Host "$successRate%" -ForegroundColor Yellow
} else {
    Write-Host "$successRate%" -ForegroundColor Red
}

Write-Host "`n"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Display service info
Write-Host "📌 SERVICE ENDPOINTS:" -ForegroundColor Cyan
Write-Host "   User Service:       http://localhost:8081" -ForegroundColor White
Write-Host "   Submission Service: http://localhost:8082" -ForegroundColor White
Write-Host "   H2 Console (User):  http://localhost:8081/h2-console" -ForegroundColor White
Write-Host "   H2 Console (Sub):   http://localhost:8082/h2-console" -ForegroundColor White

Write-Host "`n🔐 TEST CREDENTIALS:" -ForegroundColor Cyan
Write-Host "   Faculty:  john.smith@university.edu / Faculty@123" -ForegroundColor White
Write-Host "   Student:  alice.johnson@student.edu / Student@123" -ForegroundColor White

Write-Host "`n✅ Java Version: 21 LTS (OpenJDK Temurin-21.0.6+7)" -ForegroundColor Green
Write-Host "✅ Spring Boot: 3.2.0" -ForegroundColor Green
Write-Host "✅ Security: JWT + BCrypt" -ForegroundColor Green

Write-Host "`n"
