package com.assignment.submissionservice.controller;

import com.assignment.submissionservice.dto.GradeRequest;
import com.assignment.submissionservice.dto.SubmissionRequest;
import com.assignment.submissionservice.entity.Submission;
import com.assignment.submissionservice.service.SubmissionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Submission Controller
 * REST API endpoints for submission management
 */
@RestController
@RequestMapping("/api/submissions")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = "*")
public class SubmissionController {

    private final SubmissionService submissionService;

    @PostMapping
    public ResponseEntity<?> submitAssignment(@Valid @RequestBody SubmissionRequest request) {
        try {
            log.info("Student {} submitting assignment {}", request.getStudentId(), request.getAssignmentId());
            Submission submission = submissionService.submitAssignment(request);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Assignment submitted successfully");
            response.put("submission", submission);
            
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalStateException e) {
            log.error("Submission error: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
        } catch (Exception e) {
            log.error("Error submitting assignment: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to submit assignment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @PutMapping("/{id}/resubmit")
    public ResponseEntity<?> resubmitAssignment(
            @PathVariable Long id,
            @Valid @RequestBody SubmissionRequest request) {
        try {
            log.info("Resubmitting submission {}", id);
            Submission submission = submissionService.resubmitAssignment(id, request);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Assignment resubmitted successfully");
            response.put("submission", submission);
            
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            log.error("Error resubmitting assignment: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    @PutMapping("/{id}/grade")
    public ResponseEntity<?> gradeSubmission(
            @PathVariable Long id,
            @Valid @RequestBody GradeRequest request) {
        try {
            log.info("Grading submission {}", id);
            Submission submission = submissionService.gradeSubmission(id, request);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Submission graded successfully");
            response.put("submission", submission);
            
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            log.error("Error grading submission: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getSubmissionById(@PathVariable Long id) {
        try {
            Submission submission = submissionService.getSubmissionById(id);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("submission", submission);
            
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            log.error("Error fetching submission: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    @GetMapping("/assignment/{assignmentId}")
    public ResponseEntity<?> getSubmissionsByAssignment(@PathVariable Long assignmentId) {
        try {
            List<Submission> submissions = submissionService.getSubmissionsByAssignment(assignmentId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", submissions.size());
            response.put("submissions", submissions);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching submissions: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch submissions");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<?> getSubmissionsByStudent(@PathVariable Long studentId) {
        try {
            List<Submission> submissions = submissionService.getSubmissionsByStudent(studentId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", submissions.size());
            response.put("submissions", submissions);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching submissions: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch submissions");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/assignment/{assignmentId}/student/{studentId}")
    public ResponseEntity<?> getStudentSubmission(
            @PathVariable Long assignmentId,
            @PathVariable Long studentId) {
        try {
            Submission submission = submissionService.getStudentSubmission(assignmentId, studentId);
            
            if (submission == null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "No submission found");
                response.put("submission", null);
                return ResponseEntity.ok(response);
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("submission", submission);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching submission: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch submission");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/assignment/{assignmentId}/count")
    public ResponseEntity<?> countSubmissionsByAssignment(@PathVariable Long assignmentId) {
        try {
            long count = submissionService.countSubmissionsByAssignment(assignmentId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", count);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error counting submissions: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to count submissions");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/health")
    public ResponseEntity<?> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Submission Service");
        response.put("timestamp", LocalDateTime.now());
        return ResponseEntity.ok(response);
    }
}
