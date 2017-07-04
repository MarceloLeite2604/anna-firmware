#!/bin/bash

# This script defines the start log level for script executions.
#
# Parameters:
#   1. The start log level value.
#
# Returns:
#   SUCCESS - If start log level was defined successfully.
#   GENERIC_ERROR - Otherwise.
#
# Version: 
#   0.1
#
# Author: 
#   Marcelo Leite
#
# Observations:
#   This script accepts a log level as a parameter.
#


# ###
# Script sources.
# ###

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";


# ###
# Functions elaboration.
# ###

# Defines the start log level.
#
# Parameters:
#   1. The start log level value.
#
# Returns:
#   SUCCESS - If start log level was changed successfully.
#   GENERIC_ERROR - Otherwise.
#
define_start_log_level(){

    local new_start_log_level;
    local set_start_log_level_result;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "No start log level informed.";
        return ${generic_error};
    else
        new_start_log_level=${1};
    fi;

    # Defines the start log level.
    set_start_log_level ${new_start_log_level};
    set_start_log_level_result=${?};
    if [ ${set_start_log_level_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error defining start log level.";
        return ${generic_error};
    fi;

    # Informs on log that log level has changed.
    log ${log_message_type_trace} "Start log level changed to \"${new_start_log_level}\".";
    return ${success};
}

# Defines the start log level.
define_start_log_level ${@};
exit ${?};
