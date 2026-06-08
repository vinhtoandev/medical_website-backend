package com.example.demo.service;

import com.example.demo.dto.ArticleDTO;
import com.example.demo.entity.Article;
import com.example.demo.mapper.ArticleMapper;
import com.example.demo.repository.ArticleRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Search Service for full-text and semantic search
 */
@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class SearchService {

    private final ArticleRepository articleRepository;
    private final ArticleMapper articleMapper;
    private final EmbeddingService embeddingService;

    /**
     * Full-text search on articles (PostgreSQL FTS)
     * Searches in title, summary, and content
     */
    public List<ArticleDTO> fullTextSearch(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return List.of();
        }

        log.info("Performing full-text search for keyword: {}", keyword);
        List<Article> articles = articleRepository.fullTextSearch(keyword.trim());

        return articles.stream()
                .map(articleMapper::toDTO)
                .collect(Collectors.toList());
    }

    /**
     * Semantic search using pgvector
     * Generates embedding for query and finds similar articles using cosine distance
     */
    public List<ArticleDTO> semanticSearch(String query, int limit) {
        if (query == null || query.trim().isEmpty()) {
            return List.of();
        }

        if (limit <= 0 || limit > 100) {
            limit = 10;
        }

        log.info("Performing semantic search for query: {}", query);

        try {
            // Generate embedding for the query
            float[] queryEmbedding = embeddingService.generateEmbedding(query.trim());
            String embeddingVector = embeddingService.embeddingToVectorString(queryEmbedding);

            // Search for similar articles using pgvector
            List<Article> articles = articleRepository.semanticSearch(embeddingVector, limit);

            return articles.stream()
                    .map(articleMapper::toDTO)
                    .collect(Collectors.toList());

        } catch (Exception e) {
            log.error("Error during semantic search: {}", e.getMessage());
            return List.of();
        }
    }

    /**
     * Combined search: prioritize full-text results, supplement with semantic
     */
    public List<ArticleDTO> combinedSearch(String query, int limit) {
        if (query == null || query.trim().isEmpty()) {
            return List.of();
        }

        if (limit <= 0 || limit > 100) {
            limit = 10;
        }

        log.info("Performing combined search for query: {}", query);

        try {
            // First, try full-text search
            List<ArticleDTO> fullTextResults = fullTextSearch(query);

            if (fullTextResults.size() >= limit) {
                return fullTextResults.stream().limit(limit).collect(Collectors.toList());
            }

            // If not enough results, supplement with semantic search
            List<ArticleDTO> semanticResults = semanticSearch(query, limit - fullTextResults.size());
            
            // Combine results, avoiding duplicates
            return fullTextResults.stream()
                    .collect(Collectors.toCollection(() -> 
                            semanticResults.stream()
                                    .filter(semantic -> !fullTextResults.stream()
                                            .anyMatch(fullText -> fullText.getId().equals(semantic.getId())))
                                    .collect(Collectors.toCollection(() -> new java.util.ArrayList<>(fullTextResults)))
                    ))
                    .stream()
                    .limit(limit)
                    .collect(Collectors.toList());

        } catch (Exception e) {
            log.error("Error during combined search: {}", e.getMessage());
            return List.of();
        }
    }
}
