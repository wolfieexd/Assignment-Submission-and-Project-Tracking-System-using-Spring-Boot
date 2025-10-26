package com.assignment.submissionservice.controller;

import com.assignment.submissionservice.dto.AssignmentRequest;
import com.assignment.submissionservice.entity.Assignment;
import com.assignment.submissionservice.service.AssignmentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Assignment Controller
 * REST API endpoints for assignment management
 */
@RestController
@RequestMapping("/api/assignments")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = "*")
public class AssignmentController {

    private final AssignmentService assignmentService;

    @PostMapping
    public ResponseEntity<?> createAssignment(@Valid @RequestBody AssignmentRequest request) {
        try {
            log.info("Creating assignment: {}", request.getTitle());
            Assignment assignment = assignmentService.createAssignment(request);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Assignment created successfully");
            response.put("assignment", assignment);
            
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (Exception e) {
            log.error("Error creating assignment: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to create assignment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateAssignment(
            @PathVariable Long id,
            @Valid @RequestBody AssignmentRequest request) {
        try {
            log.info("Updating assignment: {}", id);
            Assignment assignment = assignmentService.updateAssignment(id, request);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Assignment updated successfully");
            response.put("assignment", assignment);
            
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            log.error("Error updating assignment: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteAssignment(@PathVariable Long id) {
        try {
            log.info("Deleting assignment: {}", id);
            assignmentService.deleteAssignment(id);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Assignment deleted successfully");
            
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            log.error("Error deleting assignment: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    @GetMapping
    public ResponseEntity<?> getAllAssignments() {
        try {
            List<Assignment> assignments = assignmentService.getAllAssignments();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", assignments.size());
            response.put("assignments", assignments);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching assignments: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch assignments");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getAssignmentById(@PathVariable Long id) {
        try {
            Assignment assignment = assignmentService.getAssignmentById(id);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("assignment", assignment);
            
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            log.error("Error fetching assignment: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    @GetMapping("/faculty/{facultyId}")
    public ResponseEntity<?> getAssignmentsByFaculty(@PathVariable Long facultyId) {
        try {
            List<Assignment> assignments = assignmentService.getAssignmentsByFaculty(facultyId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", assignments.size());
            response.put("assignments", assignments);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching assignments for faculty: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch assignments");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/overdue")
    public ResponseEntity<?> getOverdueAssignments() {
        try {
            List<Assignment> assignments = assignmentService.getOverdueAssignments();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", assignments.size());
            response.put("assignments", assignments);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching overdue assignments: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch overdue assignments");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/upcoming")
    public ResponseEntity<?> getUpcomingAssignments(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        try {
            List<Assignment> assignments = assignmentService.getUpcomingAssignments(startDate, endDate);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", assignments.size());
            response.put("assignments", assignments);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching upcoming assignments: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch upcoming assignments");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/health")
    public ResponseEntity<?> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Assignment Service");
        response.put("timestamp", LocalDateTime.now());
        return ResponseEntity.ok(response);
    }
}
