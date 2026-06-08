package com.example.demo.service;

import com.example.demo.exception.S3UploadException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;

import java.io.IOException;
import java.util.UUID;

/**
 * S3 Storage Service for uploading and managing files on AWS S3
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class S3StorageService {

    private final S3Client s3Client;

    @Value("${aws.s3.bucket-name}")
    private String bucketName;

    @Value("${aws.s3.region}")
    private String region;

    private static final String UPLOADS_FOLDER = "uploads";
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10 MB

    /**
     * Upload image file to S3
     * Returns the public URL of the uploaded file
     */
    public String uploadImage(MultipartFile file) throws S3UploadException {
        validateFile(file);

        String key = generateS3Key(file.getOriginalFilename());

        try {
            byte[] fileBytes = file.getBytes();
            
            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .contentType(file.getContentType())
                    .contentLength((long) fileBytes.length)
                    .build();

            s3Client.putObject(putObjectRequest, RequestBody.fromBytes(fileBytes));
            
            String imageUrl = generatePublicUrl(key);
            log.info("File uploaded successfully to S3: {}", key);
            return imageUrl;
            
        } catch (IOException e) {
            log.error("Error reading file content: {}", e.getMessage());
            throw new S3UploadException("Failed to read file content", e);
        } catch (S3Exception e) {
            log.error("AWS S3 error during upload: {}", e.getMessage());
            throw new S3UploadException("AWS S3 error: " + e.getMessage(), e);
        }
    }

    /**
     * Delete image from S3
     */
    public void deleteImage(String imageUrl) throws S3UploadException {
        try {
            String key = extractKeyFromUrl(imageUrl);
            
            DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            s3Client.deleteObject(deleteObjectRequest);
            log.info("File deleted successfully from S3: {}", key);
            
        } catch (S3Exception e) {
            log.error("AWS S3 error during delete: {}", e.getMessage());
            throw new S3UploadException("AWS S3 error during delete: " + e.getMessage(), e);
        }
    }

    /**
     * Generate presigned URL for temporary access to S3 object
     */
    public String generatePresignedUrl(String imageUrl, int expirationMinutes) throws S3UploadException {
        try {
            String key = extractKeyFromUrl(imageUrl);
            
            GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            // Note: Presigned URLs require additional configuration
            // This is a placeholder - implement based on your S3 configuration
            log.info("Generating presigned URL for: {}", key);
            return imageUrl; // Return direct URL if bucket is public
            
        } catch (Exception e) {
            log.error("Error generating presigned URL: {}", e.getMessage());
            throw new S3UploadException("Failed to generate presigned URL", e);
        }
    }

    /**
     * Validate file before upload
     */
    private void validateFile(MultipartFile file) throws S3UploadException {
        if (file == null || file.isEmpty()) {
            throw new S3UploadException("File is empty");
        }

        String contentType = file.getContentType();
        if (contentType == null || !isAllowedImageType(contentType)) {
            throw new S3UploadException("Invalid file type. Only images are allowed.");
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            throw new S3UploadException("File size exceeds maximum allowed size of 10 MB");
        }
    }

    /**
     * Check if file type is allowed
     */
    private boolean isAllowedImageType(String contentType) {
        return contentType.equals("image/jpeg") || 
               contentType.equals("image/png") || 
               contentType.equals("image/gif") ||
               contentType.equals("image/webp");
    }

    /**
     * Generate unique S3 key for file
     */
    private String generateS3Key(String originalFilename) {
        String timestamp = String.valueOf(System.currentTimeMillis() / 1000);
        String uuid = UUID.randomUUID().toString().substring(0, 8);
        String extension = getFileExtension(originalFilename);
        return String.format("%s/%s_%s_%s%s", UPLOADS_FOLDER, timestamp, uuid, 
                UUID.randomUUID().toString().substring(0, 4), extension);
    }

    /**
     * Get file extension
     */
    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf("."));
    }

    /**
     * Generate public URL for uploaded file
     */
    private String generatePublicUrl(String key) {
        return String.format("https://%s.s3.%s.amazonaws.com/%s", bucketName, region, key);
    }

    /**
     * Extract S3 key from public URL
     */
    private String extractKeyFromUrl(String imageUrl) {
        // Extract key from URL format: https://bucket.s3.region.amazonaws.com/key
        String[] parts = imageUrl.split(String.format("s3\\.%s\\.amazonaws\\.com/", region));
        if (parts.length > 1) {
            return parts[1];
        }
        return imageUrl;
    }
}
