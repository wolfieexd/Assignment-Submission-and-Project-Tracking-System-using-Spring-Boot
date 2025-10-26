package com.assignment.submissionservice.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

/**
 * Project Entity
 * Represents a project assigned to students with milestones
 */
@Entity
@Table(name = "projects")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Project {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Title is required")
    @Size(max = 200, message = "Title must be less than 200 characters")
    @Column(nullable = false, length = 200)
    private String title;

    @NotBlank(message = "Description is required")
    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @NotNull(message = "Faculty ID is required")
    @Column(nullable = false)
    private Long facultyId;

    @Column(length = 100)
    private String facultyName;

    @NotNull(message = "Student ID is required")
    @Column(nullable = false)
    private Long studentId;

    @Column(length = 100)
    private String studentName;

    @NotNull(message = "Deadline is required")
    @Column(nullable = false)
    private LocalDateTime deadline;

    @Column(nullable = false)
    private Integer progress = 0;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ProjectStatus status = ProjectStatus.NOT_STARTED;

    @Column
    private Integer totalMilestones = 0;

    @Column
    private Integer completedMilestones = 0;

    @Column(columnDefinition = "TEXT")
    private String milestones;

    @Column(columnDefinition = "TEXT")
    private String deliverables;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public enum ProjectStatus {
        NOT_STARTED,
        IN_PROGRESS,
        COMPLETED,
        DELAYED,
        CANCELLED
    }
}
