#!/usr/bin/env runTest
function setup() {
    bats_load_library common
    _common_setup
    source moo.bash
    taDaa() {
        dp "Mumbo jumbo..."
    }
    export taDaa
}
@test "can run our script" {
    dp "Path:"
    dp "$(echo -e ${PATH//:/\\n})"
    dp "Exported Functions:"
    dp "$(declare -F)"
    taDaa
    run Moo
    assert_output "Mooooo"
}