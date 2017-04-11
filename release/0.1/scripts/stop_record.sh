#!/bin/bash

# This script stop the audio record processes.
#
# Version: 0.1
# Author: Marcelo Leite


# Load audio capture functions.
source "$(dirname ${BASH_SOURCE})/audio/capture/functions.sh";

# Load audio encoder functions.
source "$(dirname ${BASH_SOURCE})/audio/encoder/functions.sh";

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";

# Stops the audio record processes.
#
# Parameters
#   None.
#
# Returns
#  0. If audio record processes was stopped successfully.
#  1. Otherwise.
stop_record(){
    local result;
    local continue_log_file_result;
    local log_file_created;
    local is_log_defined_result;
    local log_file_created;
    local is_recording_result;
    local stop_audio_capture_process_result;
    local stop_audio_encoder_process_result;

    # Set log level.
    set_log_level ${log_message_type_trace};

    # Set log directory.
    #set_log_directory "$(dirname ${BASH_SOURCE})/../logs/";

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
        create_log_file "stop_audio_record";
        log_file_created=${?};
    fi;

    log ${log_message_type_trace} "Stopping record processes.";

    $(dirname ${BASH_SOURCE})/is_recording.sh
    is_recording_result=${?};

    if [ ${is_recording_result} -eq 2 ];
    then
        log ${log_message_type_error} "Only one of the audio processes is running.";
        result=${generic_error};
    else
        if [ ${is_recording_result} -eq 1 ];
        then
            log ${log_message_type_trace} "Audio capture processes are not running.";
            result=${success};
        else
            stop_audio_encoder_process;
            stop_audio_encoder_process_result=${?};
            if [ ${stop_audio_encoder_process_result} -ne ${success} ];
            then
                log ${log_message_type_error} "Could not stop audio encoder process.";
                result=${generic_error};
            else
                log ${log_message_type_trace} "Audio encoder process stopped.";
                # After stop audio encoder process, check if audio capture process is still alive.
                is_audio_capture_process_running;
                is_captor_running=${?};

                if [ ${is_captor_running} -ne ${success} ];
                then
                    log ${log_message_type_trace} "Audio capture process has already stopped.";
                    result=${success};
                else

                    # Stop audio capture process.
                    stop_audio_capture_process;
                    stop_audio_capture_process_result=${?};
                    if [ ${stop_audio_capture_process_result} -ne ${success} ];
                    then
                        log ${log_message_type_error} "Could not stop audio capture process.";
                        result=${generic_error};
                    else
                        log ${log_message_type_trace} "Audio capture process stopped.";
                        result=${success};
                    fi;
                fi;
            fi;
        fi;
    fi;

    if [ ${log_file_created} -eq ${success} ];
    then

        # Finishes the log file.
        finish_log_file;
    fi;

    return ${result};
}

stop_record;
exit ${?};
