#!/bin/bash

# This script checks if log is activated.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If log is activated.
#   GENERIC_ERROR - If log is not activated or there was an error checking if log is activated.
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
# Function parameters.
# ###

# Checks if log is activated.
#
# Parameters:
#  None.
#
# Returns:
#   SUCCESS - If log is activated.
#   GENERIC_ERROR - If log is not activated or there was an error checking if log is activated.
#
is_log_activated(){

    local result;
    local is_log_defined_result;

    # Checks if log is defined.
    is_log_defined;
    is_log_defined_result=${?};
    if [ ${is_log_defined_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Checks if log is activated.
is_log_activated;
exit ${?};
