-- ========================================
-- Production Database Initialization Script
-- Submission Service Database
-- ========================================

-- Drop database if exists (ONLY for fresh installation)
-- DROP DATABASE IF EXISTS submission_service_db;

-- Create database with proper character set
CREATE DATABASE IF NOT EXISTS submission_service_db 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE submission_service_db;

-- Create dedicated user with minimal privileges
-- Replace 'STRONG_PASSWORD_HERE' with a secure password
CREATE USER IF NOT EXISTS 'submission_service_user'@'localhost' 
  IDENTIFIED BY 'STRONG_PASSWORD_HERE';

-- Grant only necessary privileges (no DROP, CREATE, ALTER on production)
GRANT SELECT, INSERT, UPDATE, DELETE ON submission_service_db.* 
  TO 'submission_service_user'@'localhost';

-- For initial setup, temporarily grant schema modification rights
-- REVOKE these after initial deployment!
GRANT CREATE, ALTER, INDEX, REFERENCES ON submission_service_db.* 
  TO 'submission_service_user'@'localhost';

FLUSH PRIVILEGES;

-- ========================================
-- Optional: Create tables manually
-- (If not using JPA auto-generation)
-- ========================================

-- Projects table
CREATE TABLE IF NOT EXISTS projects (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    faculty_id BIGINT NOT NULL,
    faculty_name VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_faculty_id (faculty_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Assignments table
CREATE TABLE IF NOT EXISTS assignments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    project_id BIGINT NOT NULL,
    faculty_id BIGINT NOT NULL,
    due_date TIMESTAMP NOT NULL,
    file_url VARCHAR(500),
    total_marks INT DEFAULT 100,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_project_id (project_id),
    INDEX idx_faculty_id (faculty_id),
    INDEX idx_due_date (due_date),
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Submissions table
CREATE TABLE IF NOT EXISTS submissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    assignment_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(255) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    remarks TEXT,
    grade INT,
    feedback TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    graded_at TIMESTAMP NULL,
    INDEX idx_assignment_id (assignment_id),
    INDEX idx_student_id (student_id),
    INDEX idx_submitted_at (submitted_at),
    UNIQUE KEY unique_submission (assignment_id, student_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Security: Revoke schema modification rights after initial deployment
-- ========================================
-- Run this after the first deployment:
-- REVOKE CREATE, ALTER, INDEX, REFERENCES ON submission_service_db.* FROM 'submission_service_user'@'localhost';
-- FLUSH PRIVILEGES;

SELECT 'Submission Service Database Setup Complete!' AS Status;
