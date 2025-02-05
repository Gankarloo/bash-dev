#!/usr/bin/env runTest.sh

setup() {
    load 'test_helper/common-setup'
    _common_setup
    load 'test_helper/json2bash'

    sut=logging.sh
    source "$sut"
}

@test "err() writes to stderr" {
    msg="an Error!"
    run err "$msg"
    assert_output -p "$msg"
    assert_success
}

@test "log() writes to stdout" {
    msg="Info text"
    run log "$msg"
    assert_output -p "$msg"
    assert_success
}