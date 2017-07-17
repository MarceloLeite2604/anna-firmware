#!/bin/bash

# This script contains all the constants required to create the "var/run/sdp" file verification service.
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
if [ -z "${CREATE_SERVICE_SDP_FILE_VERIFICATION_SERVICE_SH}" ]
then
    CREATE_SERVICE_SDP_FILE_VERIFICATION_SERVICE_SH=1;
else
    return;
fi;


# ###
# Source scripts.
# ###

# Loads the installation constants.
source "$(dirname ${BASH_SOURCE})/../../constants.sh";


# ###
# Constants.
# ###

# Path to the "var/run/sdp" file verification service's unit models' directory.
if [ -z "${service_sdp_file_verification_unit_models_directory_path}" ];
then
    readonly service_sdp_file_verification_unit_models_directory_path="${base_installation_services_directory_path}sdp_file_verification/";
fi;

# Name of the "var/run/sdp" file group change service's unit model.
if [ -z "${service_sdp_file_verification_unit_model_name}" ];
then
    readonly service_sdp_file_verification_unit_model_name="sdp-file-verification.path";
fi;

# Path to the model used to create the "var/run/sdp" file group change service systemd unit.
if [ -z "${service_sdp_file_verification_unit_model_path}" ];
then
    readonly service_sdp_file_verification_unit_model_path="${service_sdp_file_verification_unit_models_directory_path}${service_sdp_file_verification_unit_model_name}";
fi;
