package com.assignment.submissionservice.controller;

import com.assignment.submissionservice.dto.ProjectRequest;
import com.assignment.submissionservice.entity.Project;
import com.assignment.submissionservice.entity.Project.ProjectStatus;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.assignment.submissionservice.service.ProjectService;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Project Controller
 * REST API endpoints for project tracking
 */
@RestController
@RequestMapping("/api/projects")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = "*")
public class ProjectController {

    private final ProjectService projectService;

    @PostMapping
    public ResponseEntity<?> createProject(@Valid @RequestBody ProjectRequest request) {
        try {
            log.info("Creating project: {}", request.getTitle());
            Project project = projectService.createProject(request);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Project created successfully");
            response.put("project", project);
            
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (Exception e) {
            log.error("Error creating project: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to create project: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @PutMapping("/{id}/progress")
    public ResponseEntity<?> updateProgress(
            @PathVariable Long id,
            @RequestParam Integer progress) {
        try {
            log.info("Updating project {} progress to {}%", id, progress);
            Project project = projectService.updateProgress(id, progress);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Progress updated successfully");
            response.put("project", project);
            
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            log.error("Error updating progress: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateStatus(
            @PathVariable Long id,
            @RequestParam ProjectStatus status) {
        try {
            log.info("Updating project {} status to {}", id, status);
            Project project = projectService.updateStatus(id, status);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Status updated successfully");
            response.put("project", project);
            
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            log.error("Error updating status: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getProjectById(@PathVariable Long id) {
        try {
            Project project = projectService.getProjectById(id);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("project", project);
            
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            log.error("Error fetching project: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    @GetMapping
    public ResponseEntity<?> getAllProjects() {
        try {
            List<Project> projects = projectService.getAllProjects();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", projects.size());
            response.put("projects", projects);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching projects: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch projects");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/faculty/{facultyId}")
    public ResponseEntity<?> getProjectsByFaculty(@PathVariable Long facultyId) {
        try {
            List<Project> projects = projectService.getProjectsByFaculty(facultyId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", projects.size());
            response.put("projects", projects);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching projects: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch projects");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<?> getProjectsByStudent(@PathVariable Long studentId) {
        try {
            List<Project> projects = projectService.getProjectsByStudent(studentId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", projects.size());
            response.put("projects", projects);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching projects: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch projects");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<?> getProjectsByStatus(@PathVariable ProjectStatus status) {
        try {
            List<Project> projects = projectService.getProjectsByStatus(status);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("count", projects.size());
            response.put("projects", projects);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching projects: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to fetch projects");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteProject(@PathVariable Long id) {
        try {
            log.info("Deleting project: {}", id);
            projectService.deleteProject(id);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Project deleted successfully");
            
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            log.error("Error deleting project: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }
    }

    @GetMapping("/health")
    public ResponseEntity<?> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Project Service");
        response.put("timestamp", LocalDateTime.now());
        return ResponseEntity.ok(response);
    }
}
