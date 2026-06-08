package com.example.demo.util;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.UUID;

/**
 * Common utility functions
 */
public class CommonUtil {

    /**
     * Get current authenticated username from security context
     */
    public static String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getName();
        }
        return null;
    }

    /**
     * Check if user is authenticated
     */
    public static boolean isAuthenticated() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && authentication.isAuthenticated() && 
               !authentication.getPrincipal().equals("anonymousUser");
    }

    /**
     * Check if user has specific role
     */
    public static boolean hasRole(String role) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            return authentication.getAuthorities().stream()
                    .anyMatch(auth -> auth.getAuthority().equals("ROLE_" + role));
        }
        return false;
    }

    /**
     * Generate random UUID
     */
    public static String generateRandomId() {
        return UUID.randomUUID().toString();
    }

    /**
     * Generate random UUID without hyphens
     */
    public static String generateRandomIdWithoutHyphens() {
        return UUID.randomUUID().toString().replace("-", "");
    }
}
