package com.example.demo.entity;

/**
 * Article status enum
 */
public enum ArticleStatus {
    DRAFT("Draft"),
    PUBLISHED("Published");

    private final String displayName;

    ArticleStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
