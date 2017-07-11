n#!/bin/bash

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
#
create_additional_directories(){
    local additional_directories_script_execution_result;

    echo -e "Creating additional directories on destination directory.";

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
#
copy_system_files() {
    local copy_result;

    echo "Copying system files to destination directory.";

    # Copies all directories on base directory exception the installation scripts directory.
    set -x;
    ls --hide=${installation_directory_name} --hide=${source_directory_name} | xargs -I {} cp -r {} "${system_destination_directory}.";
    copy_result=${?};
    if [ ${copy_result} -ne 0 ];
    then
        print_error_message "Error copying base directories to destination directory: ${copy_result}";
        return 1;
    fi;
    set +x;

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
#
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

# Creates the temporary directories.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If temporary directories were created successfully.
#   1 - Otherwise.
#
create_temporary_directories() {

    local mkdir_result;
    local temporary_directories_array=(${temporary_directory} ${temporary_build_directory_path} ${temporary_build_output_directory} ${temporary_binaries_output_directory_path} ${temporary_objects_output_directory_path} ${temporary_unit_files_directory_path});

    echo -e "Creating temporary directories.";

    for directory_to_create in ${temporary_directories_array[@]};
    do
        if [ ! -d "${directory_to_create}" ];
        then
            echo -e "Creating temporary directory \"${directory_to_create}\".";

            mkdir -p "${directory_to_create}";
            mkdir_result=${?};
            if [ ${mkdir_result} -ne 0 ];
            then
                print_error_message "Error while creating temporary directory \"${directory_to_createi}\": ${mkdir_result}.";
                return 1;
            fi;
        else
            echo -e "Directory \"${directory_to_create}\" already exists.";
        fi;
    done;

    return 0;
}

# Removes the temporary directories.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If temporary directories were removed successfully.
#   1 - Otherwise.
#
remove_temporary_directories() {

    local rm_result;

    echo -e "Removing temporary directories.";

    rm -rf "${temporary_directory}";
    rm_result=${?};
    if [ ${rm_result} -ne 0 ];
    then
        print_error_message "Error while removing temporary directory \"${temporary_directory}\". ${rm_result}";
        return 1;
    fi;

    return 0;
}

# Installs the systemd units
#
# Parameters:
#   None.
#
# Returns:
#   0 - If systemd units were installed successfully.
#   1 - If there was an error installing systemd units.
#
install_systemd_units() {

    local sudo_check_result;
    local command_line;
    local install_systemd_units_script_exeution_result;

    echo -e "Installing systemd units.";

    # If user is not root.
    if [ $(whoami) != "root" ];
    then

        # Check if user is a superuser.
        sudo_check_result=$(sudo -l -U $(whoami) | grep "not allowed" | wc -l);
        if [ ${sudo_check_result} -eq 1 ];
        then
            print_error_message "System services installation requires a user with superuser privileges. Used \"$(whoami)\" is not a superuser.";
            print_error_message "Cancelling installation.";
            return 1;
        fi;

        echo -e "System services installation will require superuser privileges. If prompted, please inform password for used \"$(whoami)\" or hit [CTRL+C] to abort installation.";
        command_line="sudo -A ";
    fi;

    command_line="${command_line} ${install_systemd_units_script_path}";

    ${command_line};
    install_systemd_units_script_execution_result=${?};
    if [ ${install_systemd_units_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while executing script to install systemd units.";
        return 1;
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

    local cp_result;
    local build_script_execution_result;

    echo -e "Building system binaries.";

    # Copies the source files to the temporary build path.
    cp -r "${source_directory_path}" "${temporary_build_directory_path}release";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error copying \"${source_directory_path}\" to \"${temporary_build_directory_path}\": ${cp_result}.";
        return 1;
    fi;

    # Executes the build script.
    ${build_script_path} release all "${temporary_build_directory_path}" "${temporary_build_output_directory_path}";
    build_script_execution_result=${?};
    if [ ${build_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while building the binaries for system installation: ${build_script_execution_result}";
        return 1;
    fi;

    # Copy the binaries built to the destination's binaries directory.
    cp -r "${temporary_binaries_output_directory_path}" "${system_binaries_directory}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying the binaries to destination directory. ${cp_result}";
        return 1;
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

    local build_binaries_result;
    local create_destination_directory_result;
    local create_temporary_directories_result;
    local copy_system_files_result;
    local create_additional_directories_result;
    local install_systemd_units_result;
    local remove_temporary_directories_result;

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

    # Creates the temporary directories.
    create_temporary_directories;
    create_temporary_directories_result=${?};
    if [ ${create_temporary_directories_result} -ne 0 ];
    then
        print_error_message "Error while creating temporary directories.";
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

    # Installs the systemd units required to run the system.
    install_systemd_units;
    install_systemd_units_result=${?};
    if [ ${install_systemd_units_result} -ne 0 ];
    then
        print_error_message "Error while installing systemd units to system execution.";
        return 1;
    fi;

    exit 0;

    # Removes the temporary directories.
    remove_temporary_directories;
    remove_temporary_directories_result=${?};
    if [ ${remove_temporary_directories_result=} -ne 0 ];
    then
        print_error_message "Error while removing tempory directories.";
        return 1;
    fi;

    return 0;
}

install ${@};
exit ${?};
