#!/usr/bin/env runTest.sh
#!./bats/bin/bats
function setup() {
    load 'test_helper/common-setup'
    _common_setup
    source "$PROJECT_ROOT/src/mock.sh"
}
@test "mock" {
    skip "only for testing"
    source "$PROJECT_ROOT/src/mock.sh"
    curl_mock="$(mock_create)"
    mock_set_output "${curl_mock}" "version"
    echo "-- running mock.sh" >&3
    _CURL="${curl_mock}" run run_main
    # _CURL="${curl_mock}" run mock.sh
    echo "${output}" >&3
    # assert_output --partial "version"
    echo "$(mock_get_call_num ${curl_mock})" >&3
    echo "$(mock_get_call_user ${curl_mock})" >&3
    echo "$(mock_get_call_args ${curl_mock})" >&3
    # echo "$(mock_get_call_env ${curl_mock})" >&3
    
    [[ "$(mock_get_call_num ${curl_mock})" -eq 1 ]]
}