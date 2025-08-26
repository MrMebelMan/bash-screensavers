#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "beta screensaver runs" {
  run timeout 1s ./gallery/beta/beta.sh
  assert_failure
}
