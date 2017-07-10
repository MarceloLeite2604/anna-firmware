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

# Path to the system's destination directory.
if [ -z "${system_destination_directory}" ];
then
    readonly system_destination_directory="/opt/${company_name}/${system_name}/";
fi;

# Path to the temporary directory.
if [ -z "${temporary_directory}" ];
then
    readonly temporary_directory="/tmp/${company_name}/${system_name}/";
fi;

# Path to base directory.
if [ -z "${base_directory}" ];
then
    readonly base_directory="$(dirname ${BASH_SOURCE})/../../";
fi;

# Name of the directory which contains the installation files on base directory.
if [ -z "${installation_directory_name}" ];
then
    readonly installation_directory_name="installation/";
fi;

# Path to the installation directory on base directory.
if [ -z "${installation_directory_path}" ];
then
    readonly installation_directory_path="${base_directory}installation/";
fi;

# Path to the installation scripts on base directory.
if [ -z "${installation_scripts_directory_path}" ];
then
    readonly installation_scripts_directory_path="${installation_directory_path}scripts/";
fi;

# Path to the script used to build the binaries.
if [ -z "${build_script_path}" ];
then
    readonly build_script_path="${installation_scripts_directory_path}build/build.sh";
fi;

# Path to the scripts directory on base directory.
if [ -z "${scripts_directory_name}" ];
then
    readonly scripts_directory_name="scripts/";
fi;

# Name of the directory which contains the source files on base directory.
if [ -z "${source_directory_name}" ];
then
    readonly source_directory_name="source/";
fi;

# Path to the directory which contains the source files on base directory.
if [ -z "${source_directory_path}" ];
then
    readonly source_directory_path="${base_directory}source/";
fi;

# Script to create the additional directories for system execution.
if [ -z "${additional_directories_script_name}" ];
then
    readonly additional_directories_script_name="create_directories.sh";
fi;    

# Path to the script which creates the additional directories for system execution on base directory.
if [ -z "${additional_directories_script_path}" ];
then
    readonly additional_directories_script_path="${system_destination_directory}${scripts_directory_name}${additional_directories_script_name}";
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
    readonly system_service_scripts_directory="${system_destination_directory}${scripts_directory_name}system/";
fi;

# The directory which the system stores its programs.
if [ -z "${system_binaries_directory}" ];
then
    readonly system_binaries_directory="${system_destination_directory}bin/"
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

