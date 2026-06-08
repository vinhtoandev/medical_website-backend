package com.example.demo.controller;

import com.example.demo.dto.ApiResponse;
import com.example.demo.dto.ArticleDTO;
import com.example.demo.service.SearchService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Search Controller
 * Handles full-text and semantic search for articles
 */
@RestController
@RequestMapping("/api/search")
@RequiredArgsConstructor
@Tag(name = "Search", description = "Article search endpoints (full-text and semantic)")
public class SearchController {

    private final SearchService searchService;

    /**
     * Full-text search on articles
     * Searches in title, summary, and content
     */
    @GetMapping
    @Operation(summary = "Full-text search", description = "Search articles using PostgreSQL full-text search (title, summary, content)")
    public ResponseEntity<ApiResponse<List<ArticleDTO>>> fullTextSearch(
            @RequestParam String keyword) {
        List<ArticleDTO> results = searchService.fullTextSearch(keyword);
        return ResponseEntity.ok(ApiResponse.success("Search completed", results));
    }

    /**
     * Semantic search on articles
     * Uses pgvector and cosine similarity to find semantically similar articles
     */
    @GetMapping("/semantic")
    @Operation(summary = "Semantic search", description = "Search articles using semantic similarity with pgvector and OpenAI embeddings")
    public ResponseEntity<ApiResponse<List<ArticleDTO>>> semanticSearch(
            @RequestParam String query,
            @RequestParam(defaultValue = "10") int limit) {
        List<ArticleDTO> results = searchService.semanticSearch(query, limit);
        return ResponseEntity.ok(ApiResponse.success("Semantic search completed", results));
    }

    /**
     * Combined search (full-text + semantic)
     * Prioritizes full-text results and supplements with semantic search
     */
    @GetMapping("/combined")
    @Operation(summary = "Combined search", description = "Search articles using both full-text and semantic search")
    public ResponseEntity<ApiResponse<List<ArticleDTO>>> combinedSearch(
            @RequestParam String query,
            @RequestParam(defaultValue = "10") int limit) {
        List<ArticleDTO> results = searchService.combinedSearch(query, limit);
        return ResponseEntity.ok(ApiResponse.success("Combined search completed", results));
    }
}
