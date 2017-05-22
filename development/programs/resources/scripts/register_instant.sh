#!/bin/bash

# This script stores the current instant on a temporary file.
#
# Version: 0.1
# Author: Marcelo Leite

# Load generic configuration file.
source "$(dirname ${BASH_SOURCE})/generic/constants.sh";

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";

# Stores the current instant on a temporary file.
#
# Parameters
#   None.
#
# Returns
#   0. If instant was stored successfully.
#   1. Otherwise.
store_current_instant(){
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
        create_log_file "store_current_instant";
        log_file_created=${?};

        # Set log level.
        # set_log_level ${log_message_type_trace};
    fi;

    local current_instant_file_path="${_temporary_output_files_directory}instant";

    $(BINARY_DIRECTORY)/store_current_instant "${current_instant_file_path}";
    store_current_instant_result=${?};

    if [ ${store_current_instant_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not store current instant.";
        result=${generic_error};
    else
        log ${leg_message_type_trace} "Current instant stored on file \"${current_instant_file_path}\".";
        result=${success}
    fi;
        
    if [ ${log_file_created} -eq ${success} ];
    then

        # Finishes the log file.
        finish_log_file;
    fi;

    return ${result};
}

store_current_instant;
exit ${?};
