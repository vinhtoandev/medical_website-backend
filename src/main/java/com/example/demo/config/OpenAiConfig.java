package com.example.demo.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

/**
 * OpenAI Configuration
 * Configures OpenAI client with API key from environment variables
 * 
 * Note: The actual OpenAI client is initialized lazily in the EmbeddingService
 */
@Slf4j
@Configuration
@RequiredArgsConstructor
public class OpenAiConfig {

    @Value("${openai.api-key}")
    private String apiKey;

    @Value("${openai.api-url}")
    private String apiUrl;

    @Value("${openai.embedding-model}")
    private String embeddingModel;

    @Value("${openai.embedding-dimensions}")
    private int embeddingDimensions;

    public String getApiKey() {
        return apiKey;
    }

    public String getApiUrl() {
        return apiUrl;
    }

    public String getEmbeddingModel() {
        return embeddingModel;
    }

    public int getEmbeddingDimensions() {
        return embeddingDimensions;
    }

    public void validateConfiguration() {
        if (apiKey == null || apiKey.isEmpty() || apiKey.equals("${OPENAI_API_KEY:}")) {
            log.warn("OpenAI API key is not configured. Semantic search will not work.");
        } else {
            log.info("OpenAI configuration loaded successfully. Model: {}", embeddingModel);
        }
    }
}
