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

# Path to the temporary build directory.
if [ -z "${temporary_build_directory_path}" ];
then
    readonly temporary_build_directory_path="${temporary_directory}build/";
fi;

# Path to the temporary build output directory.
if [ -z "${temporary_build_output_directory_path}" ];
then
    readonly temporary_build_output_directory_path="${temporary_build_directory_path}output/";
fi;

# Path to the temporary binaries output directory.
if [ -z "${temporary_binaries_output_directory_path}" ];
then
    readonly temporary_binaries_output_directory_path="${temporary_build_output_directory_path}bin/";
fi;

# Path to the temporary objects output directory.
if [ -z "${temporary_objects_output_directory_path}" ];
then
    readonly temporary_objects_output_directory_path="${temporary_build_output_directory_path}objects/";
fi;

# Path to the temporary unit files directory.
if [ -z "${temporary_unit_files_directory_path}" ];
then
    readonly temporary_unit_files_directory_path="${temporary_directory}units/";
fi;

# Path to the temporary script files directory.
if [ -z "${temporary_script_files_directory_path}" ];
then
    readonly temporary_script_files_directory_path="${temporary_directory}scripts/";
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

# Script to install systemd units.
if [ -z "${install_systemd_units_script_name}" ];
then
    readonly install_systemd_units_script_name="install_units.sh";
fi;

# Path to the script which installs system units.
if [ -z "${install_systemd_units_script_path}" ];
then
    readonly install_systemd_units_script_path="${installation_scripts_directory_path}${install_systemd_units_script_name}";
fi;

# Script to install system variables script.
if [ -z "${install_system_variables_script_name}" ];
then
    readonly install_system_variables_script_name="install_variables_script.sh";
fi;

# Path to the script which installs the variable scripts.
if [ -z "${install_system_variables_script_path}" ];
then
    readonly install_system_variables_script_path="${installation_scripts_directory_path}${install_system_variables_script_name}";
fi;

# Path to the script which creates the additional directories for system execution on base directory.
if [ -z "${additional_directories_script_path}" ];
then
    readonly additional_directories_script_path="${system_destination_directory}${scripts_directory_name}${additional_directories_script_name}";
fi;

# Name of the file which defines the input file's location for scripts.
if [ -z "${scripts_input_location_file_name}" ];
then
    readonly scripts_input_location_file_name="input_directory";
fi;

# Path of the file which defines the input file's location for scripts.
if [ -z "${scripts_input_location_file_path}" ];
then
    readonly scripts_input_location_file_path="${system_destination_directory}${scripts_directory_name}directories/${scripts_input_location_file_name}";
fi;

# Name of the file which defines the output file's location for scripts.
if [ -z "${scripts_output_location_file_name}" ];
then
    readonly scripts_output_location_file_name="output_directory";
fi;

# Path of the file which defines the output file's location for scripts.
if [ -z "${scripts_output_location_file_path}" ];
then
    readonly scripts_output_location_file_path="${system_destination_directory}${scripts_directory_name}directories/${scripts_output_location_file_name}";
fi;

# Name of the file which defines the location of binaries for scripts.
if [ -z "${scripts_binaries_location_file_name}" ];
then
    readonly scripts_binaries_location_file_name="binaries_directory";
fi;

# Path of the file which defines the location of binaries for scripts.
if [ -z "${scripts_binaries_location_file_path}" ];
then
    readonly scripts_binaries_location_file_path="${system_destination_directory}${scripts_directory_name}directories/${scripts_binaries_location_file_name}";
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

# Path to deploy the script which defines the required variables for system execution.
if [ -z "${script_deploy_directory_path}" ];
then
    readonly script_deploy_directory_path="/etc/profile.d/";
fi;

# The directory which the system stores scripts used on system services.
if [ -z "${service_scripts_directory_path}" ];
then
    readonly service_scripts_directory_path="${system_destination_directory}${scripts_directory_name}system/";
fi;

# Final name of the script used to define the required variables for system execution.
if [ -z "${variables_script_name}" ];
then
    variables_script_name="anna_set_directories.sh";
fi;

# Path to the deployed variables script.
if [ -z "${deployed_variables_script_path}" ];
then
    deployed_variables_script_path="${script_deploy_directory_path}${variables_script_name}";
fi;

# Name of the script template used to define the required variables for system execution.
if [ -z "${variables_script_template_name}" ];
then
    variables_script_template_name="${variables_script_name}.template";
fi;

# Path to the script which defines the variables on the temporary folder.
if [ -z "${temporary_variables_script_path}" ];
then
    temporary_variables_script_path="${temporary_script_files_directory_path}${variables_script_name}";
fi;

# Path to the script template used to define the required variables for system execution.
if [ -z "${variables_script_template_path}" ];
then
    variables_script_template_path="${installation_scripts_directory_path}${variables_script_template_name}";
fi;

# The directory which the system stores its programs.
if [ -z "${system_binaries_directory}" ];
then
    readonly system_binaries_directory="${system_destination_directory}bin/";
fi;

# Term used to identify teh location which the system service scripts directory path must be inserted on sysctl unit model files.
if [ -z "${service_scripts_directory_path_term}" ];
then
    readonly service_scripts_directory_path_term="<SYSTEM_SERVICE_SCRIPTS_DIRECTORY>";
fi;

# Path to the directory which stores the files required to install systemd units.
if [ -z "${unit_files_directory_path}" ];
then
    readonly unit_files_directory_path="${installation_directory_path}units/";
fi;

# Scripts required to execute system services.
if [ -z "${system_services_scripts}" ];
then
    readonly system_services_scripts=("${unit_files_directory_path}bluetooth/pairing/scripts/bluetoothctl-commands.sh" "${unit_files_directory_path}bluetooth/pairing/scripts/bluetooth-pairing.sh");
fi;

# Unit models to request installation.
if [ -z "${unit_models_to_install}" ];
then
    readonly unit_models_to_install=("${unit_files_directory_path}bluetooth/var-run-sdp/unit_models/var-run-sdp.path" "${unit_files_directory_path}bluetooth/var-run-sdp/unit_models/var-run-sdp.service" "${unit_files_directory_path}bluetooth/pairing/unit_models/bluetooth-pairing.service");
fi;

# Term used to identify the value location for variable which identifies the input files root directory on script used to define the projects variables.
if [ -z "${input_files_location_value_term}" ];
then
    readonly input_files_location_value_term="<ANNA_INPUT_DIRECTORY_VALUE>";
fi;

# Term used to identify the value location for variable which identifies the output files root directory on script used to define the projects variables.
if [ -z "${output_files_location_value_term}" ];
then
    readonly output_files_location_value_term="<ANNA_OUTPUT_DIRECTORY_VALUE>";
fi;
