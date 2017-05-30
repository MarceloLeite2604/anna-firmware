#!/bin/bash

# This script finishes log file.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If log file was finished successfully.
#   GENERIC_ERROR - Otherwise.
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

# Finishes a log file.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If log file was finished successfully.
#   GENERIC_ERROR - Otherwise.
#
finish_log(){

    local is_log_defined_result;
    local continue_log_file_result;
    local finish_log_file_result;

    # Checks if log is defined.
    is_log_defined;
    is_log_defined_result=${?};
    if [ ${is_log_defined_result} -eq ${success} ];
    then

        # Continues log file.
        continue_log_file;
        continue_log_file_result=${?};
        if [ ${continue_log_file_result} -ne ${success} ];
        then
            return ${generic_error};
        fi;

        # Finishes log file.
        finish_log_file;
        finish_log_file_result=${?};
        if [ ${finish_log_file_result} -ne ${success} ];
        then
            return ${generic_error};
        fi;
    fi;

    return ${result};
}

# Finishes log file.
finish_log;
exit ${?};
