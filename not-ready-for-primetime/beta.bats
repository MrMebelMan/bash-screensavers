#!/usr/bin/env bats

load 'test_libs/bats-support-0.3.0/load.bash'
load 'test_libs/bats-assert-2.2.0/load.bash'

@test "beta screensaver runs" {
  run timeout 1s ./gallery/beta/beta.sh
  assert_failure
}
