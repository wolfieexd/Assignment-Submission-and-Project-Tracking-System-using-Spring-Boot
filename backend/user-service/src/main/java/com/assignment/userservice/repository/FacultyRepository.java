package com.assignment.userservice.repository;

import com.assignment.userservice.entity.Faculty;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Faculty Repository - Data Layer
 * Handles database operations for Faculty entity
 */
@Repository
public interface FacultyRepository extends JpaRepository<Faculty, Long> {
    
    Optional<Faculty> findByEmail(String email);
    
    List<Faculty> findByDepartment(String department);
    
    Boolean existsByEmail(String email);
    
    List<Faculty> findByActive(Boolean active);
}
