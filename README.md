# Derma Insight Backend API

A production-grade, scalable backend for a dermatology news and knowledge platform built with Spring Boot 4, PostgreSQL, and AWS.

## 🎯 Overview

Derma Insight Backend provides a comprehensive REST API for managing dermatology articles, categories, and enabling intelligent search through both full-text and semantic (AI-powered) search capabilities.

**Key Features:**
- 🔐 JWT-based authentication with role-based access control
- 📰 Complete article CRUD operations with automatic slug generation
- 🏷️ Category management for article organization
- 🔍 Dual-mode search: Full-text search (PostgreSQL FTS) + Semantic search (pgvector)
- 🤖 Automatic embedding generation with OpenAI API
- ☁️ AWS S3 integration for image storage
- 🐘 PostgreSQL with pgvector extension for AI-powered similarity search
- 📖 Auto-generated Swagger UI documentation
- 🐳 Docker & Docker Compose support for easy deployment
- ⚡ Clean Architecture with service layer pattern
- 🛡️ Comprehensive error handling & validation

---

## 📊 Architecture

### Clean Architecture Layers
```
┌─────────────────────────────────────────┐
│         REST Controllers                │
│  (AuthController, ArticleController)    │
└────────────────┬────────────────────────┘
                 │
┌────────────────┴────────────────────────┐
│         Service Layer                   │
│ (ArticleService, CategoryService, etc)  │
└────────────────┬────────────────────────┘
                 │
┌────────────────┴────────────────────────┐
│        Repository Layer                 │
│   (JPA Repositories with Queries)       │
└────────────────┬────────────────────────┘
                 │
┌────────────────┴────────────────────────┐
│        Entity Layer                     │
│   (JPA Entities, DTOs, Mappers)         │
└────────────────┬────────────────────────┘
                 │
┌────────────────┴────────────────────────┐
│        Data Layer                       │
│  (PostgreSQL + pgvector + S3)           │
└─────────────────────────────────────────┘
```

### Technology Stack

| Layer | Technology |
|-------|-----------|
| **Runtime** | Java 21, Spring Boot 4.0.6 |
| **Database** | PostgreSQL 16 + pgvector |
| **Search** | PostgreSQL Full-Text Search + pgvector (cosine similarity) |
| **AI/ML** | OpenAI text-embedding-3-small (1536 dimensions) |
| **Authentication** | JWT (JJWT) |
| **Storage** | AWS S3 |
| **ORM** | Spring Data JPA + Hibernate |
| **Mapping** | MapStruct |
| **Validation** | Jakarta Validation (Bean Validation) |
| **API Documentation** | Springdoc OpenAPI (Swagger 3.0) |
| **Containerization** | Docker & Docker Compose |
| **Build Tool** | Maven 3.9 |

---

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Java 21 (for local development)
- Maven 3.9+ (for local development)

### Option 1: Docker Compose (Recommended)

```bash
# Navigate to backend folder
cd backend/demo

# Start services
docker-compose up -d

# Verify services running
docker-compose ps

# Access API
open http://localhost:8080/swagger-ui.html
```

### Option 2: Local Development

```bash
# Install PostgreSQL 16 with pgvector extension

# Configure environment
cp .env.example .env
nano .env

# Build project
mvn clean compile

# Run application
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"

# Access API at http://localhost:8080
```

---

## 🔐 Authentication

### Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "demo"
  }'
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "accessToken": "eyJhbGciOiJIUzUxMiJ9...",
    "refreshToken": "eyJhbGciOiJIUzUxMiJ9...",
    "username": "admin",
    "tokenType": "Bearer",
    "expiresIn": 3600
  }
}
```

### Use Token in Requests
```bash
curl -X GET http://localhost:8080/api/articles/1 \
  -H "Authorization: Bearer <accessToken>"
```

---

## 📚 API Endpoints

### Authentication
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|----------------|
| POST | `/api/auth/login` | User login | ❌ |
| POST | `/api/auth/refresh` | Refresh access token | ❌ |
| POST | `/api/auth/logout` | User logout | ✅ |

### Articles
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|----------------|
| GET | `/api/articles` | List published articles (paginated) | ❌ |
| GET | `/api/articles/{id}` | Get article by ID | ❌ |
| GET | `/api/articles/slug/{slug}` | Get article by slug | ❌ |
| GET | `/api/articles/{id}/related` | Get related articles | ❌ |
| POST | `/api/articles` | Create article | ✅ ADMIN |
| PUT | `/api/articles/{id}` | Update article | ✅ ADMIN |
| DELETE | `/api/articles/{id}` | Delete article | ✅ ADMIN |
| POST | `/api/articles/{id}/publish` | Publish article | ✅ ADMIN |

### Categories
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|----------------|
| GET | `/api/categories` | List all categories | ❌ |
| GET | `/api/categories/{id}` | Get category by ID | ❌ |
| POST | `/api/categories` | Create category | ✅ ADMIN |
| PUT | `/api/categories/{id}` | Update category | ✅ ADMIN |
| DELETE | `/api/categories/{id}` | Delete category | ✅ ADMIN |

### Search
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|----------------|
| GET | `/api/search?keyword=mụn` | Full-text search | ❌ |
| GET | `/api/search/semantic?query=mụn tuổi dậy thì` | Semantic search | ❌ |

### Uploads
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|----------------|
| POST | `/api/uploads/image` | Upload image to S3 | ✅ ADMIN |

---

## 🔍 Search Capabilities

### Full-Text Search
Searches in article title, summary, and content using PostgreSQL Full-Text Search.

```bash
curl http://localhost:8080/api/search?keyword=điều%20trị%20mụn
```

### Semantic Search
Uses OpenAI embeddings and pgvector to find semantically similar articles.

```bash
curl "http://localhost:8080/api/search/semantic?query=chăm%20sóc%20da%20tự%20nhiên"
```

**Example:** Query "mụn tuổi dậy thì" might find articles with titles like:
- "Điều trị Acne Vulgaris ở thanh thiếu niên"
- "Chăm sóc da cho tuổi dậy thì"

---

## 📁 Directory Structure

```
backend/demo/
├── src/
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── config/              # Spring configurations
│   │   │   │   ├── SecurityConfig.java
│   │   │   │   ├── AwsS3Config.java
│   │   │   │   └── OpenApiConfig.java
│   │   │   ├── controller/          # REST endpoints
│   │   │   │   ├── ArticleController.java
│   │   │   │   ├── CategoryController.java
│   │   │   │   ├── SearchController.java
│   │   │   │   ├── AuthController.java
│   │   │   │   └── UploadController.java
│   │   │   ├── service/             # Business logic
│   │   │   │   ├── ArticleService.java
│   │   │   │   ├── CategoryService.java
│   │   │   │   ├── SearchService.java
│   │   │   │   ├── AuthService.java
│   │   │   │   ├── S3StorageService.java
│   │   │   │   └── EmbeddingService.java
│   │   │   ├── repository/          # Data access
│   │   │   │   ├── ArticleRepository.java
│   │   │   │   ├── CategoryRepository.java
│   │   │   │   └── RefreshTokenRepository.java
│   │   │   ├── entity/              # JPA entities
│   │   │   │   ├── Article.java
│   │   │   │   ├── Category.java
│   │   │   │   ├── ArticleImage.java
│   │   │   │   ├── RefreshToken.java
│   │   │   │   └── ArticleStatus.java
│   │   │   ├── dto/                 # Request/Response DTOs
│   │   │   │   ├── ArticleDTO.java
│   │   │   │   ├── CategoryDTO.java
│   │   │   │   ├── LoginRequest.java
│   │   │   │   └── AuthResponse.java
│   │   │   ├── mapper/              # MapStruct mappers
│   │   │   │   ├── ArticleMapper.java
│   │   │   │   └── CategoryMapper.java
│   │   │   ├── security/            # JWT & Security
│   │   │   │   ├── JwtProvider.java
│   │   │   │   └── JwtAuthenticationFilter.java
│   │   │   ├── exception/           # Exception handling
│   │   │   │   ├── GlobalExceptionHandler.java
│   │   │   │   └── ApiException.java
│   │   │   ├── util/                # Utilities
│   │   │   │   ├── SlugUtil.java
│   │   │   │   └── CommonUtil.java
│   │   │   └── DemoApplication.java
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── application-prod.yml
│   │       └── db/
│   │           ├── schema.sql
│   │           └── init-pgvector.sql
│   └── test/
│       └── java/...
├── Dockerfile
├── docker-compose.yml
├── pom.xml
├── .env.example
├── SETUP.md
└── README.md
```

---

## 🗄️ Database Schema

### Articles Table
```sql
CREATE TABLE articles (
  id BIGSERIAL PRIMARY KEY,
  category_id BIGINT NOT NULL,
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  summary TEXT NOT NULL,
  content TEXT NOT NULL,
  thumbnail_url VARCHAR(500),
  status VARCHAR(50) DEFAULT 'DRAFT',
  view_count BIGINT DEFAULT 0,
  published_at TIMESTAMP,
  embedding vector(1536),  -- OpenAI embeddings
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_article_embedding ON articles USING hnsw (embedding);
```

### Categories Table
```sql
CREATE TABLE categories (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

---

## 🔧 Configuration

### JWT Configuration
```yaml
jwt:
  secret: your-super-secret-key-min-32-chars
  access-token-expiration: 3600000    # 1 hour
  refresh-token-expiration: 2592000000 # 30 days
```

### AWS S3 Configuration
```yaml
aws:
  s3:
    bucket-name: derma-insight-prod
    region: us-east-1
    access-key-id: ${AWS_ACCESS_KEY_ID}
    secret-access-key: ${AWS_SECRET_ACCESS_KEY}
```

### OpenAI Configuration
```yaml
openai:
  api-key: ${OPENAI_API_KEY}
  api-url: https://api.openai.com/v1
  embedding-model: text-embedding-3-small
  embedding-dimensions: 1536
```

---

## 🧪 Testing

### Run Tests
```bash
mvn test
```

### Run Specific Test
```bash
mvn test -Dtest=ArticleServiceTest
```

### Generate Coverage Report
```bash
mvn test jacoco:report
open target/site/jacoco/index.html
```

---

## 📊 Monitoring

### Health Check
```bash
curl http://localhost:8080/actuator/health
```

### API Documentation
```
Swagger UI: http://localhost:8080/swagger-ui.html
OpenAPI JSON: http://localhost:8080/v3/api-docs
```

### Application Logs
```bash
# Docker
docker logs -f derma-insight-api

# Local
tail -f logs/application.log
```

---

## 🚀 Deployment

### Docker Build
```bash
docker build -t derma-insight-api:latest .
```

### Push to AWS ECR
```bash
docker tag derma-insight-api:latest <account>.dkr.ecr.us-east-1.amazonaws.com/derma-insight-api:latest
docker push <account>.dkr.ecr.us-east-1.amazonaws.com/derma-insight-api:latest
```

### AWS ECS / Kubernetes
Refer to [SETUP.md](SETUP.md) for detailed deployment instructions.

---

## 🔒 Security

- ✅ JWT token-based authentication
- ✅ Role-based access control (ADMIN/GUEST)
- ✅ Password encryption with BCrypt
- ✅ CORS configuration for frontend
- ✅ Request validation with Bean Validation
- ✅ SQL injection prevention through JPA
- ✅ Secrets management via environment variables

---

## 🆘 Troubleshooting

### PostgreSQL Connection Failed
```bash
# Check if service is running
docker-compose ps

# View logs
docker logs derma-insight-db
```

### JWT Token Expired
- Token expiration: 1 hour (default)
- Use refresh endpoint to get new token
- Default refresh token expiration: 30 days

### S3 Upload Fails
- Verify AWS credentials in `.env`
- Check S3 bucket permissions
- Ensure bucket exists in configured region

### Semantic Search Not Working
- Verify OpenAI API key is set
- Check API key has credits available
- Ensure article embedding was generated

---

## 📝 License

This project is licensed under the MIT License. See LICENSE file for details.

---

## 👥 Contributors

- Architecture & Implementation: Derma Insight Team
- Backend Framework: Spring Boot 4.0.6
- Database: PostgreSQL with pgvector

---

## 📧 Support

For issues, questions, or contributions:
- GitHub Issues: [Project Repository]
- Email: support@derma-insight.com
- Documentation: [SETUP.md](SETUP.md)

---

**Status**: ✅ Production Ready  
**Version**: 1.0.0  
**Last Updated**: 2024-06-04
