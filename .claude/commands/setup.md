---
description: Set up a new project by gathering requirements and filling in all template placeholders
allowed-tools: Task
---

# Project Setup

I'll help you set up a new project with the TDD workflow templates. I'll ask you about your project and automatically fill in all the placeholders in the template files.

@Task(
    description="Set up new project with TDD templates",
    prompt="I'm setting up a new project using the TDD workflow templates. Please interview me about my project by asking structured questions to gather: project name, type, purpose, target users, benefits, tech stack (language, framework, database, testing, package manager), architecture pattern, key data models, project structure, development commands, and any special considerations. After gathering all information, present a summary for confirmation. Once confirmed, customize all template files by replacing placeholders with the actual project information, remove irrelevant files (like HTTP status code files for non-REST API projects), and provide clear next steps for getting started.",
    subagent_type="project-setup"
)
