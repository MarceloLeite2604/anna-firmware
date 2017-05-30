#!/bin/bash

# This script undefines the start log level for script executions.
#
# Parameters:
#   None.
#
# Returns:
#   None.
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

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";


# ###
# Functions elaboration.
# ###

# Undefines the start log level.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If start log level was undefined successfully.
#   GENERIC_ERROR - Otherwise.
#
undefine_start_log_level(){

    local result;
    local delete_start_log_level_file_result;

    # Deletes the start log level file.
    delete_start_log_level_file;
    delete_start_log_level_file_result=${?};
    if [ ${delete_start_log_level_file_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error undefining start log level value.";
        result=${generic_error};
    else
        log ${log_message_type_trace} "Start log level undefined.";
        result=${success};
    fi;

    return ${result};
}

# Requests to undefine the start log level.
undefine_start_log_level;
exit ${?};
