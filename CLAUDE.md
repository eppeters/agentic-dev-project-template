# Claude Code Instructions - Template Repository

## Project Context & Purpose

This repository provides reusable configuration files, development workflows, and documentation templates for Claude Code projects. It is a **template repository** - the files in `templates/` are meant to be copied to target projects and customized.

**Key Business Context:**
- **Target Users**: Developers using Claude Code to build software projects
- **Core Problem**: Lack of standardized TDD workflows and project documentation for Claude Code
- **Primary Benefits**: Enforces strict Test-Driven Development, provides clean architecture patterns, ensures consistent code quality

## Repository Structure

```
agentic-dev-project-template/
├── templates/                     # Template files copied to target projects
│   ├── CLAUDE.md                 # Template project instructions (with placeholders)
│   ├── DEVELOPMENT.md            # Template development guide (with placeholders)
│   └── .claude/                  # Template Claude Code configuration
│       ├── PERSONA.md
│       ├── HTTP_STATUS_CODES.md
│       ├── agents/
│       │   ├── user-story-implementer.md
│       │   ├── http-status-reviewer.md
│       │   └── project-setup.md
│       └── commands/
│           ├── feature.md
│           ├── setup.md
│           ├── commit.md
│           └── tests.md
├── CLAUDE.md                      # THIS FILE - Instructions for working on template repo
├── DEVELOPMENT.md                 # Development guide for template repo
├── README.md                      # Public documentation
├── install.sh                     # Installation script
├── test/                          # Test suite for install.sh
└── .claude/                       # Claude Code config for template repo development
    ├── PERSONA.md
    └── commands/
```

## Critical Development Rules

### 1. Template vs Repository Files

**IMPORTANT**: This repository has TWO sets of files:

1. **Template files** (`templates/` directory):
   - These are copied to target projects by `install.sh`
   - Contain placeholders like `[PROJECT NAME]` and `[FRAMEWORK]`
   - Should be generic and applicable to many project types
   - When editing these, think: "Will this help developers using the templates?"

2. **Repository files** (root level):
   - `CLAUDE.md`, `DEVELOPMENT.md`, `.claude/` at root level
   - These guide development of the template repository itself
   - When editing these, think: "Will this help contributors to this repo?"

### 2. Testing Changes

**ALWAYS test install.sh after making changes to:**
- The `templates/` directory structure
- The `install.sh` script itself
- The test suite

Run tests:
```bash
./test/run-tests.sh
```

### 3. Commit Strategy

Use descriptive commit messages:
```
Title describing the change

- Bullet points of specific changes made
- Include technical details
- Reference any issues or requirements

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Common Development Tasks

### Adding a New Template File

1. Create the file in `templates/` directory
2. Use placeholders for project-specific values: `[PROJECT NAME]`, `[FRAMEWORK]`, etc.
3. Update the project-setup agent if it should fill in these placeholders
4. Test that install.sh copies the file correctly
5. Update documentation to mention the new file

### Adding a New Slash Command Template

1. Create the command file in `templates/.claude/commands/`
2. Use the frontmatter format with `description` and `allowed-tools`
3. Make the command generic enough for different project types
4. Document it in the template README
5. Test with install.sh

### Adding a New Agent Template

1. Create the agent file in `templates/.claude/agents/`
2. Use the frontmatter format with `name`, `description`, and `tools`
3. Make the agent follow TDD principles
4. Document it in the template README
5. Test with install.sh

### Updating Documentation

1. **Template documentation** (`templates/CLAUDE.md`, `templates/DEVELOPMENT.md`):
   - Keep placeholders for customization
   - Make examples generic
   - Think about different project types

2. **Repository documentation** (root `README.md`):
   - Explain how to use the templates
   - Keep it concise
   - Move detailed guides to `docs/` folder

### Testing install.sh

```bash
# Run full test suite
./test/run-tests.sh

# Test installation manually
./install.sh /tmp/test-project
cd /tmp/test-project
ls -la
cat CLAUDE.md  # Should have placeholders
```

## Architecture Overview

**Installation Flow:**
```
1. User runs: ./install.sh /path/to/project
2. Script copies templates/ directory to target
3. Script detects conflicts with existing files
4. Script invokes Claude Code to help resolve conflicts
5. User runs /setup to customize placeholders
```

**Template Customization Flow:**
```
1. User invokes /setup command
2. project-setup agent asks questions
3. Agent fills in all placeholders in CLAUDE.md and DEVELOPMENT.md
4. Agent removes irrelevant files (e.g., HTTP_STATUS_CODES.md for non-API projects)
5. User begins development with /feature command
```

## Technology Stack

- **Shell**: Bash (for install.sh)
- **Testing**: Bats (Bash Automated Testing System)
- **File Operations**: rsync
- **CI/CD**: GitHub Actions

## Project Structure Navigation

### Key Files to Understand First:

1. **`README.md`** - Public documentation explaining templates
2. **`install.sh`** - Installation script that copies templates/
3. **`templates/CLAUDE.md`** - Template project instructions
4. **`templates/.claude/agents/user-story-implementer.md`** - Core TDD agent
5. **`test/install.bats`** - Test suite for install.sh

### Template Files Overview:

**Core Templates:**
- `templates/CLAUDE.md` - Project-specific instructions for Claude Code
- `templates/DEVELOPMENT.md` - Development workflow guide

**Agents:**
- `user-story-implementer.md` - Implements features with TDD
- `project-setup.md` - Customizes templates for new projects
- `http-status-reviewer.md` - Reviews HTTP status codes (REST APIs only)

**Commands:**
- `/feature` - Invoke user-story-implementer to build a feature
- `/setup` - Invoke project-setup to customize templates
- `/commit` - Remind to commit changes
- `/tests` - Remind to write tests first (TDD)

## Success Criteria

When contributing to this repository:
- ✅ Templates work for multiple project types (APIs, CLIs, libraries, etc.)
- ✅ install.sh successfully copies files and handles conflicts
- ✅ All tests pass (`./test/run-tests.sh`)
- ✅ Documentation is clear and accurate
- ✅ Changes are committed with descriptive messages
- ✅ Templates enforce TDD methodology strictly

## Working with This Repository

**Adding Features:**
- Modify template files in `templates/`
- Test with install.sh
- Update documentation
- Run test suite

**Fixing Bugs:**
- Identify if bug is in templates or install script
- Write test case if applicable
- Fix and verify
- Commit with clear message

**Updating Documentation:**
- Keep README.md concise
- Move detailed guides to `docs/` if needed
- Ensure template docs have placeholders

Remember: This repository provides **templates** - prioritize flexibility and clarity over project-specific optimizations.
