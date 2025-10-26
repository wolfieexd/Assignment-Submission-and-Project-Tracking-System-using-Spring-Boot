package com.assignment.submissionservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.client.RestTemplate;

/**
 * Submission Service Application
 * Handles assignments, submissions, and project tracking
 */
@SpringBootApplication
public class SubmissionServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(SubmissionServiceApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("🚀 Submission Service Started Successfully!");
        System.out.println("🌐 Running on: http://localhost:8082");
        System.out.println("📊 H2 Console: http://localhost:8082/h2-console");
        System.out.println("========================================\n");
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
