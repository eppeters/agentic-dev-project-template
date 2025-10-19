---
description: Find bugs by binary search (comment out half the code)
allowed-tools: Read, Edit, Bash
---

# Find Bug - Binary Search Debugging

This command helps you find bugs by **systematically commenting out half of the code** until you isolate the exact line causing the issue.

## The Technique

1. **Comment out half** of the suspect code
2. **Run the test** to see if bug still happens
3. **If bug is gone** → bug was in the commented half (restore and bisect that half)
4. **If bug still happens** → bug is in the remaining half (bisect that half)
5. **Repeat** until you've isolated the exact problematic line(s)

**Efficiency**: O(log n) - even 1024 lines takes only ~10 iterations!

## Example

```python
# Suspect function with a bug (32 lines)
def process_data(data):
    # Lines 1-32 here
    ...
```

**Iteration 1**: Comment out lines 1-16
- Bug still happens → bug is in lines 17-32

**Iteration 2**: Comment out lines 17-24
- Bug gone → bug is in lines 17-24

**Iteration 3**: Comment out lines 17-20
- Bug still happens → bug is in lines 21-24

**Iteration 4**: Comment out lines 21-22
- Bug gone → bug is in lines 21-22

**Iteration 5**: Comment out line 21
- Bug still happens → **bug is on line 22!**

Found in 5 iterations instead of checking all 32 lines!

**Good for:**
- Complex functions where the bug location is unclear
- Large blocks of code that are failing
- When you know something is broken but not where
- When you want to isolate the minimal failing code

**Not ideal for:**
- Bugs you can already see in the code
- When commenting out code would break syntax (dependencies between lines)
- Race conditions or timing bugs (unreliable test)
- When you don't have a way to test if the bug is fixed

## How I'll Help You

I'll guide you through the binary search process step by step:

### Step 1: Setup
Tell me:
1. **Which file has the bug?**
2. **Which function or code block is suspect?** (or line range)
3. **How do I test if the bug is fixed?**
   - Automated test command (e.g., `pytest tests/test_feature.py`)
   - Manual reproduction steps (e.g., "Click the submit button")

### Step 2: Binary Search Loop
For each iteration, I will:
1. **Read the current code section**
2. **Comment out half of it**
3. **Run the test**
4. **Based on the result:**
   - Bug gone → restore and bisect the commented half
   - Bug still present → bisect the remaining half
5. **Repeat** until we narrow it to specific line(s)

### Step 3: Fix
Once we've isolated the problematic line(s):
1. **Restore all code**
2. **Show you the exact problematic line(s)**
3. **Analyze what's wrong**
4. **Suggest a fix**

## Example Session

**You**: `/findbug`

**Me**: I'll help you find the bug using binary search.

Which file contains the bug?

**You**: `src/api/users.py`

**Me**: Which function or section is suspect?

**You**: The `get_user_profile()` function

**Me**: How should I test if the bug is fixed?

**You**: Run `pytest tests/test_users.py::test_get_profile -v`

**Me**:
Reading `src/api/users.py:get_user_profile()`... I see 28 lines.

**Iteration 1/5**: Commenting out lines 1-14 (first half)

Running test: `pytest tests/test_users.py::test_get_profile -v`
Result: ❌ Test still fails

→ Bug is in lines 1-14 (the commented half). Restoring...

**Iteration 2/5**: Commenting out lines 1-7 (first quarter)

Running test: `pytest tests/test_users.py::test_get_profile -v`
Result: ✅ Test passes!

→ Bug is NOT in lines 1-7. Bug must be in lines 8-14.

**Iteration 3/5**: Commenting out lines 8-11

Running test: `pytest tests/test_users.py::test_get_profile -v`
Result: ✅ Test passes!

→ Bug is NOT in lines 8-11. Bug must be in lines 12-14.

**Iteration 4/5**: Commenting out line 12

Running test: `pytest tests/test_users.py::test_get_profile -v`
Result: ❌ Test still fails

→ Bug is on line 12! Let me check lines 13-14 to be sure...

**Iteration 5/5**: Testing line 13 alone

Running test: `pytest tests/test_users.py::test_get_profile -v`
Result: ✅ Test passes

→ **Bug isolated to line 12!**

**Line 12**: `user_data = db.query(User).filter(User.id == id).first()`

**Problem**: Using `id` (builtin) instead of `user_id` parameter

**Fix**: Change to `User.id == user_id`

Restoring all code and applying fix...

## Following the Bug Trail

Sometimes binary search reveals the bug is caused by code in **another file**:

**Example**:
```
Bisecting function get_user() in users.py...

Iteration 3: Isolated to line 15:
    profile = fetch_profile(user_id)

This line calls fetch_profile() from profile.py
The bug might be IN that function, not the call itself.
```

**What I'll do**:
1. **Recognize when a line calls another function/module**
2. **Ask if you want to bisect that function instead**
3. **Switch to the new file and start bisecting there**
4. **Chain through multiple files if needed**

This lets us trace the bug across your codebase until we find the actual root cause, not just the symptom.

## Starting Code Bisect

Tell me:
1. Which file has the bug?
2. Which function/section is suspect?
3. How do I test if it's fixed?

I'll systematically comment out half the code at a time until we find the exact problematic line(s).

If the bug traces to another file, I'll follow it there and continue bisecting.
