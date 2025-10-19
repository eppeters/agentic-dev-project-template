#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/templates"

# Only exclude settings.local.json from the templates directory
EXCLUDE_FILES=(
    ".claude/settings.local.json"
)

print_usage() {
    cat <<EOF
Usage: $(basename "$0") [TARGET_DIRECTORY]

Install Claude Code base project templates into a target directory.

Arguments:
    TARGET_DIRECTORY    Optional. Path to the target project directory.
                       If not provided, you will be prompted interactively.

Examples:
    $(basename "$0") /path/to/my-project
    $(basename "$0")

The script will:
  1. Create the target directory if it doesn't exist
  2. Check for conflicting files
  3. Copy non-conflicting files automatically
  4. If conflicts exist, show a summary and invoke Claude Code for help

EOF
}

check_dependencies() {
    if ! command -v rsync &> /dev/null; then
        echo "Error: rsync is required but not installed."
        echo ""
        echo "Install rsync:"
        echo "  - Ubuntu/Debian: sudo apt-get install rsync"
        echo "  - macOS: brew install rsync (or use built-in version)"
        echo "  - Fedora/RHEL: sudo dnf install rsync"
        echo "  - Arch: sudo pacman -S rsync"
        exit 1
    fi

    if ! command -v claude &> /dev/null; then
        echo "Warning: 'claude' command not found in PATH."
        echo "If there are conflicts, you'll need to resolve them manually."
        echo "Install Claude Code from: https://docs.claude.com/en/docs/claude-code"
        echo ""
        read -p "Continue anyway? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        CLAUDE_AVAILABLE=false
    else
        CLAUDE_AVAILABLE=true
    fi
}

get_target_directory() {
    local target=""

    if [ $# -eq 0 ]; then
        echo "Enter the target project directory path:"
        read -r target
    else
        target="$1"
    fi

    if [ -z "$target" ]; then
        echo "Error: No target directory provided."
        exit 1
    fi

    echo "$target"
}

build_exclude_args() {
    local exclude_args=()
    for item in "${EXCLUDE_FILES[@]}"; do
        exclude_args+=("--exclude=$item")
    done
    echo "${exclude_args[@]}"
}

detect_conflicts() {
    local target_dir="$1"
    local exclude_args
    read -ra exclude_args <<< "$(build_exclude_args)"

    echo "Checking for conflicting files..." >&2

    local conflicts=""

    while IFS= read -r template_file; do
        [ -z "$template_file" ] && continue

        local relative_path="${template_file#$TEMPLATE_DIR/}"

        local skip=false
        for exclude in "${EXCLUDE_FILES[@]}"; do
            if [[ "$relative_path" == "$exclude"* ]]; then
                skip=true
                break
            fi
        done

        [ "$skip" = true ] && continue

        if [ -f "$target_dir/$relative_path" ]; then
            conflicts="$conflicts$relative_path"$'\n'
        fi
    done < <(find "$TEMPLATE_DIR" -type f)

    echo -n "$conflicts" | grep -v '^$' || true
}

copy_files() {
    local target_dir="$1"
    local exclude_args
    read -ra exclude_args <<< "$(build_exclude_args)"

    echo "Copying template files to $target_dir..."

    rsync -a --ignore-existing "${exclude_args[@]}" \
          "$TEMPLATE_DIR/" "$target_dir/"

    echo "✓ Non-conflicting files copied successfully."
}

invoke_claude_for_conflicts() {
    local target_dir="$1"
    local conflicts="$2"

    if [ "$CLAUDE_AVAILABLE" = false ]; then
        echo ""
        echo "The following files already exist in the target directory:"
        echo "$conflicts"
        echo ""
        echo "Please review and merge these files manually."
        return 1
    fi

    local conflict_list
    conflict_list=$(echo "$conflicts" | sed 's/^/  - /')

    # Build detailed conflict information with file contents
    local conflict_details=""
    local template_source_dir
    template_source_dir="$(dirname "$0")/templates"

    while IFS= read -r conflict_file; do
        [ -z "$conflict_file" ] && continue

        conflict_details+="
---
FILE: $conflict_file

EXISTING FILE (in your project):
\`\`\`
$(head -100 "$target_dir/$conflict_file" 2>/dev/null || echo "Could not read file")
\`\`\`

TEMPLATE FILE (from templates/):
\`\`\`
$(head -100 "$template_source_dir/$conflict_file" 2>/dev/null || echo "Could not read file")
\`\`\`
"
    done <<< "$conflicts"

    local prompt
    prompt=$(cat <<EOF
# Template Installation Conflict Resolution

I've just installed Claude Code base project templates into this directory using install.sh.

The following files already exist in your project and were NOT overwritten to preserve your work:

$conflict_list

## Your Task

Help me resolve these conflicts by going through each file systematically. For each conflicting file:

### Step 1: Analyze
Read both the existing file and the template file. Identify:
- Is the existing file a customized template (contains placeholders like [PROJECT NAME])?
- Is the existing file already project-specific (no placeholders)?
- What are the key differences between them?

### Step 2: Recommend
Based on the analysis, recommend ONE of these approaches:
- **Replace**: Overwrite existing with template (when existing is outdated or incorrect)
- **Keep**: Keep existing file as-is (when it's already properly customized)
- **Merge**: Combine both files (when both have valuable content)
- **Manual Review**: Ask user to decide (when it's unclear)

### Step 3: Execute (if user approves)
If the user approves your recommendation:
- Use the appropriate tool (Edit, Write) to implement the solution
- Explain what you changed and why
- Move to the next file

## Conflict Details

$conflict_details

## Important Guidelines

- Process ONE file at a time - don't batch operations
- Always show your analysis before recommending
- Get user approval before modifying any files
- If a file contains placeholders like [PROJECT NAME], it's likely not customized yet
- Template files live in the parent directory at: $template_source_dir/

Let's start with the first conflicting file. What do you recommend?
EOF
)

    echo ""
    echo "Invoking Claude Code to help resolve conflicts..."
    echo ""

    cd "$target_dir" || exit 1
    claude "$prompt"
}

main() {
    if [ $# -gt 1 ]; then
        print_usage
        exit 1
    fi

    if [ $# -eq 1 ] && { [ "$1" = "-h" ] || [ "$1" = "--help" ]; }; then
        print_usage
        exit 0
    fi

    check_dependencies

    local target_dir
    target_dir=$(get_target_directory "$@")

    target_dir=$(realpath -m "$target_dir")

    if [ ! -d "$target_dir" ]; then
        echo "Target directory does not exist. Creating: $target_dir"
        mkdir -p "$target_dir"
    fi

    local conflicts
    conflicts=$(detect_conflicts "$target_dir")

    copy_files "$target_dir"

    if [ -n "$conflicts" ]; then
        echo ""
        echo "⚠ Some files already exist in the target directory and were not overwritten."
        echo ""
        invoke_claude_for_conflicts "$target_dir" "$conflicts"
    else
        echo ""
        echo "✓ All template files installed successfully!"
        echo ""
        echo "Next steps:"
        echo "  1. cd $target_dir"
        echo "  2. Run 'claude' and use the /setup command to customize templates"
        echo ""
    fi
}

main "$@"
