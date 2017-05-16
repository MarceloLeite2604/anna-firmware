#!/bin/bash

# This script defines the start log level for script executions.
#
# Version: 0.1
# Author: Marcelo Leite
#
# Observations
#   This script accepts a log level as a parameter.

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";


# Defines the start log level.
#
# Parameters
#  1. The start log level value.
#
# Returns
#   0. If start log level was changed successfully.
#   1. Otherwise.
define_start_log_level(){
    local result;
    local new_start_log_level;
    local set_start_log_level_result;

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "No start log level informed.";
        result=${generic_error};
    else
        new_start_log_level=${1};
        set_start_log_level ${new_start_log_level};
        set_start_log_level_result=${?};
        if [ ${set_start_log_level_result} -ne ${success} ];
        then
            log ${log_message_type_error} "Error defining start log level.";
            result=${generic_error};
        else
            log ${log_message_type_trace} "Start log level changed to "${new_start_log_level}".";
            result=${success};
        fi;
    fi;

    return ${result};
}

define_start_log_level ${@};
exit ${?};
