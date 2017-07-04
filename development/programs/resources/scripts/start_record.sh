#!/bin/bash

# This script starts the audio record processes.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If audio record was started successfully.
#   GENERIC_ERROR - Otherwise.
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

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";


# ###
# Functions elaboration.
# ###

# Starts the audio record processes.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If audio record processes was started successfully.
#   GENERIC_ERROR - Otherwise.
#
start_record(){

    local result;
    local continue_log_file_result;
    local log_file_created;
    local is_log_defined_result;
    local log_file_created;
    local is_recording_result;
    local start_audio_capture_process_result;
    local start_audio_encoder_process_result;

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
        create_log_file "start_record";
        log_file_created=${?};
    fi;

    log ${log_message_type_trace} "Starting record processes.";

    # Checks is device is already recording.
    $(dirname ${BASH_SOURCE})/is_recording.sh
    is_recording_result=${?};
    if [ ${is_recording_result} -eq 0 ];
    then
        log ${log_message_type_trace} "Audio capture processes are already running.";
        result=${success};

    else

        # Starts audio capture process.
        start_audio_capture_process;
        start_audio_capture_process_result=${?};
        if [ ${start_audio_capture_process_result} -ne ${success} ];
        then
            log ${log_message_type_error} "Could not start audio capture process."
            result=${generic_error};
        else

            # Starts audio encoder process.
            start_audio_encoder_process;
            start_audio_encoder_process_result=${?};
            if [ ${start_audio_encoder_process_result} -ne ${success} ];
            then
                log ${log_message_type_error} "Could not start audio encoder process."
                result=${generic_error};
            else
                log ${log_message_type_trace} "Audio record started.";
                result=${success};
            fi;
        fi;
    fi;

    # If log file was created by this script.
    if [ ${log_file_created} -eq ${success} ];
    then

        # Finishes the log file.
        finish_log_file;
    fi;

    return ${result};
}

start_record;
exit ${?};
