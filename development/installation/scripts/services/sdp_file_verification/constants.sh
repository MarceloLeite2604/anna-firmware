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

# Load the installation constants.
source "$(dirname ${BASH_SOURCE})/../../generic/constants.sh";


# ###
# Constants.
# ###

# Path to the "var/run/sdp" file verification service's unit models' directory.
if [ -z "${service_sdp_file_verification_unit_models_directory_path}" ];
then
    readonly service_sdp_file_verification_unit_models_directory_path="${base_installation_unit_files_directory_path}bluetooth/var-run-sdp/unit_models/";
fi;

# Name of the "var/run/sdp" file group change service's unit model.
if [ -z "${service_sdp_file_verification_unit_model_name}" ];
then
    readonly service_sdp_file_verification_unit_model_name="sdp-file-verification.service";
fi;

# Path to the model used to create the "var/run/sdp" file group change service systemd unit.
if [ -z "${service_sdp_file_verification_unit_model_path}" ];
then
    readonly service_sdp_file_verification_unit_model_path="${service_sdp_file_verification_unit_models_directory_path}${service_sdp_file_verification_unit_model_name}";
fi;
