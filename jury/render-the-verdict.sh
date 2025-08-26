#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# This script runs the bats tests and saves the results.

# Run the setup script.
"${SCRIPT_DIR}/assemble-the-jury.sh"

# Run the bats tests with pretty output.
"${SCRIPT_DIR}/test_libs/bats-core-1.12.0/bin/bats" --pretty "${SCRIPT_DIR}" > "${SCRIPT_DIR}/verdict.txt"

# Run the bats tests with TAP output.
"${SCRIPT_DIR}/test_libs/bats-core-1.12.0/bin/bats" --tap "${SCRIPT_DIR}" > "${SCRIPT_DIR}/verdict.tap"
