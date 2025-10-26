-- ========================================
-- Production Database Initialization Script
-- User Service Database
-- ========================================

-- Drop database if exists (ONLY for fresh installation)
-- DROP DATABASE IF EXISTS user_service_db;

-- Create database with proper character set
CREATE DATABASE IF NOT EXISTS user_service_db 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE user_service_db;

-- Create dedicated user with minimal privileges
-- Replace 'STRONG_PASSWORD_HERE' with a secure password
CREATE USER IF NOT EXISTS 'user_service_user'@'localhost' 
  IDENTIFIED BY 'STRONG_PASSWORD_HERE';

-- Grant only necessary privileges (no DROP, CREATE, ALTER on production)
GRANT SELECT, INSERT, UPDATE, DELETE ON user_service_db.* 
  TO 'user_service_user'@'localhost';

-- For initial setup, temporarily grant schema modification rights
-- REVOKE these after initial deployment!
GRANT CREATE, ALTER, INDEX, REFERENCES ON user_service_db.* 
  TO 'user_service_user'@'localhost';

FLUSH PRIVILEGES;

-- ========================================
-- Optional: Create tables manually
-- (If not using JPA auto-generation)
-- ========================================

-- Students table
CREATE TABLE IF NOT EXISTS students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    department VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_department (department)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Faculty table
CREATE TABLE IF NOT EXISTS faculty (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    department VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_department (department)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Security: Revoke schema modification rights after initial deployment
-- ========================================
-- Run this after the first deployment:
-- REVOKE CREATE, ALTER, INDEX, REFERENCES ON user_service_db.* FROM 'user_service_user'@'localhost';
-- FLUSH PRIVILEGES;

-- ========================================
-- Insert default admin/test data (DEVELOPMENT ONLY)
-- ========================================
-- Password: "password123" hashed with BCrypt
-- REMOVE THIS IN PRODUCTION!
-- INSERT INTO faculty (name, email, password, department) 
-- VALUES ('Admin Faculty', 'admin@university.edu', '$2a$10$xYz...', 'Computer Science');

SELECT 'User Service Database Setup Complete!' AS Status;
