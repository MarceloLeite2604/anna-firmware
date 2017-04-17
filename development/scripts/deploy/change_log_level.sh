#!/bin/bash

# This script changes the log level for script executions.
#
# Version: 0.1
# Author: Marcelo Leite
#
# Observations
#   This script accepts a log level as a parameter.

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";


# Changes the log level.
#
# Parameters
#  2. The new log level value.
#
# Returns
#   0. If log level was changed successfully.
#   1. Otherwise.
change_log_level(){
    local result;
    local new_log_level;
    local is_log_defined_result;
    local continue_log_file_result;
    local set_log_level_result;

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "No log level informed.";
        result=${generic_error};
    else
        new_log_level=${1};

        is_log_defined;
        is_log_defined_result=${?};
        if [ ${is_log_defined_result} -eq ${success} ];
        then
            continue_log_file;
            continue_log_file_result=${?};
            if [ ${continue_log_file_result} -eq ${success} ];
            then
                set_log_level ${new_log_level};
                set_log_level_result=${?};
                if [ ${set_log_level_result} -ne ${success} ];
                then
                    log ${log_message_type_error} "Error changing current log level.";
                    result=${generic_error};
                fi;
            else
                log ${log_message_type_error} "Error continuing log file.";
                result=${generic_error};
            fi;
        fi;
    fi;

    return ${result};
}

change_log_level ${@};
exit ${?};
