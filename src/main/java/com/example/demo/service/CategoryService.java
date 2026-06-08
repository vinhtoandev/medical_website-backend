package com.example.demo.service;

import com.example.demo.dto.CategoryDTO;
import com.example.demo.dto.CreateCategoryRequest;
import com.example.demo.dto.UpdateCategoryRequest;
import com.example.demo.entity.Category;
import com.example.demo.exception.EntityNotFoundException;
import com.example.demo.mapper.CategoryMapper;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.util.SlugUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Category Service for managing article categories
 */
@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryRepository categoryRepository;
    private final CategoryMapper categoryMapper;
    private final SlugUtil slugUtil;

    /**
     * Get all categories
     */
    @Transactional(readOnly = true)
    public List<CategoryDTO> getAllCategories() {
        return categoryRepository.findAll().stream()
                .map(categoryMapper::toDTO)
                .collect(Collectors.toList());
    }

    /**
     * Get category by ID
     */
    @Transactional(readOnly = true)
    public CategoryDTO getCategoryById(Long id) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Category", id.toString()));
        return categoryMapper.toDTO(category);
    }

    /**
     * Get category by slug
     */
    @Transactional(readOnly = true)
    public CategoryDTO getCategoryBySlug(String slug) {
        Category category = categoryRepository.findBySlug(slug)
                .orElseThrow(() -> new EntityNotFoundException("Category", slug));
        return categoryMapper.toDTO(category);
    }

    /**
     * Create new category
     */
    public CategoryDTO createCategory(CreateCategoryRequest request) {
        String slug = slugUtil.generateSlug(request.getName());

        // Check if slug already exists
        if (categoryRepository.findBySlug(slug).isPresent()) {
            throw new IllegalArgumentException("Category with slug '" + slug + "' already exists");
        }

        Category category = Category.builder()
                .name(request.getName())
                .slug(slug)
                .description(request.getDescription())
                .build();

        Category savedCategory = categoryRepository.save(category);
        log.info("Category created: {} ({})", savedCategory.getName(), savedCategory.getId());
        return categoryMapper.toDTO(savedCategory);
    }

    /**
     * Update existing category
     */
    public CategoryDTO updateCategory(Long id, UpdateCategoryRequest request) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Category", id.toString()));

        String newSlug = slugUtil.generateSlug(request.getName());

        // Check if new slug conflicts with other categories
        if (!category.getSlug().equals(newSlug) && categoryRepository.findBySlug(newSlug).isPresent()) {
            throw new IllegalArgumentException("Category with slug '" + newSlug + "' already exists");
        }

        category.setName(request.getName());
        category.setSlug(newSlug);
        category.setDescription(request.getDescription());

        Category updatedCategory = categoryRepository.save(category);
        log.info("Category updated: {} ({})", updatedCategory.getName(), updatedCategory.getId());
        return categoryMapper.toDTO(updatedCategory);
    }

    /**
     * Delete category
     */
    public void deleteCategory(Long id) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Category", id.toString()));

        categoryRepository.delete(category);
        log.info("Category deleted: {} ({})", category.getName(), category.getId());
    }

    /**
     * Search categories by keyword
     */
    @Transactional(readOnly = true)
    public List<CategoryDTO> searchCategories(String keyword) {
        return categoryRepository.searchByKeyword(keyword).stream()
                .map(categoryMapper::toDTO)
                .collect(Collectors.toList());
    }
}
