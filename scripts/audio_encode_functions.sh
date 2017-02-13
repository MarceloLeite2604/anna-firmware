#!/bin/bash

# This script contains all functions required to encode audio.
#
# Version: 0.1
# Author: Marcelo Leite

# Load audio generic constants file.
source $(dirname ${BASH_SOURCE})/audio_generic_constants.sh;

# Load audio generic functions script.
source $(dirname ${BASH_SOURCE})/audio_generic_functions.sh;

# Load log and trace functions.
source $(dirname ${BASH_SOURCE})/log_functions.sh;

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

    if [ ${#} -ne 0 ]
    then
        log ${type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

	local readonly audio_file_name="${audio_file_preffix}_$(get_current_time_formatted).${audio_file_suffix}";
	echo "${audio_file_name}";
	return ${success};
}

# Starts the audio encode process.
#
# Parameters
#   None.
#
# Returns
#   0. If audio encode process was successfully started.
#   1. Otherwise.
start_audio_encode_process(){

    # Searches for audio encoder program.
    local audio_encoder_program_path;
    audio_encoder_program_path=$(find_program "${audio_encoder_program}");
}

