ArrayFuncs/hasValue() {
  local -n _ArrayFuncs_hasValue_Array="$1"
  local _ArrayFuncs_hasValue_Value="$2"
  printf '%s\0' "${_ArrayFuncs_hasValue_Array[@]}" | grep --fixed-strings --line-regexp --null-data --quiet -- "${_ArrayFuncs_hasValue_Value}"
}
ArrayFuncs/hasKey() {
  local -n _ArrayFuncs_hasKey_Array="$1"
  local _ArrayFuncs_hasKey_Value="$2"
  printf '%s\0' "${!_ArrayFuncs_hasKey_Array[@]}" | grep --fixed-strings --line-regexp --null-data --quiet -- "${_ArrayFuncs_hasKey_Value}"
}
ArrayFuncs/isIndexedArray() {
  declare -p "$1" 2>/dev/null | grep --quiet 'declare -a'
}
ArrayFuncs/isAssociativeArray() {
  declare -p "$1" 2>/dev/null | grep --quiet 'declare -A'
}
ArrayFuncs/AscToIndex() {
  if [[ $# -lt 2 ]]; then
    echo "${FUNCNAME[0]} called with ${#} args, expected minimum 2"
    return 1
  fi
  # make sure we get one Associative and one Indexed array
  if ! ArrayFuncs/isAssociativeArray "$1"; then
    echo "$1 is not an Associative array"
    return 1
  fi
  if ! ArrayFuncs/isIndexedArray "$2"; then
    echo "$2 is not an Indexed array"
    return 1
  fi

  local -n _ArrayFuncs_AscToIndex_Source="$1"
  local -n _ArrayFuncs_AscToIndex_Destination="$2"
  for i in "${!_ArrayFuncs_AscToIndex_Source[@]}"; do
    _ArrayFuncs_AscToIndex_Destination+=("${i}: ${_ArrayFuncs_AscToIndex_Source[$i]}")
  done
}
