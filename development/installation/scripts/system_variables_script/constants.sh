#!/bin/bash

# This script contains the constants used to create the system variables script.
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
if [ -z "${CREATE_SYSTEM_VARIABLES_SCRIPT_CONSTANTS_SH}" ]
then
    CREATE_SYSTEM_VARIABLES_SCRIPT_CONSTANTS_SH=1;
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

# Path to deploy the script which defines the required variables for system execution.
if [ -z "${system_variables_script_deploy_directory_path}" ];
then
    readonly system_variables_script_deploy_directory_path="/etc/profile.d/";
fi;

# Name of the system variables' script.
if [ -z "${system_variables_script_name}" ];
then
    readonly system_variables_script_name="anna_set_directories.sh";
fi;

# Name of the system variables' script template.
if [ -z "${system_variables_script_template_name}" ];
then
    readonly system_variables_script_template_name="${system_variables_script_name}.template";
fi;

# Path to the system variables' script template.
if [ -z "${system_variables_script_template_path}" ];
then
    readonly system_variables_script_template_path="${base_installation_system_variables_script_directory_path}${system_variables_script_template_name}";
fi;

# Path to the temporary system variables script.
if [ -z "${temporary_system_variables_script_path}" ];
then
    readonly temporary_system_variables_script_path="${temporary_script_files_directory_path}${system_variables_script_name}";
fi;

# Path to the deployed system variables' script.
if [ -z "${deployed_system_variables_script_path}" ];
then
        readonly deployed_system_variables_script_path="${system_variables_script_deploy_directory_path}${system_variables_script_name}";
fi;
