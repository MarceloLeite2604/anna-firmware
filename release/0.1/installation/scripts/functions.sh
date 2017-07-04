#!/bin/bash

# This script install all files required to execute Anna.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If units were installed successfully.
#   1 - Otherwise.
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
if [ -z "${INSTALLATION_FUNCTIONS_SH}" ]
then
    INSTALLATION_FUNCTIONS_SH=1;
else
    return;
fi;

# ###
# Script sources.
# ###

# Load constants.
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
#   The result of this method is always 0.
print_error_message() {

    local error_message;

    if [ ${#} -gt 1 ];
    then
        error_message="${1}";
        >&2 echo "${error_preffix}: ${error_message}";
    fi;

    return 0;
}

