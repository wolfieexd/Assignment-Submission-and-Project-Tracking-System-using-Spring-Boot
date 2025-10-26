package com.assignment.userservice.service;

import com.assignment.userservice.dto.AuthResponse;
import com.assignment.userservice.dto.LoginRequest;
import com.assignment.userservice.dto.RegisterRequest;
import com.assignment.userservice.entity.Student;
import com.assignment.userservice.repository.FacultyRepository;
import com.assignment.userservice.repository.StudentRepository;
import com.assignment.userservice.security.JwtTokenProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

/**
 * Unit Tests for AuthService
 * Tests business logic for authentication and registration
 */
@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private StudentRepository studentRepository;

    @Mock
    private FacultyRepository facultyRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtTokenProvider jwtTokenProvider;

    @InjectMocks
    private AuthService authService;

    private RegisterRequest registerRequest;
    private LoginRequest loginRequest;
    private Student testStudent;

    @BeforeEach
    void setUp() {
        registerRequest = new RegisterRequest();
        registerRequest.setName("Test Student");
        registerRequest.setEmail("test@example.com");
        registerRequest.setPassword("password123");
        registerRequest.setDepartment("Computer Science");
        registerRequest.setRole("student");

        loginRequest = new LoginRequest();
        loginRequest.setEmail("test@example.com");
        loginRequest.setPassword("password123");

        testStudent = new Student();
        testStudent.setId(1L);
        testStudent.setName("Test Student");
        testStudent.setEmail("test@example.com");
        testStudent.setPassword("encodedPassword");
        testStudent.setDepartment("Computer Science");
        testStudent.setRole(Student.Role.STUDENT);
        testStudent.setActive(true);
    }

    @Test
    void testRegisterStudent_Success() {
        // Arrange
        when(studentRepository.existsByEmail(anyString())).thenReturn(false);
        when(facultyRepository.existsByEmail(anyString())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("encodedPassword");
        when(studentRepository.save(any(Student.class))).thenReturn(testStudent);
        when(jwtTokenProvider.generateToken(anyString(), anyString())).thenReturn("mockToken");

        // Act
        AuthResponse response = authService.register(registerRequest);

        // Assert
        assertNotNull(response);
        assertEquals("mockToken", response.getToken());
        assertEquals("test@example.com", response.getEmail());
        assertEquals("Test Student", response.getName());
        assertEquals("STUDENT", response.getRole());
        assertEquals("Registration successful", response.getMessage());

        verify(studentRepository, times(1)).save(any(Student.class));
        verify(jwtTokenProvider, times(1)).generateToken("test@example.com", "STUDENT");
    }

    @Test
    void testRegisterStudent_EmailAlreadyExists() {
        // Arrange
        when(studentRepository.existsByEmail(anyString())).thenReturn(true);

        // Act & Assert
        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            authService.register(registerRequest);
        });

        assertEquals("Email already exists", exception.getMessage());
        verify(studentRepository, never()).save(any(Student.class));
    }

    @Test
    void testRegisterStudent_InvalidRole() {
        // Arrange
        registerRequest.setRole("invalid");
        when(studentRepository.existsByEmail(anyString())).thenReturn(false);
        when(facultyRepository.existsByEmail(anyString())).thenReturn(false);

        // Act & Assert
        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            authService.register(registerRequest);
        });

        assertEquals("Invalid role. Must be 'student' or 'faculty'", exception.getMessage());
    }

    @Test
    void testLoginStudent_Success() {
        // Arrange
        when(studentRepository.findByEmail(anyString())).thenReturn(Optional.of(testStudent));
        when(passwordEncoder.matches(anyString(), anyString())).thenReturn(true);
        when(jwtTokenProvider.generateToken(anyString(), anyString())).thenReturn("mockToken");

        // Act
        AuthResponse response = authService.login(loginRequest);

        // Assert
        assertNotNull(response);
        assertEquals("mockToken", response.getToken());
        assertEquals("test@example.com", response.getEmail());
        assertEquals("Test Student", response.getName());
        assertEquals("STUDENT", response.getRole());
        assertEquals("Login successful", response.getMessage());

        verify(jwtTokenProvider, times(1)).generateToken("test@example.com", "STUDENT");
    }

    @Test
    void testLoginStudent_InvalidPassword() {
        // Arrange
        when(studentRepository.findByEmail(anyString())).thenReturn(Optional.of(testStudent));
        when(passwordEncoder.matches(anyString(), anyString())).thenReturn(false);

        // Act & Assert
        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            authService.login(loginRequest);
        });

        assertEquals("Invalid credentials", exception.getMessage());
        verify(jwtTokenProvider, never()).generateToken(anyString(), anyString());
    }

    @Test
    void testLoginStudent_UserNotFound() {
        // Arrange
        when(studentRepository.findByEmail(anyString())).thenReturn(Optional.empty());
        when(facultyRepository.findByEmail(anyString())).thenReturn(Optional.empty());

        // Act & Assert
        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            authService.login(loginRequest);
        });

        assertEquals("User not found", exception.getMessage());
    }

    @Test
    void testLoginStudent_AccountDeactivated() {
        // Arrange
        testStudent.setActive(false);
        when(studentRepository.findByEmail(anyString())).thenReturn(Optional.of(testStudent));

        // Act & Assert
        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            authService.login(loginRequest);
        });

        assertEquals("Account is deactivated", exception.getMessage());
        verify(jwtTokenProvider, never()).generateToken(anyString(), anyString());
    }
}
