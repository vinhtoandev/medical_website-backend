# Derma Insight Backend - Setup Guide

## System Requirements

- Java 21 (JDK or JRE)
- Maven 3.9+
- Docker & Docker Compose
- PostgreSQL 14+ (if running without Docker)
- Node.js 18+ (for frontend, optional)

## Quick Start with Docker

### 1. Clone Repository
```bash
cd backend/demo
```

### 2. Build and Start Services
```bash
docker-compose up -d
```

This will:
- Start PostgreSQL 16 with pgvector extension
- Initialize database schema
- Build and run Spring Boot application

### 3. Verify Services
```bash
# Check Docker containers
docker-compose ps

# Test API health
curl http://localhost:8080/actuator/health

# Access Swagger UI
open http://localhost:8080/swagger-ui.html
```

### 4. Stop Services
```bash
docker-compose down
```

---

## Local Development Setup (Without Docker)

### 1. Prerequisites
- Install PostgreSQL 14+
- Install Java 21 JDK
- Install Maven 3.9+

### 2. Create Database
```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE derma_insight;
CREATE USER derma_user WITH PASSWORD 'derma_password';
GRANT ALL PRIVILEGES ON DATABASE derma_insight TO derma_user;

# Install pgvector extension
\c derma_insight
CREATE EXTENSION IF NOT EXISTS vector;
```

### 3. Configure Application
```bash
# Copy environment template
cp .env.example .env

# Edit .env with your configuration
nano .env
```

### 4. Build Application
```bash
mvn clean compile
```

### 5. Run Application
```bash
# Option 1: Using Maven
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"

# Option 2: Build and run JAR
mvn clean package
java -jar target/demo-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev
```

Application will start at `http://localhost:8080`

---

## Environment Configuration

### Development Environment

Create `.env` file in project root:

```bash
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=derma_insight
DB_USERNAME=postgres
DB_PASSWORD=postgres

# JWT Secret (min 32 characters)
JWT_SECRET=dev-secret-key-min-32-chars-required-for-hs512-algorithm

# AWS S3 (optional for local dev)
AWS_S3_BUCKET=derma-insight-dev
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=

# OpenAI (optional for semantic search)
OPENAI_API_KEY=

# Spring Profile
SPRING_PROFILES_ACTIVE=dev
```

### Production Environment

Set system environment variables or use ECS task definitions:

```bash
export SPRING_DATASOURCE_URL=jdbc:postgresql://rds-endpoint:5432/derma_insight
export SPRING_DATASOURCE_USERNAME=admin
export SPRING_DATASOURCE_PASSWORD=your-secure-password
export JWT_SECRET=your-production-secret-key
export AWS_S3_BUCKET=derma-insight-prod
export AWS_REGION=us-east-1
export AWS_ACCESS_KEY_ID=your-aws-key
export AWS_SECRET_ACCESS_KEY=your-aws-secret
export OPENAI_API_KEY=sk-your-api-key
export SPRING_PROFILES_ACTIVE=prod
```

---

## API Documentation

Swagger UI is available at: **http://localhost:8080/swagger-ui.html**

OpenAPI spec: **http://localhost:8080/v3/api-docs**

### Authentication

1. **Login** - POST `/api/auth/login`
   - Username: `admin`
   - Password: `demo`
   - Returns: `accessToken` + `refreshToken`

2. **Use Token** - Add to request header:
   ```
   Authorization: Bearer <accessToken>
   ```

3. **Refresh Token** - POST `/api/auth/refresh`
   - Send `refreshToken` to get new `accessToken`

---

## Key API Endpoints

### Articles
- `GET /api/articles` - List published articles (paginated)
- `GET /api/articles/{id}` - Get article by ID
- `GET /api/articles/slug/{slug}` - Get article by slug
- `POST /api/articles` - Create article (ADMIN)
- `PUT /api/articles/{id}` - Update article (ADMIN)
- `DELETE /api/articles/{id}` - Delete article (ADMIN)
- `GET /api/articles/{id}/related` - Get related articles
- `POST /api/articles/{id}/publish` - Publish article (ADMIN)

### Categories
- `GET /api/categories` - List all categories
- `GET /api/categories/{id}` - Get category by ID
- `POST /api/categories` - Create category (ADMIN)
- `PUT /api/categories/{id}` - Update category (ADMIN)
- `DELETE /api/categories/{id}` - Delete category (ADMIN)

### Search
- `GET /api/search?keyword=...` - Full-text search
- `GET /api/search/semantic?query=...` - Semantic search

### Uploads
- `POST /api/uploads/image` - Upload image to S3 (ADMIN)

---

## Database Migrations

### Auto-Migration (Development Only)

In `application-dev.yml`:
```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: update  # Auto-update schema
```

### Manual Migration (Production)

1. **Apply initial schema**:
   ```bash
   psql -U postgres -d derma_insight -f src/main/resources/db/schema.sql
   ```

2. **Install pgvector extension**:
   ```bash
   psql -U postgres -d derma_insight -f src/main/resources/db/init-pgvector.sql
   ```

3. **In production**, use:
   ```yaml
   spring:
     jpa:
       hibernate:
         ddl-auto: validate  # Only validate schema
   ```

---

## Testing

### Unit Tests
```bash
mvn test
```

### Integration Tests
```bash
mvn verify
```

### Test Coverage
```bash
mvn test jacoco:report
# Open: target/site/jacoco/index.html
```

---

## Common Issues & Solutions

### Issue: PostgreSQL Connection Refused
**Solution**: 
- Ensure PostgreSQL is running: `docker-compose ps`
- Check database credentials in `.env`
- Verify port 5432 is available: `lsof -i :5432`

### Issue: pgvector Extension Not Found
**Solution**:
- Rebuild Docker image: `docker-compose build --no-cache postgres`
- Manually create extension: `CREATE EXTENSION IF NOT EXISTS vector;`

### Issue: JWT Token Invalid
**Solution**:
- Regenerate JWT_SECRET (must be ≥32 characters)
- Ensure token not expired (default: 1 hour)
- Check Authorization header format: `Bearer <token>`

### Issue: S3 Upload Fails
**Solution**:
- Verify AWS credentials in `.env`
- Check S3 bucket exists in correct region
- Verify bucket policy allows uploads
- Check file type is allowed (jpeg, png, gif, webp)

### Issue: Semantic Search Returns Empty
**Solution**:
- Verify OpenAI API key is configured
- Check OpenAI API key has sufficient credits
- Ensure article embedding was generated (check database)
- Test with OpenAI API directly

---

## Deployment

### Docker Push to ECR
```bash
# Build image
docker build -t derma-insight-api:latest .

# Tag for ECR
docker tag derma-insight-api:latest <aws-account>.dkr.ecr.us-east-1.amazonaws.com/derma-insight-api:latest

# Push to ECR
docker push <aws-account>.dkr.ecr.us-east-1.amazonaws.com/derma-insight-api:latest
```

### AWS ECS Deployment
```bash
# Create task definition
aws ecs register-task-definition \
  --cli-input-json file://task-definition.json

# Create service
aws ecs create-service \
  --cluster derma-insight \
  --service-name derma-insight-api \
  --task-definition derma-insight-api \
  --desired-count 2
```

### Kubernetes Deployment
```bash
# Apply manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml

# Check deployment
kubectl get deployments
kubectl get pods
kubectl logs -f deployment/derma-insight-api
```

---

## Performance Optimization

### Database Optimization
- Indexes are already created on frequently queried columns
- Use pgvector HNSW index for faster semantic search
- Monitor slow queries: `SET log_min_duration_statement = 1000;`

### Application Optimization
- Enable HTTP compression in `application.yml`
- Configure connection pooling (HikariCP)
- Implement caching for categories
- Use pagination for large datasets (default: 10 items/page)

### Vector Search Performance
- Use HNSW index instead of IVFFLAT for production
- Limit semantic search results
- Cache embedding results
- Consider approximation for very large datasets

---

## Monitoring & Logging

### Application Logs
- Located in: `/app/logs/` (Docker) or `logs/` (local)
- Log level controlled in `application.yml`

### Database Monitoring
```bash
# Connect to database
docker exec -it derma-insight-db psql -U postgres -d derma_insight

# Check index usage
SELECT schemaname, tablename, indexname, idx_scan 
FROM pg_stat_user_indexes 
ORDER BY idx_scan DESC;

# Check slow queries
SELECT query, calls, mean_exec_time 
FROM pg_stat_statements 
ORDER BY mean_exec_time DESC;
```

### Health Check
```bash
curl http://localhost:8080/actuator/health
```

---

## Backup & Recovery

### Backup PostgreSQL
```bash
# Backup to file
docker exec derma-insight-db pg_dump -U postgres derma_insight > backup.sql

# Backup with compression
docker exec derma-insight-db pg_dump -U postgres -Fc derma_insight > backup.dump
```

### Restore PostgreSQL
```bash
# From SQL dump
docker exec -i derma-insight-db psql -U postgres derma_insight < backup.sql

# From compressed dump
docker exec -i derma-insight-db pg_restore -U postgres -d derma_insight backup.dump
```

---

## Support & Documentation

- API Documentation: http://localhost:8080/swagger-ui.html
- GitHub Issues: [Project Repository]
- Discussion Forum: [Community Forum]
- Email: support@derma-insight.com

---

**Last Updated**: 2024
**Version**: 1.0.0
