#!/bin/sh

# This script contains all functions required to encode audio.
#
# Version: 0.1
# Author: Marcelo Leite

# Load configurations file
source $(dirname ${BASH_SOURCE})/configuration.sh

# Load audio constants file.
source $(dirname ${BASH_SOURCE})/audio_constants.sh

# Load log and trace functions.
source $(dirname ${BASH_SOURCE})/log_functions.sh

# Load general functions.
source $(dirname ${BASH_SOURCE})/general_functions.sh

# Directory where all audio will be stored.
audio_directory="${default_audio_directory}";

# Creates the audio file name based on current instant.
#
# Parameters
#   None.
#
# Returns
#   0. If audio file name was created successfully.
#  -1. Otherwise.
#   It also returns the file name created through "echo".
create_audio_file_name() {

    if [ $# -ne 0 ]
    then
        log ${type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

	local readonly audio_file_name="${audio_file_preffix}_$(get_current_time_formatted).${audio_file_suffix}";
	echo "${audio_file_name}";
	return ${success};
}
