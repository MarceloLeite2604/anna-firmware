#!/bin/bash

# This script checks if device is recording.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If device is recording.
#   GENERIC_ERROR - If device is not recording or if an error occurred.
#
# Version:
#   0.1
#
# Author: 
#   Marcelo Leite
#

# ###
# Script sources.
# ###

# Load audio capture functions.
source "$(dirname ${BASH_SOURCE})/audio/capture/functions.sh";

# Load audio encoder functions.
source "$(dirname ${BASH_SOURCE})/audio/encoder/functions.sh";


# ###
# Functions elaboration.
# ###

# Checks if device is recording.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If device is recording.
#   GENERIC_ERROR - If device is not recording or if an error occurred.
#
is_recording(){

    local result;
    local audio_capture_process_alive;
    local audio_encoder_process_alive;
    local is_log_defined_result;
    local continue_log_file_result;
    local log_file_created;

    continue_log_file_result=1;
    log_file_created=1;

    # Checks if log file is defined.
    is_log_defined;
    is_log_defined_result=${?};
    if [ ${is_log_defined_result} -eq ${success} ];
    then

        # Continues previous log file.
        continue_log_file;
        continue_log_file_result=${?};
    fi;

    # If previous log file was not continued.
    if [ ${continue_log_file_result} -ne ${success} ];
    then

        # Creates a new log file.
        create_log_file "is_recording";
        log_file_created=${?};

        # Set log level.
        set_log_level ${log_message_type_trace};
    fi;

    log ${log_message_type_trace} "Checking if device is recording.";

    # Checks if audio capture process is running.
    is_audio_capture_process_running;
    audio_capture_process_alive=${?};

    # Checks if audio encoder process is running.
    is_audio_encoder_process_running;
    audio_encoder_process_alive=${?};

    # Checks if ony one of the programs is running.
    if [ ${audio_capture_process_alive} -ne ${audio_encoder_process_alive} ];
    then
        log ${log_message_type_error} "Only one of the processes is running.";
        return ${generic_error};
    fi;

    # Checks if both programs is running.
    if [ ${audio_capture_process_alive} -eq ${success} -a ${audio_encoder_process_alive} -eq ${success} ];
    then
        log ${log_message_type_trace} "Device is recording."
        result=${success};
    else
        log ${log_message_type_trace} "Device is not recording."
        result=${generic_error};
    fi;

    # Checks if log file was created by thos script.
    if [ ${log_file_created} -eq ${success} ];
    then

        # Finishes the log file.
        finish_log_file;
    fi;

    return ${result};
}

is_recording;
exit ${?};
