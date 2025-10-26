package com.assignment.submissionservice.service;

import com.assignment.submissionservice.dto.GradeRequest;
import com.assignment.submissionservice.dto.SubmissionRequest;
import com.assignment.submissionservice.entity.Submission;
import com.assignment.submissionservice.entity.Submission.SubmissionStatus;
import com.assignment.submissionservice.repository.SubmissionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Submission Service
 * Business logic for submission management
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class SubmissionService {

    private final SubmissionRepository submissionRepository;

    @Transactional
    public Submission submitAssignment(SubmissionRequest request) {
        log.debug("Submitting assignment {} by student: {}", request.getAssignmentId(), request.getStudentId());

        // Check if already submitted
        submissionRepository.findByAssignmentIdAndStudentId(request.getAssignmentId(), request.getStudentId())
                .ifPresent(existing -> {
                    throw new IllegalStateException("Assignment already submitted. Use resubmit instead.");
                });

        Submission submission = new Submission();
        submission.setAssignmentId(request.getAssignmentId());
        submission.setStudentId(request.getStudentId());
        submission.setStudentName(request.getStudentName());
        submission.setStudentEmail(request.getStudentEmail());
        submission.setFileUrl(request.getFileUrl());
        submission.setFileName(request.getFileName());
        submission.setComments(request.getComments());
        submission.setStatus(SubmissionStatus.SUBMITTED);

        Submission saved = submissionRepository.save(submission);
        log.info("Submission created successfully: {}", saved.getId());
        return saved;
    }

    @Transactional
    public Submission resubmitAssignment(Long submissionId, SubmissionRequest request) {
        Submission submission = getSubmissionById(submissionId);
        
        submission.setFileUrl(request.getFileUrl());
        submission.setFileName(request.getFileName());
        submission.setComments(request.getComments());
        submission.setStatus(SubmissionStatus.RESUBMITTED);
        submission.setGrade(null);
        submission.setFeedback(null);
        submission.setGradedAt(null);

        return submissionRepository.save(submission);
    }

    @Transactional
    public Submission gradeSubmission(Long submissionId, GradeRequest request) {
        Submission submission = getSubmissionById(submissionId);
        
        submission.setGrade(request.getGrade());
        submission.setFeedback(request.getFeedback());
        submission.setStatus(SubmissionStatus.GRADED);
        submission.setGradedAt(LocalDateTime.now());

        log.info("Submission graded: {} with grade: {}", submissionId, request.getGrade());
        return submissionRepository.save(submission);
    }

    public Submission getSubmissionById(Long id) {
        return submissionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Submission not found with id: " + id));
    }

    public List<Submission> getAllSubmissions() {
        return submissionRepository.findAll();
    }

    public List<Submission> getSubmissionsByAssignment(Long assignmentId) {
        return submissionRepository.findByAssignmentId(assignmentId);
    }

    public List<Submission> getSubmissionsByStudent(Long studentId) {
        return submissionRepository.findByStudentId(studentId);
    }

    public Submission getStudentSubmission(Long assignmentId, Long studentId) {
        return submissionRepository.findByAssignmentIdAndStudentId(assignmentId, studentId)
                .orElse(null);
    }

    public Long countSubmissionsByAssignment(Long assignmentId) {
        return submissionRepository.countByAssignmentId(assignmentId);
    }
}
