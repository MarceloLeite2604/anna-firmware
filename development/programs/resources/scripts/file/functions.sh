#!/bin/bash

# This script contains generic functions related to files and directories used
# by other scripts.
#
# Version: 0.1
# Author: Marcelo Leite

# Load generic functions script.
source "$(dirname ${BASH_SOURCE})/../generic/functions.sh";

# Load log functions.
source "$(dirname ${BASH_SOURCE})/../log/functions.sh";

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
        return ${generic_error};
    fi;

    local readonly file_path="$1";

    if [ ! -d "${file_path}" -a ! -f "${file_path}" -a ! -p "${file_path}" ];
    then
        log ${log_message_type_trace} "File \"${file_path}\" does not exist.";
        return ${generic_error};
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
        return ${generic_error};
    fi;

    local readonly file_path="$1";

    check_file_exists "${file_path}";
    if [ ${?} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    if [ ! -w "${file_path}" ];
    then
        log ${log_message_type_trace} "User \"$(whoami)\" does not have write permission on \"${file_path}\".";
        return ${generic_error};
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
        return ${generic_error};
    fi;

    local readonly file_path="$1";

    check_file_exists "${file_path}";
    if [ ${?} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    if [ ! -r "${file_path}" ];
    then
        log ${log_message_type_trace} "User \"$(whoami)\" does not have read permission on \"${file_path}\".";
        return ${generic_error};
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
        return ${generic_error};
    fi;

    local readonly file_path="$1";

    check_file_exists "${file_path}";
    if [ ${?} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    if [ ! -d "${file_path}" ];
    then
        log ${log_message_type_trace} "File \"${file_path}\" is not a directory.";
        return ${generic_error};
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
        return ${generic_error};
    fi;

    local readonly file_path="$1";

    check_file_exists "${file_path}";
    if [ ${?} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    if [ ! -p "${file_path}" ];
    then
        log ${log_message_type_trace} "File \"${file_path}\" is not a pipe.";
        return ${generic_error};
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
        return ${generic_error};
    fi;

    local readonly file="$1";

    check_file_exists "${file}";

    if [ ${?} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    check_file_is_directory "${file}";

    if [ ${?} -ne ${generic_error} ];
    then
        log ${log_message_type_error} "File \"${file}\" is a directory and can't be read.";
        return ${generic_error};
    fi;

    check_read_permission "${file}";

    if [ ${?} -ne ${success} ];
    then
        return ${generic_error};
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
        return ${generic_error};
    fi;

    local readonly file="${1}";

    local check_file_exists_result;
    check_file_exists "${file}";
    check_file_exists_result=${?};

    if [ ${check_file_exists_result} -eq ${success} ];
    then
        log ${log_message_type_trace} "File \"${file}\" already exists.";
        return ${generic_error};
    fi;

    local check_file_is_directory_result;
    local pipe_directory=$(dirname "${file}");
    check_file_is_directory ${pipe_directory};
    check_file_is_directory_result=${?};

    if [ ${check_file_is_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Directory \"${pipe_directory}\" to create pipe file does not exist.";
        return ${generic_error};
    fi;        

    local mkfifo_result;
    mkfifo "${file}";
    mkfifo_result=${?};

    if [ ${mkfifo_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error creating pipe file \"${file}\" (${mkfifo_result}).";
        return ${generic_error};
    fi;

    return ${success};
}
