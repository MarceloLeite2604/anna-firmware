#!/bin/bash

# This script creates the clean up service.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the clean up service was created successfully.
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
if [ -z "${CREATE_BLUETOOTH_PAIRING_SERVICE_SH}" ]
then
    CREATE_BLUETOOTH_PAIRING_SERVICE_SH=1;
else
    return;
fi;

# ###
# Script sources.
# ###

# Load clean up service creation constants.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load function creation functions.
source "$(dirname ${BASH_SOURCE})/../functions.sh";


# ###
# Function elaborations.
# ###

# Creates the clean up service.
#
# Parameters:
#   None. 
#
# Returns:
#   0 - If clean up service was created successfully.
#   1 - Otherwise.
#
create_clean_up_service() {

    local create_service_result;

    create_service "${service_clean_up_unit_model_path}" service_clean_up_scripts_names[@] "${service_clean_up_scripts_directory_path}";
    create_service_result=${?};
    if [ ${create_service_result} -ne 0 ];
    then
        print_error_message "Error while creating clean up service.";
        return 1;
    fi;

    return 0;
}

create_clean_up_service ${#};
exit ${?};
