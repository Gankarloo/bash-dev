#!/usr/bin/env runTest.sh
#!/usr/bin/env -S bats --verbose-run --gather-test-outputs-in tout
#!/usr/bin/env -S bats --print-output-on-failure --show-output-of-passing-tests --verbose-run --gather-test-outputs-in tout
# setup_file() {
#     load 'test_helper/common-setup'
#     _common_setup
# }
setup() {
    load 'test_helper/common-setup'
    _common_setup
    # source "$PROJECT_ROOT/src/sourceAble.sh"
    source sourceAble.sh
}
@test "run it" {
    # run _test_func
    run sourceAble.sh
}
@test "source it" {
    # source sourceAble.sh
    run _test_func

    assert_output 'hej hej'
}
@test "_child_func" {
    run _child_func
    assert_output 'chumbawamba'
}
@test "_parent_func" {
    run _parent_func
    assert_output '>>chumbawamba<<'
}
@test "_parent_func mock _child_func" {
    mock=$(mock_create)
    mock_set_output "${mock}" "rumpestumpen"
    _child_func() {
        "$mock" "${@}"
    }
    export -f _child_func

    run _parent_func

    # echo "$(mock_get_call_num ${mock})" >&3
    assert_output '>>rumpestumpen<<'
    [[ "$(mock_get_call_num ${mock})" -eq 1 ]]
}
@test "_parent_func mock _child_func V2" {
    _child_func() {
        mock=$(mock_create)
        mock_set_output "${mock}" "rumpestumpen"
        "$mock" "${@}"
    }
    export -f _child_func

    run _parent_func
    
    assert_output '>>rumpestumpen<<'
}
@test "curl" {
    skip
    # mock=$(mock_create)
    # mock_set_output "${mock}" ""
    # mockfn "$mock" "curl"
    run run_curl

    assert_output -p "<h1>Example Domain</h1>"
}
@test "mock curl" {
    mock=$(mock_create)
    mock_set_output "${mock}" "The Mock...1" 1
    mock_set_output "${mock}" "The Mock...2" 2
    mock_set_output "${mock}" "The Mock...3" 3
    mock_set_output "${mock}" "The Mock...4" 4
    mockfn "$mock" "curl"
    run run_curl
    # printf "%s" "${output}" >> scriptlog.log
    # echo "$(mock_get_all_call_args ${mock})" >&3
    # dp "$(mock_get_all_call_args ${mock})"
    assert_output -p "The Mock..."
    [[ "$(mock_get_call_num ${mock})" -eq 4 ]]
    [[ "$(mock_get_call_args ${mock} 4)" =~ -H\ "Accept: application/json" ]]
}
@test "spy curl" {
    mock=$(mock_create)
    dp MockPath: "$mock"
    mock_set_output "${mock}" "The Mock...1" 1
    mock_set_output "${mock}" "The Mock...2" 2
    mock_set_output "${mock}" "The Mock...3" 3
    mock_set_output "${mock}" "The Mock...4" 4
    curl() {
        # if [[ ${*} =~ '/api/v2/cmdb/address/192.10.0.1' ]]; then

        # fi
        dp CallArgs: "${*}"
        case "${*}" in
            */api/v2/address/192.168.10.1?format=name*) echo '{"return":1}' ;;
            */api/v2/addrgrp/192.168.10.1*) echo '{"return":2}' ;;
            */api/v2/address/192.168.10.1*) echo '{"return":3}' ;;
            *) echo "=== No matching case ===" && exit 2
        esac
        dp Response: "$(${mock} ${@})"
    }
    export -f curl
    run spy_curl 1
    assert_output '{"return":1}' 

    run spy_curl 2
    assert_output '{"return":3}' 
    
    run spy_curl 3
    assert_output '{"return":2}' 
    dp "\nNumber of mock calls: $(mock_get_call_num ${mock})"
    [[ "$(mock_get_call_num ${mock})" -eq 3 ]]
}
    # source "$PROJECT_ROOT/src/mock.sh"
    # curl_mock="$(mock_create)"
    # mock_set_output "${curl_mock}" "version"
    # echo "-- running mock.sh" >&3
    # _CURL="${curl_mock}" run run_main
    # _CURL="${curl_mock}" run mock.sh
    # echo "${output}" >&3
    # assert_output --partial "version"
    # echo "$(mock_get_call_num ${curl_mock})" >&3
    # echo "$(mock_get_call_user ${curl_mock})" >&3
    # echo "$(mock_get_call_args ${curl_mock})" >&3
    # echo "$(mock_get_call_env ${curl_mock})" >&3
    
    # [[ "$(mock_get_call_num ${curl_mock})" -eq 1 ]]