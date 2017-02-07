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

# Check if a file exists.
#
# Parameters
#    1. File to be checked.
#
# Returns
#    0. If file exists.
#    1. Otherwise
check_file_exists(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_failure};
    fi;

    local readonly file_path="$1";

    if [ ! -d "${file_path}" -a ! -f "${file_path}" ];
    then
        log ${log_message_type_trace} "File \"${file_path}\" does not exist.";
        return ${general_failure};
    fi;

    return ${success};
}

# Check if current user has write permission on a file.
#
# Parameters
#   1. File to be checked.
#
# Returns
#   0. If user has write permission on file.
#   1. Otherwise.
check_write_permission(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_failure};
    fi;

    local readonly file_path="$1";

    check_file_exists "${file_path}";
    if [ $? -ne ${success} ];
    then
        return ${general_failure};
    fi;

    if [ ! -w "${file_path}" ];
    then
        log ${log_message_type_trace} "User \"$(whoami)\" does not have write permission on \"${file_path}\".";
        return ${general_failure};
    fi;

    return ${success};
}

# Check if current user has read permission on a file.
#
# Parameters
#   1. File to be checked.
#
# Returns
#   0. If user has read permission on file.
#   1. Otherwise.
check_read_permission(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_failure};
    fi;

    local readonly file_path="$1";

    check_file_exists "${file_path}";
    if [ $? -ne ${success} ];
    then
        return ${general_failure};
    fi;

    if [ ! -r "${file_path}" ];
    then
        log ${log_message_type_trace} "User \"$(whoami)\" does not have read permission on \"${file_path}\".";
        return ${general_failure};
    fi;

    return ${success};
}

# Check if a file is a directory
#
# Parameters
#    1. File to be checked.
#
# Returns
#    0. If file is a directory.
#    1. Otherwise
check_file_is_directory(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_failure};
    fi;

    local readonly file_path="$1";

    check_file_exists "${file_path}";
    if [ $? -ne ${success} ];
    then
        return ${general_failure};
    fi;

    if [ ! -d "${file_path}" ];
    then
        log ${log_message_type_trace} "File \"${file_path}\" is not a directory.";
        return ${general_failure};
    fi;

    return ${success};
}
