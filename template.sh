#!/usr/bin/env bash

#===================================================================================================
#  *                              BASH SCRIPT TEMPLATE
#
#    Author: Bill Fritz
#    Email: <bfritz@uw.edu>
#    Description: This is a template for bash scripts
#    Created: 2023-02-06
#
#===================================================================================================
# *                                CHANGELOG
#
#    2023-02-06: initial
#
#===================================================================================================

# Set variables
_script_name=$(basename "$0")
_script_dir=$(dirname "$0")
_script_path=$(realpath "$0")
_utils_location="$_script_dir/utils"

# Set flags
debug=0
log=0

# shellcheck disable=SC1090
for file in "$_utils_location"/*.bash; do
    source "$file"
done

_alert() {
    local _color
    local _alertType="${1}"
    local _message="${2}"
    local _line="${3:-}"

    case "${_alertType}" in
    success)
        _color="\e[32m"
        ;;
    header)
        _color="\e[95m"
        ;;
    notice)
        _color="\e[96m"
        ;;
    dryrun)
        _color="\e[93m"
        ;;
    debug)
        _color="\e[90m"
        ;;
    warning)
        _color="\e[33m"
        ;;
    error)
        _color="\e[31m"
        ;;
    fatal)
        _color="\e[31m"
        ;;
    info)
        _color="\e[34m"
        ;;
    input)
        _color="\e[36m"
        ;;
    *)
        _color="\e[39m"
        ;;
    esac

    if [[ -n "${_line}" ]]; then
        _message="${_message} (line ${_line})"
    fi
    # shellcheck disable=SC2154
    if [[ "${_alertType}" == "fatal" ]]; then
        echo -e "${_color}${_message}\e[0m"
        if [[ "${log}" -eq 1 ]]; then
            echo -e "${_color}${_message}\e[0m" >>"${_logFile}"
        fi        
        exit 1
    elif [[ "${_alertType}" == "debug" ]] && [[ "${debug}" -eq 1 ]]; then
        echo -e "${_color}${_message}\e[0m"
    elif [[ "${_alertType}" != "debug" ]]; then
        echo -e "${_color}${_message}\e[0m"
    fi

}

function fatal() {
    _alert fatal "${1}"
}

function die() {
    _alert fatal "${1}"
}

function success() {
    _alert success "${1}"
}

function notice() {
    _alert notice "${1}"
}

function dryrun() {
    _alert dryrun "${1}"
}

function debug() {
    _alert debug "${1}"
}

function warning() {
    _alert warning "${1}"
}

function error() {
    _alert error "${1}"
}

function info() {
    _alert info "${1}"
}

function input() {
    _alert input "${1}"
}

function header() {
    _alert header "${1}"
}

# shellcheck disable=SC2034
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -d|--debug)
            debug=1
            ;;
        -l|--log)
            log=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            die "Unknown option: $key"
            ;;
    esac
    shift
done

# Set debug mode
if [[ $debug -eq 1 ]]; then
    set -x
fi

# Display usage and arguments
function usage {
    echo "Usage: ${_script_name} [options]"
    echo "Options:"
    echo "  -d, --debug     Enable debug mode"
    echo "  -l, --log       Enable logging"
    echo "  -h, --help      Display this help message"
}

# Main 
function main {
    # check_root
    req_check "git" # Format "one" "two" "three"
    _update

}

main

# Trap function to clean up on exit
trap _cleanup EXIT

