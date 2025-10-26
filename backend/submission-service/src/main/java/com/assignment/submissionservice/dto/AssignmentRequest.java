package com.assignment.submissionservice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO for creating/updating assignments
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AssignmentRequest {

    @NotBlank(message = "Title is required")
    @Size(max = 200, message = "Title must be less than 200 characters")
    private String title;

    @NotBlank(message = "Description is required")
    private String description;

    @NotBlank(message = "Course is required")
    @Size(max = 100, message = "Course must be less than 100 characters")
    private String course;

    @NotNull(message = "Faculty ID is required")
    private Long facultyId;

    @NotBlank(message = "Faculty name is required")
    private String facultyName;

    @NotNull(message = "Due date is required")
    private LocalDateTime dueDate;

    private Integer maxPoints = 100;

    private String attachmentUrl;
}
