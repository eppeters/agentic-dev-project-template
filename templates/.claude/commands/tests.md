---
description: Remind it to write tests
allowed-tools: Bash, SlashCommand
---

# Test-Driven Development Reminder

**CRITICAL REMINDER**: This project follows STRICT **Double Loop TDD** methodology.

## THE IRON LAW OF TDD

**RULE #1**: ALWAYS WRITE TESTS BEFORE NON-TEST CODE

You MUST write tests before writing ANY implementation code. This includes:
- ✅ Database migrations
- ✅ Validation changes
- ✅ Route updates
- ✅ Package changes
- ✅ Text changes
- ✅ Exception behavior
- ✅ Error responses
- ✅ **LITERALLY EVERYTHING**

## Double Loop TDD Development Cycle

### OUTER LOOP: Acceptance/E2E Test (Hours to Days)

1. **Write ONE Acceptance Test** (FIRST)
   - Write failing acceptance/E2E test for the user story
   - Test from user's perspective (HTTP, CLI, UI)
   - Tests must fail due to ImportError or NotImplementedError
   - NOT syntax errors or missing imports

2. **Run Acceptance Test** (Verify RED)
   ```bash
   # Run the acceptance test (check @DEVELOPMENT.md)
   pytest path/to/test_acceptance.py -v
   ```

3. **STOP and Get User Confirmation**
   - Show the failing acceptance test
   - Wait for user to confirm test correctly validates user story
   - **DO NOT proceed to inner loop without confirmation**

4. **Enter Inner Loop**
   - Break down feature into components
   - For each component, complete inner loop below
   - Periodically run acceptance test to check progress

5. **When Acceptance Test Passes (GREEN)**
   - Refactor the complete implementation
   - Run acceptance test - ensure still GREEN
   - STOP for user review of refactored code
   - Commit complete feature

### INNER LOOP: Unit Tests (Minutes) - RED-GREEN-REFACTOR

1. **RED - Write ONE Failing Unit Test**
   - Test one small piece of functionality
   - Use mocking to isolate component
   - Run test - should fail
   - STOP for user confirmation

2. **GREEN - Make Test Pass**
   - Write minimal code (3-5 lines typically)
   - Don't worry about perfection
   - Follow architecture pattern in @CLAUDE.md
   - Use NotImplementedError stubs for dependencies
   - Run test - should pass

3. **REFACTOR - Improve Code**
   - Eliminate duplication (DRY)
   - Improve naming and clarity
   - Check security (input validation, error handling)
   - Follow project standards
   - Run test - ensure still GREEN

4. **Commit**
   - After each complete RED-GREEN-REFACTOR cycle

5. **Repeat**
   - Write next unit test or exit to outer loop

## What You Should Do RIGHT NOW

**If you haven't written tests yet:**
1. STOP implementing code immediately
2. Write comprehensive tests covering the feature
3. Run tests to verify they fail correctly
4. Get user confirmation
5. THEN implement

**If you've already written tests:**
1. Run the tests to verify current state
2. Implement the next layer
3. Run tests again
4. Commit when tests pass

**If tests are passing:**
1. Run the full test suite to ensure nothing broke
2. Commit the changes using `/commit`

---

## Now Run Tests

Execute the appropriate test command for this project (check @DEVELOPMENT.md for the exact command):

```bash
# Common patterns (adjust for your project):
pytest tests/ -v
npm test
cargo test
go test ./...
```

After running tests, use `/commit` to commit your work:

/commit
