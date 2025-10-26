package com.assignment.submissionservice.enums;

/**
 * Submission Status Enum
 * Represents the various states of a submission
 */
public enum SubmissionStatus {
    SUBMITTED,      // Initial submission
    GRADED,         // Graded by faculty
    REJECTED,       // Rejected - needs resubmission
    RESUBMITTED     // Student resubmitted
}
