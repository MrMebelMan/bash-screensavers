#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# This script runs the bats tests and saves the results.

# Run the setup script.
"${SCRIPT_DIR}/assemble-the-jury.sh"

# cd into the jury directory to run the tests.
cd "${SCRIPT_DIR}" || exit 1

# Run the bats tests with pretty output.
"test_libs/bats-core-1.12.0/bin/bats" --pretty . > "verdict.txt"

# Run the bats tests with TAP output.
"test_libs/bats-core-1.12.0/bin/bats" --tap . > "verdict.tap"
