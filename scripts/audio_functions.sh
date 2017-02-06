#!/bin/sh

# This script contains all functions required to record audio.
#
# Version: 0.1
# Author: Marcelo Leite

# Load configurations file
source $(dirname $BASH_SOURCE)/configuration.sh

# Load audio constants file.
source $(dirname $BASH_SOURCE)/audio_constants.sh

# Load log and trace functions.
source $(dirname $BASH_SOURCE)/log_functions.sh

# Directory where all audio will be stored.
audio_directory=${default_audio_directory};

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

# Check if audio directory exists and user can read and write on it.
#
# Parameters
#   None.
#
# Returns
#    0. If directory exists and user has read and write permissions on it.
#   -1. Otherwise.
check_audio_directory(){

    if [ $# -ne 0 ]
    then
        log ${type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

    if [ ! -d "${audio_directory}" ];
    then

        log ${type_error} "Audio directory \"${audio_directory}\" does not exists.";
        return ${general_failure};
    fi;


    if [ ! -w "${audio_directory}" ];
    then
        log ${type_error} "User \"$(whoami)\" does not have write permission on directory \"${audio_directory}\".";
        return ${general_failure};
     fi;

     if [ ! -r "${audio_directory}" ];
     then
         log ${type_error} "User \"$(whoami)\" does not have read permission on directory \"${audio_directory}\".";
         return ${general_failure};
     fi;
     
     return ${success};
}
