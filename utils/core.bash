#!/usr/bin/env bash


function _update() {
    if [[ -d .git ]]; then
        git fetch
        if [[ $(git rev-parse HEAD) != $(git rev-parse "@{u}") ]]; then
            git pull
            _alert success "Updated to latest version, please re-run script"
            exit 0
        fi
    fi
}

function req_check {
    local _program
    local _missing_programs=()
    for _program in "$@"; do
        if ! command -v "${_program}" &>/dev/null; then
            _missing_programs+=("${_program}")
        fi
    done

    if [[ ${#_missing_programs[@]} -gt 0 ]]; then
        fatal "Missing required programs: ${_missing_programs[*]}"
    fi
}

function check_root {
    if [[ $EUID -ne 0 ]]; then
        fatal "This script must be run as root"
    fi
}

