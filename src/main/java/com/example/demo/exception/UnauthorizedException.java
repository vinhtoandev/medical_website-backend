package com.example.demo.exception;

import org.springframework.http.HttpStatus;

/**
 * Exception thrown when user is unauthorized
 */
public class UnauthorizedException extends ApiException {
    public UnauthorizedException(String message) {
        super(message, HttpStatus.UNAUTHORIZED.value(), "UNAUTHORIZED");
    }

    public UnauthorizedException() {
        super("Invalid credentials or token", HttpStatus.UNAUTHORIZED.value(), "UNAUTHORIZED");
    }
}
