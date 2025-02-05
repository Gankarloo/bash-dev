#!/usr/bin/env bats
function setup_file() {
    # load 'test_helper/common-setup'
    # load 'test_helper/bats-assert/load'
    bats_load_library common
    _common_setup
}
@test "can run our script" {
    # run project1.sh
    dp "Testing testing"
    dp "$(declare -p BATS_LIB_PATH)"
    # echo "second testing" >2
    printf "%s" "Second testing" >&3
    run project.sh
    # assert_output --partial 'Welcome to our project!'
    # [[ 1 == 1 ]]
}
@test "Show welcome message on first invocation" {
    skip "not implemented"
    run project.sh
    assert_output --partial 'Welcome to our project!'

    run project.sh
    refute_output --partial 'Welcome to our project!'
}