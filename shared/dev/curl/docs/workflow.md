# Curl Quick Reference

Quick guide for making API requests with curl.

---

## Setup: api.conf (Recommended)

**Create `api.conf` in your project directory:**

```bash
# api.conf
url = "https://api-staging.revisemate.ai"
header = "Content-Type: application/json"
header = "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE"
```

**Update token after login:**
```bash
vim api.conf  # Edit the Authorization line with new token
```

---

## GET Requests

### With api.conf
```bash
# Simple GET
curl -K api.conf /v1/users

# GET with pretty print
curl -K api.conf /v1/users | jq .

# GET and save to file
curl -K api.conf /v1/users > response.json
curl -K api.conf /v1/users >> output.log  # Append
```

### Manual headers
```bash
curl -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     https://api-staging.revisemate.ai/v1/users
```

---

## POST Requests

### With api.conf + JSON file
```bash
# Using --json flag (auto sets Content-Type)
curl -K api.conf --json @login.json /v1/auth/login

# Using -d with JSON file
curl -K api.conf -X POST -d @user.json /v1/users
```

### With api.conf + inline JSON
```bash
curl -K api.conf -X POST \
     -d '{"email":"user@test.com","password":"secret"}' \
     /v1/auth/login
```

### Manual headers + inline JSON
```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     -d '{"name":"John","email":"john@test.com"}' \
     https://api-staging.revisemate.ai/v1/users
```

### Manual headers + JSON file
```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     --json @data.json \
     https://api-staging.revisemate.ai/v1/users
```

---

## PUT Requests

### With api.conf + inline JSON
```bash
curl -K api.conf -X PUT \
     -d '{"name":"Jane Doe","email":"jane@test.com"}' \
     /v1/users/123
```

### With api.conf + JSON file
```bash
curl -K api.conf -X PUT -d @update.json /v1/users/123
```

### Manual headers
```bash
curl -X PUT \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     -d '{"name":"Jane Doe"}' \
     https://api-staging.revisemate.ai/v1/users/123
```

---

## DELETE Requests

### With api.conf
```bash
curl -K api.conf -X DELETE /v1/users/123
```

### Manual headers
```bash
curl -X DELETE \
     -H "Authorization: Bearer YOUR_TOKEN" \
     https://api-staging.revisemate.ai/v1/users/123
```

---

## Common Patterns

### Login and extract token
```bash
# Login and save full response
curl -K api.conf --json @login.json /v1/auth/login > login-response.json

# Extract token with jq
cat login-response.json | jq -r '.access_token'

# One-liner: login and extract token
TOKEN=$(curl -K api.conf --json @login.json /v1/auth/login | jq -r '.access_token')
echo $TOKEN
```

### Debug requests (see headers and response)
```bash
# Verbose output
curl -K api.conf -v /v1/users

# Show only response headers
curl -K api.conf -I /v1/users

# Include response headers in output
curl -K api.conf -i /v1/users
```

### Handle response codes
```bash
# Show HTTP status code
curl -K api.conf -w "\nHTTP Status: %{http_code}\n" /v1/users

# Only get status code
curl -K api.conf -o /dev/null -w "%{http_code}" /v1/users
```

---

## Quick Reference Table

| Action | With api.conf | Manual Headers |
|--------|---------------|----------------|
| **GET** | `curl -K api.conf /endpoint` | `curl -H "Auth: Bearer TOKEN" URL` |
| **POST (inline)** | `curl -K api.conf -X POST -d '{json}' /endpoint` | `curl -X POST -H "Auth: Bearer TOKEN" -d '{json}' URL` |
| **POST (file)** | `curl -K api.conf --json @file.json /endpoint` | `curl -X POST -H "Auth: Bearer TOKEN" --json @file.json URL` |
| **PUT** | `curl -K api.conf -X PUT -d '{json}' /endpoint` | `curl -X PUT -H "Auth: Bearer TOKEN" -d '{json}' URL` |
| **DELETE** | `curl -K api.conf -X DELETE /endpoint` | `curl -X DELETE -H "Auth: Bearer TOKEN" URL` |

---

## Useful Flags

| Flag | Purpose |
|------|---------|
| `-K file` | Use config file |
| `-X METHOD` | Specify HTTP method (POST, PUT, DELETE, etc.) |
| `-H "Header"` | Add custom header |
| `-d 'data'` | Send data in request body |
| `-d @file` | Send file contents in request body |
| `--json @file` | Send JSON file (auto sets Content-Type) |
| `-o file` | Save output to file |
| `> file` | Redirect output to file |
| `>> file` | Append output to file |
| `-v` | Verbose (show request/response headers) |
| `-i` | Include response headers in output |
| `-I` | Show only response headers (HEAD request) |
| `\| jq .` | Pretty print JSON response |

---

## Example Workflow

```bash
# 1. Create api.conf with base URL and headers
cat > api.conf << 'EOF'
url = "https://api-staging.revisemate.ai"
header = "Content-Type: application/json"
header = "Authorization: Bearer PLACEHOLDER"
EOF

# 2. Login and get token
curl -K api.conf --json @login.json /v1/auth/login | jq .

# 3. Copy access_token from response and update api.conf
vim api.conf  # Paste token in Authorization header

# 4. Make authenticated requests
curl -K api.conf /v1/users | jq .
curl -K api.conf -X POST -d '{"name":"Test"}' /v1/products | jq .
curl -K api.conf -X PUT -d '{"status":"active"}' /v1/users/123 | jq .
curl -K api.conf -X DELETE /v1/users/123
```

---

**Pro tip:** Keep your `api.conf` in `.gitignore` to avoid committing tokens!
