#!/usr/bin/env bash
# This script runs the bats tests and saves the results.

# Run the setup script.
./jury/assemble-the-jury.sh

# Run the bats tests with pretty output.
./jury/test_libs/bats-core-1.12.0/bin/bats --pretty jury/ > verdict.txt

# Run the bats tests with TAP output.
./jury/test_libs/bats-core-1.12.0/bin/bats --tap jury/ > verdict.tap
