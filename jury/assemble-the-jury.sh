#!/bin/bash

set -e

TEST_LIBS_DIR="jury/test_libs"

# Create a directory for the test dependencies
mkdir -p ${TEST_LIBS_DIR}

# Download and extract bats-core
BATS_CORE_VERSION="v1.12.0"
wget -O "${TEST_LIBS_DIR}/bats-core.tar.gz" "https://github.com/bats-core/bats-core/archive/refs/tags/${BATS_CORE_VERSION}.tar.gz"
tar -xzf "${TEST_LIBS_DIR}/bats-core.tar.gz" -C "${TEST_LIBS_DIR}"

# Download and extract bats-support
BATS_SUPPORT_VERSION="v0.3.0"
wget -O "${TEST_LIBS_DIR}/bats-support.tar.gz" "https://github.com/bats-core/bats-support/archive/refs/tags/${BATS_SUPPORT_VERSION}.tar.gz"
tar -xzf "${TEST_LIBS_DIR}/bats-support.tar.gz" -C "${TEST_LIBS_DIR}"

# Download and extract bats-assert
BATS_ASSERT_VERSION="v2.2.0"
wget -O "${TEST_LIBS_DIR}/bats-assert.tar.gz" "https://github.com/bats-core/bats-assert/archive/refs/tags/${BATS_ASSERT_VERSION}.tar.gz"
tar -xzf "${TEST_LIBS_DIR}/bats-assert.tar.gz" -C "${TEST_LIBS_DIR}"


echo "Bats and its dependencies have been installed in ${TEST_LIBS_DIR}"
echo "You can now run the tests using: ./${TEST_LIBS_DIR}/bats-core-${BATS_CORE_VERSION#v}/bin/bats jury"
