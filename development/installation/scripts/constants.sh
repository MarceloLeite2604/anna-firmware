#!/bin/bash

# This script contains all the constants required to the first stage of system installation.
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
# Source scripts.
# ###

# Load generic installation constants.
source "$(dirname ${BASH_SOURCE})/generic/constants.sh";


# ###
# Constants.
# ###

# Name of the directory which contains the installation files.
if [ -z "${installation_directory_name}" ];
then
    readonly installation_directory_name="installation/";
fi;

# Name of the directory which contains the scripts.
if [ -z "${scripts_directory_name}" ];
then
    readonly scripts_directory_name="scripts/";
fi;

# Name of the directory which contains the source files.
if [ -z "${source_directory_name}" ];
then
    readonly source_directory_name="source/";
fi;

# Name of the script which installs system services.
if [ -z "${install_services_script_name}" ];
then
    readonly install_services_script_name="install_services.sh";
fi;

# Name of the script which installs system variables' script.
if [ -z "${install_system_variables_script_name}" ];
then
    readonly install_system_variables_script_name="install_system_variables_script.sh";
fi;

# Name of the script which creates the additional directories required for system execution.
if [ -z "${create_additional_directories_script_name}" ];
then
    readonly create_additional_directories_script_name="create_directories.sh";
fi;

# Name of the file which defines the input files' location for scripts.
if [ -z "${file_name_location_input_files_script}" ];
then
    readonly file_name_location_input_files_script="input_directory";
fi;

# Name of the file which defines the output files' location for scripts.
if [ -z "${file_name_location_output_files_script}" ];
then
    readonly file_name_location_output_files_script="output_directory";
fi;

# Name of the file which defines the binaries' location for scripts.
if [ -z "${file_name_location_binaries_script}" ];
then
    readonly file_name_location_binaries_script="binaries_directory";
fi;

# Path to base directory.
if [ -z "${base_directory_path}" ];
then
    readonly base_directory_path="$(realpath "$(dirname ${BASH_SOURCE})/../../")";
fi;

# Path to installation directory on base.
if [ -z "${base_installation_directory_path}" ];
then
    readonly base_installation_directory_path="${base_directory}${installation_directory_name}";
fi;

# Path to installation scripts' directory on base.
if [ -z "${base_installation_scripts_directory_path}" ];
then
    readonly base_installation_scripts_directory_path="${base_installation_directory_path}scripts/";
fi;

# Path to the script used to build the binaries.
if [ -z "${base_installation_build_script_path}" ];
then
    readonly base_installation_build_script_path="${base_installation_scripts_directory_path}build/build.sh";
fi;

# Path to the services installation's scripts.
if [ -z "${base_installation_install_services_scripts_directory_path}" ];
then
   readonly base_installation_install_services_scripts_directory_path="${base_installation_scripts_directory_path}services/";
fi;

# Path to the script which installs system services.
if [ -z "${base_installation_install_services_script_path}" ];
then
    readonly base_installation_install_services_script_path="${base_installation_install_services_scripts_directory_path}${install_services_script_name}";
fi;

# Path to the script which installs system services.
if [ -z "${base_installation_install_system_variables_script_path}" ];
then
    readonly base_installation_install_system_variables_script_path="${base_installation_scripts_directory_path}system_variables_script/${install_system_variables_script_name}";
fi;

# Path to systemd unit models' directory on base.
if [ -z "${base_installation_unit_files_directory_path}" ];
then
    readonly base_installation_unit_files_directory_path="${base_installation_directory_path}units/";
fi;

# Path to the source files' directory on base directory.
if [ -z "${base_source_directory_path}" ];
then
    readonly base_source_directory_path="${base_directory_path}source/";
fi;

# Path to the system's destination directory.
if [ -z "${destination_directory_path}" ];
then
    readonly destination_directory_path="/opt/${company_name}/${system_name}/";
fi;

# Path to services' shell scripts' directory on destination directory.
if [ -z "${destination_services_scripts_directory_path}" ];
then
    readonly destination_services_scripts_directory_path="${destination_directory_path}${scripts_directory_name}services/";
fi;

# Path to binaries' directory on destination directory.
if [ -z "${destination_binaries_directory_path}" ];
then
    readonly destination_binaries_directory_path="${destination_directory_path}bin/";
fi;

# Path to the script which creates the additional directories on destination directory.
if [ -z "${destination_create_additional_directories_script_path}" ];
then
    readonly destination_create_additional_directories_script_path="${destination_services_scripts_directory_path}${create_additional_directories_script_name}";
fi;

# Path of the file which defines the input files' location for scripts on destination directory.
if [ -z "${destination_file_name_location_input_files_script_path}" ];
then
    readonly destination_file_name_location_input_files_script_path="${destination_services_scripts_directory_path}directories/${scripts_input_location_file_name}";
fi;

# Path of the file which defines the output files' location for scripts on destination directory.
if [ -z "${destination_file_name_location_output_files_script_path}" ];
then
    readonly destination_file_name_location_output_files_script_path="${destination_services_scripts_directory_path}directories/${scripts_output_location_file_name}";
fi;

# Path of the file which defines the binaries' location for scripts on destination directory.
if [ -z "${destination_file_name_location_binaries_script_path}" ];
then
    readonly destination_file_name_location_binaries_script_path="${destination_services_scripts_directory_path}directories/${scripts_binaries_location_file_name}";
fi;

# Path to the file which defines the input files' location for scripts on destination directory.
if [ -z "${destination_file_name_location_input_files_script_path}" ];
then
    readonly file_name_location_input_files_script="input_directory";
fi;

# Path to the file which defines the output files' location for scripts on destination directory.
if [ -z "${destination_file_name_location_input_files_script_path}" ];
then
    readonly file_name_location_output_files_script="output_directory";
fi;

# Path to the file which defines the binaries' location for scripts on destination directory.
if [ -z "${destination_file_name_location_input_files_script_path}" ];
then
    readonly file_name_location_binaries_script="binaries_directory";
fi;

# Path to temporary directory.
if [ -z "${temporary_directory_path}" ];
then
    readonly temporary_directory_path="/tmp/${company_name}/${system_name}/";
fi;

# Path to temporary build directory.
if [ -z "${temporary_build_directory_path}" ];
then
    readonly temporary_build_directory_path="${temporary_build_directory_path}build/";
fi;

# Path to temporary source directory.
if [ -z "${temporary_source_directory_path}" ];
then
    readonly temporary_source_directory_path="${temporary_build_directory_path}release/";
fi;

# Path to temporary build output directory.
if [ -z "${temporary_build_output_directory_path}" ];
then
    readonly temporary_build_output_directory_path="${temporary_build_directory_path}output/";
fi;

# Path to temporary binaries output directory.
if [ -z "${temporary_binaries_output_directory_path}" ];
then
    readonly temporary_binaries_output_directory_path="${temporary_build_output_directory_path}bin/";
fi;

# Path to temporary objects output directory.
if [ -z "${temporary_objects_output_directory_path}" ];
then
    readonly temporary_objects_output_directory_path="${temporary_build_output_directory_path}objects/";
fi;

# Path to temporary unit files directory.
if [ -z "${temporary_unit_files_directory_path}" ];
then
    readonly temporary_unit_files_directory_path="${temporary_build_directory_path}units/";
fi;

# Path to temporary script files directory.
if [ -z "${temporary_script_files_directory_path}" ];
then
    readonly temporary_script_files_directory_path="${temporary_build_directory_path}scripts/";
fi;

# Array with the all temporary directories' path.
if [ -z "${temporary_directories}" ];
then
    readonly temporary_directories=("${temporary_directory_path}" "${temporary_build_directory_path}" "${temporary_build_output_directory_path}" "${temporary_binaries_output_directory_path}" "${temporary_objects_output_directory_path}" "${temporary_unit_files_directory_path}" "${temporary_script_files_directory_path}");
fi;

# Path to deploy the script which defines the required variables for system execution.
if [ -z "${script_deploy_directory_path}" ];
then
    readonly script_deploy_directory_path="/etc/profile.d/";
fi;

# Term used to identify the location where the services' shell scripts' directory path must be inserted on systemd unit model files.
if [ -z "${term_destination_services_scripts_directory_path}" ];
then
    readonly term_destination_services_scripts_directory_path="<SYSTEM_SERVICE_SCRIPTS_DIRECTORY>";
fi;

# Term used to identify the location where the scripts' input directory definition file's path must be inserted on system variables' script.
if [ -z "${input_files_location_value_term}" ];
then
    readonly input_files_location_value_term="<ANNA_INPUT_DIRECTORY_VALUE>";
fi;

#  Term used to identify the location where the scripts' output directory definition file's path must be inserted on system variables' script.
if [ -z "${output_files_location_value_term}" ];
then
    readonly output_files_location_value_term="<ANNA_OUTPUT_DIRECTORY_VALUE>";
fi;
