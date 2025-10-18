# Troubleshooting Guide

## Common Issues

### Claude isn't following TDD strictly enough
- Ensure `CLAUDE.md` has clear "MUST" language in critical rules
- Verify `DEVELOPMENT.md` emphasizes the TDD workflow
- Use the `/feature` command to invoke the specialized agent
- Use the `/tests` command to remind Claude about TDD

### Tests aren't comprehensive enough
- Update acceptance criteria to be more specific
- Add examples of edge cases to `DEVELOPMENT.md`
- Review the `user-story-implementer` agent's test coverage requirements

### The workflow feels too rigid
- This is intentional! Strictness prevents bugs and technical debt
- However, customize the templates to match your team's preferences
- You can relax certain rules by updating `CLAUDE.md`

### How do I handle quick fixes or emergencies?
- Even quick fixes benefit from tests
- For true emergencies, document that you'll add tests afterward
- Use git commit `--no-verify` if you have pre-commit hooks, but sparingly

### Claude forgets to commit changes
- Use the `/commit` command to remind Claude
- Emphasize the commit strategy in your `CLAUDE.md`
- Check that the commit command template is present in `.claude/commands/`

### Installation conflicts with existing files
- The `install.sh` script will detect conflicts and invoke Claude Code
- Claude will help you review and merge conflicting files
- You can manually resolve conflicts if Claude Code is not available
