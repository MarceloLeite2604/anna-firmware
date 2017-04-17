#!/bin/bash

# This script undefines the start log level for script executions.
#
# Version: 0.1
# Author: Marcelo Leite

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";


# Undefines the start log level.
#
# Parameters
#   None  
#
# Returns
#   0. If start log level was undefined successfully.
#   1. Otherwise.
undefine_start_log_level(){
    local result;
    local new_log_level;
    local continue_log_file_result;
    local set_log_level_result;

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

undefine_start_log_level ${@};
exit ${?};
