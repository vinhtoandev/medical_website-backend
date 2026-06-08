package com.example.demo.exception;

import org.springframework.http.HttpStatus;

/**
 * Exception thrown when an entity is not found
 */
public class EntityNotFoundException extends ApiException {
    public EntityNotFoundException(String message) {
        super(message, HttpStatus.NOT_FOUND.value(), "ENTITY_NOT_FOUND");
    }

    public EntityNotFoundException(String entityType, String identifier) {
        this(String.format("%s not found with identifier: %s", entityType, identifier));
    }
}
