#!/bin/bash

# This script contains all the constants required to install the system variables' script.
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
if [ -z "${INSTALLATION_SYSTEM_VARIABLES_SCRIPT_CONSTANTS_SH}" ]
then
    INSTALLATION_SYSTEM_VARIABLES_SCRIPT_CONSTANTS_SH=1;
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

# Path to the directory where the system variables' script must be deployed.
if [ -z "${variables_script_deploy_directory_path}" ];
then
    readonly variables_script_deploy_directory_path="/etc/profile.d/";
fi;

# Name of the script which defines the variables for system execution.
if [ -z "${system_variables_script_name}" ];
then
    readonly system_variables_script_name="anna_set_directories.sh";
fi;

# Name of the template used to create the system variables' script.
if [ -z "${system_variables_script_template_name}" ];
then
    readonly system_variables_script_template_name="${system_variables_script_name}.template";
fi;

# Path to the template used to create the system variables' script.
if [ -z "${system_variables_script_template_path}" ];
then
    readonly system_variables_script_template_path="${installation_scripts_directory_path}system_variables_script/${system_variables_script_template_name}";
fi;

# Path to the temporary script used to created from the system variables' script template.
if [ -z "${temporary_system_variables_script_path}" ];
then
    readonly temporary_system_variables_script_path="${temporary_script_files_directory_path}${system_variables_script_name}";
fi;

# Path to the deployed system variables' script.
if [ -z "${deployed_variables_script_path}" ];
then
    readonly deployed_variables_script_path="${variables_script_deploy_directory_path}${system_variables_script_name}";
fi;
