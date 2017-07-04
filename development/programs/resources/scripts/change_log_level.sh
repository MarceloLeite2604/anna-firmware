#!/bin/bash

# This script changes the log level for script executions.
#
# Parameters:
#   1. The new log level. 
#
# Return:
#   SUCCESS - If log level was defined successfully.
#   GENERIC_ERROR - Otherwise.
#
# Version:
#   0.1
#
# Author: 
#   Marcelo Leite
#
# Observations:
#   The valid log level values are defined on log constants file.


# ###
# Source scripts.
# ###

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";


# ###
# Functions elaboration.
# ###

# Changes the log level.
#
# Parameters:
#   1. The new log level value.
#
# Returns:
#   SUCCESS - If log level was changed successfully.
#   GENERIC_ERROR - Otherwise.
#
change_log_level(){

    local new_log_level;
    local is_log_defined_result;
    local continue_log_file_result;
    local set_log_level_result;

    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "No log level informed.";
        return ${generic_error};
    else
        new_log_level=${1};
    fi;

    # Checks if log is defined.
    is_log_defined;
    is_log_defined_result=${?};
    if [ ${is_log_defined_result} -eq ${success} ];
    then

        # Continues the log file.
        continue_log_file;
        continue_log_file_result=${?};
        if [ ${continue_log_file_result} -eq ${success} ];
        then

            # Defines the log level.
            set_log_level ${new_log_level};
            set_log_level_result=${?};
            if [ ${set_log_level_result} -ne ${success} ];
            then
                log ${log_message_type_error} "Error changing current log level.";
                return ${generic_error};
            fi;
        else
            log ${log_message_type_error} "Error continuing log file.";
            return ${generic_error};
        fi;
    fi;

    return ${success};
}

# Requests to change the log level.
change_log_level ${@};
exit ${?};
