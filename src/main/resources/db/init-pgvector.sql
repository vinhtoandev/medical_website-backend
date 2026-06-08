-- Initialize pgvector extension for PostgreSQL
-- This script must be run with superuser privileges

-- Create vector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Verify extension is installed
SELECT * FROM pg_extension WHERE extname = 'vector';
