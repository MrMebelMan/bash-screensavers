#!/usr/bin/env bats

load 'jury/test_libs/bats-support-0.3.0/load.bash'
load 'jury/test_libs/bats-assert-2.2.0/load.bash'

SCRIPT="gallery/tunnel/tunnel.sh"

@test "tunnel: should be executable" {
  assert [ -x "$SCRIPT" ]
}

@test "tunnel: runs without errors for 1 second" {
  run timeout 1s "$SCRIPT"
  assert_success
}
