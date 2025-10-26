package com.assignment.submissionservice.service;

import com.assignment.submissionservice.dto.AssignmentRequest;
import com.assignment.submissionservice.entity.Assignment;
import com.assignment.submissionservice.repository.AssignmentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Assignment Service
 * Business logic for assignment management
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class AssignmentService {

    private final AssignmentRepository assignmentRepository;

    @Transactional
    public Assignment createAssignment(AssignmentRequest request) {
        log.debug("Creating assignment: {}", request.getTitle());

        Assignment assignment = new Assignment();
        assignment.setTitle(request.getTitle());
        assignment.setDescription(request.getDescription());
        assignment.setCourse(request.getCourse());
        assignment.setFacultyId(request.getFacultyId());
        assignment.setFacultyName(request.getFacultyName());
        assignment.setDueDate(request.getDueDate());
        assignment.setMaxPoints(request.getMaxPoints());
        assignment.setAttachmentUrl(request.getAttachmentUrl());
        assignment.setActive(true);

        Assignment saved = assignmentRepository.save(assignment);
        log.info("Assignment created successfully: {}", saved.getId());
        return saved;
    }

    public List<Assignment> getAllAssignments() {
        return assignmentRepository.findAll();
    }

    public List<Assignment> getActiveAssignments() {
        return assignmentRepository.findByActiveTrue();
    }

    public List<Assignment> getAssignmentsByFaculty(Long facultyId) {
        return assignmentRepository.findByFacultyId(facultyId);
    }

    public Assignment getAssignmentById(Long id) {
        return assignmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Assignment not found with id: " + id));
    }

    @Transactional
    public Assignment updateAssignment(Long id, AssignmentRequest request) {
        Assignment assignment = getAssignmentById(id);
        
        assignment.setTitle(request.getTitle());
        assignment.setDescription(request.getDescription());
        assignment.setCourse(request.getCourse());
        assignment.setDueDate(request.getDueDate());
        assignment.setMaxPoints(request.getMaxPoints());
        assignment.setAttachmentUrl(request.getAttachmentUrl());

        return assignmentRepository.save(assignment);
    }

    @Transactional
    public void deleteAssignment(Long id) {
        Assignment assignment = getAssignmentById(id);
        assignment.setActive(false);
        assignmentRepository.save(assignment);
        log.info("Assignment deactivated: {}", id);
    }

    public List<Assignment> getOverdueAssignments() {
        return assignmentRepository.findByDueDateBefore(LocalDateTime.now());
    }

    public List<Assignment> getUpcomingAssignments(LocalDateTime startDate, LocalDateTime endDate) {
        return assignmentRepository.findByDueDateBetween(startDate, endDate);
    }
}
