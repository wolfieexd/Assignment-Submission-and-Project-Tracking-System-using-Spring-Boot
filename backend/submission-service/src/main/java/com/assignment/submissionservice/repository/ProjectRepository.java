package com.assignment.submissionservice.repository;

import com.assignment.submissionservice.entity.Project;
import com.assignment.submissionservice.entity.Project.ProjectStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Project Repository
 * Data access layer for Project entity
 */
@Repository
public interface ProjectRepository extends JpaRepository<Project, Long> {
    
    List<Project> findByFacultyId(Long facultyId);
    
    List<Project> findByStudentId(Long studentId);
    
    List<Project> findByStatus(ProjectStatus status);
    
    List<Project> findByFacultyIdAndStatus(Long facultyId, ProjectStatus status);
    
    List<Project> findByStudentIdAndStatus(Long studentId, ProjectStatus status);
    
    Long countByStudentId(Long studentId);
    
    Long countByFacultyId(Long facultyId);
}
