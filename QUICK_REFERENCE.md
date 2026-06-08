# Quick Reference Guide - Derma Insight Backend

## 🚀 Quick Start (30 seconds)

```bash
cd backend/demo
docker-compose up -d
open http://localhost:8080/swagger-ui.html
```

---

## 🔑 Default Credentials

| Username | Password | Role |
|----------|----------|------|
| admin | demo | ADMIN |
| guest | guest | GUEST |

---

## 📝 API Examples

### 1. Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"demo"}'
```

### 2. Create Category
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"name":"Điều trị Mụn","description":"Các phương pháp..."}'
```

### 3. Create Article
```bash
curl -X POST http://localhost:8080/api/articles \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "title":"Cách điều trị mụn ở tuổi dậy thì",
    "summary":"Hướng dẫn chi tiết...",
    "content":"Nội dung bài viết...",
    "categoryId":1,
    "status":"DRAFT"
  }'
```

### 4. Publish Article
```bash
curl -X POST http://localhost:8080/api/articles/1/publish \
  -H "Authorization: Bearer <token>"
```

### 5. Full-Text Search
```bash
curl "http://localhost:8080/api/search?keyword=mụn"
```

### 6. Semantic Search
```bash
curl "http://localhost:8080/api/search/semantic?query=chăm%20sóc%20da%20tự%20nhiên"
```

### 7. List Articles
```bash
curl "http://localhost:8080/api/articles?page=0&size=10&categoryId=1"
```

### 8. Upload Image
```bash
curl -X POST http://localhost:8080/api/uploads/image \
  -H "Authorization: Bearer <token>" \
  -F "file=@path/to/image.jpg"
```

---

## 📊 Database Useful Queries

```sql
-- Connect to database
psql -h localhost -U postgres -d derma_insight

-- List all articles
SELECT id, title, slug, status, view_count, created_at 
FROM articles 
ORDER BY created_at DESC;

-- Search by title
SELECT * FROM articles 
WHERE title ILIKE '%mụn%' 
AND status = 'PUBLISHED';

-- Articles by category
SELECT a.title, c.name as category 
FROM articles a 
JOIN categories c ON a.category_id = c.id 
WHERE c.slug = 'dieu-tri-mun';

-- Top viewed articles
SELECT id, title, view_count 
FROM articles 
ORDER BY view_count DESC LIMIT 10;

-- Check indexes
SELECT schemaname, tablename, indexname, idx_scan 
FROM pg_stat_user_indexes 
ORDER BY idx_scan DESC;

-- Cleanup expired tokens
DELETE FROM refresh_tokens 
WHERE expired_at < NOW();

-- Database size
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

---

## 🐳 Docker Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f backend

# View database logs
docker-compose logs -f postgres

# Stop database only
docker-compose stop postgres

# Restart everything
docker-compose restart

# Remove all (including data)
docker-compose down -v

# Build fresh image
docker-compose build --no-cache
```

---

## 📂 File Locations

| Purpose | Path |
|---------|------|
| Main config | `src/main/resources/application.yml` |
| Dev config | `src/main/resources/application-dev.yml` |
| Prod config | `src/main/resources/application-prod.yml` |
| Database schema | `src/main/resources/db/schema.sql` |
| Entities | `src/main/java/com/example/demo/entity/` |
| Services | `src/main/java/com/example/demo/service/` |
| Controllers | `src/main/java/com/example/demo/controller/` |
| DTOs | `src/main/java/com/example/demo/dto/` |
| Repositories | `src/main/java/com/example/demo/repository/` |

---

## 🔧 Configuration Keys

```yaml
# JWT
jwt.secret: Your secret key (min 32 chars)
jwt.access-token-expiration: 3600000 (1 hour)
jwt.refresh-token-expiration: 2592000000 (30 days)

# Database
spring.datasource.url: PostgreSQL connection string
spring.datasource.username: DB username
spring.datasource.password: DB password

# AWS S3
aws.s3.bucket-name: S3 bucket name
aws.s3.region: AWS region
aws.s3.access-key-id: AWS access key
aws.s3.secret-access-key: AWS secret key

# OpenAI
openai.api-key: OpenAI API key
openai.embedding-model: text-embedding-3-small
openai.embedding-dimensions: 1536
```

---

## 🧪 Testing Scenarios

### Test Full Workflow
1. Login (get token)
2. Create category
3. Create article (will auto-generate embedding)
4. Publish article
5. Search articles (full-text)
6. Search articles (semantic)
7. View article (increment view count)
8. Get related articles

### Test Permissions
1. Try to create article without token → 401
2. Login as admin → Create works ✅
3. Try as guest → 403 Forbidden

### Test Search
1. Create 3 articles with different titles
2. Full-text search: Exact term
3. Semantic search: Similar meaning word
4. Verify embedding was generated

### Test Images
1. Upload thumbnail for article
2. Verify S3 URL returned
3. Delete image
4. Verify deleted from S3

---

## 🐛 Debugging Tips

### Check if Services Running
```bash
docker-compose ps
curl http://localhost:8080/actuator/health
```

### View Application Logs
```bash
docker logs derma-insight-api -f

# Or local
tail -f logs/application.log
```

### Check Database Connection
```bash
docker exec derma-insight-db psql -U postgres -c "SELECT 1"
```

### Verify JWT Token
- Visit: http://jwt.io
- Paste token to decode

### Test API Without Frontend
```bash
# Swagger UI: http://localhost:8080/swagger-ui.html
# Or use curl/Postman/Insomnia
```

---

## 🎯 Common Development Tasks

### Add New Endpoint
1. Create method in Service (e.g., `ArticleService`)
2. Create method in Repository if needed
3. Add method to Controller with `@RequestMapping`
4. Add `@Operation` Swagger annotation
5. Test via Swagger UI

### Add New Field to Article
1. Add field to `Article.java` entity
2. Update `ArticleDTO.java`
3. Update `ArticleMapper.java`
4. Create database migration if needed
5. Update `CreateArticleRequest.java`
6. Update tests

### Regenerate Mappers
```bash
# Automatic with Maven compile
mvn clean compile

# Or just compile the specific module
```

### Run Tests
```bash
mvn test

# Specific test
mvn test -Dtest=ArticleServiceTest

# With coverage
mvn test jacoco:report
```

---

## 🚨 Emergency Commands

### Reset Database
```bash
docker-compose down -v
docker-compose up -d
# Database recreated with schema
```

### Rebuild Everything
```bash
docker-compose down -v
docker system prune -a
docker-compose build --no-cache
docker-compose up -d
```

### Stop Everything
```bash
docker-compose stop
```

### Clean Maven Cache
```bash
rm -rf ~/.m2/repository
mvn clean
```

---

## 📈 Performance Tips

### Database
- Indexes are already optimized
- Use pagination: `?page=0&size=10`
- HNSW index used for vector search

### Application
- Connection pooling enabled (HikariCP)
- HTTP compression enabled
- View count uses eventual consistency

### Search
- Full-text: Fast with GIN index
- Semantic: Fast with HNSW index
- Combine for best results

---

## 🔒 Security Checklist

Before production:
- [ ] Change default credentials
- [ ] Update JWT_SECRET to strong value
- [ ] Configure HTTPS/TLS
- [ ] Enable CORS only for known origins
- [ ] Set strong database password
- [ ] Enable database backups
- [ ] Configure AWS IAM roles
- [ ] Rotate API keys regularly
- [ ] Monitor access logs
- [ ] Set up rate limiting

---

## 📞 Troubleshooting

| Problem | Solution |
|---------|----------|
| Can't connect to DB | Check `docker-compose ps`, verify network |
| JWT token invalid | Check expiration, regenerate if needed |
| S3 upload fails | Verify AWS credentials, bucket permissions |
| Semantic search empty | Check OpenAI API key, ensure article has embedding |
| Swagger not loading | Check port 8080, clear browser cache |
| Port 5432/8080 in use | Kill existing processes or use different ports |
| Build fails | `mvn clean compile`, check dependencies |

---

## 📚 Resources

- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **Health Check**: http://localhost:8080/actuator/health
- **API Docs**: http://localhost:8080/v3/api-docs
- **Project Repo**: [GitHub URL]
- **Full Setup Guide**: See SETUP.md
- **Documentation**: See README.md

---

**Pro Tips:**
- 💡 Use Postman/Insomnia to test API before frontend integration
- 💡 Watch database logs during development: `docker logs -f derma-insight-db`
- 💡 Keep OpenAPI/Swagger updated with endpoint documentation
- 💡 Test semantic search with different query phrasing
- 💡 Monitor view counts and trending articles
- 💡 Regular backup of PostgreSQL data

---

**Last Updated**: 2024-06-04  
**Version**: 1.0.0
