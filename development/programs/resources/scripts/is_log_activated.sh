#!/bin/bash

# This script checks is log is activated.
#
# Version: 0.1
# Author: Marcelo Leite
#

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";

# Checks if log is activated.
#
# Parameters
#  None
#
# Returns
#   0. If log is active.
#   1. If log is not active.
#   2. If there was an error.
#
is_log_activated(){
    local result;
    local is_log_defined_result;

    is_log_defined;
    is_log_defined_result=${?};

    if [ ${is_log_defined_result} -eq ${success} ];
    then
        result=${success};
    else
        result=${generic_error};
    fi;

    return ${result};
}

is_log_activated;
exit ${?};
