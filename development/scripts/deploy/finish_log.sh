#!/bin/bash

# This script stops a log file.
#
# Version: 0.1
# Author: Marcelo Leite
#

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";

# Finishes a log file.
#
# Parameters
#   None.
#
# Returns
#   0. If log file was finished successfully.
#   1. Otherwise.
finish_log(){
    local result;
    local is_log_defined_result;
    local continue_log_file_result;
    local finish_log_file_result;

    is_log_defined;
    is_log_defined_result=${?};
    if [ ${is_log_defined_result} -eq ${success} ];
    then
        continue_log_file;
        continue_log_file_result=${?};
        if [ ${continue_log_file_result} -eq ${success} ];
        then
            finish_log_file;
            finish_log_file_result=${?};
            if [ ${finish_log_file_result} -eq ${success} ];
            then
                result=${success};
            else
                result=${generic_error};
            fi;
        else
            result=${generic_error};
        fi;
    fi;

    return ${result};
}

finish_log;
exit ${?};
