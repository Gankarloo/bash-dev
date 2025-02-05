#!/usr/bin/env bash
trace() {
  local trace/callingFunc="${FUNCNAME[1]}"
  local availableFunctions=$(typeset -F | awk '{print $3}')
  local level=$1
  shift

  case "$level" in 
    
  esac
  # availableFunctions=$(typeset -F )
  # echo "$availableFunctions"

}