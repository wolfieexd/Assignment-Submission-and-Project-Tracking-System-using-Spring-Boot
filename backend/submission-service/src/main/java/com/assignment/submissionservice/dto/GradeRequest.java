package com.assignment.submissionservice.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for grading submissions
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GradeRequest {

    @Min(value = 0, message = "Grade must be at least 0")
    @Max(value = 100, message = "Grade must be at most 100")
    private Integer grade;

    private String feedback;
}
