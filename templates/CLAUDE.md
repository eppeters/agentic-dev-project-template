# Claude Code Instructions - [PROJECT NAME]

## Project Context & Purpose

[Describe your project's purpose and key business context here]

**Key Business Context:**
- **Target Users**: [Who are your users?]
- **Core Problem**: [What problem does this solve?]
- **Primary Benefits**: [What value does this provide?]

## Architecture Overview

**Architecture Pattern:**
```
[Describe your architecture pattern here, e.g.:
API Layer (FastAPI routes)
    ↓
Service Layer (Business logic)
    ↓
Repository Layer (Data access)
    ↓
Model Layer (Database ORM)
]
```

**Technology Stack:**
- **Framework**: [e.g., FastAPI, Django, Express]
- **Database**: [e.g., PostgreSQL, SQLite, MongoDB]
- **Testing**: [e.g., pytest, Jest, JUnit]
- **Package Manager**: [e.g., uv, npm, pip]
- **Language/Version**: [e.g., Python 3.13, Node 18]

## Critical Development Rules

### 1. Test-Driven Development (MANDATORY)
**ALWAYS follow Double Loop TDD when adding features:**
1. **Outer Loop**: Write acceptance/E2E test first → RED → Get user confirmation → Inner Loop
2. **Inner Loop**: Write unit test → RED → Get user confirmation → Write code → GREEN → Refactor → Commit
3. Repeat inner loop until acceptance test passes
4. Refactor at outer loop level when feature complete
5. Get user review before final commit
6. See @DEVELOPMENT.md for complete Double Loop TDD methodology

### 2. Commit Strategy (REQUIRED)
**MUST commit after completing each logical step:**
- Use descriptive commit messages with format:
```
Title describing the change

Following: [Original user request or context]

- Bullet points of specific changes made
- Include technical details
- Reference any specs or requirements

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### 3. Code Quality Standards
- **Type Safety**: Use type hints/annotations throughout
- **Error Handling**: Use appropriate exceptions with proper error codes
- **Validation**: Use validation libraries for all input/output
- **Documentation**: Code should be self-documenting with clear naming

## Project Structure Navigation

### Key Files to Understand First:
[List the 5-10 most important files developers should read first]
1. **`path/to/main.py`** - Entry point
2. **`path/to/config.py`** - Configuration
3. **`path/to/models/`** - Data models
4. **`path/to/api/`** - API endpoints
5. **`tests/conftest.py`** - Test configuration

### Core Data Models:
[Describe your primary data models and their relationships]
- **Model1**: [Description]
- **Model2**: [Description]
- **Model3**: [Description]

### Common Enums/Constants:
[List important enums or constants used throughout the project]
```
STATUS_ENUM = ["pending", "active", "complete", "cancelled"]
```

## Common Development Patterns

### Adding a New API Endpoint:
1. **Schema**: Define validation models
2. **Repository**: Add data access methods
3. **Service**: Add business logic
4. **API**: Add route handler
5. **Tests**: Create test cases

### Working with the Database:
[Provide common patterns for database operations in your project]

### Repository Pattern:
[Provide example of repository pattern if used]

### Service Pattern:
[Provide example of service pattern if used]

## Testing Approach

### Test Structure:
- **`tests/conftest.py`**: Test configuration and fixtures
- **`tests/test_*.py`**: Test files following naming convention

### Running Tests:
```bash
[command to run all tests]
[command to run specific tests]
[command to run with coverage]
```

### Test Fixtures Available:
[List available test fixtures and their purpose]

## Development Workflow

### Starting Development:
```bash
# Setup environment
[setup commands]

# Start development server
[start command]

# Access points:
# - API: [URL]
# - Docs: [URL if applicable]
```

### Making Database Changes:
```bash
# Create migration
[migration create command]

# Apply migrations
[migration apply command]
```

## API Design Patterns

[If building an API, describe your endpoint naming conventions]

### Endpoint Naming:
- `GET /api/v1/resources/` - List resources
- `POST /api/v1/resources/` - Create resource
- `GET /api/v1/resources/{id}` - Get specific resource
- `PUT /api/v1/resources/{id}` - Update resource
- `DELETE /api/v1/resources/{id}` - Delete resource

## Key Business Logic

[Describe important business rules, workflows, or domain logic]

### Important Workflows:
1. [Workflow 1 description]
2. [Workflow 2 description]

### Relationships:
[Describe key relationships between entities]

## Troubleshooting Guide

### Common Issues:
1. **Import Errors**: [How to resolve]
2. **Database Errors**: [How to resolve]
3. **Test Failures**: [How to resolve]
4. **Build/Runtime Errors**: [How to resolve]

### Debugging Tools:
[List debugging approaches and tools]

## Future Considerations

### Planned Features:
[List upcoming features or technical debt to address]

### Scalability Notes:
[Describe scalability considerations or migration paths]

## Working with Specifications

**Primary Spec**: [Link to main specification document]
**Implementation Plan**: [Link to implementation plan if exists]

When adding features:
1. Reference user stories or requirements documentation
2. Implement data model requirements from specs
3. Follow API behavior requirements from specs
4. Include business logic per specifications

## Success Criteria

When development is complete, the system should:
- ✅ [Criterion 1]
- ✅ [Criterion 2]
- ✅ [Criterion 3]
- ✅ Have comprehensive test coverage
- ✅ Follow clean architecture patterns
- ✅ Include proper error handling and validation

Remember: [Add your project's core values or principles here]

- Always use [package manager] to modify dependencies. Do not edit the dependency file directly.
- Do not update non-test code before writing or updating tests. You MUST follow the test-driven development workflow in @DEVELOPMENT.md.
- You MUST follow @DEVELOPMENT.md for all development.
- You MUST NEVER add comments to code explaining what the code does.
- [Add any other project-specific rules]
