#!/bin/bash

# This script creates the "/var/run/sdp" file group change verification service.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the "/var/run/sdp" file group change verification service was created successfully.
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

# Load "/var/run/sdp" file group change verification service creation constants.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load function creation functions.
source "$(dirname ${BASH_SOURCE})/../functions.sh";


# ###
# Function elaborations.
# ###

# Creates the "/var/run/sdp" file group change verification service.
#
# Parameters:
#   None. 
#
# Returns:
#   0 - If "/var/run/sdp" file group change verification service was created successfully.
#   1 - Otherwise.
#
create_sdp_file_group_change_verification_service() {

    local create_service_result;

    create_service "${service_sdp_file_group_change_verification_unit_model_path}";
    create_service_result=${?};
    if [ ${create_service_result} -ne 0 ];
    then
        print_error_message "Error while creating \"/var/run/sdp\" file group change verification service.";
        return 1;
    fi;

    return 0;
}

create_sdp_file_group_change_verification_service ${#};
exit ${?};
