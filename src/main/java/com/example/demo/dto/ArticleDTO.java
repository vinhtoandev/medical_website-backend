package com.example.demo.dto;

import com.example.demo.entity.ArticleStatus;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Article DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ArticleDTO {
    private Long id;
    private Long categoryId;
    private CategoryDTO category;
    private String title;
    private String slug;
    private String summary;
    private String content;
    private String thumbnailUrl;
    private ArticleStatus status;
    private Long viewCount;
    private LocalDateTime publishedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Float relevanceScore; // For search results
    private List<ArticleImageDTO> images; // Images embedded in content
}
