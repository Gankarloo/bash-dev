#!/usr/bin/env bash
# read file with
# jq -n --arg content "$(cat tmp/cookie)" '$content|@json'
json2bash() {
    local -n _array_ref="${1?'Missing array parameter'}"
    if [[ ! $(declare -p "$1") == declare\ -A* ]]; then
        echo "First argument must be an Associative Array."
        return 1
    fi
    local _json
    json="${2?'Missing json file paramter'}"

    # echo ">> Parsing json file: ${json} <<"
    while IFS='=' read -r key value; do
        # echo "$key=$value"
        _array_ref["$key"]="$value"
    done < <(jq -r 'to_entries | .[] | .key + "=" + .value' "$json")
    # done < <(jq -r 'to_entries | .[] | .key + "=" + (.value|fromjson)' "$json")
}
txt2json(){
    declare json="${1?'Missing json file paramter'}"
    local data="${2?'Missing data file paramter'}"
    local name="${3:-$(basename "${data%.*}")}"
    declare serialized
    echo "Name: $name"
    echo "data: $data"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    json2bash "${@}"
    # declare -A _myArr
    # json2bash _myArr /workspaces/EC-Vintage-FWautomation/tmp/data.json
fi