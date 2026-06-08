package com.example.demo.repository;

import com.example.demo.entity.Article;
import com.example.demo.entity.ArticleStatus;
import com.example.demo.entity.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Article Repository with Full-Text Search and pgvector support
 */
@Repository
public interface ArticleRepository extends JpaRepository<Article, Long> {
    
    Optional<Article> findBySlug(String slug);

    Page<Article> findByCategoryAndStatusOrderByPublishedAtDesc(
            Category category, ArticleStatus status, Pageable pageable);

    Page<Article> findByStatusOrderByViewCountDesc(ArticleStatus status, Pageable pageable);

    Page<Article> findByStatusOrderByPublishedAtDesc(ArticleStatus status, Pageable pageable);

    /**
     * Full-text search using PostgreSQL FTS on title, summary, and content
     * Returns articles ordered by relevance
     */
    @Query(value = "SELECT a FROM Article a WHERE " +
            "a.status = 'PUBLISHED' AND (" +
            "LOWER(a.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(a.summary) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(a.content) LIKE LOWER(CONCAT('%', :keyword, '%'))" +
            ") ORDER BY " +
            "CASE WHEN LOWER(a.title) LIKE LOWER(CONCAT('%', :keyword, '%')) THEN 0 ELSE 1 END, " +
            "a.publishedAt DESC")
    List<Article> fullTextSearch(@Param("keyword") String keyword);

    /**
     * Paginated full-text search
     */
    @Query(value = "SELECT a FROM Article a WHERE " +
            "a.status = 'PUBLISHED' AND (" +
            "LOWER(a.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(a.summary) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(a.content) LIKE LOWER(CONCAT('%', :keyword, '%'))" +
            ") ORDER BY " +
            "CASE WHEN LOWER(a.title) LIKE LOWER(CONCAT('%', :keyword, '%')) THEN 0 ELSE 1 END, " +
            "a.publishedAt DESC")
    Page<Article> fullTextSearchPaginated(@Param("keyword") String keyword, Pageable pageable);

    /**
     * Semantic search using pgvector cosine distance
     * Returns articles similar to the given embedding vector
     * Note: This uses native query due to pgvector complexity
     */
    @Query(value = "SELECT a.* FROM articles a " +
            "WHERE a.embedding IS NOT NULL " +
            "AND a.status = 'PUBLISHED' " +
            "ORDER BY a.embedding <-> CAST(:embedding AS vector) LIMIT :limit",
            nativeQuery = true)
    List<Article> semanticSearch(@Param("embedding") String embedding, @Param("limit") Integer limit);

    /**
     * Find articles by category for related articles
     */
    List<Article> findByCategoryAndStatusAndIdNotOrderByPublishedAtDesc(
            Category category, ArticleStatus status, Long excludeId, Pageable pageable);

    /**
     * Trending articles (most viewed)
     */
    Page<Article> findByStatusOrderByViewCountDescPublishedAtDesc(ArticleStatus status, Pageable pageable);
}
