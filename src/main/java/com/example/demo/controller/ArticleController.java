package com.example.demo.controller;

import com.example.demo.dto.ApiResponse;
import com.example.demo.dto.ArticleDTO;
import com.example.demo.dto.CreateArticleRequest;
import com.example.demo.dto.UpdateArticleRequest;
import com.example.demo.service.ArticleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Article Controller
 * Handles CRUD operations and retrieval of articles
 */
@RestController
@RequestMapping("/api/articles")
@RequiredArgsConstructor
@Tag(name = "Articles", description = "Article management and retrieval endpoints")
public class ArticleController {

    private final ArticleService articleService;

    private static final int DEFAULT_PAGE = 0;
    private static final int DEFAULT_SIZE = 10;

    /**
     * Get all articles with pagination and filtering
     */
    @GetMapping
    @Operation(summary = "Get all articles", description = "Retrieve paginated list of published articles with optional filtering")
    public ResponseEntity<ApiResponse<Page<ArticleDTO>>> getAllArticles(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String sortBy) {
        Page<ArticleDTO> articles = articleService.getAllArticles(page, size, categoryId, sortBy);
        return ResponseEntity.ok(ApiResponse.success(articles));
    }

    /**
     * Get article by ID
     */
    @GetMapping("/{id}")
    @Operation(summary = "Get article by ID", description = "Retrieve specific article by its ID and increment view count")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Article found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Article not found")
    })
    public ResponseEntity<ApiResponse<ArticleDTO>> getArticleById(@PathVariable Long id) {
        ArticleDTO article = articleService.getArticleById(id);
        return ResponseEntity.ok(ApiResponse.success(article));
    }

    /**
     * Get article by slug
     */
    @GetMapping("/slug/{slug}")
    @Operation(summary = "Get article by slug", description = "Retrieve specific article by its URL slug and increment view count")
    public ResponseEntity<ApiResponse<ArticleDTO>> getArticleBySlug(@PathVariable String slug) {
        ArticleDTO article = articleService.getArticleBySlug(slug);
        return ResponseEntity.ok(ApiResponse.success(article));
    }

    /**
     * Get related articles
     */
    @GetMapping("/{id}/related")
    @Operation(summary = "Get related articles", description = "Retrieve articles related to specified article (same category + semantic similarity)")
    public ResponseEntity<ApiResponse<List<ArticleDTO>>> getRelatedArticles(
            @PathVariable Long id,
            @RequestParam(defaultValue = "6") int limit) {
        List<ArticleDTO> relatedArticles = articleService.getRelatedArticles(id, limit);
        return ResponseEntity.ok(ApiResponse.success(relatedArticles));
    }

    /**
     * Get trending articles
     */
    @GetMapping("/trending")
    @Operation(summary = "Get trending articles", description = "Retrieve most viewed articles")
    public ResponseEntity<ApiResponse<Page<ArticleDTO>>> getTrendingArticles(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<ArticleDTO> trendingArticles = articleService.getTrendingArticles(page, size);
        return ResponseEntity.ok(ApiResponse.success(trendingArticles));
    }

    /**
     * Create new article (ADMIN only)
     */
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Create new article", description = "Create new article with automatic embedding generation (ADMIN only)")
    @SecurityRequirement(name = "bearerAuth")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Article created successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Unauthorized"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Forbidden")
    })
    public ResponseEntity<ApiResponse<ArticleDTO>> createArticle(
            @Valid @RequestBody CreateArticleRequest request) {
        ArticleDTO article = articleService.createArticle(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Article created successfully", article));
    }

    /**
     * Update article (ADMIN only)
     */
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Update article", description = "Update existing article with automatic embedding regeneration (ADMIN only)")
    @SecurityRequirement(name = "bearerAuth")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Article updated successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Article not found")
    })
    public ResponseEntity<ApiResponse<ArticleDTO>> updateArticle(
            @PathVariable Long id,
            @Valid @RequestBody UpdateArticleRequest request) {
        ArticleDTO article = articleService.updateArticle(id, request);
        return ResponseEntity.ok(ApiResponse.success("Article updated successfully", article));
    }

    /**
     * Delete article (ADMIN only)
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Delete article", description = "Delete article by ID (ADMIN only)")
    @SecurityRequirement(name = "bearerAuth")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Article deleted successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Article not found")
    })
    public ResponseEntity<ApiResponse<?>> deleteArticle(@PathVariable Long id) {
        articleService.deleteArticle(id);
        return ResponseEntity.ok(ApiResponse.success("Article deleted successfully", null));
    }

    /**
     * Publish article (ADMIN only)
     */
    @PostMapping("/{id}/publish")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Publish article", description = "Publish article and set publish date (ADMIN only)")
    @SecurityRequirement(name = "bearerAuth")
    public ResponseEntity<ApiResponse<ArticleDTO>> publishArticle(@PathVariable Long id) {
        ArticleDTO article = articleService.publishArticle(id);
        return ResponseEntity.ok(ApiResponse.success("Article published successfully", article));
    }

    /**
     * Regenerate embeddings for all articles without embedding (ADMIN only)
     * Runs asynchronously — returns immediately with a 202 Accepted.
     */
    @PostMapping("/regenerate-embeddings")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Regenerate embeddings", description = "Generate OpenAI embeddings for all articles that currently have none (ADMIN only)")
    @SecurityRequirement(name = "bearerAuth")
    public ResponseEntity<ApiResponse<String>> regenerateEmbeddings() {
        // Run in background thread so HTTP response is not blocked
        Thread worker = new Thread(() -> articleService.regenerateAllEmbeddings());
        worker.setDaemon(true);
        worker.setName("embedding-regenerator");
        worker.start();
        return ResponseEntity.accepted()
                .body(ApiResponse.success("Embedding regeneration started in background. Check server logs for progress.", null));
    }
}
