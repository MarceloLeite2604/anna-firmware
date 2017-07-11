#!/bin/bash

# This script install all systemd units required for project.
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
# Script sources.
# ###

# Load functions.
source "$(dirname ${BASH_SOURCE})/functions.sh";


# ###
# Function elaborations.
# ###

# Installs the systemctl unit requested.
#
# Parameters:
#   1. The unit file path.
#
# Returns:
#   0 - If unit was installed successfully.
#   1 - Otherwise.
#
install_unit() {

    local unit_file_path;
    local unit_file_name;
    local cp_result;
    local file_name;
    local installed_unit_file_path;
    local chmod_result;
    local systemctl_reload_result;
    local systemctl_enable_result;

    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        unit_file_path="${1}";
        unit_file_name=$(basename "${unit_file_path}");
    fi;

    # Checks if unit file path exists.
    if [ ! -f "${unit_file_path}" ];
    then
        print_error_message "Could not find unit file \"${unit_file_path}\".";
        return 1;
    fi;

    # Checks if current user has write permission on unit directory.
    if [ ! -w "${unit_directory_path}" ];
    then
        print_error_message "User \"$(whoami)\" does not have permission to write on directory \"${unit_directory_path}\".";
        return 1;
    fi;

    # Copies unit file to unit directory.
    cp "${unit_file_path}" "${unit_directory_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying \"${unit_file_path}\" to \"${unit_directory_path}\": ${cp_result}";
        return 1;
    fi;

    installed_unit_file_path="${unit_directory_path}${unit_file_name}";

    # Changes file permission
    chmod 644 "${installed_unit_file_path}";
    chmod_result=${?};
    if [ ${chmod_result} -ne 0 ];
    then
        print_error_message "Error while changing file permissions on \"${installed_unit_file_path}\": ${chmod_result}";
        return 1;
    fi;

    # Requests systemctl to update its list of units.
    systemctl daemon-reload;
    systemctl_reload_result=${?};
    if [ ${systemctl_reload_result} -ne 0 ];
    then
        print_error_message "Error while reloading list of units on systemctl: ${systemctl_reload_result}";
        return 1;
    fi;

    # Enables systemctl unit.
    systemctl enable ${unit_file_name};
    systemctl_enable_result=${?};
    if [ ${systemctl_enable_result} -ne 0 ];
    then
        print_error_message "Error while enabling unit \"${unit_name}\": ${systemctl_enable_result}.";
        return 1;
    fi;

    return 0;
}

# Creates the unit file from unit model file.
#
# Parameters:
#   1. The unit model file path.
#
# Returns:
#   0 - If unit file was created successfully.
#   1 - Otherwise.
#   It also returns the unit file path through "echo".
#
create_unit_file() {

    local unit_model_file_path;
    local system_installation_directory;
    local unit_file_name;
    local basename_result;
    local cp_result;
    local temporary_unit_file_path;
    local sed_result;

    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        unit_model_file_path="${1}";
        unit_file_name="$(basename ${unit_model_file_path})";
    fi;

    # Copies the unit model to a temporary directory.
    cp "${unit_model_file_path}" "${temporary_unit_files_directory_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying unit model file to temporary directory \"${temporary_unit_files_directory_path}\": ${cp_result}.";
        return 1;
    fi;

    temporary_unit_file_path="${temporary_unit_files_directory_path}${unit_file_name}";

    # On the "service scripts directory path" variable, precedes the forward slashes with backward slashed (escape character to "sed" command).
    replace_string="${service_scripts_directory_path//\//\\/}";

    # Replaces the "system service scripts directory" term by its value.
    sed -i -e "s/${service_scripts_directory_path_term}/${replace_string}/g" ${temporary_unit_file_path};
    sed_result=${?};
    if [ ${sed_result} -ne 0 ];
    then
        print_error_message "Error replacing terms on temporary unit file \"${temporary_unit_file_path}\": ${sed_result}.";
        return 1;
    fi;

    echo "${temporary_unit_file_path}";

    return 0;
}

# Requests a unit installation.
#
# Parameters:
#   1. The unit model file path.
#
# Returns:
#   0 - If unit was installed successfully.
#   1 - Otherswise.
#
request_installation() {

    local unit_model_file_path;
    local unit_model_file_name;
    local system_installation_directory;
    local temporary_unit_file_path;
    local create_unit_file_result;
    local install_unit_result;
    local rm_result;
    
    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        unit_model_file_path="${1}";
        unit_model_file_name="$(basename ${unit_model_file_path})";
    fi;

    # Creates unit file.
    temporary_unit_file_path="$(create_unit_file "${unit_model_file_path}")";
    create_unit_file_result=${?};
    if [ ${create_unit_file_result} -ne 0 ];
    then
        print_error_message "Error while creating unit file from unit model \"${unit_model_file_path}\".";
        return 1;
    fi;

    # Requests unit installation.
    install_unit "${temporary_unit_file_path}";
    install_unit_result=${?};
    if [ ${install_unit_result} -ne 0 ];
    then
        print_error_message "Error while installing \"${unit_model_file_name}\" unit.";
        return 1;
    fi;

    # Removes the temporary unit file.
    rm -f "${temporary_unit_file_path}";
    rm_result=${?};
    if [ ${rm_result} -ne 0 ];
    then
        print_error_message "Error while removing temporary unit file \"${temporary_unit_file_path}\".";
        return 1;
    fi;

    return 0; 
}

# Installs systemd unit files.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If unit files were installed successfully.
#   1 - Otherwise.
#
install_unit_files() {

    echo -e "Installing systemd unit files.";

    # Request the installtion of each unit model informed.
    for unit_model_file_path in ${unit_models_to_install[@]};
    do
        echo "Installing unit model \"$(basename ${unit_model_file_path})\".";

        request_installation "${unit_model_file_path}";
        request_installation_result=${?};
        if [ ${request_installation_result} -ne 0 ];
        then
            print_error_message "Error while installing unit model \"$(basename ${unit_model_file_path})\".";
            return 1;
        fi;
    done;

    return 0;
}

# Installs scripts executed by systemd units.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the scripts were installed successfully.
#   1 - Otherwise.
#
install_unit_scripts() {

    local mkdir_result;
    local cp_result;

    echo -e "Instaling scripts required for systemd units execution.";

    mkdir -p "${service_scripts_directory_path}";
    mkdir_result=${?};
    if [ ${mkdir_result} -ne 0 ];
    then
        print_error_message "Error while creating the directory to store system scripts \"${service_scripts_directory_path}\".";
        return 1;
    fi;

    for script_to_install in ${system_services_scripts[@]};
    do
        echo "Installing script \"$(basename ${script_to_install})\".";

        cp "${script_to_install}" "${service_scripts_directory_path}";
        cp_result=${?};
        if [ ${cp_result} -ne 0 ];
        then
            print_error_message "Error while copying script \"${script_to_install}\" to \"${service_scripts_directory_path}\".";
            return 1;
        fi;
    done;

    return 0;
}

# Installs all units required for project.
#
# Parameters:
#   None. 
#
# Returns:
#   0 - If units were installed successfully.
#   1 - Otherwise.
#
install_units() {

    local install_unit_scripts_result;
    local request_installation_result;

    # Installs the scripts required for systemctl unit executions.
    install_unit_scripts;
    install_unit_scripts_result=${?};
    if [ ${install_unit_scripts_result} -ne 0 ];
    then
        print_error_message "Error while installing scripts required to execute system services.";
        return 1;
    fi;


    # Installs unit files.
    install_unit_files;
    install_unit_files_result=${?};
    if [ ${install_unit_files_result} -ne 0 ];
    then
        print_error_message "Error while installing systemd units.";
        return 1;
    fi;

    return 0;
}

install_units ${#};
exit ${?};
