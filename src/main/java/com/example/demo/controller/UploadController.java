package com.example.demo.controller;

import com.example.demo.dto.ApiResponse;
import com.example.demo.dto.UploadImageResponse;
import com.example.demo.service.S3StorageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * Upload Controller
 * Handles file uploads to AWS S3
 */
@RestController
@RequestMapping("/api/uploads")
@RequiredArgsConstructor
@Tag(name = "Uploads", description = "File upload endpoints to AWS S3")
public class UploadController {

    private final S3StorageService s3StorageService;

    /**
     * Upload image to AWS S3
     * Returns public URL of uploaded image
     */
    @PostMapping("/image")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Upload image", description = "Upload image file to AWS S3 (ADMIN only)")
    @SecurityRequirement(name = "bearerAuth")
    @io.swagger.v3.oas.annotations.responses.ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Image uploaded successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid file format or size"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Unauthorized"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Forbidden")
    })
    public ResponseEntity<ApiResponse<UploadImageResponse>> uploadImage(
            @RequestParam("file") MultipartFile file) {
        String imageUrl = s3StorageService.uploadImage(file);
        UploadImageResponse response = UploadImageResponse.builder()
                .url(imageUrl)
                .size(file.getSize())
                .contentType(file.getContentType())
                .build();
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Image uploaded successfully", response));
    }

    /**
     * Delete image from AWS S3
     */
    @DeleteMapping("/image")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Delete image", description = "Delete image file from AWS S3 (ADMIN only)")
    @SecurityRequirement(name = "bearerAuth")
    public ResponseEntity<ApiResponse<?>> deleteImage(@RequestParam String imageUrl) {
        s3StorageService.deleteImage(imageUrl);
        return ResponseEntity.ok(ApiResponse.success("Image deleted successfully", null));
    }
}
