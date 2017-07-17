#!/bin/bash

# This script contains all the constants required to install the clean up service.
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
if [ -z "${CREATE_SERVICE_CLEAN_UP_CONSTANTS_SH}" ]
then
    CREATE_SERVICE_CLEAN_UP_CONSTANTS_SH=1;
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

# Path to the clean up service's unit models' directory.
if [ -z "${service_clean_up_unit_models_directory_path}" ];
then
    readonly service_clean_up_unit_models_directory_path="${base_installation_services_directory_path}clean_up/";
fi;

# Path to the clean up scripts' directory on base.
if [ -z "${service_clean_up_scripts_directory_path}" ];
then
    readonly service_clean_up_scripts_directory_path="${service_clean_up_unit_models_directory_path}scripts/";
fi;

# Name of the clean up service's scripts.
if [ -z "${service_clean_up_scripts_names}" ];
then
    readonly service_clean_up_scripts_names=("clean_up.sh");
fi;

# Name of the clean up service's unit model.
if [ -z "${service_clean_up_unit_model_name}" ];
then
    readonly service_clean_up_unit_model_name="anna-clean-up.service";
fi;

# Path to the model used to create the clean up service systemd unit.
if [ -z "${service_clean_up_unit_model_path}" ];
then
    readonly service_clean_up_unit_model_path="${service_clean_up_unit_models_directory_path}${service_clean_up_unit_model_name}";
fi;
