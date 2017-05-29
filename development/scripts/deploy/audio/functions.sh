#!/bin/bash

# This script contains all generic functions required for audio capture and encoding.
#
# Parameters:
#   None.
#
# Return:
#   None.
#
# Version:
#   0.1
#
# Author: 
#   Marcelo Leite


# ###
# Script sources.
# ###

# Load generic audio constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load generic functions script.
source "$(dirname ${BASH_SOURCE})/../generic/functions.sh";

# Load file functions script.
source "$(dirname ${BASH_SOURCE})/../file/functions.sh";

# Load log functions script.
source "$(dirname ${BASH_SOURCE})/../log/functions.sh";


# ###
# Functions.
# ###

# Reads an audio configuration file.
#
# Parameters
#   1. Path to configuration file to read.
#
# Returns
#   SUCCESS - If configuration file was read and there was content on it.
#   GENERIC_ERROR - Otherwise.
#   It also returns the configuration file's content through "echo".
#
read_audio_configuration_file(){
    local file;
    local file_content;

    # Check function parameters.
    if [ ${#} -ne 1 ]
    then
        log ${type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    else
        file="${1}";
    fi;

    # Get configuration file content.
    file_content=$(read_file "${file}");
    if [ ${?} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    # Check if configuration file has a content.
    if [ -z "${file_content}" ];
    then
        log ${log_message_type_error} "File \"${audio_capture_channels_configuration_file}\" is empty.";
        return ${generic_error};
    fi;

    # Returns configuration file's content through "echo".
    echo "${file_content}";

    return ${success};
}
