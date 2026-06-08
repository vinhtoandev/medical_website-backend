package com.example.demo.dto;

import com.example.demo.entity.ArticleStatus;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Create Article Request DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateArticleRequest {
    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Summary is required")
    private String summary;

    @NotBlank(message = "Content is required")
    private String content;

    private String thumbnailUrl;

    @NotNull(message = "Category ID is required")
    private Long categoryId;

    @Builder.Default
    private ArticleStatus status = ArticleStatus.DRAFT;
}
