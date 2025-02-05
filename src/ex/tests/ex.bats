#!/usr/bin/env bats
function setup() {
    load 'test_helper/common-setup'
    _common_setup
}
@test "can run our script" {
    run project.sh
    assert_output --partial 'Welcome to our project!'
    # [[ 1 == 1 ]]
}
@test "Show welcome message on first invocation" {
    skip "not implemented"
    run project.sh
    assert_output --partial 'Welcome to our project!'

    run project.sh
    refute_output --partial 'Welcome to our project!'
}