#!/bin/bash

# This script contains all the constants required to install all the system.
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
if [ -z "${INSTALLATION_CONSTANTS_SH}" ]
then
    INSTALLATION_CONSTANTS_SH=1;
else
    return;
fi;

# ###
# Constants.
# ###

# The company's name.
if [ -z "${company_name}" ];
then
    readonly company_name="astring";
fi;

# The system name.
if [ -z "${system_name}" ];
then
    readonly system_name="anna";
fi;

# Path to the installation directory.
if [ -z "${installation_directory}" ];
then
    readonly installation_directory="/opt/${company_name}/${system_name}/";
fi;

# Path to the installation scripts directory on base directory.
if [ -z "${installation_scripts_directory_name}" ];
then
    readonly installation_scripts_directory_name="installation/";
fi;

# Path to the scripts directory on base directory.
if [ -z "${scripts_directory_name}" ];
then
readonly scripts_directory_name="scripts/";

# Script to create the additional directories for system execution.
if [ -z "${additional_directories_script_name}" ];
then
readonly additional_directories_script_name="create_directories.sh";

# Path to the script which creates the additional directories for system execution on base directory.
if [ -z "${additional_directories_script_path}" ];
then
    readonly additional_directories_script_path="${scripts_directory_name}${additional_directories_script_name}";
fi;

# Path to base directory.
if [ -z "${base_directory}" ];
then
    readonly base_directory="$(dirname ${BASH_SOURCE})/../";
fi;

# Preffix to show an error message.
if [ -z "${error_preffix}" ];
then
    readonly error_preffix="[ERROR]:";
fi;

# Path to depoly unit files.
if [ -z "${unit_directory_path}" ];
then
    readonly unit_directory_path="/etc/systemd/system/";
fi;

# The directory which the system stores scripts used on system services.
if [ -z "${system_service_scripts_directory}" ];
then
    readonly system_service_scripts_directory="${installation_directory}${scripts_directory_name}system/";
fi;

# Term used to identify teh location which the system service scripts directory path must be inserted on sysctl unit model files.
if [ -z "${system_service_scripts_directory_term}" ];
then
    readonly system_service_scripts_directory_term="<SYSTEM_SERVICE_SCRIPTS_DIRECTORY>";
fi;

# Scripts required to execute system services.
if [ -z "${system_services_scripts}" ];
then
    readonly system_services_scripts="../units/bluetooth/pairing/scripts/bluetoothctl-commands.sh ../units/bluetooth/pairing/scripts/bluetooth-pairing.sh"
fi;

# Unit models to request installation.
if [ -z "${unit_models_to_install}" ];
then
    readonly unit_models_to_install="../units/bluetooth/var-run-sdp/unit_models/var-run-sdp.path ../units/bluetooth/var-run-sdp/unit_models/var-run-sdp.service ../units/bluetooth/pairing/unit_models/bluetooth-pairing.service"
fi;

