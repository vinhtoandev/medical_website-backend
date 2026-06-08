package com.example.demo.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Login Request DTO
 */
@Data
@NoArgsConstructor
public class LoginRequest {
    private String username;
    private String password;
}
