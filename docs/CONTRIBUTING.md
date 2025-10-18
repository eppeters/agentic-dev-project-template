# Contributing to Template Repository

## Development Setup

### Prerequisites
- Bash 4.0+
- rsync
- Git
- Claude Code CLI (optional, for testing)

### Running Tests

```bash
./test/run-tests.sh
```

### Manual Testing

```bash
./install.sh /tmp/test-project
cd /tmp/test-project
cat CLAUDE.md  # Should have placeholders
```

## Making Changes

### To Template Files

1. Edit files in `templates/` directory
2. Keep placeholders: `[PROJECT NAME]`, `[FRAMEWORK]`, etc.
3. Test installation: `./test/run-tests.sh`
4. Commit with descriptive message

### To install.sh

1. Edit `install.sh`
2. Update tests in `test/install.bats` if behavior changed
3. Run tests: `./test/run-tests.sh`
4. Test manually with various scenarios

### To Documentation

1. Keep README.md concise - move details to `docs/`
2. Ensure template docs have placeholders
3. Update both repository and template documentation as needed

## Test Framework

### Bats Testing Framework

The repository vendors Bats-core 1.12.0 in `test/bats/`. To update:

```bash
# Remove old version
rm -rf test/bats

# Clone new version
cd /tmp
git clone --depth 1 https://github.com/bats-core/bats-core.git

# Copy to project, excluding unnecessary files
cp -r bats-core /path/to/template-repo/test/bats
cd /path/to/template-repo/test/bats
rm -rf .git test test2 docs .github

# Verify it works
cd ../..
./test/run-tests.sh

# Commit
git add test/bats
git commit -m "Update Bats testing framework to version X.Y.Z"
```

## Continuous Integration

Tests run automatically on every push via GitHub Actions. Check `.github/workflows/test.yml`.

## Commit Message Format

```
Title describing the change

- Bullet points of specific changes made
- Include technical details
- Reference any issues if applicable

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Pull Request Guidelines

1. All tests must pass
2. Manual installation test completed
3. Documentation updated
4. Commit messages are descriptive
5. Changes maintain backward compatibility when possible
