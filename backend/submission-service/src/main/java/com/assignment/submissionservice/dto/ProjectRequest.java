package com.assignment.submissionservice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO for creating/updating projects
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProjectRequest {

    @NotBlank(message = "Title is required")
    @Size(max = 200, message = "Title must be less than 200 characters")
    private String title;

    @NotBlank(message = "Description is required")
    private String description;

    @NotNull(message = "Faculty ID is required")
    private Long facultyId;

    @NotBlank(message = "Faculty name is required")
    private String facultyName;

    @NotNull(message = "Student ID is required")
    private Long studentId;

    @NotNull(message = "Deadline is required")
    private LocalDateTime deadline;

    private Integer totalMilestones = 0;

    private String milestones;

    private String deliverables;
}
