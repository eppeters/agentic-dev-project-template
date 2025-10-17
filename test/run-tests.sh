#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BATS="${SCRIPT_DIR}/bats/bin/bats"

if [ ! -x "$BATS" ]; then
    echo "Error: bats not found at ${BATS}"
    echo "The bats testing framework should be vendored in test/bats/"
    exit 1
fi

echo "Running install.sh tests with Bats..."
echo ""

"${BATS}" "${SCRIPT_DIR}/install.bats" "$@"
