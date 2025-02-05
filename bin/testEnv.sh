#!/usr/bin/env bash
debugInfo() {
    echo "---- $(basename "$0") -----"
    echo "ARGS: ${*}"
    echo "--- Available variables ---"
    while read -r var; do 
        printf "%s=%q\n" "$var" "${!var}"
    done < <(compgen -v)
    echo "----------- END -----------"
}
testEnv_main() {
    :
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    [[ $DEBUG -gt 0 ]] && debugInfo "$@"
    testEnv_main
fi