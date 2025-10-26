package com.assignment.submissionservice.repository;

import com.assignment.submissionservice.entity.Assignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Assignment Repository
 * Data access layer for Assignment entity
 */
@Repository
public interface AssignmentRepository extends JpaRepository<Assignment, Long> {
    
    List<Assignment> findByFacultyId(Long facultyId);
    
    List<Assignment> findByFacultyIdAndActiveTrue(Long facultyId);
    
    List<Assignment> findByActiveTrue();
    
    List<Assignment> findByCourse(String course);
    
    List<Assignment> findByDueDateBefore(LocalDateTime date);
    
    List<Assignment> findByDueDateAfter(LocalDateTime date);
    
    List<Assignment> findByDueDateBetween(LocalDateTime startDate, LocalDateTime endDate);
}
