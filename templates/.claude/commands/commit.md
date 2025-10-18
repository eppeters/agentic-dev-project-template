---
description: Remind it to commit the work
allowed-tools: Bash
---

# Commit Reminder

**CRITICAL REMINDER**: You MUST create a git commit immediately for the changes you just made.

This project follows strict development rules that require:
- **IMMEDIATE COMMITS** after every file change
- **NEVER batch multiple unrelated changes** into one commit
- **DESCRIPTIVE COMMIT MESSAGES** following the project format

## Commit Message Format

Use this exact format:

```
Title describing the change

Following: [Original user request or context]

- Bullet points of specific changes made
- Include technical details
- Reference any specs or requirements

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Instructions

1. Review the files you just changed
2. Create a commit NOW using the Bash tool
3. Use a HEREDOC for the commit message to ensure proper formatting

**Example**:
```bash
git add . && git commit -m "$(cat <<'EOF'
Add user authentication endpoint

Following: User request to add login functionality

- Created POST /api/auth/login endpoint
- Added password validation logic
- Implemented JWT token generation
- Added error handling for invalid credentials

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

## STOP PROCRASTINATING - COMMIT NOW
