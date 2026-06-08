package com.example.demo.service;

import com.example.demo.dto.ArticleDTO;
import com.example.demo.dto.ArticleImageDTO;
import com.example.demo.dto.CreateArticleRequest;
import com.example.demo.dto.UpdateArticleRequest;
import com.example.demo.entity.Article;
import com.example.demo.entity.ArticleImage;
import com.example.demo.entity.ArticleStatus;
import com.example.demo.entity.Category;
import com.example.demo.exception.EntityNotFoundException;
import com.example.demo.mapper.ArticleImageMapper;
import com.example.demo.mapper.ArticleMapper;
import com.example.demo.repository.ArticleImageRepository;
import com.example.demo.repository.ArticleRepository;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.util.SlugUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * Article Service for managing articles with embedding generation
 */
@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class ArticleService {

    private final ArticleRepository articleRepository;
    private final ArticleImageRepository articleImageRepository;
    private final CategoryRepository categoryRepository;
    private final ArticleMapper articleMapper;
    private final ArticleImageMapper articleImageMapper;
    private final EmbeddingService embeddingService;
    private final SlugUtil slugUtil;

    /** Regex to extract src from <img src="..."> tags */
    private static final Pattern IMG_SRC_PATTERN =
            Pattern.compile("<img[^>]+src=[\"']([^\"']+)[\"']", Pattern.CASE_INSENSITIVE);

    private static final int DEFAULT_PAGE = 0;
    private static final int DEFAULT_SIZE = 10;

    /**
     * Get all articles with pagination and filtering
     */
    @Transactional(readOnly = true)
    public Page<ArticleDTO> getAllArticles(int page, int size, Long categoryId, String sortBy) {
        Pageable pageable = createPageable(page, size, sortBy);

        Page<Article> articles;
        if (categoryId != null) {
            Category category = categoryRepository.findById(categoryId)
                    .orElseThrow(() -> new EntityNotFoundException("Category", categoryId.toString()));
            articles = articleRepository.findByCategoryAndStatusOrderByPublishedAtDesc(
                    category, ArticleStatus.PUBLISHED, pageable);
        } else {
            articles = articleRepository.findByStatusOrderByPublishedAtDesc(
                    ArticleStatus.PUBLISHED, pageable);
        }

        return articles.map(articleMapper::toDTO);
    }

    /**
     * Get article by ID
     */
    @Transactional(readOnly = true)
    public ArticleDTO getArticleById(Long id) {
        Article article = articleRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Article", id.toString()));

        // Increment view count
        incrementViewCount(article);

        return toDTOWithImages(article);
    }

    /**
     * Get article by slug
     */
    @Transactional(readOnly = true)
    public ArticleDTO getArticleBySlug(String slug) {
        Article article = articleRepository.findBySlug(slug)
                .orElseThrow(() -> new EntityNotFoundException("Article", slug));

        // Increment view count
        incrementViewCount(article);

        return toDTOWithImages(article);
    }

    /**
     * Create new article with thumbnail upload and embedding generation
     */
    public ArticleDTO createArticle(CreateArticleRequest request) {
        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new EntityNotFoundException("Category", request.getCategoryId().toString()));

        String slug = slugUtil.generateSlug(request.getTitle());

        // Check if slug already exists
        if (articleRepository.findBySlug(slug).isPresent()) {
            throw new IllegalArgumentException("Article with slug '" + slug + "' already exists");
        }

        // Generate embedding from title + summary
        String textForEmbedding = request.getTitle() + " " + request.getSummary();
        float[] embedding = embeddingService.generateEmbedding(textForEmbedding);
        String embeddingVector = embeddingService.embeddingToVectorString(embedding);

        ArticleStatus finalStatus = request.getStatus() != null ? request.getStatus() : ArticleStatus.DRAFT;

        Article article = Article.builder()
                .category(category)
                .title(request.getTitle())
                .slug(slug)
                .summary(request.getSummary())
                .content(request.getContent())
                .thumbnailUrl(request.getThumbnailUrl())
                .status(finalStatus)
                .publishedAt(finalStatus == ArticleStatus.PUBLISHED ? LocalDateTime.now() : null)
                .viewCount(0L)
                .embedding(embeddingVector)
                .build();

        Article savedArticle = articleRepository.save(article);
        syncArticleImages(savedArticle, request.getContent());
        log.info("Article created: {} ({})", savedArticle.getTitle(), savedArticle.getId());
        return articleMapper.toDTO(savedArticle);
    }

    /**
     * Update existing article and regenerate embedding
     */
    public ArticleDTO updateArticle(Long id, UpdateArticleRequest request) {
        Article article = articleRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Article", id.toString()));

        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new EntityNotFoundException("Category", request.getCategoryId().toString()));

        String newSlug = slugUtil.generateSlug(request.getTitle());

        // Check if new slug conflicts with other articles
        if (!article.getSlug().equals(newSlug) && articleRepository.findBySlug(newSlug).isPresent()) {
            throw new IllegalArgumentException("Article with slug '" + newSlug + "' already exists");
        }

        article.setTitle(request.getTitle());
        article.setSlug(newSlug);
        article.setSummary(request.getSummary());
        article.setContent(request.getContent());
        article.setThumbnailUrl(request.getThumbnailUrl());
        article.setCategory(category);

        if (request.getStatus() != null) {
            article.setStatus(request.getStatus());
            if (request.getStatus() == ArticleStatus.PUBLISHED && article.getPublishedAt() == null) {
                article.setPublishedAt(LocalDateTime.now());
            } else if (request.getStatus() == ArticleStatus.DRAFT) {
                article.setPublishedAt(null);
            }
        }

        // Regenerate embedding when content changes
        String textForEmbedding = request.getTitle() + " " + request.getSummary();
        float[] embedding = embeddingService.generateEmbedding(textForEmbedding);
        String embeddingVector = embeddingService.embeddingToVectorString(embedding);
        article.setEmbedding(embeddingVector);

        Article updatedArticle = articleRepository.save(article);
        syncArticleImages(updatedArticle, request.getContent());
        log.info("Article updated: {} ({})", updatedArticle.getTitle(), updatedArticle.getId());
        return articleMapper.toDTO(updatedArticle);
    }

    /**
     * Delete article
     */
    public void deleteArticle(Long id) {
        Article article = articleRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Article", id.toString()));

        // Remove associated image records first
        articleImageRepository.deleteByArticleId(id);
        articleRepository.delete(article);
        log.info("Article deleted: {} ({})", article.getTitle(), article.getId());
    }

    /**
     * Publish article (change status to PUBLISHED and set publishedAt)
     */
    public ArticleDTO publishArticle(Long id) {
        Article article = articleRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Article", id.toString()));

        article.setStatus(ArticleStatus.PUBLISHED);
        article.setPublishedAt(LocalDateTime.now());

        Article publishedArticle = articleRepository.save(article);
        log.info("Article published: {} ({})", publishedArticle.getTitle(), publishedArticle.getId());
        return articleMapper.toDTO(publishedArticle);
    }

    /**
     * Get related articles (same category + semantic similarity)
     */
    @Transactional(readOnly = true)
    public List<ArticleDTO> getRelatedArticles(Long articleId, int limit) {
        Article article = articleRepository.findById(articleId)
                .orElseThrow(() -> new EntityNotFoundException("Article", articleId.toString()));

        // Get articles from same category (first priority)
        Pageable pageable = PageRequest.of(0, limit);
        List<Article> categoryArticles = articleRepository
                .findByCategoryAndStatusAndIdNotOrderByPublishedAtDesc(
                        article.getCategory(), ArticleStatus.PUBLISHED, articleId, pageable);


        return categoryArticles.stream()
                .map(articleMapper::toDTO)
                .limit(limit)
                .collect(Collectors.toList());
    }

    /**
     * Get trending articles (most viewed)
     */
    @Transactional(readOnly = true)
    public Page<ArticleDTO> getTrendingArticles(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("viewCount").descending());
        Page<Article> articles = articleRepository.findByStatusOrderByViewCountDesc(
                ArticleStatus.PUBLISHED, pageable);
        return articles.map(articleMapper::toDTO);
    }

    /**
     * Increment view count for article
     */
    private void incrementViewCount(Article article) {
        article.setViewCount(article.getViewCount() + 1);
        articleRepository.save(article);
    }

    /**
     * Regenerate embeddings for all articles that have NULL embedding.
     * Calls OpenAI API for each article with a small delay to avoid rate limits.
     * Returns the number of articles processed.
     */
    public int regenerateAllEmbeddings() {
        List<Article> articles = articleRepository.findAll().stream()
                .filter(a -> a.getEmbedding() == null || a.getEmbedding().isBlank())
                .collect(Collectors.toList());

        log.info("Regenerating embeddings for {} articles without embedding", articles.size());
        int processed = 0;

        for (Article article : articles) {
            try {
                String textForEmbedding = article.getTitle() + " " + article.getSummary();
                float[] embedding = embeddingService.generateEmbedding(textForEmbedding);
                String embeddingVector = embeddingService.embeddingToVectorString(embedding);
                article.setEmbedding(embeddingVector);
                articleRepository.save(article);
                processed++;
                log.info("Embedding generated [{}/{}]: {}", processed, articles.size(), article.getSlug());

                // Small delay to avoid hitting OpenAI rate limits
                Thread.sleep(200);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log.error("Interrupted during embedding generation for article: {}", article.getSlug());
                break;
            } catch (Exception e) {
                log.error("Failed to generate embedding for article {}: {}", article.getSlug(), e.getMessage());
            }
        }

        log.info("Embedding regeneration complete. Processed: {}/{}", processed, articles.size());
        return processed;
    }

    /**
     * Create pageable object with sorting
     */
    private Pageable createPageable(int page, int size, String sortBy) {
        if (page < 0) page = DEFAULT_PAGE;
        if (size <= 0 || size > 100) size = DEFAULT_SIZE;

        Sort.Direction direction = Sort.Direction.DESC;
        String property = "publishedAt";

        if (sortBy != null) {
            if (sortBy.startsWith("-")) {
                direction = Sort.Direction.DESC;
                property = sortBy.substring(1);
            } else {
                direction = Sort.Direction.ASC;
                property = sortBy;
            }
        }

        return PageRequest.of(page, size, Sort.by(direction, property));
    }

    /**
     * Convert Article entity to DTO and attach its associated images.
     */
    private ArticleDTO toDTOWithImages(Article article) {
        ArticleDTO dto = articleMapper.toDTO(article);
        List<ArticleImageDTO> imageDTOs = articleImageRepository.findByArticleId(article.getId())
                .stream()
                .map(articleImageMapper::toDTO)
                .collect(Collectors.toList());
        dto.setImages(imageDTOs.isEmpty() ? null : imageDTOs);
        return dto;
    }

    /**
     * Parse HTML content, extract all <img src="..."> URLs,
     * delete old records for this article, then save new ones.
     * Skips base64 data URIs (they are not stored externally).
     */
    private void syncArticleImages(Article article, String htmlContent) {
        // Remove old image records for this article
        articleImageRepository.deleteByArticleId(article.getId());

        if (htmlContent == null || htmlContent.isBlank()) return;

        List<ArticleImage> images = new ArrayList<>();
        Matcher matcher = IMG_SRC_PATTERN.matcher(htmlContent);
        while (matcher.find()) {
            String src = matcher.group(1);
            // Skip base64-encoded images
            if (src.startsWith("data:")) continue;
            images.add(ArticleImage.builder()
                    .article(article)
                    .imageUrl(src)
                    .build());
        }

        if (!images.isEmpty()) {
            articleImageRepository.saveAll(images);
            log.info("Synced {} image(s) for article {}", images.size(), article.getId());
        }
    }
}
