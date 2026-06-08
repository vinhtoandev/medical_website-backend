package com.example.demo.mapper;

import com.example.demo.dto.CategoryDTO;
import com.example.demo.dto.CreateCategoryRequest;
import com.example.demo.entity.Category;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

/**
 * MapStruct mapper for Category entity and DTO
 */
@Mapper(
        componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface CategoryMapper {
    CategoryDTO toDTO(Category entity);
    Category toEntity(CategoryDTO dto);
    Category toEntity(CreateCategoryRequest request);
}
