package com.example.demo.service;

import com.example.demo.dto.AuthResponse;
import com.example.demo.dto.LoginRequest;
import com.example.demo.dto.RefreshTokenRequest;
import com.example.demo.entity.RefreshToken;
import com.example.demo.exception.UnauthorizedException;
import com.example.demo.repository.RefreshTokenRepository;
import com.example.demo.security.JwtProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * Authentication Service for handling login, token refresh, and logout
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtProvider jwtProvider;
    private final RefreshTokenRepository refreshTokenRepository;

    /**
     * Authenticate user and generate JWT tokens
     */
    public AuthResponse login(LoginRequest request) throws UnauthorizedException {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getUsername(),
                            request.getPassword()
                    )
            );

            String accessToken = jwtProvider.generateAccessToken(request.getUsername());
            String refreshToken = jwtProvider.generateRefreshToken(request.getUsername());

            // Save refresh token to database
            long refreshTokenExpirationTime = jwtProvider.getTokenExpirationTime(refreshToken);
            RefreshToken tokenEntity = RefreshToken.builder()
                    .token(refreshToken)
                    .expiredAt(LocalDateTime.now().plusSeconds(refreshTokenExpirationTime / 1000))
                    .build();
            refreshTokenRepository.save(tokenEntity);

            log.info("User logged in successfully: {}", request.getUsername());

            return AuthResponse.builder()
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .username(request.getUsername())
                    .tokenType("Bearer")
                    .expiresIn(3600)
                    .build();

        } catch (Exception e) {
            log.error("Login failed for user: {} - Error: {}", request.getUsername(), e.getMessage(), e);
            throw new UnauthorizedException("Invalid username or password");
        }
    }

    /**
     * Refresh access token using refresh token
     */
    public AuthResponse refreshToken(RefreshTokenRequest request) throws UnauthorizedException {
        RefreshToken storedToken = refreshTokenRepository.findByToken(request.getRefreshToken())
                .orElseThrow(() -> new UnauthorizedException("Invalid refresh token"));

        // Check if refresh token is expired
        if (storedToken.getExpiredAt().isBefore(LocalDateTime.now())) {
            refreshTokenRepository.delete(storedToken);
            throw new UnauthorizedException("Refresh token has expired");
        }

        // Validate token
        if (!jwtProvider.validateToken(request.getRefreshToken())) {
            throw new UnauthorizedException("Invalid refresh token");
        }

        String username = jwtProvider.getUsernameFromToken(request.getRefreshToken());
        String newAccessToken = jwtProvider.generateAccessToken(username);

        log.info("Token refreshed successfully for user: {}", username);

        return AuthResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(request.getRefreshToken())
                .username(username)
                .tokenType("Bearer")
                .expiresIn(3600)
                .build();
    }

    /**
     * Logout by deleting refresh token
     */
    public void logout(String refreshToken) {
        RefreshToken tokenEntity = refreshTokenRepository.findByToken(refreshToken)
                .orElse(null);

        if (tokenEntity != null) {
            refreshTokenRepository.delete(tokenEntity);
            log.info("User logged out successfully");
        }
    }

    /**
     * Clean up expired refresh tokens
     */
    public void cleanupExpiredTokens() {
        refreshTokenRepository.deleteByExpiredAtBefore(LocalDateTime.now());
        log.info("Expired refresh tokens cleaned up");
    }
}
