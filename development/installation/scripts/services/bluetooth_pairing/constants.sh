#!/bin/bash

# This script contains all the constants required to install the bluetooth pairing service.
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
if [ -z "${CREATE_SERVICE_BLUETOOTH_PAIRING_CONSTANTS_SH}" ]
then
    CREATE_SERVICE_BLUETOOTH_PAIRING_CONSTANTS_SH=1;
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

# Path to the bluetooth pairing scripts' directory on base.
if [ -z "${service_bluetooth_pairing_scripts_directory_path}" ];
then
    readonly service_bluetooth_pairing_scripts_directory_path="${base_installation_unit_files_directory_path}bluetooth/pairing/scripts/";
fi;

# Name of the bluetooth pairing service's scripts.
if [ -z "${service_bluetooth_pairing_scripts_names}" ];
then
    readonly service_bluetooth_pairing_scripts_names=("bluetooth-pairing.sh" "bluetoothctl-commands.sh");
fi;

# Path to the bluetooth pairing service's unit models' directory.
if [ -z "${service_bluetooth_pairing_unit_models_directory_path}" ];
then
    readonly service_bluetooth_pairing_unit_models_directory_path="${base_installation_unit_files_directory_path}bluetooth/pairing/unit_models/";
fi;

# Name of the bluetooth pairing service's unit model.
if [ -z "${service_bluetooth_pairing_unit_model_name}" ];
then
    readonly service_bluetooth_pairing_unit_model_name="bluetooth-pairing.service";
fi;

# Path to the model used to create the bluetooth pairing service systemd unit.
if [ -z "${service_bluetooth_pairing_unit_model_path}" ];
then
    readonly service_bluetooth_pairing_unit_model_path="${service_bluetooth_pairing_unit_models_directory_path}${service_bluetooth_pairing_unit_model_name}";
fi;
