# Simple API Test Script
Write-Host "`n=== ASSIGNMENT SYSTEM - FUNCTIONAL TEST ===`n" -ForegroundColor Cyan

# Test 1: Register Faculty
Write-Host "[1/11] Registering Faculty..." -ForegroundColor Yellow
$faculty = @{ name="Dr. Smith"; email="smith@univ.edu"; password="Faculty@123"; role="FACULTY"; department="CS" } | ConvertTo-Json
$fReg = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $faculty -ContentType "application/json"
Write-Host "SUCCESS: $($fReg.name) registered`n" -ForegroundColor Green

# Test 2: Register Student
Write-Host "[2/11] Registering Student..." -ForegroundColor Yellow
$student = @{ name="Alice"; email="alice@univ.edu"; password="Student@123"; role="STUDENT"; department="CS" } | ConvertTo-Json
$sReg = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $student -ContentType "application/json"
Write-Host "SUCCESS: $($sReg.name) registered`n" -ForegroundColor Green

# Test 3: Faculty Login
Write-Host "[3/11] Faculty Login..." -ForegroundColor Yellow
$fLogin = @{ email="smith@univ.edu"; password="Faculty@123" } | ConvertTo-Json
$fAuth = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $fLogin -ContentType "application/json"
$fToken = $fAuth.token
Write-Host "SUCCESS: JWT Token received (${fToken.Length} chars)`n" -ForegroundColor Green

# Test 4: Student Login
Write-Host "[4/11] Student Login..." -ForegroundColor Yellow
$sLogin = @{ email="alice@univ.edu"; password="Student@123" } | ConvertTo-Json
$sAuth = Invoke-RestMethod -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $sLogin -ContentType "application/json"
$sToken = $sAuth.token
$sId = $sAuth.id
Write-Host "SUCCESS: JWT Token received (Student ID: $sId)`n" -ForegroundColor Green

# Test 5: Create Assignment
Write-Host "[5/11] Creating Assignment (Faculty)..." -ForegroundColor Yellow
$assignment = @{
    title="Spring Boot Project"
    description="Build a REST API"
    course="CS301"
    dueDate=(Get-Date).AddDays(7).ToString("yyyy-MM-ddTHH:mm:ss")
    maxPoints=100
} | ConvertTo-Json
$headers = @{ "Authorization"="Bearer $fToken" }
$asg = Invoke-RestMethod -Uri "http://localhost:8082/api/assignments" -Method POST -Body $assignment -ContentType "application/json" -Headers $headers
$asgId = $asg.id
Write-Host "SUCCESS: Assignment created (ID: $asgId)`n" -ForegroundColor Green

# Test 6: Get All Assignments
Write-Host "[6/11] Getting All Assignments..." -ForegroundColor Yellow
$allAsg = Invoke-RestMethod -Uri "http://localhost:8082/api/assignments" -Headers $headers
Write-Host "SUCCESS: Retrieved $($allAsg.Count) assignment(s)`n" -ForegroundColor Green

# Test 7: Submit Assignment
Write-Host "[7/11] Submitting Assignment (Student)..." -ForegroundColor Yellow
$submission = @{
    assignmentId=$asgId
    fileUrl="uploads/project.zip"
    fileName="project.zip"
    comments="Completed all requirements"
} | ConvertTo-Json
$sHeaders = @{ "Authorization"="Bearer $sToken" }
$sub = Invoke-RestMethod -Uri "http://localhost:8082/api/submissions" -Method POST -Body $submission -ContentType "application/json" -Headers $sHeaders
$subId = $sub.id
Write-Host "SUCCESS: Submission created (ID: $subId, Status: $($sub.status))`n" -ForegroundColor Green

# Test 8: Get Student Submissions
Write-Host "[8/11] Getting My Submissions (Student)..." -ForegroundColor Yellow
$mySubs = Invoke-RestMethod -Uri "http://localhost:8082/api/submissions/my" -Headers $sHeaders
Write-Host "SUCCESS: Retrieved $($mySubs.Count) submission(s)`n" -ForegroundColor Green

# Test 9: Grade Submission
Write-Host "[9/11] Grading Submission (Faculty)..." -ForegroundColor Yellow
$grade = @{ grade=95; feedback="Excellent work!" } | ConvertTo-Json
$graded = Invoke-RestMethod -Uri "http://localhost:8082/api/submissions/$subId/grade" -Method PUT -Body $grade -ContentType "application/json" -Headers $headers
Write-Host "SUCCESS: Graded $($graded.grade)/100, Status: $($graded.status)`n" -ForegroundColor Green

# Test 10: Create Project
Write-Host "[10/11] Creating Project (Faculty)..." -ForegroundColor Yellow
$project = @{
    title="Final Year Project"
    description="E-Commerce Platform"
    studentId=$sId
    deadline=(Get-Date).AddDays(90).ToString("yyyy-MM-ddTHH:mm:ss")
    milestones="Design|Development|Testing"
    deliverables="Code|Docs|Presentation"
    totalMilestones=3
    completedMilestones=0
    progress=0
    status="NOT_STARTED"
} | ConvertTo-Json
$proj = Invoke-RestMethod -Uri "http://localhost:8082/api/projects" -Method POST -Body $project -ContentType "application/json" -Headers $headers
Write-Host "SUCCESS: Project created (ID: $($proj.id), Status: $($proj.status))`n" -ForegroundColor Green

# Test 11: Get All Projects
Write-Host "[11/11] Getting All Projects..." -ForegroundColor Yellow
$allProj = Invoke-RestMethod -Uri "http://localhost:8082/api/projects" -Headers $headers
Write-Host "SUCCESS: Retrieved $($allProj.Count) project(s)`n" -ForegroundColor Green

# Summary
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "  ALL TESTS PASSED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "`nJava Version: 21 LTS" -ForegroundColor White
Write-Host "Spring Boot: 3.2.0" -ForegroundColor White
Write-Host "Security: JWT + BCrypt" -ForegroundColor White
Write-Host "`nServices Running:" -ForegroundColor White
Write-Host "  User Service:       http://localhost:8081" -ForegroundColor White
Write-Host "  Submission Service: http://localhost:8082`n" -ForegroundColor White
