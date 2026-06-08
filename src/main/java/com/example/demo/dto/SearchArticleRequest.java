package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Search Articles Request DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SearchArticleRequest {
    private String keyword;
    private Integer page;
    private Integer size;
}
