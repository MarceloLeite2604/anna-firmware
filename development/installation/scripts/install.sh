#!/bin/bash

# This script installs the system.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the system was installed successfully.
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
if [ -z "${INSTALL_SH}" ]
then
    INSTALL_SH=1;
else
    return;
fi;

# ###
# Script sources.
# ###

# Load generic functions.
source "$(dirname ${BASH_SOURCE})/generic/functions.sh";

# Load installation constants.
source "$(dirname ${BASH_SOURCE})/constants.sh";


# ###
# Function elaborations.
# ###

# Creates on destination directory the additional directories required for system execution.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the additional directories were created successfully.
#   1 - Otherwise.
#
create_additional_directories(){

    local create_additional_directories_script_result;

    echo -e "Creating additional directories on destination directory.";

    # Executes the script which creates the additional directories required to execute the system.
    ${destination_create_additional_directories_script_path} "${destination_directory_path}"; 
    create_additional_directories_script_result=${?};
    if [ ${create_additional_directories_script_result} -ne 0 ];
    then
        print_error_message "Error while executing the script which creates the additional system directories on \"${destination_directory_path}\": ${create_additional_directories_script_result}.";
        return 1;
    fi;

    return 0;
}

# Defines the input, output and binary directories on destination directory.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If locations were defined successfully.
#   1 - Otherwise.
#
    define_file_locations() {

        local echo_result;
        local location;

        echo "Defining locations for input and output files and binaries.";

        # echo ${scripts_input_location_file_path};
        
        location="../../";
        
        echo "${location}" > ${destination_file_name_location_input_files_script_path};
        echo_result=${?};
        if [ ${echo_result} -ne 0 ];
        then
            print_error_message "Error while defining input_files' location for scripts: ${echo_result}.";
            return 1;
        fi;

        echo ${location} > ${destination_file_name_location_output_files_script_path};
        echo_result=${?};
        if [ ${echo_result} -ne 0 ];
        then
            print_error_message "Error while defining output files' location for scripts: ${echo_result}.";
            return 1;
        fi;

        echo "${location}bin/" > ${destination_file_name_location_binaries_script_path};
        echo_result=${?};
    if [ ${echo_result} -ne 0 ];
    then
        print_error_message "Error while defining binaries' location for scripts: ${echo_result}.";
        return 1;
    fi;

    return 0;
}

# Copies the system files to destination directory.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If system files were copied successfully.
#   1 - Otherwise.
#
copy_system_files() {

    local copy_result;

    echo "Copying system files to destination directory.";

    # Copies all directories on base directory except the installation scripts and source files' directory.
    # Observation: Removes the forward slash on directories' names so "ls" command hide them when listing.
    ls --hide=${installation_directory_name/\//} --hide=${source_directory_name/\//} | xargs -I {} cp -r {} "${destination_directory_path}.";
    copy_result=${?};
    if [ ${copy_result} -ne 0 ];
    then
        print_error_message "Error copying base directories to destination directory: ${copy_result}.";
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
#   0 - If system's destination directory was created successfullly.
#   1 - Otherwise.
#
create_destination_directory() {

    local mkdir_result;

    # If system's destination directory does not exist.
    if [ ! -d "${destination_directory_path}" ];
    then

         # If user does not have the privilege to write on "/opt" directory.
        if [ ! -w "/opt" ];
        then
            print_error_message "User \"$(whoami)\" does not have permission to write on \"/opt\" directory.";
            return 1;
        fi;

        echo "Creating directory \"${destination_directory_path}\".";

        # Creates the installation directory.
        mkdir -p "${destination_directory_path}";
        mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "Error creating directory \"${destination_directory_path}\": ${mkdir_result}.";
            return 1;
        fi;
    else
        echo "Directory \"${destination_directory_path}\" already exists.";
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
    
    echo -e "Creating temporary directories.";

    for directory_to_create in ${temporary_directories[@]};
    do
    
        # If directory to create does not exist.
        if [ ! -d "${directory_to_create}" ];
        then
            echo -e "Creating temporary directory \"${directory_to_create}\".";

            mkdir -p "${directory_to_create}";
            mkdir_result=${?};
            if [ ${mkdir_result} -ne 0 ];
            then
                print_error_message "Error while creating temporary directory \"${directory_to_create}\": ${mkdir_result}.";
                return 1;
            fi;
        else
            echo "Directory \"${directory_to_create}\" already exists.";
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
        print_error_message "Error while removing temporary directory \"${temporary_directory}\": ${rm_result}.";
        return 1;
    fi;

    return 0;
}

# Installs the script which defines the system variables.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the script was installed successfully.
#   1 - Otherwise.
#
install_system_variables_script() {

    local install_system_variables_script_execution_result;

    echo -e "Installing system variables script.";

    execute_command_as_superuser "${base_installation_install_system_variables_script_path}";
    install_system_variables_script_execution_result=${?};
   if [ ${install_system_variables_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while executing script to install system variables script.";
        return 1;
    fi;

    return 0;
}

# Creates the system services
#
# Parameters:
#   None.
#
# Returns:
#   0 - If system services were installed successfully.
#   1 - Otherwise.
#
create_system_services() {

    local create_system_services_script_execution_result;

    echo -e "Creating system services.";
    
    execute_command_as_superuser "${base_installation_create_services_script_path}";
    create_system_services_script_execution_result=${?};
    if [ ${create_system_services_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while executing script to create system services.";
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
    cp -r "${base_source_directory_path}" "${temporary_source_directory_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error copying \"${base_source_directory_path}\" to \"${temporary_source_directory_path}\": ${cp_result}.";
        return 1;
    fi;

    # Executes the build script.
    ${base_installation_build_script_path} release all "${temporary_build_directory_path}" "${temporary_build_output_directory_path}";
    build_script_execution_result=${?};
    if [ ${build_script_execution_result} -ne 0 ];
    then
        print_error_message "Error while building the binaries for system installation: ${build_script_execution_result}.";
        return 1;
    fi;

    # Copies the binaries built to the destination directory.
    cp -r "${temporary_binaries_output_directory_path}" "${destination_binaries_directory_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying the built binaries to destination directory: ${cp_result}.";
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

    local create_destination_directory_result;
    local copy_system_files_result;
    local create_additional_directories_result;
    local define_file_locations_result;
    local create_temporary_directories_result;
    local build_binaries_result;
    local create_system_services_result;
    local install_system_variables_script;
    local remove_temporary_directories_result;
    

    # Creates the system's destination directory.
    create_destination_directory;
    create_destination_directory_result=${?};
    if [ ${create_destination_directory_result} -ne 0 ];
    then
        print_error_message "Error while creating system's destination directory.";
        return 1;
    fi;

    # Copies the system files to destination directory.
    copy_system_files;
    copy_system_files_result=${?};
    if [ ${copy_system_files_result} -ne 0 ];
    then
        print_error_message "Error while copying system files to destination directory.";
        return 1;
    fi;

    # Creates on destination directory the additional directories required for system execution.
    create_additional_directories;
    create_additional_directories_result=${?};
    if [ ${create_additional_directories_result} -ne 0 ];
    then
        print_error_message "Error creating additional directories on destination directory.";
        return 1;
    fi;

    # Defines the input, output and binary directories on destination directory.
    define_file_locations;
    define_file_locations_result=${?};
    if [ ${define_file_locations_result} -ne 0 ];
    then
        print_error_message "Error while defining directory files.";
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

    # Creates the system services.
    create_system_services;
    create_system_services_result=${?};
    if [ ${create_system_services_result} -ne 0 ];
    then
        print_error_message "Error while creating the system services.";
        return 1;
    fi;

    # Installs the script which defines the system variables.
    install_system_variables_script;
    install_system_variables_script_result=${?};
    if [ ${install_system_variables_script_result} -ne 0 ];
    then
        print_error_message "Error while installing system variables script.";
        return 1;
    fi;

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
