#!/usr/bin/env bash

# tmp directory - will be deleted on exit
# shellcheck disable=SC2154
_tmp_dir="/tmp/${_script_name}.$RANDOM.$RANDOM.$RANDOM.$$"
(umask 077 && mkdir "${_tmp_dir}") || {
    die "Could not create temporary directory! Exiting."
}

# Logfile location
_logFile="${_tmp_dir}/log/${_script_name}.log"


# Function to Set trap to delete temp directory on exit
function _cleanup {
    if [[ -d "${_tmp_dir}" ]] && [[ "${log}" -eq 0 ]]; then
        rm -rf "${_tmp_dir}"
    fi
}
