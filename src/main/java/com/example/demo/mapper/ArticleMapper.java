package com.example.demo.mapper;

import com.example.demo.dto.ArticleDTO;
import com.example.demo.dto.CreateArticleRequest;
import com.example.demo.dto.UpdateArticleRequest;
import com.example.demo.entity.Article;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

/**
 * MapStruct mapper for Article entity and DTO
 */
@Mapper(
        componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        uses = CategoryMapper.class
)
public interface ArticleMapper {
    ArticleDTO toDTO(Article entity);
    Article toEntity(ArticleDTO dto);
    Article toEntity(CreateArticleRequest request);
    void updateEntityFromRequest(UpdateArticleRequest request, @MappingTarget Article entity);
}
