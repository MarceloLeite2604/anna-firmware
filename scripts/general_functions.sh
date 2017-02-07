#!/bin/bash

# This script contains general functions used by other scripts.
#
# Version: 0.1
# Author: Marcelo Leite

# Load configurations file.
source $(dirname ${BASH_SOURCE})/configuration.sh

# Load log functions.
source $(dirname ${BASH_SOURCE})/log_functions.sh

# Returns current time.
#
# Parameters
#   None
#
# Returns
#    The current time through "echo".
get_current_time(){

    if [ ${#} -ne 0 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_failure};
    fi;

    echo "$(date +"%Y/%m/%d %H:%M:%S")";
    return ${success};
}

# Return current time formatted as a string.
#
# Parameters:
#   None.
#
# Returns:
#   The current time formatted as a string through "echo".
get_current_time_formatted() {

    if [ ${#} -ne 0 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_failure};
    fi;

    echo "$(date +"%Y%m%d_%H%M%S")";
    return ${success};
};


# Check if a directory exists and current user has read and write permissions on it.
#
# Parameters
#    1. Directory to be checked.
#
# Returns
#   0. If directory exists and user has read and write permissions on it.
#   1. Otherwise.
check_directory_permissions(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[1]}\".";
        return ${general_failure};
    fi;

    local readonly directory_path="$1";

    if [ ! -d "${directory_path}" ];
    then
        log ${log_message_type_trace} "Path \"${directory_path}\" is invalid or is not a directory.";
        return ${general_failure};
    fi;

    if [ ! -r ${directory_path} ];
    then
        log ${log_message_type_trace} "User \"$(whoami)\" does not have read permission on directory \"${directory_path}\".";
        return ${general_failure};
    fi;

    if [ ! -w ${directory_path} ];
    then
        log ${log_message_type_trace} "User \"$(whoami)\" does not have write permission on directory \"${directory_path}\".";
        return ${general_failure};
    fi;

    return ${success};
}
