# Development Guide - [PROJECT NAME]

## Project Overview

[Brief description of what this project does and its role in the larger system]

**Component Role**: [Describe the specific role this component plays]

## Architecture & Project Structure

### Layered Architecture - Responsibilities and Guidelines

This project follows a **Clean Architecture** pattern with clearly defined layers. Each layer has specific responsibilities and should only communicate with adjacent layers.

#### Architecture Layers

[Customize this section based on your architecture. Below is an example for a typical web API:]

#### 1. API Layer (`api/`) - HTTP Interface
**Responsibility**: Handle HTTP request/response cycle, input validation, and API concerns.

**What belongs here:**
- Route handlers
- HTTP status code decisions
- Query parameter parsing and validation
- Request/response serialization
- HTTP-specific error handling
- API versioning concerns

**What does NOT belong here:**
- Business logic or domain rules
- Database queries or data transformations
- Complex validation beyond HTTP concerns

#### 2. Schema Layer (`schemas/`) - Data Contracts
**Responsibility**: Define API input/output contracts and validation rules.

**What belongs here:**
- Validation models for API requests/responses
- Input validation rules
- Data serialization/deserialization logic
- Documentation for API

#### 3. Service Layer (`services/`) - Business Logic
**Responsibility**: Implement domain business rules, orchestrate operations, and coordinate between repositories.

**What belongs here:**
- Business logic and domain rules
- Workflow orchestration
- Cross-repository operations
- Business validation
- Domain-specific calculations
- Transaction boundaries

#### 4. Repository Layer (`repositories/`) - Data Access
**Responsibility**: Abstract database operations and provide clean data access interface.

**What belongs here:**
- Database queries
- Data filtering, sorting, and pagination
- Complex queries involving joins
- Database transaction management
- Data mapping between ORM and service layer

#### 5. Model Layer (`models/`) - Data Structure
**Responsibility**: Define database schema and data relationships.

**What belongs here:**
- ORM model definitions
- Database table structure
- Relationships between entities
- Database-level validation
- Enums for controlled vocabularies

#### Layer Communication Rules

**Allowed dependencies** (top-to-bottom only):
```
API → Service → Repository → Model
API → Schema (for validation)
Service → Schema (for type contracts)
```

**Forbidden dependencies**:
- Models should NEVER import from upper layers
- Repositories should NEVER import from Service or API layers
- Services should NEVER import from API layer
- Circular dependencies between any layers

### Project Structure
```
project-root/
├── src/
│   └── [package-name]/
│       ├── main.py              # Application entry point
│       ├── config.py            # Configuration
│       ├── models/              # Data models
│       ├── schemas/             # Validation schemas
│       ├── repositories/        # Data access
│       ├── services/            # Business logic
│       └── api/                 # API endpoints
├── tests/                       # Test suite
│   ├── conftest.py             # Test configuration
│   └── test_*.py               # Test files
├── [config files]
└── README.md
```

## Development Workflow - Test-Driven Development (TDD)

**CRITICAL**: This project follows strict TDD methodology. Failure to follow these rules will result in rejected code.

### MANDATORY Development Rules

**RULE 1: ALWAYS WRITE TESTS BEFORE NON-TEST CODE**
- You MUST write tests before writing ANY implementation code
- This includes: database migrations, validation changes, route updates, package changes, text changes, exception behavior, error responses, literally EVERYTHING
- Tests are your feedback mechanism - they tell you if your changes work
- No exceptions to this rule

**RULE 2: IMMEDIATE COMMITS REQUIRED**
- You MUST create a git commit immediately after editing ANY files
- Every file change must be committed before proceeding
- Use descriptive commit messages following the format specified in this document
- Never batch multiple unrelated changes into one commit

**RULE 3: COMPREHENSIVE TEST COVERAGE**
Tests must cover EVERYTHING, including but not limited to:
- Database migrations and their end states
- Schema validation changes
- API route updates and new endpoints
- Package dependency changes
- User-facing text and message changes
- Exception handling and error responses
- Business logic changes
- Data transformations
- Authentication and authorization
- Configuration changes

**RULE 4: [PROJECT-SPECIFIC DATABASE RULES]**
[Customize based on your database:]
- Never delete the database file
- Use proper migration strategies
- Always use [package manager] to modify dependencies

**RULE 5: CODE STANDARDS**
- Never add comments to code explaining what it does
- Follow existing code patterns and conventions
- Use type hints throughout
- Handle errors appropriately

### TDD Process

1. **Write Tests First**: Always write tests before implementing any code
2. **Test Structure**: Use mocking to isolate layers not yet implemented
3. **Test-Fail Cycle**: Ensure tests fail correctly due to:
   - Import errors for non-existent modules/classes
   - `NotImplementedError` exceptions
   - NOT syntax errors or missing imports
4. **User Confirmation Required**: MUST stop and allow user to confirm or make changes to failing tests before proceeding to implementation
5. **Layer Implementation**: Implement in order based on your architecture
6. **Implementation Rules**:
   - Implement only ONE layer at a time
   - Fill dependencies with stubs raising `NotImplementedError`
   - Run tests iteratively and update until passing
   - Stop for review once tests pass

### Development Loop
Write tests → Run tests (fail) → **STOP for user confirmation** → Write minimal code → Run tests (pass) → Commit immediately → Repeat

## Running the Development Server

### Prerequisites
[List prerequisites, e.g.:]
- [Language/Runtime version]
- [Package manager]
- [Other tools]

### Setup
```bash
# Install dependencies
[install command]

# Setup hooks if using pre-commit
[hook setup command]

# Run database migrations
[migration command]
```

### Start Development Server
```bash
# Start with hot reload
[start command]

# Server will be available at:
# - [Primary URL]
# - [Docs URL if applicable]
```

### Manual Testing

[Provide examples of how to manually test your application]

## Writing and Running Tests

### Test Configuration
[Describe your test setup]

### Running Tests

```bash
# Run all tests
[test command]

# Run with verbose output
[test command with verbose]

# Run specific tests
[test command for specific file/test]

# Run with coverage
[test command with coverage]
```

### Writing Tests

#### Test Structure
```[language]
# Example test structure for your framework
```

#### Available Fixtures
[List available test fixtures]

#### Test Categories
[Describe test categories if you use markers/tags]

### TDD Example

```[language]
# 1. Write failing test first
def test_new_feature():
    # Test code here
    assert expected == actual

# 2. Run test - should fail appropriately
# [test command]

# 3. Implement minimal code to make test pass
# Implementation code here

# 4. Run test again - should pass
# 5. Refactor if needed while keeping tests green
```

## Database Management

### Migrations
```bash
# Create new migration
[migration create command]

# Apply migrations
[migration apply command]

# Rollback migration
[migration rollback command]
```

### Database Schema
[Describe your primary entities and relationships]

## Code Quality and Pre-Commit Hooks

[If using pre-commit hooks, describe them here]

### Pre-Commit Hook Setup

```bash
# Install pre-commit hooks
[hook install command]
```

**What runs automatically on each commit:**
1. [Hook 1]
2. [Hook 2]
3. [Tests]

**Manual execution**:
```bash
# Run all hooks
[hook run all command]

# Skip hooks for emergency commits (use sparingly!)
git commit --no-verify -m "Emergency fix"
```

## Key Features Implemented

[List major features and capabilities]

### API Endpoints (if applicable)
[List primary endpoints]

### Data Model Features
[Describe key data model capabilities]

### Architecture Benefits
[List architecture advantages]

## Common Development Tasks

### Adding a New Feature
1. Write tests first (TDD approach)
2. [Step 2]
3. [Step 3]
4. Update tests and documentation

### Adding a New Endpoint (if applicable)
1. Define validation models
2. Add repository methods if needed
3. Add service methods for business logic
4. Add route handler
5. Write tests for the new endpoint

### Debugging Tips
- [Tip 1]
- [Tip 2]
- [Tip 3]

## Performance Considerations
[List performance considerations specific to your project]

## Commit Message Format

Use this format for all commits:

```
Title describing the change

Following: [Original user request or context]

- Bullet points of specific changes made
- Include technical details
- Reference any specs or requirements

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
