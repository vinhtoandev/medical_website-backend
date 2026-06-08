package com.example.demo.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3ClientBuilder;

/**
 * AWS S3 Configuration
 * Configures S3Client bean with credentials from environment variables
 */
@Slf4j
@Configuration
@RequiredArgsConstructor
public class AwsS3Config {

    @Value("${aws.s3.region}")
    private String awsRegion;

    @Value("${aws.s3.access-key-id:}")
    private String accessKeyId;

    @Value("${aws.s3.secret-access-key:}")
    private String secretAccessKey;

    /**
     * Create and configure S3Client bean
     * Uses AWS credentials from environment variables or application config
     */
    @Bean
    public S3Client s3Client() {
        S3ClientBuilder builder = S3Client.builder()
                .region(Region.of(awsRegion));

        // If credentials are provided, use them; otherwise use default credential provider chain
        if (accessKeyId != null && !accessKeyId.isEmpty() && 
            secretAccessKey != null && !secretAccessKey.isEmpty()) {
            AwsBasicCredentials credentials = AwsBasicCredentials.create(accessKeyId, secretAccessKey);
            builder.credentialsProvider(StaticCredentialsProvider.create(credentials));
            log.info("S3Client configured with provided AWS credentials");
        } else {
            log.info("S3Client configured with default AWS credential provider chain");
        }

        return builder.build();
    }
}
