#!/bin/bash

# This script installs all files required to execute Anna.
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

    ${additional_directories_script_path} "${system_destination_directory}"; 
    additional_directories_script_execution_result=${?};
    if [ ${additional_directories_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while creating additional directories on \"${system_destination_directory}\": ${additional_directories_script_execution_result}.";
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
    ls --hide=${installation_directory_name} --hide=${source_directory_name} | xargs -I {} cp -r {} "${system_destination_directory}.";
    copy_result=${?};
    if [ ${copy_result} -ne 0 ];
    then
        print_error_message "Error copying base directories to destination directory: ${copy_result}";
        return 1;
    fi;

    return 0;
}

# Creates the system's destination directory.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If destination directory was created successfullly.
#   1 - Otherwise.
create_destination_directory() {

    local mkdir_result;

    # If installation directory does not exist.
    if [ ! -d "${system_destination_directory}" ];
    then

        if [ ! -w "/opt" ];
        then
            print_error_message "User \"$(whoami)\" does not have permission to write on \"/opt\" directory.";
            return 1;
        fi;

        echo "Creating directory \"${system_destination_directory}\".";

        # Creates the installation directory.
        mkdir -p "${system_destination_directory}";
        mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "\"mkdir\" command returned value ${mkdir_result}.";
            return 1;
        fi;
    else
        echo "Directory \"${system_destination_directory}\" already exists.";
    fi;

    return 0;
}

# Builds the binaries required for the system.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If binaries were built successfully.
#   1 - Otherwise. 
#
build_binaries() {

    local build_directory_path;
    local build_release_directory_path;
    local build_output_directory_path;
    local build_output_objects_directory_path;
    local build_output_binaries_directory_path;
    local mkdir_result;
    local cp_result;
    local build_script_execution_result;
    local rm_result;

    build_directory_path="${temporary_directory}build/";

    if [ ! -d "${build_directory_path}" ];
    then
        mkdir -p "${build_directory_path}";
        mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "Error while creating temporary directory \"${build_directory_path}\": ${mkdir_result}.";
            return 1;
        fi;
    fi;

    # build_release_directory_path="${build_directory_path}release/";
    # if [ ! -d "${build_release_directory_path}" ];
    # then
    #     mkdir -p "${build_release_directory_path}";
    #     mkdir_result=${?};
    #     if [ ${mkdir_result} -ne 0 ];
    #     then
    #         print_error_message "Error while creating temporary directory \"${build_release_directory_path}\": ${mkdir_result}.";
    #         return 1;
    #     fi;
    # fi;

    build_output_directory_path="${temporary_directory}output/";
    if [ ! -d "${build_output_directory_path}" ];
    then
        mkdir -p "${build_output_directory_path}";
        mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "Error while creating temporary directory \"${build_output_directory_path}\": ${mkdir_result}.";
            return 1;
        fi;
    fi;

    build_output_objects_directory_path="${build_output_directory_path}objects/"
    if [ ! -d "${build_output_objects_directory_path}" ];
    then
        mkdir -p "${build_output_objects_directory_path}";
        mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "Error while creating temporary directory \"${build_output_objects_directory_path}\": ${mkdir_result}.";
            return 1;
        fi;
    fi;

    build_output_binaries_directory_path="${build_output_directory_path}/bin/"
    if [ ! -d "${build_output_binaries_directory_path}" ];
    then
        mkdir -p "${build_output_binaries_directory_path}";
        mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "Error while creating temporary directory \"${build_output_binaries_directory_path}\": ${mkdir_result}.";
            return 1;
        fi;
    fi;

    # Copies the source files to the temporary build path.
    cp -r "${source_directory_path}" "${build_directory_path}release";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error copying \"${source_directory_path}\" to \"${build_directory_path}\": ${cp_result}.";
        return 1;
    fi;

    set -x;
    # Executes the build script.
    ${build_script_path} release "${build_directory_path}" "${build_output_directory_path}";
    build_script_execution_result=${?};
    if [ ${build_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while building the binaries for system installation: ${build_script_execution_result}";
        return 1;
    fi;

    # Copy the binaries built to the "binaries" directory.
    cp "${build_output_binaries_directory_path}" "${system_binaries_directory}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying the binaries to destination directory. ${cp_result}";
        return 1;
    fi;

    # Removes the build directories.
    rm -rf "${build_directory_path}";
    rm_result=${?};
    if [ ${rm_result} -ne 0 ];
    then
        print_error_message "Error while removing the build directories. ${rm_result}";
        return 1;
    fi;

    # Removes the output directories.
    rm -rf "${build_output_directory_path}";
    rm_result=${?};
    if [ ${rm_result} -ne 0 ];
    then
        print_error_message "Error while removing the build output directories. ${rm_result}";
        return 1;
    fi;
    set +x;   
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

    local build_binaries_result;
    local create_destination_directory_result;
    local copy_system_files_result;
    local create_additional_directories_result;
    local install_units_result;

    # Creates the system's destination directory.
    create_destination_directory;
    create_destination_directory_result=${?};
    if [ ${create_destination_directory_result} -ne 0 ];
    then
        print_error_message "Error while creating destination directory.";
        return 1;
    fi;

    # Copy system files to destination directory.
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

    # Build the binaries required for system execution.
    build_binaries;
    build_binaries_result=${?};
    if [ ${build_binaries_result} -ne 0 ];
    then
        print_error_message "Error while building the system binaries.";
        return 1;
    fi;

    exit 0;

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
