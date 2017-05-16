#!/bin/bash

# This script finds the latest audio recorded and stores its name on "last audio" file.
#
# Version: 0.1
# Author: Marcelo Leite
#

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";

# Load generic audio encoder constants script.
source "$(dirname ${BASH_SOURCE})/audio/encoder/constants.sh"


# Finds the latest audio recorded and stores its name on "last audio" file.
#
# Parameters
#
# Returns
#   0. If the latest audio record name was stored successfully.
#   1. Otherwise.
find_latest_audio_record(){
    local result;
    local latest_audio_record_file_name;
    local echo_result;
    local continue_log_file_result;
    local log_file_created;
    local is_log_defined_result;
    local log_file_created;
    local audio_file_pattern;

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
        create_log_file "find_lastest_audio_record";
        log_file_created=${?};

        # Set log level.
        set_log_level ${log_message_type_trace};
    fi;

    audio_file_pattern="${audio_directory}${audio_file_preffix}*${audio_file_suffix}"

    latest_audio_record_file_name=$(eval ls -A1tr "${audio_file_pattern}" 2> /dev/null | tail -n 1);
    latest_audio_record_file_name=$(basename "${latest_audio_record_file_name}");
    if [ -z "${latest_audio_record_file_name}" ];
    then
        log ${log_message_type_error} "Could not find latest audio record file name.";
        result=${generic_error};
    else

        log ${log_message_type_trace} "Latest audio record file name: \"${latest_audio_record_file_name}\".";


        echo -ne "${latest_audio_record_file_name}" > ${latest_audio_record_file_name_file};
        echo_result=${?};
        if [ ${echo_result} -ne ${success} ];
        then
            log ${log_message_type_error} "Could not write latest audio record file name.";
            result=${generic_error};
        else
            result=${success};
        fi;
    fi;

    if [ ${log_file_created} -eq ${success} ];
    then

        # Finishes the log file.
        finish_log_file;
    fi;

    return ${result};
}

find_latest_audio_record;
exit ${?};
