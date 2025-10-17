---
description: Implement a new feature using Test-Driven Development methodology
allowed-tools: Task
---

# Feature Implementation

I'll help you implement a new feature using the specialized user-story-implementer agent with strict Test-Driven Development methodology.

@Task(
    description="Implement new feature with TDD",
    prompt="I need to implement a new feature following the project's strict TDD methodology. Please gather the complete requirements from the user by asking about the user type, what they want to accomplish, and why they want it. Then write comprehensive acceptance tests first, and implement the feature following the layered architecture one layer at a time as defined in @CLAUDE.md. Ensure all tests pass and follow the project conventions in @CLAUDE.md and @DEVELOPMENT.md.",
    subagent_type="user-story-implementer"
)
