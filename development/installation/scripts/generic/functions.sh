#!/bin/bash

# This contains generic functions used throughout all the system installation process.
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
if [ -z "${INSTALLATION_GENERIC_FUNCTIONS_SH}" ]
then
    INSTALLATION_GENERIC_FUNCTIONS_SH=1;
else
    return;
fi;

# ###
# Script sources.
# ###

# Load generic constants.
source "$(dirname ${BASH_SOURCE})/constants.sh";


# ###
# Function elaborations.
# ###

# Checks if current user has the privilege to execute commands as a superuser.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If current user has the privilege to execute commands as a superuser.
#   1 - Otherwise.
#
check_user_has_superuser_privileges() {

    local user;
    
    # Retrieves the username.
    user=$(whoami);

    # If user is not root.
    if [ "${user}" != "root" ];
    then

        # If user does not have the privilege to execute commands as superuser.
        sudo_check_result=$(sudo -l -U $(whoami) | grep "not allowed" | wc -l);
        if [ ${sudo_check_result} -eq 1 ];
        then
            return 1;
        fi;
    fi;
    
    return 0;
}

# Executes a command as superuser (if needed).
#
# Parameters:
#   1. The command to execute.
#
# Returns:
#   1. If user does not have the privilege to execute the command as superuser.
#   If user have the privilege to execute the command as superuser, it will return the value received from the command result.
#
execute_command_as_superuser() {

    local command;
    local user;
    local command_result;
    
    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
      print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
      return 1;
    else
        command="sudo ${1}";
    fi;
    
    # Retrieves the username.
    user=$(whoami);
    
    if [ ${check_user_has_superuser_privileges_result} -ne 0 ];
    then
        print_error_message "User \"${user}\" does not have the privilege to execute a command as superuser.";
        return 1;
    fi;
    
    echo -e "The next command will be executed with superuser privileges. If prompted, please inform password for user \"$(whoami)\" or hit [CTRL+C] to abort installation.";
    ${command};
    command_result=${?};
    return ${command_result};
}

# Prints an error message.
#
# Parameters:
#   1. The error message to print.
#
# Returns:
#   The result of this method is always 0.
#
print_error_message() {

    local error_message;

    if [ ${#} -ge 1 ];
    then
        error_message="${1}";
        >&2 echo "${error_prefix} ${error_message}";
    fi;

    return 0;
}

