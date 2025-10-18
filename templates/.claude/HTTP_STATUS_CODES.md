# HTTP Status Code Guidelines

## Overview

This document establishes standardized HTTP status code usage for REST APIs. Following these guidelines ensures consistent, predictable API behavior that adheres to REST principles and industry best practices.

**⚠️ IMPORTANT**: This document is **only relevant for REST API projects** (web servers, microservices, etc.). If your project is:
- A CLI application
- A desktop/mobile application
- A library/SDK
- A data processing pipeline
- Any non-web-server project

**You should DELETE this file** and `.claude/agents/http-status-reviewer.md` from your project.

## Quick Reference

| Operation | Success Code | Description | Example |
|-----------|-------------|-------------|---------|
| **CREATE** (POST new resource) | **201 Created** | Resource successfully created | `POST /api/v1/resources/` |
| **READ** (GET) | **200 OK** | Resource(s) retrieved successfully | `GET /api/v1/resources/1` |
| **UPDATE** (PUT/PATCH) | **200 OK** | Resource updated successfully | `PUT /api/v1/resources/1` |
| **DELETE** (DELETE) | **204 No Content** | Resource deleted successfully | `DELETE /api/v1/resources/1` |
| **ACTION** (POST operation) | **200 OK** | Operation completed successfully | `POST /api/v1/resources/1/start` |

## 2xx Success Status Codes

### 200 OK
**Use for**: Successful requests where content is returned

**When to use**:
- GET operations (retrieving resources)
- PUT operations (updating resources)
- POST operations that perform actions (not creating resources)
- Any successful operation that returns data

**Examples**:
```http
GET /api/v1/resources/1 → 200 OK
PUT /api/v1/resources/1 → 200 OK
POST /api/v1/resources/1/start → 200 OK
POST /api/v1/resources/1/complete → 200 OK
```

**Response body**: MUST include relevant data

### 201 Created
**Use for**: Successful resource creation

**When to use**:
- POST operations that create new resources
- Only when a new entity is persisted to the database
- NEVER for actions/operations that don't create resources

**Examples**:
```http
POST /api/v1/resources/ → 201 Created
POST /api/v1/resources/1/associations/2 → 201 Created (creates association)
```

**Response body**: MUST include the created resource with its ID
**Headers**: SHOULD include `Location` header with resource URI (optional)

### 204 No Content
**Use for**: Successful operations with no response body

**When to use**:
- DELETE operations
- PUT operations where no data needs to be returned
- POST operations that perform actions without returning data

**Examples**:
```http
DELETE /api/v1/resources/1 → 204 No Content
```

**Response body**: MUST be empty or only contain status message

## 4xx Client Error Status Codes

### 400 Bad Request
**Use for**: Invalid request data or business rule violations

**When to use**:
- Request body validation failures
- Business logic violations
- Malformed JSON or missing required fields
- Invalid query parameters

**Examples**:
```http
POST /api/v1/resources/ → 400 Bad Request
Body: {"detail": "Name field is required"}
```

**Response body**: MUST include descriptive error message

### 401 Unauthorized
**Use for**: Authentication required or invalid credentials

**When to use**:
- Missing or invalid authentication tokens
- Expired sessions
- Authentication required for protected endpoints

### 403 Forbidden
**Use for**: Valid authentication but insufficient permissions

**When to use**:
- User lacks permission to access resource
- Operation not allowed for current user role

### 404 Not Found
**Use for**: Resource does not exist

**When to use**:
- Requested resource ID doesn't exist in database
- Invalid URLs/endpoints
- Resource deleted or never existed

**Examples**:
```http
GET /api/v1/resources/999 → 404 Not Found
```

**Response body**: MUST include descriptive error message

### 409 Conflict
**Use for**: Request conflicts with current resource state

**When to use**:
- Attempting to create duplicate resources (if applicable)
- State conflicts in business logic
- Concurrent modification conflicts

**Examples**:
```http
POST /api/v1/resources/ → 409 Conflict
Body: {"detail": "Resource with this name already exists"}
```

### 422 Unprocessable Entity
**Use for**: Valid JSON but semantic validation errors

**When to use**:
- Data type correct but values invalid
- Cross-field validation failures
- Business constraint violations

**Examples**:
```http
POST /api/v1/resources/ → 422 Unprocessable Entity
Body: {"detail": "Duration must be positive"}
```

## 5xx Server Error Status Codes

### 500 Internal Server Error
**Use for**: Unexpected server-side errors

**When to use**:
- Database connection failures
- Unhandled exceptions in code
- System-level errors
- Programming errors/bugs

**Response body**: SHOULD include generic error message (avoid exposing internal details)

### 503 Service Unavailable
**Use for**: Temporary server unavailability

**When to use**:
- Database maintenance
- System overload
- Dependency service failures

## Operation-Specific Guidelines

### CRUD Operations

#### Create (POST /resources/)
```http
POST /api/v1/resources/
Content-Type: application/json

{
  "name": "New Resource",
  "description": "Resource description"
}
```

**Success Response**:
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1,
  "name": "New Resource",
  "description": "Resource description",
  "created_at": "2024-01-15T10:00:00"
}
```

#### Read (GET /resources/{id})
```http
GET /api/v1/resources/1
```

**Success Response**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 1,
  "name": "Resource Name",
  "description": "Resource description"
}
```

#### Update (PUT /resources/{id})
```http
PUT /api/v1/resources/1
Content-Type: application/json

{
  "name": "Updated Resource Name"
}
```

**Success Response**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 1,
  "name": "Updated Resource Name",
  "description": "Resource description",
  "updated_at": "2024-01-15T10:05:00"
}
```

#### Delete (DELETE /resources/{id})
```http
DELETE /api/v1/resources/1
```

**Success Response**:
```http
HTTP/1.1 204 No Content
```

### Action Operations (Non-CRUD)

#### Perform Action
```http
POST /api/v1/resources/1/start
```

**Success Response**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 1,
  "status": "active",
  "started_at": "2024-01-15T10:10:00"
}
```

**Note**: This performs an action, not creating a resource, hence 200 OK not 201 Created

## Error Response Format

All error responses SHOULD follow a consistent format:

```json
{
  "detail": "Human-readable error message"
}
```

### Error Message Guidelines

1. **Be descriptive**: "Resource not found" not just "Not found"
2. **Be specific**: "Cannot perform action on completed resource" not just "Invalid operation"
3. **Be consistent**: Use similar language for similar errors
4. **Avoid technical jargon**: Write for API consumers
5. **Don't expose internals**: No stack traces or database errors in production

## Testing Guidelines

### Status Code Test Patterns

#### Creation Tests
```python
def test_create_resource(client):
    data = {"name": "Test Resource"}
    response = client.post("/api/v1/resources/", json=data)
    assert response.status_code == 201  # Not 200!
    assert response.json()["id"] is not None
```

#### Retrieval Tests
```python
def test_get_resource(client):
    response = client.get("/api/v1/resources/1")
    assert response.status_code == 200
    assert "name" in response.json()
```

#### Error Tests
```python
def test_get_nonexistent_resource(client):
    response = client.get("/api/v1/resources/999")
    assert response.status_code == 404
    assert "not found" in response.json()["detail"].lower()
```

### Common Test Mistakes

❌ **Wrong**: Using 200 for creation
```python
response = client.post("/api/v1/resources/", json=data)
assert response.status_code == 200  # Should be 201
```

✅ **Right**: Using 201 for creation
```python
response = client.post("/api/v1/resources/", json=data)
assert response.status_code == 201
```

❌ **Wrong**: Generic error checking
```python
assert response.status_code != 200  # Too vague
```

✅ **Right**: Specific error checking
```python
assert response.status_code == 404
assert "not found" in response.json()["detail"].lower()
```

## Framework-Specific Implementation

### FastAPI Example
```python
from fastapi import status, HTTPException

@router.post("/", response_model=Schema, status_code=status.HTTP_201_CREATED)
def create_resource(data: CreateSchema):
    # Create logic here
    return created_resource

@router.get("/{id}", response_model=Schema)  # Defaults to 200
def get_resource(id: int):
    if not resource:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Resource not found"
        )
    return resource

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_resource(id: int):
    # Delete logic here
    return  # No response body for 204
```

### Express/Node.js Example
```javascript
// Create - 201
app.post('/api/v1/resources', (req, res) => {
  const resource = createResource(req.body);
  res.status(201).json(resource);
});

// Get - 200
app.get('/api/v1/resources/:id', (req, res) => {
  const resource = getResource(req.params.id);
  if (!resource) {
    return res.status(404).json({ detail: 'Resource not found' });
  }
  res.status(200).json(resource);
});

// Delete - 204
app.delete('/api/v1/resources/:id', (req, res) => {
  deleteResource(req.params.id);
  res.status(204).send();
});
```

## Migration Checklist

When updating existing endpoints:

1. ✅ Review current status code usage
2. ✅ Update route handlers with correct status codes
3. ✅ Update all corresponding tests
4. ✅ Verify error handling uses appropriate status codes
5. ✅ Test API endpoints manually or with automated tests
6. ✅ Update API documentation if necessary

## Future Considerations

### When Adding New Endpoints

1. **Choose appropriate status code** before implementation
2. **Write tests with correct expectations** first (TDD)
3. **Document any non-standard choices**
4. **Be consistent** with existing similar endpoints

## References

- [RESTful API HTTP Status Codes](https://restfulapi.net/http-status-codes/)
- [HTTP Status Code Definitions (RFC 7231)](https://tools.ietf.org/html/rfc7231#section-6)
- [Mozilla HTTP Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

---

**Remember**: Consistent, predictable HTTP status codes improve developer experience and API reliability. When in doubt, choose the most specific status code that accurately represents the outcome of the operation.
