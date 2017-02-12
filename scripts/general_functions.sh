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

    if [ ! -d "${file_path}" -a ! -f "${file_path}" -a ! -p "${file_path}" ];
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

# Check if a file is a directory.
#
# Parameters
#    1. File to be checked.
#
# Returns
#    0. If file is a directory.
#    1. Otherwise.
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

# Check if a file is a pipe.
#
# Parameters
#    1. File to be checked.
#
# Returns
#    0. If file is a pipe.
#    1. Otherwise.
check_file_is_pipe() {

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_failure};
    fi;

    local readonly file_path="$1";

    check_file_exists "${file_path}";
    if [ ${?} -ne ${success} ];
    then
        return ${general_failure};
    fi;

    if [ ! -p "${file_path}" ];
    then
        log ${log_message_type_trace} "File \"${file_path}\" is not a pipe.";
        return ${general_failure};
    fi;

    return ${success};
}

# Reads a file.
#
# Parameters
#    1. File to be read.
#
# Returns
#    0. If file was read correctly.
#    1. Otherwise
#    It also returns the file content through "echo".
read_file(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

    local readonly file="$1";

    check_file_exists "${file}";

    if [ $? -ne ${success} ];
    then
        return ${general_failure};
    fi;

    check_file_is_directory "${file}";

    if [ $? -ne ${general_failure} ];
    then
        log ${log_message_type_error} "File \"${file}\" is a directory and can't be read.";
        return ${general_failure};
    fi;

    check_read_permission "${file}";

    if [ $? -ne ${success} ];
    then
        return ${general_failure};
    fi;

    local readonly file_content=$(cat "${file}");

    echo "${file_content}";

    return ${success};
}

# Creates a pipe file.
#
# Parameters
#   1. Path to pipe file.
#
# Returns
#   0. If pipe was created successfully.
#   1. Otherwise.
create_pipe_file() {

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

    local readonly file="${1}";

    local check_file_exists_result;
    check_file_exists "${file}";
    check_file_exists_result=${?};

    if [ ${check_file_exists_result} -eq ${success} ];
    then
        log ${log_message_type_trace} "File \"${file}\" already exists.";
        return ${general_failure};
    fi;

    local check_file_is_directory_result;
    local pipe_directory=$(dirname "${file}");
    check_file_is_directory ${pipe_directory};
    check_file_is_directory_result=${?};

    if [ ${check_file_is_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Directory \"${pipe_directory}\" to create pipe file does not exist.";
        return ${general_failure};
    fi;        

    local mkfifo_result;
    mkfifo "${file}";
    mkfifo_result=${?};

    if [ ${mkfifo_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error creating pipe file \"${file}\" (${mkfifo_result}).";
        return ${general_error};
    fi;

    return ${success};
}

# Finds a program location.
#
# Parameters
#   1. Program to be searched.
#
# Returns
#   0. If the program was located.
#   1. Otherwise.
#   It also returns the program location through "echo".
find_program(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

    local program="${1}";

    local program_location;
    program_location=$(command -v "${program}");
    if [ ${?} -ne ${success} -o -z "${program_location}" ];
    then
        log ${log_message_type_trace} "Could not find program \"${program}\".";
        return  ${general_failure};
    fi;

    echo "${program_location}";

    return ${success};
}

# Starts a new process.
#
# Parameters
#   1. Command to start the new process.
#
# Returns
#   0. If process was started successfully.
#   1. Otherwise.
#   It also returns the new process id through "echo".
start_process(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

    local readonly new_process_command="${1}";
    local process_id;

    local eval_result;
    log ${log_message_type_trace} "Starting a new process with command \"${new_process_command}\".";

    eval "${new_process_command} &";
    eval_result=${?};
    if [ ${eval_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error starting the new process (${eval_result}).";
    fi;
    local new_process_id=${!};
    log ${log_message_type_trace} "New process id: ${new_process_id}";

    echo ${new_process_id};
}
