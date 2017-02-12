#!/bin/sh

# This script contains all generic functions required to record audio.
#
# Version: 0.1
# Author: Marcelo Leite

# Load configurations file.
source $(dirname ${BASH_SOURCE})/configuration.sh

# Load generic audio constants file.
source $(dirname ${BASH_SOURCE})/audio_generic_constants.sh

# Load generic functions script.
source $(dirname ${BASH_SOURCE})/generic_functions.sh

# Load log and trace functions script.
source $(dirname ${BASH_SOURCE})/log_functions.sh

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
