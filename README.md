# Claude Code Base Project Template

[![Tests](https://github.com/eppeters/claude-code-base-project-template/workflows/Test%20install.sh/badge.svg)](https://github.com/eppeters/claude-code-base-project-template/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Claude Code Base Project Template provides reusable configuration files, development workflows, and documentation templates for Claude Code projects.

**Note**: These templates are designed for Claude Code CLI and have not been tested with other AI coding assistants.

## Features

- **Claude Code Configuration**: Persona definitions, custom agents, and slash commands
- **TDD Methodology**: Test-driven development workflows with testing patterns
- **Clean Architecture**: Layered architecture templates with separation of concerns
- **Project Documentation**: CLAUDE.md and DEVELOPMENT.md templates
- **Installation**: Script with conflict resolution
- **Testing**: Test suite with GitHub Actions integration
- **Documentation**: Guides for different project types and languages

## Installation

```bash
git clone https://github.com/eppeters/claude-code-base-project-template.git
cd claude-code-base-project-template
./install.sh /path/to/your/project
```

After installation, customize templates for your project:
```
/setup
```

## Usage Workflow

### Starting a New Project

1. **Install templates**:
   ```bash
   ./install.sh ~/projects/my-new-app
   cd ~/projects/my-new-app
   ```

2. **Run setup** in Claude Code:
   ```
   /setup
   ```

   The setup agent will ask about:
   - Project name and type
   - Technology stack (language, framework, database)
   - Architecture pattern
   - Testing framework
   - Files to remove (e.g., REST API files for non-API projects)

3. **Verify templates**:
   - Check `CLAUDE.md` for project-specific values
   - Review `DEVELOPMENT.md` for setup commands
   - Remove `.claude/HTTP_STATUS_CODES.md` and `.claude/agents/http-status-reviewer.md` if not building a REST API

### Implementing a Feature

Use the `/feature` command to implement new functionality with TDD:

```
/feature
```

The agent will guide you through:

1. **User story creation**:
   - Who is the user?
   - What do they want?
   - Why do they want it?

2. **Acceptance criteria**:
   - Agent proposes GIVEN/WHEN/THEN scenarios
   - You review and approve

3. **Test creation**:
   - Agent writes tests covering all acceptance criteria
   - Tests fail with ImportError or NotImplementedError
   - You confirm tests before implementation

4. **Implementation**:
   - Agent implements one layer at a time
   - Uses stubs for unimplemented dependencies
   - Runs tests after each layer
   - Commits when tests pass

Example session:
```
You: /feature

Agent: Let's implement a new feature using TDD.

Who is the user for this feature?

You: API consumers

Agent: What does the API consumer want to accomplish?

You: List all active users with pagination

Agent: Why do they want this?

You: To display users in a dashboard UI

Agent: Here are the acceptance criteria:

GIVEN an API consumer
WHEN they request GET /api/users?status=active&page=1&limit=10
THEN they receive:
- 200 OK status
- JSON array of active users
- Pagination metadata (total, page, limit)
- Users sorted by creation date descending

[Tests are written, implementation proceeds layer by layer]
```

### Example Project Timeline

**Day 1: Setup**
```
./install.sh ~/projects/task-api
cd ~/projects/task-api
claude
> /setup
```

**Day 2: First Feature**
```
> /feature
[Implement user authentication]
```

**Day 3: Second Feature**
```
> /feature
[Implement task creation]
```

**Day 4: Third Feature**
```
> /feature
[Implement task listing with filters]
```

Each feature follows TDD: tests first, implementation second, commit when passing.

## What's Included

### Core Documentation Templates

1. **`CLAUDE.md`** - Project-specific instructions for Claude Code
   - Describes your project's purpose, architecture, and technology stack
   - Defines critical development rules (TDD, commit strategy, code quality)
   - Documents common patterns, data models, and business logic
   - Provides troubleshooting guidance and success criteria

2. **`DEVELOPMENT.md`** - Comprehensive development guide
   - Details the layered architecture and layer responsibilities
   - Explains the TDD workflow and mandatory development rules
   - Provides setup, testing, and debugging instructions
   - Documents common development tasks and patterns

### Claude Code Configuration (`.claude/`)

3. **`.claude/PERSONA.md`** - Agent communication style
   - Defines the technical advisor role and analytical approach
   - Establishes clinical, factual communication patterns
   - Requires balanced analysis with pros/cons for all proposals
   - Eliminates hype words, intensifiers, and consultant-speak
   - Mandates research-based recommendations and self-critical evaluation
   - Prohibits fabricated metrics or anthropomorphization

4. **`.claude/agents/user-story-implementer.md`** - TDD implementation agent
   - Gathers user story requirements through structured questioning
   - Writes comprehensive acceptance tests before implementation
   - Implements features layer-by-layer following TDD principles
   - Ensures compliance with all project development rules

5. **`.claude/agents/project-setup.md`** - Project setup and customization agent
   - Interviews you about your project to gather all necessary information
   - Automatically fills in all template placeholders
   - Removes irrelevant files based on project type
   - Invoked via the `/setup` command

6. **`.claude/commands/feature.md`** - Feature implementation slash command
   - Provides `/feature` command to trigger TDD workflow
   - Invokes the user-story-implementer agent
   - Streamlines the feature development process

7. **`.claude/commands/setup.md`** - Project setup slash command
   - Provides `/setup` command to initialize a new project
   - Invokes the project-setup agent
   - Makes customizing templates effortless

### REST API Specific (Optional)

8. **`.claude/agents/http-status-reviewer.md`** - HTTP status code validator *(REST APIs only)*
   - Reviews test files for correct HTTP status code expectations
   - Validates against REST best practices
   - Flags incorrect patterns and provides recommendations
   - **Delete this file if your project is not a REST API**

9. **`.claude/HTTP_STATUS_CODES.md`** - HTTP status code guidelines *(REST APIs only)*
   - Comprehensive REST API status code reference
   - Includes examples, test patterns, and common mistakes
   - Framework-specific implementation examples
   - **Delete this file if your project is not a REST API**

## Detailed Installation

### Quick Start

1. **Clone this repository** (if you haven't already):
   ```bash
   git clone https://github.com/eppeters/claude-code-base-project-template.git
   cd claude-code-base-project-template
   ```

2. **Run the installation script** pointing to your target project:
   ```bash
   ./install.sh /path/to/your/project
   ```

   Or run interactively (will prompt for target directory):
   ```bash
   ./install.sh
   ```

3. **Handle any conflicts**: If files already exist in your project, the script will:
   - Copy all non-conflicting files automatically
   - Show you a summary of conflicting files
   - Launch Claude Code to help you resolve conflicts interactively

4. **Customize your project** using Claude Code:
   ```
   /setup
   ```
   This will interview you about your project and fill in all template placeholders.

### Manual Installation

If you prefer manual control:

1. **Copy files manually** to your project root:
   ```bash
   rsync -av --exclude='README.md' --exclude='.git/' --exclude='.github/' \
         --exclude='install.sh' --exclude='test/' --exclude='LICENSE' \
         --exclude='GITHUB_DESCRIPTION.md' --exclude='.claude/settings.local.json' \
         /path/to/claude-code-base-project-template/ /path/to/your/project/
   ```

2. **Customize `CLAUDE.md`**:
   - Replace `[PROJECT NAME]` with your actual project name
   - Fill in the project context, purpose, and business domain
   - Document your specific architecture pattern
   - List your technology stack
   - Define your core data models
   - Add project-specific patterns and workflows

3. **Customize `DEVELOPMENT.md`**:
   - Update the architecture section to match your project structure
   - Customize the layer descriptions based on your architecture
   - Update setup, testing, and deployment commands
   - Add project-specific development tasks

4. **Configure `.claude/` files**:
   - **For non-REST API projects**: Delete `.claude/HTTP_STATUS_CODES.md` and `.claude/agents/http-status-reviewer.md`
   - **For REST API projects**: Keep all files and customize HTTP status code guidelines if needed
   - Update the `user-story-implementer.md` if you have project-specific patterns
   - Customize the `/feature` command if needed

5. **Add to your main project README** (optional):
   ```markdown
   ## Development Workflow

   This project follows strict Test-Driven Development (TDD) methodology.
   See @CLAUDE.md and @DEVELOPMENT.md for detailed instructions.

   To implement a new feature: Use the `/feature` command in Claude Code
   ```

### For an Existing Project

1. **Start with documentation**:
   - Create `CLAUDE.md` by filling in the template with your existing project details
   - Create `DEVELOPMENT.md` to document your current architecture and workflows

2. **Gradually adopt the workflow**:
   - Begin using TDD for new features
   - Set up the `.claude/` agents and commands
   - Use the `user-story-implementer` agent for new user stories

3. **Iterate and refine**:
   - Update the documentation as you discover patterns
   - Customize the agents to match your team's preferences
   - Add project-specific guidelines as needed

## Key Principles

### 1. Test-Driven Development (TDD)
- **Write tests FIRST**, before any implementation code
- Tests must fail correctly (ImportError or NotImplementedError)
- Get user confirmation before proceeding to implementation
- Implement one layer at a time
- Run tests continuously until they pass

### 2. Specification-Driven Development
- Every feature starts with a clear user story
- Define specific, testable acceptance criteria
- Link implementation to requirements
- Verify all acceptance criteria are met

### 3. Layered Architecture
- Maintain clear separation between layers
- Each layer has specific responsibilities
- Top-to-bottom dependencies only (API → Service → Repository → Model)
- No circular dependencies

### 4. Continuous Verification
- Commit immediately after each logical change
- Run tests after every implementation change
- Never batch unrelated changes
- Use descriptive commit messages

### 5. Quality Enforcement
- Use sub-agents to validate standards
- Follow consistent coding patterns
- No code comments explaining what code does
- Use type hints throughout

## Workflow Example

Here's how a typical feature implementation works with these templates:

1. **User invokes `/feature` command** in Claude Code
2. **user-story-implementer agent asks questions**:
   - Who is the user?
   - What do they want to accomplish?
   - Why do they want this?
3. **Agent proposes acceptance criteria** in GIVEN/WHEN/THEN format
4. **Agent writes comprehensive tests** covering all criteria
5. **Tests are run** and fail correctly (ImportError/NotImplementedError)
6. **User confirms** tests are correct
7. **Agent implements layer by layer**:
   - API layer (with service stubs)
   - Service layer (with repository stubs)
   - Repository layer (with model stubs)
   - Model layer
8. **Tests pass**, feature is complete
9. **Agent reports** what was implemented and commits all changes

## Customization Guide

### Adapting for Different Project Types

**Web API Projects (FastAPI, Express, Django REST)**:
- ✅ Use all templates as-is
- ✅ Keep `.claude/HTTP_STATUS_CODES.md` and `.claude/agents/http-status-reviewer.md`
- Customize with your specific endpoints and patterns

**CLI Applications**:
- ❌ Delete `.claude/HTTP_STATUS_CODES.md` and `.claude/agents/http-status-reviewer.md`
- Update architecture to CLI-specific patterns
- Focus on command-line interaction patterns

**Libraries/SDKs**:
- ❌ Delete `.claude/HTTP_STATUS_CODES.md` and `.claude/agents/http-status-reviewer.md`
- Update architecture to focus on public API design
- Emphasize documentation and examples

**Desktop/Mobile Applications**:
- ❌ Delete `.claude/HTTP_STATUS_CODES.md` and `.claude/agents/http-status-reviewer.md`
- Adapt architecture to UI/presentation layers
- Update testing patterns for UI testing
- Consider adding UI-specific sub-agents

**Data Processing/ML Projects**:
- ❌ Delete `.claude/HTTP_STATUS_CODES.md` and `.claude/agents/http-status-reviewer.md`
- Update architecture for data pipelines or model training
- Focus on data validation and transformation patterns
- Emphasize reproducibility and experiment tracking

### Adapting for Different Languages

**Python**:
- Templates include Python-specific examples (pytest, FastAPI)
- Update with your specific frameworks

**JavaScript/TypeScript**:
- Replace pytest with Jest/Mocha
- Update import patterns
- Adjust type annotation examples

**Java/Kotlin**:
- Replace pytest with JUnit
- Update class structure examples
- Adjust for statically-typed patterns

**Go**:
- Update testing patterns for Go's testing package
- Adjust error handling patterns
- Update import and package structure

## Benefits of This Approach

1. **Bulletproof Code**: Comprehensive tests catch bugs before they reach production
2. **Clear Requirements**: User stories ensure everyone understands what's being built
3. **Maintainable Architecture**: Clean separation of concerns makes code easy to modify
4. **Consistent Quality**: Automated enforcement of standards via sub-agents
5. **Efficient Collaboration**: Clear documentation helps team members and AI assistants understand the codebase
6. **Reduced Technical Debt**: Tests and architecture prevent accumulation of shortcuts
7. **Faster Onboarding**: New team members can quickly understand development workflow

## Troubleshooting

**Q: Claude isn't following TDD strictly enough**
- Ensure `CLAUDE.md` has clear "MUST" language in critical rules
- Verify `DEVELOPMENT.md` emphasizes the TDD workflow
- Use the `/feature` command to invoke the specialized agent

**Q: Tests aren't comprehensive enough**
- Update acceptance criteria to be more specific
- Add examples of edge cases to `DEVELOPMENT.md`
- Review the `user-story-implementer` agent's test coverage requirements

**Q: The workflow feels too rigid**
- This is intentional! Strictness prevents bugs and technical debt
- However, customize the templates to match your team's preferences
- You can relax certain rules by updating `CLAUDE.md`

**Q: How do I handle quick fixes or emergencies?**
- Even quick fixes benefit from tests
- For true emergencies, document that you'll add tests afterward
- Use git commit `--no-verify` if you have pre-commit hooks, but sparingly

## Development

### Running Tests

This repository includes a comprehensive test suite for the `install.sh` script using the Bats testing framework.

**Run all tests:**
```bash
./test/run-tests.sh
```

**Run specific tests:**
```bash
./test/bats/bin/bats test/install.bats --filter "pattern"
```

**Test coverage includes:**
- Happy path: fresh installs, directory creation, file copying
- Conflict detection: handling existing files, preserving user data
- Edge cases: relative paths, multiple arguments, excluded files
- Mock integration: simulates Claude Code invocation for conflict resolution

The tests use a mock `claude` command to avoid requiring an actual Claude Code installation for testing.

### Continuous Integration

Tests run automatically on every push to GitHub via GitHub Actions. See `.github/workflows/test.yml` for the CI configuration.

### Updating the Test Framework

The repository vendors Bats-core 1.12.0 in `test/bats/`. To update to a newer version:

```bash
# Remove old version
rm -rf test/bats

# Clone new version
cd /tmp
git clone --depth 1 https://github.com/bats-core/bats-core.git

# Copy to project, excluding unnecessary files
cp -r bats-core claude-code-base-project-template/test/bats
cd claude-code-base-project-template/test/bats
rm -rf .git test test2 docs .github

# Verify it works
cd ../..
./test/run-tests.sh

# Commit
git add test/bats
git commit -m "Update Bats testing framework to version X.Y.Z"
```

## Contributing Back

If you develop useful enhancements to these templates:
- Consider sharing them with others
- Document project-specific agents you create
- Share domain-specific patterns and guidelines

## Contributing

This is a personal template repository, but suggestions and improvements are welcome. Feel free to fork and adapt for your own needs.

## License

These templates are provided as-is for use in any project. Customize them freely to match your needs.

## Credits

**Created by Eddie Peters** (eddie@dinogalactic.com)

These templates were derived from production codebases and best practices, refined through real-world application of TDD and specification-driven workflows.
