#!/bin/bash

# This script contains generic functions used by other scripts.
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
# Include guard.
# ###
if [ -z "${GENERIC_FUNCTIONS_SH}" ];
then
    GENERIC_FUNCTIONS_SH=1;
else
    return;
fi;


# ###
# Script sources.
# ###

# Load generic constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load log functions script.
source "$(dirname ${BASH_SOURCE})/../log/functions.sh";


# ###
# Function elaborations.
# ###

# Returns current time formatted in a readable format.
#
# Parameters:
#   None
#
# Returns:
#    SUCCESS - If current time was retireved successfully.
#    GENERIC_ERROR - Otherwise.
#    It also returns the current time through "echo".
#
get_current_time(){

    # Checks function parameters.
    if [ ${#} -ne 0 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    # Retrieves current time.
    echo "$(date +"%Y/%m/%d %H:%M:%S")";
    return ${success};
}

# Returns current time formatted as a string to sort files.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If current time was retrieved successfully.
#   GENERIC_ERROR - Otherwise.
#   It also returns current time formatted as a string through "echo".
#
get_current_time_formatted() {

    # Checks function parameters.
    if [ ${#} -ne 0 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    # Retrieves current time formatted to sort files.
    echo "$(date +"%Y%m%d_%H%M%S")";
    return ${success};
};

# Finds a program location.
#
# Parameters
#   1. Program to be searched.
#
# Returns
#   SUCCESS - If the program was located.
#   GENERIC_ERROR - Otherwise.
#   It also returns the program location through "echo".
#
find_program(){

    local program;
    local program_location;
    local command_result;

    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        program="${1}";
    fi;

    # Finds a program location.
    program_location=$(command -v "${program}");
    command_result=${?};
    if [ ${command_result} -ne ${success} -o -z "${program_location}" ];
    then
        log ${log_message_type_trace} "Could not find program \"${program}\".";
        return  ${generic_error};
    fi;

    echo "${program_location}";

    return ${success};
}
