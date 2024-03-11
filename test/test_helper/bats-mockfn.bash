newmock() {
    local -n mock=$1

}
mockfn() {
    local mock="${1?'Mock must be specified'}"
    local funcName=${2?'Function name must be specified'}
    local func
    func="${BATS_TMPDIR}/bats-func.$$"

    cat <<EOF > "${func}"
function ${funcName} () {
    "${mock}" "\${@}"
}
EOF
    # shellcheck disable=SC1090
    source "${func}"
}
mock_get_all_call_args() {
  local mock="${1?'Mock must be specified'}"
  local n
    for f in "${mock}".args.*; do
        # echo "$(cat ${f})"
        n="${f##*.}"
        # cat "${f}"
        printf "%s %s\n" "$n" "$(<"${f}")"
    done
}
dp() {
    if [[ -n ${ENABLE_DP} ]]; then
        printf "%s\n" "${*}" >&3
    fi
    # printf "%s\n" "${@}"
}
