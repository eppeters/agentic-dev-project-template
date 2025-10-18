---
description: Remind it to write tests
allowed-tools: Bash, SlashCommand
---

# Test-Driven Development Reminder

**CRITICAL REMINDER**: This project follows STRICT Test-Driven Development (TDD) methodology.

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

## TDD Development Cycle

1. **Write Tests First** (ALWAYS)
   - Create comprehensive test file covering all acceptance criteria
   - Tests must fail due to ImportError or NotImplementedError
   - NOT syntax errors or missing imports

2. **Run Tests** (Verify They Fail)
   ```bash
   # Run the test command for this project (check @DEVELOPMENT.md)
   pytest path/to/test_file.py -v
   ```

3. **STOP and Get User Confirmation**
   - Show the failing tests
   - Wait for user to confirm tests are correct
   - **DO NOT proceed to implementation without confirmation**

4. **Implement ONE Layer at a Time**
   - Follow the architecture pattern in @CLAUDE.md
   - Use NotImplementedError stubs for dependencies
   - Run tests after each layer
   - Commit immediately when tests pass

5. **Commit Immediately**
   - After tests are written and verified
   - After each layer is implemented
   - After tests pass

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
