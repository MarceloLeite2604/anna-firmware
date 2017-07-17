#!/bin/bash

# This script creates the bluetooth pairing service.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the bluetooth pairing service was created successfully.
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

# Load bluetooth pairing service creation constants.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load function creation functions.
source "$(dirname ${BASH_SOURCE})/../functions.sh";


# ###
# Function elaborations.
# ###

# Creates the bluetooth pairing service.
#
# Parameters:
#   None. 
#
# Returns:
#   0 - If bluetooth pairing service was created successfully.
#   1 - Otherwise.
#
create_bluetooth_pairing_service() {

    local create_service_result;

    create_service "${service_bluetooth_pairing_unit_model_path}" service_bluetooth_pairing_scripts_names[@] "${service_bluetooth_pairing_scripts_directory_path}";
    create_service_result=${?};
    if [ ${create_service_result} -ne 0 ];
    then
        print_error_message "Error while creating bluetooth pairing service.";
        return 1;
    fi;

    return 0;
}

create_bluetooth_pairing_service ${#};
exit ${?};
