package com.example.demo.entity;

/**
 * User role enum
 */
public enum UserRole {
    ADMIN("Administrator"),
    GUEST("Guest User");

    private final String displayName;

    UserRole(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
