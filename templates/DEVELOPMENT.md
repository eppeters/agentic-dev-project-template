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

**RULE 2: COMMITS AT KEY CHECKPOINTS**
- You MUST create a git commit after completing each RED-GREEN-REFACTOR cycle
- Commit after acceptance tests pass and are refactored
- Commit after each unit test passes and is refactored
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

### TDD Process: Double Loop Methodology

This project follows **Double Loop TDD**, which combines acceptance testing (outer loop) with unit testing (inner loop). The outer loop operates on a timescale of hours to days, while the inner loop operates on a timescale of minutes.

#### Outer Loop: Acceptance/End-to-End Testing

The outer loop tests the feature from the user's perspective, verifying the entire system works together.

**Outer Loop Cycle:**
1. **Write ONE failing acceptance/E2E test** for the user story
2. **Run the test** - it should fail (RED)
3. **STOP for user confirmation** - review the test covers acceptance criteria
4. **Enter Inner Loop** - write unit tests and implementation
5. **Periodically run acceptance test** - check progress toward feature completion
6. **When acceptance test passes** (GREEN) - feature is functionally complete
7. **Refactor** - improve design, security, and code quality
8. **Run acceptance test again** - ensure refactoring didn't break anything (stay GREEN)
9. **STOP for user review** - review refactored code
10. **Commit** - acceptance test and refactored implementation
11. **Move to next user story** - only work on ONE acceptance test at a time

**Key Rules:**
- Write only ONE acceptance test at a time
- Don't write another acceptance test until the current one passes
- Acceptance tests verify user stories work as expected
- Test from the user's perspective (e.g., HTTP requests, CLI commands, UI interactions)

#### Inner Loop: Unit Testing (RED-GREEN-REFACTOR)

The inner loop tests individual components and classes in isolation.

**Inner Loop Cycle:**
1. **RED - Write ONE failing unit test**
   - Test one small piece of functionality
   - Use mocking to isolate the component
   - Run test - should fail due to ImportError or NotImplementedError
   - **STOP for user confirmation** - review test is correct

2. **GREEN - Make the test pass**
   - Write minimal code to make the test pass
   - Don't worry about perfection - just make it work
   - Implement only ONE layer at a time (following your architecture)
   - Use `NotImplementedError` stubs for dependencies not yet implemented
   - Run test - should now pass

3. **REFACTOR - Improve the code**
   - Now that tests pass, improve the implementation
   - Check refactoring checklist (see below)
   - Run tests again - ensure they still pass (stay GREEN)
   - **Commit** - unit test and refactored implementation

4. **Repeat** - Write next unit test or return to outer loop

**Key Rules:**
- Work in very small increments (typically 3-5 lines of test, 3-5 lines of code)
- You'll complete many inner loop cycles (20-40 per hour)
- Never skip the REFACTOR step
- Keep all tests passing at all times

#### Refactoring Checklist

During the REFACTOR step, check for:

**Code Quality:**
- **DRY (Don't Repeat Yourself)**: Eliminate duplication
- **Single Responsibility**: Each function/class does one thing
- **Code Smells**: Long methods, large classes, primitive obsession, feature envy
- **Naming**: Clear, self-documenting names for variables, functions, and classes

**Project Standards:**
- **Architecture Patterns**: Follow layered architecture in @CLAUDE.md
- **Type Safety**: Use type hints/annotations throughout
- **Error Handling**: Appropriate exceptions with clear messages
- **Validation**: Input/output validation using project's validation library

**Security:**
- **Input Validation**: Sanitize and validate all inputs
- **Error Messages**: Don't leak sensitive information
- **Secrets Management**: No hardcoded credentials or API keys
- **Authentication/Authorization**: Properly enforce access controls

**Performance:**
- **Database Queries**: N+1 query problems, missing indexes
- **Algorithm Complexity**: Can this be more efficient?
- **Resource Management**: Proper cleanup (close files, connections, etc.)

### Development Loop Summary

```
OUTER LOOP (Hours to Days):
  Write E2E test → RED → STOP (user review) → Inner Loop → Periodic E2E checks →
  GREEN → Refactor → GREEN → STOP (user review) → Commit → Next feature

INNER LOOP (Minutes):
  Write unit test → RED → STOP (user review) → Write code → GREEN →
  Refactor → GREEN → Commit → Repeat or exit to outer loop
```

**Critical Checkpoints:**
- STOP after every RED (failing test) for user confirmation
- STOP after outer loop GREEN + REFACTOR for user review
- Commit after every complete RED-GREEN-REFACTOR cycle
- Run acceptance test periodically to track progress

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
