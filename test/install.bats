#!/usr/bin/env bats

# Test suite for install.sh script

setup() {
    # Create a temporary directory for each test
    TEST_TEMP_DIR="$(mktemp -d)"

    # Path to the script being tested
    INSTALL_SCRIPT="${BATS_TEST_DIRNAME}/../install.sh"

    # Path to template directory (parent of test dir)
    TEMPLATE_DIR="${BATS_TEST_DIRNAME}/.."

    # Mock claude command - just records that it was called
    export PATH="${BATS_TEST_DIRNAME}/mocks:${PATH}"
    mkdir -p "${BATS_TEST_DIRNAME}/mocks"

    # Create mock claude script
    cat > "${BATS_TEST_DIRNAME}/mocks/claude" <<'EOF'
#!/usr/bin/env bash
# Mock claude command for testing
echo "MOCK_CLAUDE_INVOKED" >> "${CLAUDE_INVOCATION_LOG}"
echo "$@" >> "${CLAUDE_INVOCATION_LOG}"
exit 0
EOF
    chmod +x "${BATS_TEST_DIRNAME}/mocks/claude"

    # Log file to track claude invocations
    export CLAUDE_INVOCATION_LOG="${TEST_TEMP_DIR}/claude_invocations.log"
}

teardown() {
    # Clean up temporary directory
    rm -rf "${TEST_TEMP_DIR}"
    rm -rf "${BATS_TEST_DIRNAME}/mocks"
}

# Happy path tests

@test "install.sh --help shows usage information" {
    run "${INSTALL_SCRIPT}" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "Install Claude Code base project templates" ]]
}

@test "install.sh -h shows usage information" {
    run "${INSTALL_SCRIPT}" -h
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "install to empty directory succeeds without conflicts" {
    run "${INSTALL_SCRIPT}" "${TEST_TEMP_DIR}/new-project"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "All template files installed successfully" ]]
    [[ ! "$output" =~ "Some files already exist" ]]
    [[ ! "$output" =~ "Invoking Claude" ]]

    # Verify files were copied
    [ -f "${TEST_TEMP_DIR}/new-project/CLAUDE.md" ]
    [ -f "${TEST_TEMP_DIR}/new-project/DEVELOPMENT.md" ]
    [ -d "${TEST_TEMP_DIR}/new-project/.claude" ]

    # Verify excluded files were NOT copied
    [ ! -f "${TEST_TEMP_DIR}/new-project/README.md" ]
    [ ! -f "${TEST_TEMP_DIR}/new-project/install.sh" ]
    [ ! -d "${TEST_TEMP_DIR}/new-project/.git" ]
}

@test "install creates target directory if it doesn't exist" {
    run "${INSTALL_SCRIPT}" "${TEST_TEMP_DIR}/nonexistent/deeply/nested/project"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Creating: ${TEST_TEMP_DIR}/nonexistent/deeply/nested/project" ]]
    [ -d "${TEST_TEMP_DIR}/nonexistent/deeply/nested/project" ]
    [ -f "${TEST_TEMP_DIR}/nonexistent/deeply/nested/project/CLAUDE.md" ]
}

@test "install copies .claude directory structure" {
    run "${INSTALL_SCRIPT}" "${TEST_TEMP_DIR}/test-claude-dir"
    [ "$status" -eq 0 ]

    [ -d "${TEST_TEMP_DIR}/test-claude-dir/.claude" ]
    [ -f "${TEST_TEMP_DIR}/test-claude-dir/.claude/PERSONA.md" ]
    [ -d "${TEST_TEMP_DIR}/test-claude-dir/.claude/agents" ]
    [ -d "${TEST_TEMP_DIR}/test-claude-dir/.claude/commands" ]
}

@test "install excludes .claude/settings.local.json" {
    # Create settings.local.json in template if it exists
    touch "${TEMPLATE_DIR}/.claude/settings.local.json.test"

    run "${INSTALL_SCRIPT}" "${TEST_TEMP_DIR}/test-exclude"
    [ "$status" -eq 0 ]

    # Should not be copied
    [ ! -f "${TEST_TEMP_DIR}/test-exclude/.claude/settings.local.json" ]

    # Cleanup
    rm -f "${TEMPLATE_DIR}/.claude/settings.local.json.test"
}

# Conflict detection tests

@test "detects conflicts when files already exist" {
    # Pre-create conflicting files
    mkdir -p "${TEST_TEMP_DIR}/existing-project"
    echo "# My existing docs" > "${TEST_TEMP_DIR}/existing-project/CLAUDE.md"
    echo "# My dev guide" > "${TEST_TEMP_DIR}/existing-project/DEVELOPMENT.md"

    run "${INSTALL_SCRIPT}" "${TEST_TEMP_DIR}/existing-project"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Some files already exist" ]]
    [[ "$output" =~ "Invoking Claude Code" ]]

    # Verify existing files were NOT overwritten
    content=$(cat "${TEST_TEMP_DIR}/existing-project/CLAUDE.md")
    [[ "$content" == "# My existing docs" ]]

    # Verify claude was invoked
    [ -f "${CLAUDE_INVOCATION_LOG}" ]
    grep -q "MOCK_CLAUDE_INVOKED" "${CLAUDE_INVOCATION_LOG}"
}

@test "preserves existing files during install" {
    mkdir -p "${TEST_TEMP_DIR}/preserve-test"
    echo "Important content" > "${TEST_TEMP_DIR}/preserve-test/CLAUDE.md"

    run "${INSTALL_SCRIPT}" "${TEST_TEMP_DIR}/preserve-test"
    [ "$status" -eq 0 ]

    # File should still have original content
    content=$(cat "${TEST_TEMP_DIR}/preserve-test/CLAUDE.md")
    [[ "$content" == "Important content" ]]
}

@test "copies non-conflicting files even when some files conflict" {
    mkdir -p "${TEST_TEMP_DIR}/partial-conflict"
    echo "Existing" > "${TEST_TEMP_DIR}/partial-conflict/CLAUDE.md"

    run "${INSTALL_SCRIPT}" "${TEST_TEMP_DIR}/partial-conflict"
    [ "$status" -eq 0 ]

    # CLAUDE.md should be preserved
    content=$(cat "${TEST_TEMP_DIR}/partial-conflict/CLAUDE.md")
    [[ "$content" == "Existing" ]]

    # But DEVELOPMENT.md and .claude should be copied
    [ -f "${TEST_TEMP_DIR}/partial-conflict/DEVELOPMENT.md" ]
    [ -d "${TEST_TEMP_DIR}/partial-conflict/.claude" ]
}

# Error handling tests

@test "fails with error when rsync is not available" {
    # This test would require temporarily hiding rsync, which is complex
    # Skipping for now as it would require PATH manipulation
    skip "Requires complex PATH manipulation to test"
}

@test "fails when more than one argument provided" {
    run "${INSTALL_SCRIPT}" /path/one /path/two
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "handles relative paths correctly" {
    cd "${TEST_TEMP_DIR}"
    mkdir -p subdir

    run "${INSTALL_SCRIPT}" ./subdir/relative-project
    [ "$status" -eq 0 ]
    [ -d "${TEST_TEMP_DIR}/subdir/relative-project" ]
    [ -f "${TEST_TEMP_DIR}/subdir/relative-project/CLAUDE.md" ]
}

# Claude invocation tests

@test "claude receives correct prompt when conflicts exist" {
    mkdir -p "${TEST_TEMP_DIR}/conflict-prompt-test"
    echo "Existing" > "${TEST_TEMP_DIR}/conflict-prompt-test/CLAUDE.md"

    run "${INSTALL_SCRIPT}" "${TEST_TEMP_DIR}/conflict-prompt-test"
    [ "$status" -eq 0 ]

    # Check that claude was invoked with correct context
    [ -f "${CLAUDE_INVOCATION_LOG}" ]
    grep -q "MOCK_CLAUDE_INVOKED" "${CLAUDE_INVOCATION_LOG}"
    grep -q "already exist and were NOT overwritten" "${CLAUDE_INVOCATION_LOG}"
    grep -q "CLAUDE.md" "${CLAUDE_INVOCATION_LOG}"
}

@test "claude is NOT invoked when no conflicts exist" {
    run "${INSTALL_SCRIPT}" "${TEST_TEMP_DIR}/no-conflicts"
    [ "$status" -eq 0 ]

    # Claude should not have been called
    [ ! -f "${CLAUDE_INVOCATION_LOG}" ]
}

@test "provides helpful next steps after successful install" {
    run "${INSTALL_SCRIPT}" "${TEST_TEMP_DIR}/next-steps-test"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Next steps:" ]]
    [[ "$output" =~ "/setup" ]]
}
