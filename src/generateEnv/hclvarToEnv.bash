#!/usr/bin/env bash
# check if script is sourced.
# shellcheck disable=SC2128
[[ $0 != "$BASH_SOURCE" ]] && __SOURCED__=0 || __SOURCED__=1
# source ../../lib/errorHandling.sh

hclvarToEnv/trim() {
  : "trim()"
    local _hclvarToEnv_trim_var="$*"
    # remove leading whitespace characters
    _hclvarToEnv_trim_var="${_hclvarToEnv_trim_var#"${_hclvarToEnv_trim_var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    _hclvarToEnv_trim_var="${_hclvarToEnv_trim_var%"${_hclvarToEnv_trim_var##*[![:space:]]}"}"
    printf '%s' "${_hclvarToEnv_trim_var}"
}
hclvarToEnv/debug() {
  : "debug()"
  if [[ -n ${DEBUG} ]]; then
    echo -e "$@"
  fi
}
hclvarToEnv/ArrayShift() {
  : "ArrayShift()"
  if [[ $# -ne 2 ]]; then
    echo "ArrayShift called with wrong nr args, expected 2 got: ${#}"
    return 1
  fi
  local -n _hclvarToEnv_ArrayShift_arr;_hclvarToEnv_ArrayShift_arr="$1"
  local -n _hclvarToEnv_ArrayShift_ret;_hclvarToEnv_ArrayShift_ret="$2"
  local _hclvarToEnv_ArrayShift_value

  # return if array is empty
  ((${#_hclvarToEnv_ArrayShift_arr[@]} == 0 )) && return
  # Grab first index
  _hclvarToEnv_ArrayShift_value="$(hclvarToEnv/trim "${_hclvarToEnv_ArrayShift_arr[0]}")"
  # Remove first index from array
  _hclvarToEnv_ArrayShift_arr=("${_hclvarToEnv_ArrayShift_arr[@]:1}")
  # Assign value to return variable
  _hclvarToEnv_ArrayShift_ret="${_hclvarToEnv_ArrayShift_value}"
}
hclvarToEnv/splitKV() {
  : "splitKV()"
  # [[ $DEBUG == "splitKV" ]] && set -x
  if [[ $# -ne 3 ]]; then
    echo "splitKV called with wrong nr args, expected 3 got: ${#}"
    return 1
  fi
  local _hclvarToEnv_splitKV_line;_hclvarToEnv_splitKV_line="$1"
  local -n _hclvarToEnv_splitKV_return_key;_hclvarToEnv_splitKV_return_key="$2"
  local -n _hclvarToEnv_splitKV_return_value;_hclvarToEnv_splitKV_return_value="$3"
  local _hclvarToEnv_splitKV_arr
  local _hclvarToEnv_splitKV_key
  local _hclvarToEnv_splitKV_val

  IFS='=' read -ra _hclvarToEnv_splitKV_arr <<< "${_hclvarToEnv_splitKV_line}"

  hclvarToEnv/ArrayShift _hclvarToEnv_splitKV_arr _hclvarToEnv_splitKV_key
  _hclvarToEnv_splitKV_return_key="${_hclvarToEnv_splitKV_key}"
  _hclvarToEnv_splitKV_return_value=$(hclvarToEnv/trim "${_hclvarToEnv_splitKV_arr[@]}")
  # [[ $DEBUG == "splitKV" ]] && set +x
}
hclvarToEnv/parse() {
  : "parse()"
  if [[ $# -ne 2 ]]; then
    echo "Parse() called with wrong nr args expected 2 got: ${#}"
    return 1
  fi
  local _hclvarToEnv_parse_file;_hclvarToEnv_parse_file=$1
  local -n _hclvarToEnv_parse_array;_hclvarToEnv_parse_array=$2
  declare -A _hclvarToEnv_parse_tmp_array
  local _hclvarToEnv_parse_line
  # local KV
  local _hclvarToEnv_parse_file_key
  local _hclvarToEnv_parse_file_value
  local _hclvarToEnv_parse_file_multiline

  hclvarToEnv/debug "  >>> $1 <<<"
  while IFS='' read -r _hclvarToEnv_parse_line; do
    # Skip lines with leading comment char
    if [[ $_hclvarToEnv_parse_line =~ ^(#|//) ]]; then
      continue
    fi
    if [[ $_hclvarToEnv_parse_file_multiline == "true" ]]; then
      hclvarToEnv/debug  "\t||| Multiline for key >${K}<|||>$_hclvarToEnv_parse_line"

      #append to value
      _hclvarToEnv_parse_file_value="${_hclvarToEnv_parse_file_value}$(hclvarToEnv/trim "${_hclvarToEnv_parse_line}")"

    # End of multiline?
      if [[ $_hclvarToEnv_parse_line =~ ^] ]]; then
        _hclvarToEnv_parse_file_value="${_hclvarToEnv_parse_file_value}'"
        hclvarToEnv/debug "\t--- found end of multiline assign to array"
        # found end of multiline assign to array
        _hclvarToEnv_parse_array["$_hclvarToEnv_parse_file_key"]="$_hclvarToEnv_parse_file_value"
        # Clear multiline var
        _hclvarToEnv_parse_file_multiline=
      fi
      continue
    fi
    # handle key value pairs
    if [[ $_hclvarToEnv_parse_line == *"="* ]]; then
      hclvarToEnv/debug "=== $_hclvarToEnv_parse_line ==="
      # Special handling of structs
      if [[ $_hclvarToEnv_parse_line =~ \[$ ]]; then
        hclvarToEnv/debug "<<< Beginning Multiline >>>"
        _hclvarToEnv_parse_file_multiline=true
        hclvarToEnv/splitKV "$_hclvarToEnv_parse_line" _hclvarToEnv_parse_file_key _hclvarToEnv_parse_file_value
      else
        hclvarToEnv/debug "\$_hclvarToEnv_parse_line:${_hclvarToEnv_parse_line}"
        hclvarToEnv/splitKV "$_hclvarToEnv_parse_line" _hclvarToEnv_parse_file_key _hclvarToEnv_parse_file_value
        hclvarToEnv/debug "\$_hclvarToEnv_parse_file_key:${_hclvarToEnv_parse_file_key} \$_hclvarToEnv_parse_file_value:${_hclvarToEnv_parse_file_value}"
        _hclvarToEnv_parse_array["$_hclvarToEnv_parse_file_key"]="$_hclvarToEnv_parse_file_value"
      fi
    fi
  done < "$_hclvarToEnv_parse_file"

  echo "Finished parsing file: ${_hclvarToEnv_parse_file}"
}
hclvarToEnv/printArray() {
  : "printArray()"
  local -n _hclvarToEnv_printArray_arr=$1

  for key in "${!_hclvarToEnv_printArray_arr[@]}"; do
    echo "$key=${_hclvarToEnv_printArray_arr[$key]}"
  done
}
hclvarToEnv/findFilesInPath() {
  : "findFilesInPath()"
  local _hclvarToEnv_findFilesInPath_path;_hclvarToEnv_findFilesInPath_path=$1
  local -n _hclvarToEnv_findFilesInPath_ret;_hclvarToEnv_findFilesInPath_ret=$2
  if [[ ! -d $_hclvarToEnv_findFilesInPath_path ]]; then
    echo "Err: $_hclvarToEnv_findFilesInPath_path is not a directory"
    return 1
  fi
  for file in "$_hclvarToEnv_findFilesInPath_path"/*; do
    _hclvarToEnv_findFilesInPath_ret+=("$file")
  done
}
hclvarToEnv/writeEnvrc() {
  : "writeEnvrc()"
  local -n _hclvarToEnv_writeEnvrc_arr=$1
  # remove previous content
  printf '' > .envrc.local
  for key in "${!_hclvarToEnv_writeEnvrc_arr[@]}"; do
    printf 'export PKR_VAR_%s=%s\n' "$key" "${_hclvarToEnv_writeEnvrc_arr[$key]}" >> .envrc.local
  done
}
hclvarToEnv/main() {
  : "main()"
  source ./trace.bash
  if [[ $# -ne 1 ]]; then
    echo "Missing Path argument!"
    echo "  ${0} 'path to config directory'"
    return 1
  fi
  # shellcheck disable=SC2034 # very much needed...
  declare -A kvArr
  local -a configs
  hclvarToEnv/findFilesInPath "$1" configs

  for path in "${configs[@]}"; do
    hclvarToEnv/parse "$path" kvArr
  done

  hclvarToEnv/debug "parsing done.."
  [[ -n ${DEBUG} ]] && hclvarToEnv/printArray kvArr
  hclvarToEnv/writeEnvrc kvArr
}

if [[ ${__SOURCED__} -ne 0 ]]; then
  echo "not sourced, running script!"
  set -e
  hclvarToEnv/main "$@"
fi
# fails due to set -e # [[ $DEBUG -eq 2 ]] && [[ ${__SOURCED__} -ne 0 ]] && set -x
