package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Upload Image Response DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UploadImageResponse {
    private String url;
    private String key;
    private Long size;
    private String contentType;
}
