#!/bin/bash

# This script contains generic functions related to files and directories used
# by other scripts.
#
# Parameters:
#   None.
#
# Returns:
#   None.
#
# Version: 
#   0.1
# Author:
#   Marcelo Leite
#

# ###
# Include guard.
# ###
if [ -z "${FILE_FUNCTIONS_SH}" ];
then
    FILE_FUNCTIONS_SH=1;
else
    return;
fi;


# ###
# Script sources.
# ###

# Load generic functions script.
source "$(dirname ${BASH_SOURCE})/../generic/functions.sh";

# Load log functions.
source "$(dirname ${BASH_SOURCE})/../log/functions.sh";


# ###
# Function elaborations.
# ###

# Checks if a file exists.
#
# Parameters:
#    1. File to be checked.
#
# Returns:
#    SUCCESS - If file exists.
#    GENERIC_ERROR - Otherwise.
#
check_file_exists(){

    local file_path;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        file_path="${1}";
    fi;

    # Checks if file informed exists (as a directory, file or pipe).
    if [ ! -d "${file_path}" -a ! -f "${file_path}" -a ! -p "${file_path}" ];
    then
        log ${log_message_type_trace} "File \"${file_path}\" does not exist.";
        return ${generic_error};
    fi;

    return ${success};
}

# Checks if current user has write permission on a file.
#
# Parameters:
#   1. File to be checked.
#
# Returns:
#   SUCCESS - If user has write permission on file.
#   GENERIC_ERROR - Otherwise.
#
check_write_permission(){

    local file_path;
    local check_file_exists_result;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        file_path="${1}";
    fi;

    # Check if specified file exists.
    check_file_exists "${file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    # Checks if user has write permission on specified file.
    if [ ! -w "${file_path}" ];
    then
        log ${log_message_type_trace} "User \"$(whoami)\" does not have write permission on \"${file_path}\".";
        return ${generic_error};
    fi;

    return ${success};
}

# Checks if current user has read permission on a file.
#
# Parameters:
#   1. File to be checked.
#
# Returns:
#   SUCCESS - If user has read permission on file.
#   GENERIC_ERROR - Otherwise.
#
check_read_permission(){

    local file_path;
    local check_file_exists_result;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        file_path="${1}";
    fi;

    # Checks if file exists.
    check_file_exists "${file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    # Checks if user has read permission on file.
    if [ ! -r "${file_path}" ];
    then
        log ${log_message_type_trace} "User \"$(whoami)\" does not have read permission on \"${file_path}\".";
        return ${generic_error};
    fi;

    return ${success};
}

# Checks if specified file is a directory.
#
# Parameters:
#    1. File to be checked.
#
# Returns:
#    SUCCESS - If file is a directory.
#    GENERIC_ERROR - Otherwise.
#
check_file_is_directory(){

    local file_path;
    local check_file_exists_result;

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        file_path="${1}";
    fi;

    # Checks if specified file exists.
    check_file_exists "${file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    # Checks if specified file is as directory.
    if [ ! -d "${file_path}" ];
    then
        log ${log_message_type_trace} "File \"${file_path}\" is not a directory.";
        return ${generic_error};
    fi;

    return ${success};
}

# Checks if specified file is a pipe.
#
# Parameters:
#    1. File to be checked.
#
# Returns:
#    SUCCESS - If file is a pipe.
#    GENERIC_ERROR - Otherwise.
#
check_file_is_pipe() {

    local file_path;
    local check_file_exists_result;

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        file_path="${1}";
    fi;

    # Checks if specified file exists.
    check_file_exists "${file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    # Checks if specified file is a pipe.
    if [ ! -p "${file_path}" ];
    then
        log ${log_message_type_trace} "File \"${file_path}\" is not a pipe.";
        return ${generic_error};
    fi;

    return ${success};
}

# Reads a file content.
#
# Parameters:
#    1. File to be read.
#
# Returns:
#    SUCCESS - If file was read correctly.
#    GENERIC_ERROR - Otherwise
#    It also returns the file content through "echo".
#
read_file(){

    local file_path;
    local check_file_exists_result;
    local check_file_is_directory_result;
    local check_read_permission_result;
    local file_content;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        file_path="${1}";
    fi;

    # Checks if file exists.
    check_file_exists "${file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    # Checks if file is not a directory
    check_file_is_directory "${file_path}";
    check_file_is_directory_result=${?};
    if [ ${check_file_is_directory_result} -ne ${generic_error} ];
    then
        log ${log_message_type_error} "File \"${file_path}\" is a directory and can't be read.";
        return ${generic_error};
    fi;

    # Checks if user has read permission on file.
    check_read_permission "${file_path}";
    check_read_permission_result=${?};
    if [ ${check_read_permission_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    # Read specified file content.
    file_content="$(cat "${file_path}")";

    echo "${file_content}";

    return ${success};
}

# Creates a pipe file.
#
# Parameters:
#   1. Path to pipe file.
#
# Returns:
#   SUCCESS - If pipe was created successfully.
#   GENERIC_ERROR - Otherwise.
create_pipe_file() {

    local file_path;
    local check_file_exists_result;
    local check_file_is_directory_result;
    local pipe_directory;
    local mkfifo_result;

    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        file_path="${1}";
    fi;

    # Checks if specified file does not exist.
    check_file_exists "${file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -eq ${success} ];
    then
        log ${log_message_type_trace} "File \"${file_path}\" already exists.";
        return ${generic_error};
    fi;

    # Retrives directory from specified file.
    pipe_directory="$(dirname "${file_path}")";

    # Checks if specified file's directory exists.
    check_file_is_directory ${pipe_directory};
    check_file_is_directory_result=${?};
    if [ ${check_file_is_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Directory \"${pipe_directory}\" to create pipe file does not exist.";
        return ${generic_error};
    fi;        

    # Creates the pipe file.
    mkfifo "${file_path}";
    mkfifo_result=${?};
    if [ ${mkfifo_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error creating pipe file \"${file_path}\" (${mkfifo_result}).";
        return ${generic_error};
    fi;

    return ${success};
}
