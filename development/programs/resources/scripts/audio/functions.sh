#!/bin/bash

# This script contains all generic functions required for audio functions.
#
# Version: 0.1
# Author: Marcelo Leite

# Load generic audio constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load generic functions script.
source "$(dirname ${BASH_SOURCE})/../generic/functions.sh";

# Load file functions script.
source "$(dirname ${BASH_SOURCE})/../file/functions.sh";

# Load log functions script.
source "$(dirname ${BASH_SOURCE})/../log/functions.sh";

# Reads an audio configuration file.
#
# Parameters
#    1. Configuration file to be read.
#
# Returns
#    0. If confguration file was read and there was content on it.
#    1. Otherwise.
read_audio_configuration_file(){
    if [ $# -ne 1 ]
    then
        log ${type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

    local readonly file="$1";

    local file_content;
    file_content=$(read_file "${file}");
    if [ ${?} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    if [ -z "${file_content}" ];
    then
        log ${log_message_type_error} "File \"${audio_capture_channels_configuration_file}\" is empty.";
        return ${generic_error};
    fi;

    echo "${file_content}";

    return ${success};
}
