-- PostgreSQL Database Schema for Derma Insight
-- Includes pgvector support for semantic search

-- Categories Table
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_category_slug ON categories(slug);

-- Articles Table
CREATE TABLE articles (
    id BIGSERIAL PRIMARY KEY,
    category_id BIGINT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    summary TEXT NOT NULL,
    content TEXT NOT NULL,
    thumbnail_url TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'PUBLISHED')),
    view_count BIGINT DEFAULT 0,
    published_at TIMESTAMP,
    embedding vector(1536),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_article_slug ON articles(slug);
CREATE INDEX idx_article_category_id ON articles(category_id);
CREATE INDEX idx_article_status_published_at ON articles(status, published_at);
CREATE INDEX idx_article_view_count ON articles(view_count);
-- Vector index using HNSW for faster semantic search
CREATE INDEX idx_article_embedding ON articles USING hnsw (embedding vector_cosine_ops);

-- Full-text search index on articles
CREATE INDEX idx_article_fts ON articles USING GIN (
    to_tsvector('english', title || ' ' || summary || ' ' || content)
);

-- Article Images Table (metadata for images in article content)
CREATE TABLE article_images (
    id BIGSERIAL PRIMARY KEY,
    article_id BIGINT NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    alt_text TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_article_image_article_id ON article_images(article_id);

-- Refresh Tokens Table
CREATE TABLE refresh_tokens (
    id BIGSERIAL PRIMARY KEY,
    token VARCHAR(500) NOT NULL UNIQUE,
    expired_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_refresh_token_token ON refresh_tokens(token);
CREATE INDEX idx_refresh_token_expired_at ON refresh_tokens(expired_at);

-- Clean up old refresh tokens (can be run periodically)
-- DELETE FROM refresh_tokens WHERE expired_at < CURRENT_TIMESTAMP;
