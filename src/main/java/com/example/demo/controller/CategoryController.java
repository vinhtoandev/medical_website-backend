package com.example.demo.controller;

import com.example.demo.dto.ApiResponse;
import com.example.demo.dto.CategoryDTO;
import com.example.demo.dto.CreateCategoryRequest;
import com.example.demo.dto.UpdateCategoryRequest;
import com.example.demo.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Category Controller
 * Handles CRUD operations for article categories
 */
@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
@Tag(name = "Categories", description = "Article category management endpoints")
public class CategoryController {

    private final CategoryService categoryService;

    /**
     * Get all categories
     */
    @GetMapping
    @Operation(summary = "Get all categories", description = "Retrieve list of all article categories")
    public ResponseEntity<ApiResponse<List<CategoryDTO>>> getAllCategories() {
        List<CategoryDTO> categories = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success(categories));
    }

    /**
     * Get category by ID
     */
    @GetMapping("/{id}")
    @Operation(summary = "Get category by ID", description = "Retrieve specific category by its ID")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Category found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Category not found")
    })
    public ResponseEntity<ApiResponse<CategoryDTO>> getCategoryById(@PathVariable Long id) {
        CategoryDTO category = categoryService.getCategoryById(id);
        return ResponseEntity.ok(ApiResponse.success(category));
    }

    /**
     * Get category by slug
     */
    @GetMapping("/slug/{slug}")
    @Operation(summary = "Get category by slug", description = "Retrieve specific category by its URL slug")
    public ResponseEntity<ApiResponse<CategoryDTO>> getCategoryBySlug(@PathVariable String slug) {
        CategoryDTO category = categoryService.getCategoryBySlug(slug);
        return ResponseEntity.ok(ApiResponse.success(category));
    }

    /**
     * Create new category (ADMIN only)
     */
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Create new category", description = "Create a new article category (ADMIN only)")
    @SecurityRequirement(name = "bearerAuth")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Category created successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Unauthorized"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Forbidden")
    })
    public ResponseEntity<ApiResponse<CategoryDTO>> createCategory(
            @Valid @RequestBody CreateCategoryRequest request) {
        CategoryDTO category = categoryService.createCategory(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Category created successfully", category));
    }

    /**
     * Update category (ADMIN only)
     */
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Update category", description = "Update existing category (ADMIN only)")
    @SecurityRequirement(name = "bearerAuth")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Category updated successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Category not found")
    })
    public ResponseEntity<ApiResponse<CategoryDTO>> updateCategory(
            @PathVariable Long id,
            @Valid @RequestBody UpdateCategoryRequest request) {
        CategoryDTO category = categoryService.updateCategory(id, request);
        return ResponseEntity.ok(ApiResponse.success("Category updated successfully", category));
    }

    /**
     * Delete category (ADMIN only)
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Delete category", description = "Delete category by ID (ADMIN only)")
    @SecurityRequirement(name = "bearerAuth")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Category deleted successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Category not found")
    })
    public ResponseEntity<ApiResponse<?>> deleteCategory(@PathVariable Long id) {
        categoryService.deleteCategory(id);
        return ResponseEntity.ok(ApiResponse.success("Category deleted successfully", null));
    }

    /**
     * Search categories by keyword
     */
    @GetMapping("/search")
    @Operation(summary = "Search categories", description = "Search categories by keyword")
    public ResponseEntity<ApiResponse<List<CategoryDTO>>> searchCategories(
            @RequestParam String keyword) {
        List<CategoryDTO> categories = categoryService.searchCategories(keyword);
        return ResponseEntity.ok(ApiResponse.success(categories));
    }
}
