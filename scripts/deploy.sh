#!/bin/bash

# This script controls the deployment of project's subdivisions.
#
# Version: 
#   0.1
#
# Author: 
#   Marcelo Leite
#

# ###
# Source scripts.
# ###

# Load generic functions script.
source "$(dirname ${BASH_SOURCE})/generic/functions.sh";

# Load constants used on project controlling.
source "$(dirname ${BASH_SOURCE})/constants.sh";


# ###
# Function elaborations.
# ###

# Creates the additional directories required for project execution.
#
# Parameters:
#   1. The root directory which the additional directories will be created.
#
# Returns:
#   0 - If directory structure was created successfully.
#   1 - Otherwise.
#
# create_directory_structure(){
# 
#     local root_directory="${1}";
# 
#     create_directory "${root_directory}temporary/";
#     local create_directory_result=${?};
#     if [ ${create_directory_result} -ne 0 ];
#     then
#         return ${create_directory_result};
#     fi;
# 
#     create_directory "${root_directory}pids/";
#     local create_directory_result=${?};
#     if [ ${create_directory_result} -ne 0 ];
#     then
#         return ${create_directory_result};
#     fi;
# 
#     create_directory "${root_directory}audio/";
#     local create_directory_result=${?};
#     if [ ${create_directory_result} -ne 0 ];
#     then
#         return ${create_directory_result};
#     fi;
# 
#     create_directory "${root_directory}logs/";
#     local create_directory_result=${?};
#     if [ ${create_directory_result} -ne 0 ];
#     then
#         return ${create_directory_result};
#     fi;
# 
#     return 0;
# }

# Defines the input and output directories for system.
#
# Parameters:
#   1. Path to directory where the files which stores the input and output directories must be stored.
#   2. Path to the input directory.
#   3. Path to the output directory.
#
# Returns:
#   0 - If input and output files were defined successfully.
#   1 - Otherwise.
# define_input_output_directories() {
# 
#     local echo_result;
# 
#     local source_directory="${1}";
#     local input_directory="${2}";
#     local output_directory="${3}";
# 
#     echo "${input_directory}" > ${source_directory}input_directory;
#     echo_result=${?};
#     if [ ${echo_result} -ne 0 ];
#     then
#         echo -e "Error while defining the input directory.";
#         return 1;
#     fi;
# 
#     echo "${output_directory}" > ${source_directory}output_directory;
#     echo_result=${?};
#     if [ ${echo_result} -ne 0 ];
#     then
#         echo -e "Error while defining the output directory.";
#         return 1;
#     fi;
# 
#     # echo "${input_output_directory}../build/release/bin/" > ${source_directory}binaries_directory;
# 
#     return 0;
# }

# Creates the directory to store the current release version.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the directory was created successfully.
#   1 - Otherwise.
#
create_current_release_version_directory(){

    local mkdir_result;

    # If current release version directory does not exist.
    if [ ! -d "${current_release_version_directory}" ];
    then
        echo -n "Creating release version directory.";

        # Creates the current release version directory.
        mkdir -p "${current_release_version_directory}";
        mkdir_result=${?};

        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "Error while creating directory \"${current_release_version_directory}\": ${mkdir_result}";
            return 1;
        fi;
    fi;

    # create_directory_structure "${current_release_version_directory}";

    return 0;
}

# Copies a directory.
#
# Parameters:
#   1. Path to the directory to be copied.
#   2. Path to the copied directory.
#
# Returns:
#   0 - If copy was done successfully.
#   1 - Otherwise.
#
# Observations:
#   If a directory with the same name exists on base directory, its content will be replaced.
#
copy_directory(){

    local directory_to_copy;
    local base_directory;
    local destination_directory;
    local rm_result;
    local cp_result;

    if [ ${#} -ne 2 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else
        directory_to_copy="${1}";
        destination_directory="${2}";
    fi;

    if [[ ${directory_to_copy} != */ ]];
    then
        echo -e "[WARNING]: Parameter 1 informed for \"${FUNCNAME[0]}\" method does not have the leading forward slash.";
        directory_to_copy="${directory_to_copy}/";
    fi;

    if [[ ${destination_directory} != */ ]];
    then
        echo -e "[WARNING]: Parameter 2 informed for \"${FUNCNAME[0]}\" method does not have the leading forward slash.";
        destination_directory="${destination_directory}/";
    fi;

    if [ -d "${destination_directory}" ];
    then
        # echo -e "Directory \"${destination_directory}\" already exists.";

        rm -rf "${destination_directory}";
        rm_result=${?}
        if [ ${rm_result} -ne 0 ];
        then
            print_error_message "Error while deleting directory \"${destination_directory}\".";
            return 1;
        fi;
    fi;

    cp -r "${directory_to_copy}" "${destination_directory}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying \"${directory_to_copy}\" to \"${base_directory}\".";
        return 1;
    fi;

    return 0;
}

# Deploys the "configuration" project subdivision.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If project subdivision was deployed successfully.
#   1 - Otherwise.
#
deploy_configuration(){
    echo -e "Deploying \"configuration\" project division.";

    local copy_directory_result;

    create_current_release_version_directory;

    echo -e "Deploying to release version directory.";
    copy_directory "${subdivision_configuration_directory_path}" "${current_release_version_directory}configuration/";
    copy_directory_result=${?};
    if [ ${copy_directory_result} -ne 0 ];
    then
        print_error_message "Error while deploying configuration files to release version directory.";
        return 1;
    fi;

    echo -e "Deploying to \"programs\" project subdivision.";
    copy_directory "${subdivision_configuration_directory_path}" "${subdivision_programs_directory_path}resources/configuration/";
    copy_directory_result=${?};
    if [ ${copy_directory_result} -ne 0 ];
    then
        print_error_message "Error while deploying configuration files to \"programs\" project subdivision.";
        return 1;
    fi;

    echo -e "Deploying to \"scripts\" project subdivision.";
    copy_directory "${subdivision_configuration_directory_path}" "${subdivision_scripts_directory_path}resources/configuration/";
    copy_directory_result=${?};
    if [ ${copy_directory_result} -ne 0 ];
    then
        print_error_message "Error while deploying configuration files to \"scripts\" project subdivision.";
        return 1;
    fi;

    return 0;
}

# Deploys the "scripts" project subdivision.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If project subdivision was deployed successfully.
#   1 - Otherwise.
#
deploy_scripts(){
    echo -e "Deploying \"scripts\" project division.";

    local copy_directory_result;

    create_current_release_version_directory;

    echo -e "Deploying to release version directory.";
    copy_directory "${subdivision_scripts_directory_path}deploy/" "${current_release_version_directory}scripts/";
    copy_directory_result=${?};
    if [ ${copy_directory_result} -ne 0 ];
    then
        print_error_message "Error while deploying scripts to release version directory.";
        return 1;
    fi;

    echo -e "Deploying to \"programs\" project subdivision.";
    copy_directory "${subdivision_scripts_directory_path}deploy/" "${subdivision_programs_directory_path}resources/scripts/";
    copy_directory_result=${?};
    if [ ${copy_directory_result} -ne 0 ];
    then
        print_error_message "Error while deploying scripts to \"programs\" project subdivision.";
        return 1;
    fi;


    # echo -e "Defining input and output directories on release version directory.";
    # define_input_output_directories "${current_release_version_directory}scripts/directories/" "../../"

    # echo -e "Defining input and output directories on \"programs\" subdivision.";
    # define_input_output_directories "${subdivision_programs_directory_path}resources/scripts/directories/" "../../"

    # create_directory_structure "${subdivision_programs_directory_path}resources/";

    return 0;
}

# Deploys the "programs" project subdivision.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If project subdivision was deployed successfully.
#   1 - Otherwise.
#
deploy_programs() {
    echo -e "Deploying \"programs\" project division.";

    local copy_directory_result;

    create_current_release_version_directory;

    echo -e "Deploying source files to release version directory."
    copy_directory "${subdivision_programs_directory_path}/src/release/" "${current_release_version_directory}source/"
    copy_directory_result=${?};
    if [ ${copy_directory_result} -ne 0 ];
    then
        print_error_message "Error while copying source files to release version directory.";
        return 1;
    fi;

    echo -e "Deploying built programs to \"scripts\" project subdivision.";
    copy_directory "${subdivision_programs_directory_path}/build/release/" "${subdivision_scripts_directory_path}resources/programs/"
    copy_directory_result=${?};
    if [ ${copy_directory_result} -ne 0 ];
    then
        print_error_message "Error while deploying build programs to \"scripts\" project subdivision.";
        return 1;
    fi;

    echo -e "Deploying build scripts to \"installation\" project subdivision.";
    copy_directory "${subdivision_programs_directory_path}/build/scripts/" "${subdivision_installation_directory_path}scripts/build/"
    copy_directory_result=${?};
    if [ ${copy_directory_result} -ne 0 ];
    then
        print_error_message "Error while deploying build scripts to \"installation\" project subdivision.";
        return 1;
    fi;

    return 0;
}

# Deploys the "installation" project subdivision.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If project subdivision was deployed successfully.
#   1 - Otherwise.
#
deploy_installation() {
    echo -e "Deploying \"installation\" project subdivision.";

    local copy_directory_result;

    create_current_release_version_directory;

    echo -e "Deploying to release version directory.";
    copy_directory "${subdivision_installation_directory_path}" "${current_release_version_directory}installation/"
    copy_directory_result=${?};
    if [ ${copy_directory_result} -ne 0 ];
    then
        print_error_message "Error while copying installation files to release version directory.";
        return 1;
    fi;

    return 0;
}

# Prints the usage of this script.
#
# Parameters:
#   None.
#
# Returns:
#   0 - Any case.
#
print_usage(){
    echo -e "Use this script to deploy the project subdivisions.\n"
    echo -e "Usage:"
    echo -e "\t$(basename ${0}) {configuration, scripts, programs, installation}"
    echo -e "\tDepending on parameter informed the script will deploy a project subdivision.\n"

    return 0;
}

deploy(){

    local deploy_result;
    local subdivision;

    if [ "${1}" == "help" -o "${1}" == "-h" ] ;
    then
        print_usage;
        return 0;
    fi;

    subdivision="${1}";

    if [ -z "${subdivision}" ];
    then
        print_usage;
        print_error_message "Project subdivision not informed.";
        return 1;
    fi;

    if [ "${subdivision}" != "configuration" -a "${subdivision}" != "scripts" -a "${subdivision}" != "programs" -a "${subdivision}" != "installation" ];
    then
        print_usage;
        print_error_message "Unknown project subdivision informed.";
        return 1;
    fi;

    deploy_${subdivision};
    deploy_result=${?};
    if [ ${deploy_result} -ne 0 ];
    then
        print_error_message "Error while deploying \"${subdivision}\" project subdivision.";
        return 1;
    fi;

    return 0;
}

deploy ${@};
exit ${?};
