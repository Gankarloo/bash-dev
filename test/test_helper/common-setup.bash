#!/usr/bin/env bash
function _common_setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    load 'test_helper/bats-mock/load'
    load 'test_helper/bats-mockfn'
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    # DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PROJECT_ROOT="$( cd "$( dirname "${BATS_TEST_FILENAME}" )/.." >/dev/null 2>&1 && pwd )"
    echo PJ="$PROJECT_ROOT"
    # make executables in src/ visible to PATH
    # PATH="$(realpath "$DIR"/../src):$PATH"
    PROJECT_PATHS="$(find "${PROJECT_ROOT}"/src -type d -printf ":%p")"
    # PATH="$PROJECT_ROOT/src:$PATH"
    PATH="${PROJECT_PATHS}:${PATH}"
    
    # make dp available when testing independent script
    export -f dp
}