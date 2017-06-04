#!/bin/bash

# This script install all systemctl units required for project.
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
# Constants.
# ###

# Path to depoly unit files.
readonly unit_directory_path="/etc/systemd/system/";

# Preffix to show an erro message.
readonly error_preffix="[ERROR]:";


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

    local cp_result;
    local file_name;
    local installed_unit_file_path;
    local chmod_result;
    local systemctl_reload_result;
    local systemctl_enable_result;

        # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        >&2 echo "${error_preffix} Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        unit_file_path="$(dirname "${BASH_SOURCE}")/${1}";
        file_name=$(basename "${unit_file_path}");
    fi;

    # Checks if unit file path exists.
    if [ ! -f "${unit_file_path}" ];
    then
        >&2 echo "${error_preffix} Could not find unit file \"${unit_file_path}\".";
        return 1;
    fi;

    # Checks if current user has write permission on unit directory.
    if [ ! -w "${unit_directory_path}" ];
    then
        >&2 echo "${error_preffix} User \"$(whoami)\" does not have permission to write on directory \"${unit_directory_path}\".";
        return 1;
    fi;

    # Copies unit file to unit directory.
    cp "${unit_file_path}" "${unit_directory_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        >&2 echo "${error_preffix} Error while copying \"${unit_file_path}\" to \"${unit_directory_path}\".";
        >&2 echo "${error_preffix} Returned code from command: ${cp_result}";
        return 1;
    fi;

    installed_unit_file_path="${unit_directory_path}${file_name}";

    # Changes file permission
    chmod 644 "${installed_unit_file_path}";
    chmod_result=${?};
    if [ ${chmod_result} -ne 0 ];
    then
        >&2 echo "${error_preffix} Error while changing file permissions on \"${installed_unit_file_path}\".";
        >&2 echo "${error_preffix} Returned code from command: ${chmod_result}";
        return 1;
    fi;

    # Requests systemctl to update its list of units.
    systemctl daemon-reload;
    systemctl_reload_result=${?};
    if [ ${systemctl_reload_result} -ne 0 ];
    then
        >&2 echo "${error_preffix} Error while reloading list of units on systemctl.";
        >&2 echo "${error_preffix} Returned code from command: ${systemctl_reload_result}";
        return 1;
    fi;

    # Enables systemctl unit.
    systemctl enable ${file_name};
    systemctl_enable_result=${?};
    if [ ${systemctl_enable_result} -ne 0 ];
    then
        >&2 echo "${error_preffix} Error while enabling unit \"${unit_name}\".";
        >&2 echo "${error_preffix} Returned code from command: ${systemctl_enable_result}";
        return 1;
    fi;

    return 0;
}

# Requests a unit installation.
#
# Parameters:
#   1. The unit file path.
#
# Returns:
#   0 - If unit was installed successfully.
#   1 - Otherswise.
#
request_installation() {

    local unit_file_path;
    local unit_name;
    local install_unit_result;
    
    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        >&2 echo "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        unit_file_path="${1}";
        unit_name="$(basename ${unit_file_path})";
    fi;

    # Requests unit installation.
    install_unit "${unit_file_path}";
    install_unit_result=${?};
    if [ ${install_unit_result} -ne 0 ];
    then
        >&2 echo "Error while installing \"${unit_name}\" unit.";
        exit 1;
    else
        echo "Unit \"${unit_name}\" installed successfuly.";
        return 0;
    fi;
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

    request_installation "../units/bluetooth/var-run-sdp/unit_files/var-run-sdp.path";
    request_installation "../units/bluetooth/var-run-sdp/unit_files/var-run-sdp.service";
    request_installation "../units/bluetooth/pairing/unit_files/bluetooth-pairing.service";
}

install_units;