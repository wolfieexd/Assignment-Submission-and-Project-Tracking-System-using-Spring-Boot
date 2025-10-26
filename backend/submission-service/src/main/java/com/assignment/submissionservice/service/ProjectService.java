package com.assignment.submissionservice.service;

import com.assignment.submissionservice.dto.ProjectRequest;
import com.assignment.submissionservice.entity.Project;
import com.assignment.submissionservice.entity.Project.ProjectStatus;
import com.assignment.submissionservice.repository.ProjectRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Project Service
 * Business logic for project management
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ProjectService {

    private final ProjectRepository projectRepository;

    @Transactional
    public Project createProject(ProjectRequest request) {
        log.debug("Creating project: {}", request.getTitle());

        Project project = new Project();
        project.setTitle(request.getTitle());
        project.setDescription(request.getDescription());
        project.setFacultyId(request.getFacultyId());
        project.setFacultyName(request.getFacultyName());
        project.setStudentId(request.getStudentId());
        project.setDeadline(request.getDeadline());
        project.setTotalMilestones(request.getTotalMilestones());
        project.setCompletedMilestones(0);
        project.setProgress(0);
        project.setStatus(ProjectStatus.NOT_STARTED);
        project.setMilestones(request.getMilestones());
        project.setDeliverables(request.getDeliverables());

        Project saved = projectRepository.save(project);
        log.info("Project created successfully: {}", saved.getId());
        return saved;
    }

    @Transactional
    public Project updateProgress(Long id, Integer progress) {
        Project project = getProjectById(id);
        
        project.setProgress(progress);
        
        // Auto-update status based on progress
        if (progress == 0) {
            project.setStatus(ProjectStatus.NOT_STARTED);
        } else if (progress == 100) {
            project.setStatus(ProjectStatus.COMPLETED);
        } else {
            project.setStatus(ProjectStatus.IN_PROGRESS);
        }

        return projectRepository.save(project);
    }

    @Transactional
    public Project updateStatus(Long id, ProjectStatus status) {
        Project project = getProjectById(id);
        project.setStatus(status);
        return projectRepository.save(project);
    }

    public Project getProjectById(Long id) {
        return projectRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Project not found with id: " + id));
    }

    public List<Project> getAllProjects() {
        return projectRepository.findAll();
    }

    public List<Project> getProjectsByFaculty(Long facultyId) {
        return projectRepository.findByFacultyId(facultyId);
    }

    public List<Project> getProjectsByStudent(Long studentId) {
        return projectRepository.findByStudentId(studentId);
    }

    public List<Project> getProjectsByStatus(ProjectStatus status) {
        return projectRepository.findByStatus(status);
    }

    @Transactional
    public void deleteProject(Long id) {
        projectRepository.deleteById(id);
        log.info("Project deleted: {}", id);
    }
}
