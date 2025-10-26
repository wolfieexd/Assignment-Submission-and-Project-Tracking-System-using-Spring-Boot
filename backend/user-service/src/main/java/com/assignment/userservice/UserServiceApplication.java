package com.assignment.userservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main Application Class for User Service
 * Handles user registration, authentication, and role management
 */
@SpringBootApplication
public class UserServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(UserServiceApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("🚀 User Service Started Successfully!");
        System.out.println("📍 Running on: http://localhost:8081");
        System.out.println("📊 H2 Console: http://localhost:8081/h2-console");
        System.out.println("========================================\n");
    }
}
