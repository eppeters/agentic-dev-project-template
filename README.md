# Claude Code Base Project Template

[![Tests](https://github.com/eppeters/claude-code-base-project-template/workflows/Test%20install.sh/badge.svg)](https://github.com/eppeters/claude-code-base-project-template/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Reusable configuration files, development workflows, and documentation templates for Claude Code projects that enforce strict Test-Driven Development and clean architecture patterns.

**Note**: These templates are designed for Claude Code CLI and have not been tested with other AI coding assistants.

## Quick Start

```bash
# Install templates
git clone https://github.com/eppeters/claude-code-base-project-template.git
cd claude-code-base-project-template
./install.sh /path/to/your/project

# Customize for your project
cd /path/to/your/project
claude
> /setup
```

## Features

- **TDD Enforcement**: Strict test-driven development with `/tests` and `/feature` commands
- **Clean Architecture**: Layered architecture with clear separation of concerns
- **Smart Commits**: `/commit` command ensures proper commit practices
- **Project Setup**: `/setup` command customizes all template placeholders
- **REST API Support**: Optional HTTP status code validation (for API projects)
- **Conflict Resolution**: Install script detects conflicts and helps merge files

## Repository Structure

```
agentic-dev-project-template/
├── templates/              # Files copied to your project
│   ├── CLAUDE.md          # Project instructions (with placeholders)
│   ├── DEVELOPMENT.md     # Development guide (with placeholders)
│   └── .claude/           # Claude Code configuration
│       ├── agents/        # Specialized agents (TDD, setup, HTTP status)
│       └── commands/      # Slash commands (/feature, /setup, /commit, /tests)
├── install.sh             # Installation script
├── docs/                  # Detailed documentation
└── test/                  # Test suite
```

**Important**: Files in `templates/` are copied to your project. Root-level `CLAUDE.md` and `DEVELOPMENT.md` guide development of this template repository itself.

## Usage

### 1. Install Templates

```bash
./install.sh ~/projects/my-app
```

The script copies `templates/` to your project and handles conflicts intelligently.

### 2. Customize with /setup

```bash
cd ~/projects/my-app
claude
> /setup
```

The setup agent will ask about your project and fill in all placeholders:
- Project name, type, and purpose
- Technology stack (language, framework, database)
- Architecture pattern
- Testing framework

### 3. Implement Features with /feature

```bash
> /feature
```

The feature agent enforces TDD methodology:
1. Gathers user story requirements
2. Writes comprehensive tests FIRST
3. Implements code layer-by-layer
4. Commits when tests pass

### 4. Use Helper Commands

- `/tests` - Reminds Claude to write tests before implementation
- `/commit` - Reminds Claude to commit changes immediately

## What's Included

### Slash Commands (templates/.claude/commands/)
- **`/feature`** - Implement features with strict TDD
- **`/setup`** - Customize templates for your project
- **`/commit`** - Enforce immediate commits with proper format
- **`/tests`** - Enforce test-first development

### Agents (templates/.claude/agents/)
- **`user-story-implementer`** - Implements features layer-by-layer with TDD
- **`project-setup`** - Customizes all template placeholders
- **`http-status-reviewer`** *(optional)* - Validates REST API status codes

### Documentation Templates
- **`CLAUDE.md`** - Project-specific instructions for Claude Code
- **`DEVELOPMENT.md`** - Comprehensive development guide
- **`PERSONA.md`** - Communication style and approach

## Key Principles

1. **Test-Driven Development**: Write tests FIRST, always
2. **Immediate Commits**: Commit after every logical change
3. **Layered Architecture**: Clear separation of concerns
4. **User Stories**: Every feature starts with acceptance criteria

## Documentation

- **[Customization Guide](docs/CUSTOMIZATION.md)** - Adapt for different project types and languages
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions
- **[Contributing](docs/CONTRIBUTING.md)** - Development setup and guidelines

## Example Workflow

```bash
# Day 1: Setup
./install.sh ~/projects/task-api
cd ~/projects/task-api
claude
> /setup

# Day 2-N: Build features
> /feature
[Implement user authentication]

> /feature
[Implement task creation]

> /feature
[Implement task listing]
```

Each feature follows TDD: tests first, implementation second, commit when passing.

## Supported Project Types

- **Web APIs** (FastAPI, Express, Django REST) - Use all templates
- **CLI Applications** - Remove HTTP status files
- **Libraries/SDKs** - Focus on public API design
- **Desktop/Mobile Apps** - Adapt to UI patterns
- **Data/ML Projects** - Focus on pipelines and reproducibility

See [Customization Guide](docs/CUSTOMIZATION.md) for details.

## Benefits

- ✅ Bulletproof code with comprehensive test coverage
- ✅ Clear requirements from user stories
- ✅ Maintainable architecture with separation of concerns
- ✅ Consistent quality enforced by agents
- ✅ Reduced technical debt
- ✅ Faster onboarding for new developers

## Development

### Running Tests

```bash
./test/run-tests.sh
```

### Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for development setup and guidelines.

## License

MIT License - See [LICENSE](LICENSE) for details.

## Credits

**Created by Eddie Peters** (eddie@dinogalactic.com)

These templates were derived from production codebases and best practices, refined through real-world application of TDD and specification-driven workflows.
