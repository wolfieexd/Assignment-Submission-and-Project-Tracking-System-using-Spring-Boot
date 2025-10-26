package com.assignment.submissionservice.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

/**
 * Submission Entity
 * Represents a student's submission for an assignment
 */
@Entity
@Table(name = "submissions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Submission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull(message = "Assignment ID is required")
    @Column(nullable = false)
    private Long assignmentId;

    @NotNull(message = "Student ID is required")
    @Column(nullable = false)
    private Long studentId;

    @Column(length = 100)
    private String studentName;

    @Column(length = 100)
    private String studentEmail;

    @NotBlank(message = "File URL is required")
    @Column(nullable = false, columnDefinition = "TEXT")
    private String fileUrl;

    @Column(length = 200)
    private String fileName;

    @Column(columnDefinition = "TEXT")
    private String comments;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private SubmissionStatus status = SubmissionStatus.SUBMITTED;

    @Column
    private Integer grade;

    @Column(columnDefinition = "TEXT")
    private String feedback;

    @Column
    private LocalDateTime gradedAt;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime submittedAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public enum SubmissionStatus {
        SUBMITTED,
        GRADED,
        REJECTED,
        RESUBMITTED
    }
}
