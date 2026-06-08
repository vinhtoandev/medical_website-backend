package com.example.demo.service;

import com.example.demo.config.OpenAiConfig;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Embedding Service for generating embeddings using OpenAI API
 * Uses text-embedding-3-small model
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class EmbeddingService {

    private final OpenAiConfig openAiConfig;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final HttpClient httpClient = HttpClient.newHttpClient();

    /**
     * Generate embedding for given text using OpenAI API
     * Returns a float array of 1536 dimensions (text-embedding-3-small)
     */
    public float[] generateEmbedding(String text) {
        if (text == null || text.isEmpty()) {
            log.warn("Empty text provided for embedding generation");
            return new float[openAiConfig.getEmbeddingDimensions()];
        }

        if (openAiConfig.getApiKey() == null || openAiConfig.getApiKey().isEmpty()) {
            log.error("OpenAI API key not configured");
            return generateDummyEmbedding();
        }

        try {
            // Limit text to 8191 tokens (approximate)
            String truncatedText = truncateText(text, 8000);
            
            // Create request body
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", openAiConfig.getEmbeddingModel());
            requestBody.put("input", truncatedText);
            requestBody.put("encoding_format", "float");

            String jsonBody = objectMapper.writeValueAsString(requestBody);

            // Create HTTP request
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(openAiConfig.getApiUrl() + "/embeddings"))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + openAiConfig.getApiKey())
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .build();

            // Send request
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                log.error("OpenAI API error: {}", response.body());
                return generateDummyEmbedding();
            }

            // Parse response
            JsonNode responseJson = objectMapper.readTree(response.body());
            JsonNode dataArray = responseJson.get("data");

            if (dataArray.isArray() && dataArray.size() > 0) {
                JsonNode embeddingNode = dataArray.get(0).get("embedding");
                List<Float> embeddingList = new ArrayList<>();
                
                embeddingNode.forEach(node -> embeddingList.add((float) node.asDouble()));
                
                float[] embedding = new float[embeddingList.size()];
                for (int i = 0; i < embeddingList.size(); i++) {
                    embedding[i] = embeddingList.get(i);
                }
                
                log.debug("Generated embedding of size: {}", embedding.length);
                return embedding;
            }

            log.warn("No embedding data in OpenAI response");
            return generateDummyEmbedding();

        } catch (IOException | InterruptedException e) {
            log.error("Error calling OpenAI API: {}", e.getMessage());
            Thread.currentThread().interrupt();
            return generateDummyEmbedding();
        }
    }

    /**
     * Convert embedding (float array) to PostgreSQL vector string format
     * Format: [0.1, 0.2, 0.3, ...]
     */
    public String embeddingToVectorString(float[] embedding) {
        if (embedding == null || embedding.length == 0) {
            return null;
        }

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < embedding.length; i++) {
            sb.append(embedding[i]);
            if (i < embedding.length - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }

    /**
     * Convert PostgreSQL vector string to embedding (float array)
     */
    public float[] vectorStringToEmbedding(String vectorString) {
        if (vectorString == null || vectorString.isEmpty()) {
            return new float[0];
        }

        // Remove brackets and split by comma
        String cleaned = vectorString.replaceAll("[\\[\\]]", "").trim();
        String[] parts = cleaned.split(",");
        
        float[] embedding = new float[parts.length];
        for (int i = 0; i < parts.length; i++) {
            embedding[i] = Float.parseFloat(parts[i].trim());
        }
        return embedding;
    }

    /**
     * Calculate cosine similarity between two embeddings
     */
    public double cosineSimilarity(float[] embedding1, float[] embedding2) {
        if (embedding1.length != embedding2.length) {
            throw new IllegalArgumentException("Embeddings must have same dimension");
        }

        double dotProduct = 0.0;
        double norm1 = 0.0;
        double norm2 = 0.0;

        for (int i = 0; i < embedding1.length; i++) {
            dotProduct += embedding1[i] * embedding2[i];
            norm1 += embedding1[i] * embedding1[i];
            norm2 += embedding2[i] * embedding2[i];
        }

        double denominator = Math.sqrt(norm1) * Math.sqrt(norm2);
        if (denominator == 0) {
            return 0.0;
        }

        return dotProduct / denominator;
    }

    /**
     * Generate dummy embedding for development/testing when API key is not available
     */
    private float[] generateDummyEmbedding() {
        float[] dummy = new float[openAiConfig.getEmbeddingDimensions()];
        for (int i = 0; i < dummy.length; i++) {
            dummy[i] = (float) Math.random();
        }
        return dummy;
    }

    /**
     * Truncate text to approximate token limit
     * OpenAI API has token limits; approximate 1 token = 4 characters
     */
    private String truncateText(String text, int maxChars) {
        if (text.length() > maxChars) {
            return text.substring(0, maxChars) + "...";
        }
        return text;
    }
}
