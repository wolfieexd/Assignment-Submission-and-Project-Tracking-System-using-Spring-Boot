package com.assignment.submissionservice.repository;

import com.assignment.submissionservice.entity.Submission;
import com.assignment.submissionservice.entity.Submission.SubmissionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Submission Repository
 * Data access layer for Submission entity
 */
@Repository
public interface SubmissionRepository extends JpaRepository<Submission, Long> {
    
    List<Submission> findByAssignmentId(Long assignmentId);
    
    List<Submission> findByStudentId(Long studentId);
    
    Optional<Submission> findByAssignmentIdAndStudentId(Long assignmentId, Long studentId);
    
    List<Submission> findByStatus(SubmissionStatus status);
    
    List<Submission> findByAssignmentIdAndStatus(Long assignmentId, SubmissionStatus status);
    
    Long countByAssignmentId(Long assignmentId);
    
    Long countByStudentId(Long studentId);
}
