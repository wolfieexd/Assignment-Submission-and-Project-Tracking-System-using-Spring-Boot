package com.assignment.submissionservice.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * File Upload Service
 * Handles file upload operations for assignments and submissions
 */
@Service
@Slf4j
public class FileUploadService {

    @Value("${file.upload.dir:uploads}")
    private String uploadDir;

    @Value("${file.upload.max-size:10485760}") // 10MB default
    private long maxFileSize;

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(
            "pdf", "doc", "docx", "txt", "zip", "rar", 
            "jpg", "jpeg", "png", "ppt", "pptx"
    );
    
    // Dangerous extensions that should never be allowed
    private static final List<String> DANGEROUS_EXTENSIONS = Arrays.asList(
            "exe", "bat", "cmd", "sh", "bash", "ps1", "msi", "app",
            "jar", "class", "py", "rb", "php", "jsp", "asp", "aspx",
            "js", "vbs", "com", "scr", "dll", "sys", "bin"
    );

    /**
     * Upload a file to the server
     * 
     * @param file The file to upload
     * @param subfolder Subfolder within upload directory (e.g., "assignments", "submissions")
     * @return The file URL/path
     * @throws IOException If file upload fails
     */
    public String uploadFile(MultipartFile file, String subfolder) throws IOException {
        // Validate file
        validateFile(file);

        // Create upload directory if it doesn't exist
        Path uploadPath = Paths.get(uploadDir, subfolder);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Generate unique filename
        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename);
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String uniqueId = UUID.randomUUID().toString().substring(0, 8);
        String newFilename = String.format("%s_%s.%s", timestamp, uniqueId, extension);

        // Save file
        Path filePath = uploadPath.resolve(newFilename);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        log.info("File uploaded successfully: {}", newFilename);

        // Return relative path or URL
        return String.format("%s/%s", subfolder, newFilename);
    }

    /**
     * Delete a file from the server
     * 
     * @param filePath The file path to delete
     * @return true if deleted successfully, false otherwise
     */
    public boolean deleteFile(String filePath) {
        try {
            Path path = Paths.get(uploadDir, filePath);
            if (Files.exists(path)) {
                Files.delete(path);
                log.info("File deleted successfully: {}", filePath);
                return true;
            } else {
                log.warn("File not found: {}", filePath);
                return false;
            }
        } catch (IOException e) {
            log.error("Error deleting file: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Get the full file path
     * 
     * @param relativePath The relative file path
     * @return The full file path
     */
    public Path getFilePath(String relativePath) {
        return Paths.get(uploadDir, relativePath);
    }

    /**
     * Check if a file exists
     * 
     * @param filePath The file path to check
     * @return true if exists, false otherwise
     */
    public boolean fileExists(String filePath) {
        Path path = Paths.get(uploadDir, filePath);
        return Files.exists(path);
    }

    /**
     * Validate uploaded file
     * 
     * @param file The file to validate
     * @throws IllegalArgumentException If validation fails
     */
    private void validateFile(MultipartFile file) {
        // Check if file is empty
        if (file.isEmpty()) {
            throw new IllegalArgumentException("File is empty");
        }

        // Check file size
        if (file.getSize() > maxFileSize) {
            throw new IllegalArgumentException(
                    String.format("File size exceeds maximum allowed size of %d MB", 
                            maxFileSize / (1024 * 1024)));
        }

        // Check file extension
        String filename = file.getOriginalFilename();
        if (filename == null || filename.isEmpty()) {
            throw new IllegalArgumentException("Invalid filename");
        }
        
        // Sanitize filename - prevent path traversal
        if (filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
            throw new IllegalArgumentException("Invalid filename: path traversal attempt detected");
        }

        String extension = getFileExtension(filename).toLowerCase();
        
        // Check for dangerous extensions
        if (DANGEROUS_EXTENSIONS.contains(extension)) {
            log.warn("Attempted upload of dangerous file type: {}", extension);
            throw new IllegalArgumentException(
                    String.format("File type .%s is not allowed for security reasons", extension));
        }
        
        // Check if extension is in allowed list
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new IllegalArgumentException(
                    String.format("File type .%s is not allowed. Allowed types: %s", 
                            extension, String.join(", ", ALLOWED_EXTENSIONS)));
        }
        
        // Additional security: Check MIME type matches extension
        String contentType = file.getContentType();
        if (contentType != null && !isValidMimeType(extension, contentType)) {
            log.warn("MIME type mismatch: extension={}, contentType={}", extension, contentType);
            throw new IllegalArgumentException("File type mismatch detected");
        }
    }

    /**
     * Get file extension from filename
     * 
     * @param filename The filename
     * @return The file extension
     */
    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf(".") + 1);
    }

    /**
     * Get file size in human-readable format
     * 
     * @param size File size in bytes
     * @return Formatted file size
     */
    public String getHumanReadableSize(long size) {
        if (size < 1024) {
            return size + " B";
        } else if (size < 1024 * 1024) {
            return String.format("%.2f KB", size / 1024.0);
        } else {
            return String.format("%.2f MB", size / (1024.0 * 1024.0));
        }
    }
    
    /**
     * Validate MIME type matches file extension
     * Additional security layer to prevent file type spoofing
     * 
     * @param extension File extension
     * @param mimeType MIME type from file
     * @return true if MIME type is valid for extension
     */
    private boolean isValidMimeType(String extension, String mimeType) {
        // Basic MIME type validation - expand as needed
        switch (extension.toLowerCase()) {
            case "pdf":
                return mimeType.equals("application/pdf");
            case "doc":
                return mimeType.equals("application/msword");
            case "docx":
                return mimeType.equals("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
            case "txt":
                return mimeType.equals("text/plain");
            case "zip":
                return mimeType.equals("application/zip") || mimeType.equals("application/x-zip-compressed");
            case "rar":
                return mimeType.equals("application/x-rar-compressed") || mimeType.equals("application/vnd.rar");
            case "jpg":
            case "jpeg":
                return mimeType.equals("image/jpeg");
            case "png":
                return mimeType.equals("image/png");
            case "ppt":
                return mimeType.equals("application/vnd.ms-powerpoint");
            case "pptx":
                return mimeType.equals("application/vnd.openxmlformats-officedocument.presentationml.presentation");
            default:
                // If not explicitly listed, allow (trust the extension check)
                return true;
        }
    }
}
