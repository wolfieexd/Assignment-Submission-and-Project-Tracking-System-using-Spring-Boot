package com.assignment.userservice.service;

import com.assignment.userservice.dto.AuthResponse;
import com.assignment.userservice.dto.LoginRequest;
import com.assignment.userservice.dto.RegisterRequest;
import com.assignment.userservice.entity.Faculty;
import com.assignment.userservice.entity.Student;
import com.assignment.userservice.repository.FacultyRepository;
import com.assignment.userservice.repository.StudentRepository;
import com.assignment.userservice.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Auth Service - Business Layer
 * Handles authentication and registration logic
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class AuthService {

    private final StudentRepository studentRepository;
    private final FacultyRepository facultyRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        // Check if email already exists
        if (studentRepository.existsByEmail(request.getEmail()) ||
                facultyRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        String role = request.getRole().toLowerCase();
        String token;
        String name = request.getName();

        if ("student".equals(role)) {
            Student student = new Student();
            student.setName(request.getName());
            student.setEmail(request.getEmail());
            student.setPassword(passwordEncoder.encode(request.getPassword()));
            student.setDepartment(request.getDepartment());
            student.setRole(Student.Role.STUDENT);
            student.setActive(true);

            student = studentRepository.save(student);
            token = jwtTokenProvider.generateToken(student.getEmail(), "STUDENT");
            log.info("New student registered: {}", student.getEmail());

        } else if ("faculty".equals(role)) {
            Faculty faculty = new Faculty();
            faculty.setName(request.getName());
            faculty.setEmail(request.getEmail());
            faculty.setPassword(passwordEncoder.encode(request.getPassword()));
            faculty.setDepartment(request.getDepartment());
            faculty.setRole(Student.Role.FACULTY);
            faculty.setActive(true);

            faculty = facultyRepository.save(faculty);
            token = jwtTokenProvider.generateToken(faculty.getEmail(), "FACULTY");
            log.info("New faculty registered: {}", faculty.getEmail());

        } else {
            throw new RuntimeException("Invalid role. Must be 'student' or 'faculty'");
        }

        return AuthResponse.builder()
                .token(token)
                .email(request.getEmail())
                .name(name)
                .role(role.toUpperCase())
                .message("Registration successful")
                .build();
    }

    public AuthResponse login(LoginRequest request) {
        String email = request.getEmail();
        String password = request.getPassword();

        // Try to find as student first
        var student = studentRepository.findByEmail(email);
        if (student.isPresent()) {
            if (!student.get().getActive()) {
                throw new RuntimeException("Account is deactivated");
            }
            if (!passwordEncoder.matches(password, student.get().getPassword())) {
                throw new RuntimeException("Invalid credentials");
            }

            String token = jwtTokenProvider.generateToken(email, "STUDENT");
            log.info("Student logged in: {}", email);

            return AuthResponse.builder()
                    .token(token)
                    .email(email)
                    .name(student.get().getName())
                    .role("STUDENT")
                    .message("Login successful")
                    .build();
        }

        // Try to find as faculty
        var faculty = facultyRepository.findByEmail(email);
        if (faculty.isPresent()) {
            if (!faculty.get().getActive()) {
                throw new RuntimeException("Account is deactivated");
            }
            if (!passwordEncoder.matches(password, faculty.get().getPassword())) {
                throw new RuntimeException("Invalid credentials");
            }

            String token = jwtTokenProvider.generateToken(email, "FACULTY");
            log.info("Faculty logged in: {}", email);

            return AuthResponse.builder()
                    .token(token)
                    .email(email)
                    .name(faculty.get().getName())
                    .role("FACULTY")
                    .message("Login successful")
                    .build();
        }

        throw new RuntimeException("User not found");
    }
}
