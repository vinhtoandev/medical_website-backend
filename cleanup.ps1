$loginResp = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -ContentType "application/json" -Body '{"username":"admin","password":"demo"}'
$token = $loginResp.data.accessToken
$headers = @{ Authorization = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:8080/api/articles/69" -Method DELETE -Headers $headers | Out-Null
Write-Host "Da xoa bai viet test (ID=69)" -ForegroundColor Yellow
