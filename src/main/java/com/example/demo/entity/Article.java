package com.example.demo.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnTransformer;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.elasticsearch.annotations.Document;

import java.time.LocalDateTime;

/**
 * Article Entity with pgvector support for semantic search
 */
@Entity
@Table(name = "articles", indexes = {
        @Index(name = "idx_article_slug", columnList = "slug", unique = true),
        @Index(name = "idx_article_category", columnList = "category_id"),
        @Index(name = "idx_article_status_published", columnList = "status, published_at"),
        @Index(name = "idx_article_view_count", columnList = "view_count")
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Article {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Column(nullable = false, length = 255)
    private String title;

    @Column(nullable = false, unique = true, length = 255)
    private String slug;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String summary;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(name = "thumbnail_url", columnDefinition = "TEXT")
    private String thumbnailUrl;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private ArticleStatus status = ArticleStatus.DRAFT;

    @Column(name = "view_count")
    @Builder.Default
    private Long viewCount = 0L;

    @Column(name = "published_at")
    private LocalDateTime publishedAt;

    /**
     * PostgreSQL pgvector column for semantic search
     * Stores embedding vector (1536 dimensions from OpenAI text-embedding-3-small)
     * Uses @ColumnTransformer to cast String to vector on write
     */
    @Column(name = "embedding", columnDefinition = "vector(1536)")
    @ColumnTransformer(write = "?::vector")
    private String embedding;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(nullable = false)
    private LocalDateTime updatedAt;
}
