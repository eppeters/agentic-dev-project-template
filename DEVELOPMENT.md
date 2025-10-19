# Development Guide - Template Repository

## Project Overview

This repository maintains templates for Claude Code projects that enforce Test-Driven Development methodology and clean architecture patterns. The templates are installed into target projects via `install.sh`.

**Component Role**: Provides standardized project structure and documentation templates for Claude Code users.

## Repository Structure

### Directory Organization

```
agentic-dev-project-template/
├── templates/              # Files copied to target projects
│   ├── CLAUDE.md          # Template with placeholders
│   ├── DEVELOPMENT.md     # Template with placeholders
│   └── .claude/           # Claude Code configuration templates
├── install.sh             # Installation script
├── test/                  # Test suite
│   ├── run-tests.sh      # Test runner
│   └── install.bats      # Bats tests for install.sh
├── CLAUDE.md             # Instructions for this repository
├── DEVELOPMENT.md        # This file
└── .claude/              # Claude Code config for template development
```

### Template Files vs Repository Files

**Template Files** (`templates/` directory):
- Copied to target projects by `install.sh`
- Contain placeholders: `[PROJECT NAME]`, `[FRAMEWORK]`, etc.
- Customized by the project-setup agent when user runs `/setup`

**Repository Files** (root level):
- Guide contributors working on the template repository
- Not copied to target projects
- Specific to maintaining and testing templates

## Development Workflow

### Making Changes to Templates

1. **Edit files in `templates/` directory**
   ```bash
   vim templates/CLAUDE.md
   vim templates/.claude/agents/user-story-implementer.md
   ```

2. **Test the installation process**
   ```bash
   ./test/run-tests.sh
   ```

3. **Manual testing** (optional but recommended)
   ```bash
   ./install.sh /tmp/test-project
   cd /tmp/test-project
   cat CLAUDE.md  # Verify placeholders exist
   ```

4. **Commit changes**
   ```bash
   git add templates/
   git commit -m "Update template files

   - Specific changes made
   - Why these changes improve the templates"
   ```

### Adding New Template Files

1. **Create file in `templates/` directory**
   ```bash
   touch templates/.claude/commands/new-command.md
   ```

2. **Use placeholders for project-specific values**
   ```markdown
   # Example with placeholders
   Run tests: [test command]
   Framework: [FRAMEWORK]
   ```

3. **Update project-setup agent** if it should fill placeholders
   - Edit `templates/.claude/agents/project-setup.md`
   - Add logic to replace new placeholders

4. **Test installation**
   ```bash
   ./test/run-tests.sh
   ```

5. **Document in template README**
   - Update templates' documentation to mention new file

### Modifying install.sh

1. **Edit install.sh**
   ```bash
   vim install.sh
   ```

2. **Test changes thoroughly**
   ```bash
   ./test/run-tests.sh

   # Test manually
   ./install.sh /tmp/test-install
   ```

3. **Update tests if behavior changed**
   ```bash
   vim test/install.bats
   ```

## Running Tests

### Quick Test Run

```bash
./test/run-tests.sh
```

### Verbose Test Output

```bash
./test/bats/bin/bats test/install.bats -t
```

### Running Specific Tests

```bash
./test/bats/bin/bats test/install.bats --filter "conflict"
```

### Test Coverage

The test suite covers:
- ✅ Fresh installations to new directories
- ✅ Directory creation
- ✅ File copying from `templates/`
- ✅ Conflict detection for existing files
- ✅ Exclusion of settings.local.json
- ✅ Relative and absolute paths
- ✅ Error handling

## Manual Testing Process

### Test Installation to New Project

```bash
# Create test directory
mkdir -p /tmp/test-new-project

# Run installation
./install.sh /tmp/test-new-project

# Verify files were copied
ls -la /tmp/test-new-project
cat /tmp/test-new-project/CLAUDE.md

# Check for placeholders
grep -r "\[PROJECT NAME\]" /tmp/test-new-project

# Clean up
rm -rf /tmp/test-new-project
```

### Test Conflict Resolution

```bash
# Create project with existing files
mkdir -p /tmp/test-conflict
echo "existing content" > /tmp/test-conflict/CLAUDE.md

# Run installation (should detect conflict)
./install.sh /tmp/test-conflict

# Expected behavior:
# 1. Script detects CLAUDE.md conflict
# 2. Invokes Claude Code automatically
# 3. Claude receives both file versions in the prompt
# 4. Claude analyzes and recommends: Replace/Keep/Merge
# 5. User approves recommendation
# 6. Claude executes the solution

# Verify conflict was detected
# Verify existing file was NOT overwritten (until user approves)
cat /tmp/test-conflict/CLAUDE.md

# Clean up
rm -rf /tmp/test-conflict
```

### Test Template Customization

```bash
# Install to new project
./install.sh /tmp/test-setup
cd /tmp/test-setup

# Start Claude Code and run /setup
claude

# In Claude Code:
# > /setup
# Answer questions and verify placeholders are replaced

# Clean up
cd -
rm -rf /tmp/test-setup
```

## Common Development Tasks

### Adding a New Slash Command Template

1. Create `templates/.claude/commands/your-command.md`
2. Use frontmatter format:
   ```markdown
   ---
   description: Brief description of command
   allowed-tools: Tool1, Tool2
   ---

   # Command Implementation

   [Command content here]
   ```
3. Test with install.sh
4. Document in template README

### Adding a New Agent Template

1. Create `templates/.claude/agents/your-agent.md`
2. Use frontmatter format:
   ```markdown
   ---
   name: agent-name
   description: Brief description
   tools: Tool1, Tool2, Tool3
   ---

   # Agent Instructions

   [Agent implementation here]
   ```
3. Test with install.sh
4. Document in template README

### Updating Documentation Templates

1. Edit `templates/CLAUDE.md` or `templates/DEVELOPMENT.md`
2. Keep placeholders for customization: `[PROJECT NAME]`, `[FRAMEWORK]`, etc.
3. Make examples generic enough for various project types
4. Test installation
5. Verify project-setup agent can fill placeholders

## Commit Message Format

Use this format for all commits:

```
Title describing the change

- Bullet points of specific changes made
- Include technical details
- Reference any issues if applicable

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Testing Best Practices

### Before Committing

1. **Run the test suite**
   ```bash
   ./test/run-tests.sh
   ```

2. **Manual installation test**
   ```bash
   ./install.sh /tmp/verify
   cd /tmp/verify
   # Check that everything looks correct
   ```

3. **Verify placeholders** exist in templates
   ```bash
   grep -r "\[PROJECT NAME\]" templates/
   ```

### After Major Changes

1. Test on multiple scenarios:
   - Fresh installation
   - Installation with conflicts
   - Installation to existing git repo
   - Installation with relative paths

2. Verify GitHub Actions CI passes

## Architecture Patterns

### Installation Flow

```
User runs: ./install.sh /path/to/project
    ↓
Script validates target directory
    ↓
Script copies templates/ to target (rsync)
    ↓
Script detects conflicting files
    ↓
If conflicts: Invoke Claude Code for help
    ↓
User runs /setup to customize templates
```

### Template Customization Flow

```
User runs: /setup in target project
    ↓
project-setup agent asks questions
    ↓
Agent collects: name, tech stack, architecture, etc.
    ↓
Agent replaces placeholders in CLAUDE.md and DEVELOPMENT.md
    ↓
Agent removes irrelevant files (e.g., HTTP_STATUS_CODES.md for non-APIs)
    ↓
User begins development with /feature
```

## Troubleshooting

### Tests Failing

1. **Check Bats installation**
   ```bash
   ./test/bats/bin/bats --version
   ```

2. **Run tests with verbose output**
   ```bash
   ./test/bats/bin/bats test/install.bats -t
   ```

3. **Check for syntax errors in install.sh**
   ```bash
   bash -n install.sh
   ```

### install.sh Not Copying Files

1. **Verify templates/ directory exists**
   ```bash
   ls -la templates/
   ```

2. **Check TEMPLATE_DIR variable**
   ```bash
   # In install.sh, should be:
   TEMPLATE_DIR="$SCRIPT_DIR/templates"
   ```

3. **Test rsync manually**
   ```bash
   rsync -av --ignore-existing templates/ /tmp/test-rsync/
   ```

### Placeholders Not Being Replaced

1. **Check project-setup agent** (`templates/.claude/agents/project-setup.md`)
2. **Verify placeholder format** matches what agent expects
3. **Test /setup command** manually

## CI/CD

### GitHub Actions

Tests run automatically on every push via `.github/workflows/test.yml`.

**Workflow:**
1. Checkout code
2. Run `./test/run-tests.sh`
3. Report results

**Viewing Results:**
- Check Actions tab on GitHub
- Badge in README.md shows status

## Contributing Guidelines

When contributing to this repository:

1. **Understand the dual structure**: Template files vs repository files
2. **Test thoroughly**: Run test suite and manual tests
3. **Keep templates generic**: Applicable to many project types
4. **Document changes**: Update relevant README sections
5. **Commit frequently**: Small, logical commits
6. **Follow patterns**: Match existing code style and structure

## Success Criteria

Changes are ready to merge when:
- ✅ All tests pass (`./test/run-tests.sh`)
- ✅ Manual installation works correctly
- ✅ Templates contain appropriate placeholders
- ✅ Documentation is updated
- ✅ Commit messages are descriptive
- ✅ GitHub Actions CI passes

Remember: These templates help developers build better software with Claude Code. Prioritize clarity, flexibility, and strict TDD enforcement.
