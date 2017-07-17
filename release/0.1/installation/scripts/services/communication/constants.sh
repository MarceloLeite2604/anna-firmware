#!/bin/bash

# This script contains all the constants required to create the communication service.
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
if [ -z "${CREATE_SERVICE_COMMUNICATION_SERVICE_SH}" ]
then
    CREATE_SERVICE_COMMUNICATION_SERVICE_SH=1;
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

# Path to the communication service's unit models' directory.
if [ -z "${service_communication_unit_models_directory_path}" ];
then
    readonly service_communication_unit_models_directory_path="${base_installation_services_directory_path}communication/";
fi;

# Path to the communication scripts' directory on base.
if [ -z "${service_communication_scripts_directory_path}" ];
then
    readonly service_communication_scripts_directory_path="${service_communication_unit_models_directory_path}scripts/";
fi;

# Name of the communication service's scripts.
if [ -z "${service_communication_scripts_names}" ];
then
    readonly service_communication_scripts_names=("communication.sh");
fi;

# Name of the communication service's unit model.
if [ -z "${service_communication_unit_model_name}" ];
then
    readonly service_communication_unit_model_name="anna-communication.service";
fi;

# Path to the model used to create the communication service systemd unit.
if [ -z "${service_communication_unit_model_path}" ];
then
    readonly service_communication_unit_model_path="${service_communication_unit_models_directory_path}${service_communication_unit_model_name}";
fi;
