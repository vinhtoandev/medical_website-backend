package com.example.demo.mapper;

import com.example.demo.dto.ArticleImageDTO;
import com.example.demo.entity.ArticleImage;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

/**
 * MapStruct mapper for ArticleImage entity and DTO
 */
@Mapper(
        componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface ArticleImageMapper {
    ArticleImageDTO toDTO(ArticleImage entity);
    ArticleImage toEntity(ArticleImageDTO dto);
}
