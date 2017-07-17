#!/bin/bash

# This script contains the constants used to create the system services.
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
if [ -z "${CREATE_SERVICES_CONSTANTS_SH}" ]
then
    CREATE_SERVICES_CONSTANTS_SH=1;
else
    return;
fi;


# ###
# Source scripts.
# ###

# Loads installation constants.
source "$(dirname ${BASH_SOURCE})/../constants.sh"



# ###
# Constants.
# ###

# Path to the directory where the unit files created must be deployed.
if [ -z "${systemd_unit_files_deploy_directory_path}" ];
then
    readonly systemd_unit_files_deploy_directory_path="/etc/systemd/system/";
fi;

# Term used to identify the location where the services' shell scripts' directory path must be inserted on service files.
if [ -z "${term_destination_services_scripts_directory_path}" ];
then
    readonly term_destination_services_scripts_directory_path="<SYSTEM_SERVICE_SCRIPTS_DIRECTORY>";
fi;

# Term used to identify the location where the shell scripts' directory path must be inserted on service files.
if [ -z "${term_destination_scripts_directory_path}" ];
then
    readonly term_destination_scripts_directory_path="<SYSTEM_SCRIPTS_DIRECTORY>";
fi;

# Term used to identify the location where the binaries' directory path must be inserted on service files.
if [ -z "${term_destination_binaries_directory_path}" ];
then
    readonly term_destination_binaries_directory_path="<SYSTEM_BINARIES_DIRECTORY>";
fi;

# Path to the script which creates the bluetooth pairing service.
if [ -z "${create_service_bluetooth_pairing_script_path}" ];
then
    readonly create_service_bluetooth_pairing_script_path="${base_installation_create_services_scripts_directory_path}bluetooth_pairing/create_service.sh";
fi;

# Path to the script which creates the "/var/run/sdp" file verification service.
if [ -z "${create_service_sdp_file_verification_script_path}" ];
then
    readonly create_service_sdp_file_verification_script_path="${base_installation_create_services_scripts_directory_path}sdp_file_verification/create_service.sh";
fi;

# Path to the script which creates the "/var/run/sdp" file group changing verification service.
if [ -z "${create_service_sdp_file_group_changing_verification_script_path}" ];
then
    readonly create_service_sdp_file_group_changing_verification_script_path="${base_installation_create_services_scripts_directory_path}sdp_file_group_change_verification/create_service.sh";
fi;

# Path to the script which creates the clean up service.
if [ -z "${create_service_clean_up_script_path}" ];
then
    readonly create_service_clean_up_script_path="${base_installation_create_services_scripts_directory_path}clean_up/create_service.sh";
fi;

# Path to the script which creates the communication service.
if [ -z "${create_service_communication_script_path}" ];
then
    readonly create_service_communication_script_path="${base_installation_create_services_scripts_directory_path}communication/create_service.sh";
fi;
