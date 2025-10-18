# Customization Guide

## Adapting for Different Project Types

### Web API Projects (FastAPI, Express, Django REST)
- ✅ Use all templates as-is
- ✅ Keep `templates/.claude/HTTP_STATUS_CODES.md` and `templates/.claude/agents/http-status-reviewer.md`
- Customize with your specific endpoints and patterns

### CLI Applications
- ❌ Delete `templates/.claude/HTTP_STATUS_CODES.md` and `templates/.claude/agents/http-status-reviewer.md`
- Update architecture to CLI-specific patterns
- Focus on command-line interaction patterns

### Libraries/SDKs
- ❌ Delete `templates/.claude/HTTP_STATUS_CODES.md` and `templates/.claude/agents/http-status-reviewer.md`
- Update architecture to focus on public API design
- Emphasize documentation and examples

### Desktop/Mobile Applications
- ❌ Delete `templates/.claude/HTTP_STATUS_CODES.md` and `templates/.claude/agents/http-status-reviewer.md`
- Adapt architecture to UI/presentation layers
- Update testing patterns for UI testing
- Consider adding UI-specific sub-agents

### Data Processing/ML Projects
- ❌ Delete `templates/.claude/HTTP_STATUS_CODES.md` and `templates/.claude/agents/http-status-reviewer.md`
- Update architecture for data pipelines or model training
- Focus on data validation and transformation patterns
- Emphasize reproducibility and experiment tracking

## Adapting for Different Languages

### Python
- Templates include Python-specific examples (pytest, FastAPI)
- Update with your specific frameworks

### JavaScript/TypeScript
- Replace pytest with Jest/Mocha
- Update import patterns
- Adjust type annotation examples

### Java/Kotlin
- Replace pytest with JUnit
- Update class structure examples
- Adjust for statically-typed patterns

### Go
- Update testing patterns for Go's testing package
- Adjust error handling patterns
- Update import and package structure

## For Existing Projects

### Start with Documentation
- Create `CLAUDE.md` by filling in the template with your existing project details
- Create `DEVELOPMENT.md` to document your current architecture and workflows

### Gradually Adopt the Workflow
- Begin using TDD for new features
- Set up the `.claude/` agents and commands
- Use the `user-story-implementer` agent for new user stories

### Iterate and Refine
- Update the documentation as you discover patterns
- Customize the agents to match your team's preferences
- Add project-specific guidelines as needed
