#!/bin/bash

# This script install all files required to execute Anna.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If units were installed successfully.
#   1 - Otherwise.
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

# Load functions.
source "$(dirname ${BASH_SOURCE})/functions.sh";


# ###
# Function elaborations.
# ###

# Creates the additional directories on installation directory.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the additional directories were created successfully.
#   1 - Otherwise.
create_additional_directories(){

    local additional_directories_script_execution_result;

    ${additional_directories_script_path}; 
    additional_directories_script_execution_result=${?};
    if [ ${additional_directories_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while creating additional directories on system directory: ${additional_directories_script_execution_result}";
        return 1;
    fi;

    return 0;
}

# Copy system files to installation directory.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If system files' copy was executed successfully.
#   1 - Otherwise.
copy_system_files() {

    local copy_result;

    # Copies all directories on base directory exception the installation scripts directory.
    l --hide=${installation_scripts_directory_name} | xargs cp -r "${installation_directory}";
    copy_result=${?};
    if [ ${copy_result} -ne 0 ];
    then
        print_error_message "Error copying base directories to installation directory: ${copy_result}";
        return 1;
    fi;

    return 0;
}

# Creates the installation directory.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If installation directory was created successfullly.
#   1 - Otherwise.
create_installation_directory() {

    local mkdir_result;

    # If installation directory does not exist.
    if [ ! -d "${installation_directory}" ];
    then

        echo "Creating directory \"${installation_directory}\".";

        # Creates the installation directory.
        mkdir -p "${installation_directory}";
        mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "\"mkdir\" command returned value ${mkdir_result}.";
            return 1;
        fi;
    else
        echo "Directory \"${installation_directory}\" already exists.";
    fi;

    return 0;
}

# Installs the system.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If system were installed successfully.
#   1 - Otherwise.
#
install() {

    local create_installation_directory_result;
    local copy_system_files_result;
    local create_additional_directories_result;
    local install_units_result;
    
    # Creates the installation directory.
    create_installation_directory;
    create_installation_directory_result=${?};
    if [ ${create_installation_directory_result} -ne 0 ];
    then
        print_error_message "Error while creating installation directory.";
        return 1;
    fi;

    # Copy system files to installation directory.
    copy_system_files;
    copy_system_files_result=${?};
    if [ ${copy_system_files_result} -ne 0 ];
    then
        print_error_message "Error while copying system files to installation directory.";
        return 1;
    fi;

    # Creates additional directories required for system execution.
    create_additional_directories;
    create_additional_directories_result=${?};
    if [ ${create_additional_directories_result} -ne 0 ];
    then
        print_error_message "Error creating additional directories on installation directory.";
        return 1;
    fi;

    # Installs the systemctl units required to run the system.
    install_units;
    install_units_result=${?};
    if [ ${install_units_result} -ne 0 ];
    then
        print_error_message "Error installing systemctl units for system execution.";
        return 1;
    fi;

    return 0;
}

install ${@};
exit ${?};
