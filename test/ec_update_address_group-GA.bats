#!/usr/bin/env runTest.sh

setup() {
    load 'test_helper/common-setup'
    _common_setup
    # source ec_update_address_group-GA.sh
    load 'test_helper/json2bash'
    # source 'test_helper/json2bash.sh'
    sut=ec_update_address_group-GA.sh
    declare -gA sutData
    export sutData
    json2bash sutData  "${BATS_TEST_DIRNAME}/ec_update_address_group-GA.helper.json"
    createTestBed() {
        mkdir -p "${BATS_TEST_TMPDIR}"/{logs,tmp,groupbackup}
        cp "${PROJECT_ROOT}/src/.ftn" "${BATS_TEST_TMPDIR}"
        # echo "ccsrftoken \"B3F662E4B5791F28342C86D9AB1FA\"" > "${BATS_TEST_TMPDIR}/tmp/cookie"
        # echo "${sutData[cookieFile]}" | jq -r >&3
        # Mock the cookiefile location for the tests
        export CFMOCK="${BATS_TEST_TMPDIR}/tmp/cookie"
        # echo "${sutData[cookieFile]}" | jq -r > "${BATS_TEST_TMPDIR}"
        # echo "${sutData[cookieFile]}" | jq -r > "${BATS_TEST_TMPDIR}/tmp/cookie"
        echo "${sutData[cookieFile]}" | jq -r > "${CFMOCK}"
    }
}

@test "ADD" {
    #########################
    # Enable Debug Printing #
    # export ENABLE_DP=1    #
    #########################

    # preparations

    dp "BATS_TEST_DIRNAME: ${BATS_TEST_DIRNAME}"
    createTestBed

    # create curl spy
    mock=$(mock_create)
    dp MockPath: "$mock"

    # export to make it available in spy function
    export mock
    export -f mock_default_n
    export res1=${sutData[addGetAddrgrpMember]}
    export res2=${sutData[fail]}
    export resDefault=${sutData[success]}
    curl() {
        "${mock}" "${@}"

        local nr=$(mock_default_n "${mock}")
        dp Number: "$nr"
        dp CallArgs: "${*}"
        
        case "$nr" in
            1) 
                dp Response: "$res1"
                echo "$res1"
                ;;
            2)
                dp Response: "$res2"
                echo "$res2"
                ;;
            *) 
                dp Default response: "$resDefault"
                echo "${resDefault}"
                ;;
        esac
    }

    sutParams=()
    sutParams+=(-add)
    sutParams+=(-fw "164.9.146.144")
    sutParams+=(-vdom "TF")
    sutParams+=(-ipname "H10.208.230.161")
    sutParams+=(-group "AUTO-Grp-TF-Vlan1469-WinManage-withVIP")

    export -f curl

    export EC_MAINDIR="${BATS_TEST_TMPDIR}"
    # export DEBUG_FW="1"
    # echo ">> tmp: ${BATS_TEST_TMPDIR} <<" >&3
    dp ">> tmp: ${BATS_TEST_TMPDIR} <<"
    run "$sut" "${sutParams[@]}"

    dp '======================='
    dp "${output}"
    [[  "$(mock_get_call_num ${mock})" -eq 4  ]]
    assert_success
    assert_output '+OK:ec_update_address_group:POST:IPName=H10.208.230.161,Group=AUTO-Grp-TF-Vlan1469-WinManage-withVIP,Subnet=,vdom=TF,fw=164.9.146.144:[http_status=200]'
}
