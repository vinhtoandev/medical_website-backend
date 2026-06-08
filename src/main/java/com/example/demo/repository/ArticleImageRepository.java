package com.example.demo.repository;

import com.example.demo.entity.ArticleImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Article Image Repository
 */
@Repository
public interface ArticleImageRepository extends JpaRepository<ArticleImage, Long> {
    List<ArticleImage> findByArticleId(Long articleId);
    void deleteByArticleId(Long articleId);
}
