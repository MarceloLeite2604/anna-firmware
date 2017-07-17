#!/bin/bash

# This script creates the communication service.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the communication service was created successfully.
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

# Load communication service creation constants.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load function creation functions.
source "$(dirname ${BASH_SOURCE})/../functions.sh";


# ###
# Function elaborations.
# ###

# Creates the communication service.
#
# Parameters:
#   None. 
#
# Returns:
#   0 - If communication service was created successfully.
#   1 - Otherwise.
#
create_communication_service() {

    local create_service_result;

    create_service "${service_communication_unit_model_path}" service_communication_scripts_names[@] "${service_communication_scripts_directory_path}";
    create_service_result=${?};
    if [ ${create_service_result} -ne 0 ];
    then
        print_error_message "Error while creating communication service.";
        return 1;
    fi;

    return 0;
}

create_communication_service ${#};
exit ${?};
