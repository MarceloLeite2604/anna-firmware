#!/bin/bash

# Generic functions used throughout the project controlling and development.
#
# Version: 
#   0.1
#
# Author: 
#   Marcelo Leite

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
# Source scripts.
# ###

# Load generic constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# ###
# Function elaborations.
# ###

# Prints an error message.
#
# Parameters:
#   1. The error message to print.
#
# Returns:
#   0 - Any case.
#
print_error_message() {

    local error_message;

    if [ ${#} -ge 1 ];
    then
        error_message="${1}";
        >&2 echo "${error_message_preffix} ${error_message}";
    fi;

    return 0;
}


# Creates a new directory.
#
# Parameters:
#   1. Path to new directory.
#
# Returns:
#   0 - If directory was created successfully.
#   1 - Otherwise.
#
# Observations:
#   If the directory already exists, the method leave as it is.
#
create_directory() {

    local directory;
    local mkdir_result;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else
        directory="${1}";
    fi;

    # If specified directory does not exist.
    if [ ! -d "${directory}" ];
    then
        echo -e "Creating directory \"${directory}\".";

        # Creates the directory.
        mkdir -p "${directory}";
        mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "Error creating directory \"${directory}\" (${mkdir_result}).";
            return 1;
        fi;
    fi;

    return 0;
}
