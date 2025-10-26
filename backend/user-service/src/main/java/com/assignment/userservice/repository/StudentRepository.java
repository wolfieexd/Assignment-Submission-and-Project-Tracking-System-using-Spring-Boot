package com.assignment.userservice.repository;

import com.assignment.userservice.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Student Repository - Data Layer
 * Handles database operations for Student entity
 */
@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    
    Optional<Student> findByEmail(String email);
    
    List<Student> findByDepartment(String department);
    
    Boolean existsByEmail(String email);
    
    List<Student> findByActive(Boolean active);
}
