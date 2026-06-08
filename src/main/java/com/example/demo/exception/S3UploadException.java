package com.example.demo.exception;

import org.springframework.http.HttpStatus;

/**
 * Exception thrown when S3 upload fails
 */
public class S3UploadException extends ApiException {
    public S3UploadException(String message) {
        super(message, HttpStatus.INTERNAL_SERVER_ERROR.value(), "S3_UPLOAD_ERROR");
    }

    public S3UploadException(String message, Throwable cause) {
        super(message, cause, HttpStatus.INTERNAL_SERVER_ERROR.value(), "S3_UPLOAD_ERROR");
    }
}
