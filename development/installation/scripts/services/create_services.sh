#!/bin/bash

# This script creates all services required for system execution.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If system services were created successfully.
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
if [ -z "${CREATE_SERVICES_SH}" ]
then
    CREATE_SERVICES_SH=1;
else
    return;
fi;

# ###
# Script sources.
# ###

# Loads service creation functions.
source "$(dirname ${BASH_SOURCE})/functions.sh";

# Loads installation functions.
source "$(dirname ${BASH_SOURCE})/../function.sh";


# ###
# Function elaborations.
# ###

# Installs all services required for system execution.
#
# Parameters:
#   None. 
#
# Returns:
#   0 - If services were installed successfully.
#   1 - Otherwise.
#
install_services() {

    local create_services_scripts_directory_result;
    local create_service_bluetooth_pairing_script_execution_result;
    local create_service_sdp_file_verification_script_execution_result;
    local create_service_clean_up_script_execution_result;
    local create_service_communication_script_execution_result;
    
    # Creates the services' shell scripts' directory on system destination directory.
    create_services_scripts_directory;
    create_services_scripts_directory_result=${?};
    if [ ${create_services_scripts_directory_result} -ne 0 ];
    then
        print_error_message "Error while creating the services' shell scripts' directory on system destination directory.";
        return 1;
    fi;
    
    # Requests the creation of bluetooth pairing service.
    ${create_service_bluetooth_pairing_script_path};
    create_service_bluetooth_pairing_script_execution_result=${?};
    if [ ${create_service_bluetooth_pairing_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while creating bluetooth pairing service.";
        return 1;
    fi;

    # Requests the creation of "/var/run/sdp" file group changing verification service.
    ${create_service_sdp_file_group_changing_verification_script_path};
    create_service_sdp_file_group_changing_verification_script_execution_result=${?};
    if [ ${create_service_sdp_file_group_changing_verification_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while creating \"/var/run/sdp\" file group changing verification service.";
        return 1;
    fi;
    
    # Requests the creation of "/var/run/sdp" file verification service.
    ${create_service_sdp_file_verification_script_path};
    create_service_sdp_file_verification_script_execution_result=${?};
    if [ ${create_service_sdp_file_verification_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while creating \"/var/run/sdp\" file verification service.";
        return 1;
    fi;
    
    # Requests the creation of cleaning up service.
    ${create_service_clean_up_script_path};
    create_service_clean_up_script_execution_result=${?};
    if [ ${create_service_clean_up_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while creating cleaning up service.";
        return 1;
    fi;

    # Requests the creation of communication service.
    ${create_service_communication_script_path};
    create_service_communication_script_execution_result=${?};
    if [ ${create_service_clean_up_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while creating communication service.";
        return 1;
    fi;
    return 0;
}

install_services ${#};
exit ${?};
