package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Article Image DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ArticleImageDTO {
    private Long id;
    private Long articleId;
    private String imageUrl;
    private String altText;
}
