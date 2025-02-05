#!/usr/bin/env bash
function _common_setup() {
    echo "From common setup" >&3
    # load 'test_helper/bats-support/load'
    bats_load_library bats-support
    # load 'test_helper/bats-assert/load'
    bats_load_library bats-assert
    # load 'test_helper/bats-mock/load'
    # bats_load_library bats-mock
    # load 'test_helper/bats-mockfn'
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    # DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PROJECT_ROOT="$( cd "$( dirname "${BATS_TEST_FILENAME}" )/.." >/dev/null 2>&1 && pwd )"
    dp "ProjectRoot= $PROJECT_ROOT"
    # make executables in src/ visible to PATH
    # PATH="$(realpath "$DIR"/../src):$PATH"
    # dp "HALOOOOOOO"
    PROJECT_PATHS="$(find "${PROJECT_ROOT}"/src -type d -printf ":%p")"
    dp "ProjectPaths= $PROJECT_PATHS"
    # PATH="$PROJECT_ROOT/src:$PATH"
    PATH="${PROJECT_PATHS}:${PATH}"
    # dp "Path= $PATH"
    # dp "exported functions:"
    # dp "$(declare -F)"
    # make dp available when testing independent script
    export -f dp
}