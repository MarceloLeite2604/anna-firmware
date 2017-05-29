#!/bin/bash

# This script contains functions specific to control process executions.
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
# Script sources.
# ###

# Loads process constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Loads log functions script.
source "$(dirname ${BASH_SOURCE})/../log/functions.sh";


# ###
# Functions elaboration.
# ###

# Checks if a process is alive.
#
# Parameters
#   1. The id of the process.
#
# Returns:
#   SUCCESS - If the process is alive.
#   GENERIC_ERROR - Otherwise.
#
check_process_is_alive(){

    local process_id;
    local process_count;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        process_id=${1};
    fi;

    # Checks if there is a process with id informed.
    process_count=$(ps -o pid= -p ${process_id} | wc -l);
    if [ ${process_count} -eq 0 ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Creates the process id file path.
#
# Parameters:
#   1. The preffix with identifies the process id file.
#
# Returns:
#   SUCCESS - If process id file path was created successfully.
#   GENERIC_ERROR - Otherwise
#   It also returns the process id file path through "echo".
#
create_process_id_file_path(){

    local process_id_file_preffix;
    local process_id_file_name;
    local check_file_is_directory_result;
    local process_id_file_path;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        process_id_file_preffix="${1}";
    fi;

    # Elaborates the process id file name.
    process_id_file_name="${process_id_file_preffix}${process_id_files_suffix}";

    # Checks if process id files directory exists.
    check_file_is_directory "${process_id_files_directory}";
    check_file_is_directory_result=${?};
    if [ ${check_file_is_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not find directory \"${process_id_files_directory}\".";
        return ${generic_error};
    fi;

    # Elaborates the process id file path.
    process_id_file_path="${process_id_files_directory}${process_id_file_name}";

    echo "${process_id_file_path}";

    return ${success};
}

# Saves a process id on a process id file.
#
# Parameters:
#   1. The process id file preffix.
#   2. The process id to be written on process id file.
#
# Returns:
#   SUCCESS - If the process id was successfully written on process_id file.
#   GENERIC_ERROR - Otherwise.
#
save_process_id() {

    local process_id_file_preffix;
    local process_id;
    local create_process_id_file_path_result;
    local check_write_permission_result;
    local check_file_exists_result;
    local process_id_on_pid_file;
    local check_process_is_alive_result;
    local echo_result;

    # Checks function parameters.
    if [ ${#} -ne 2 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        process_id_file_preffix="${1}";
        process_id=${2};
    fi;

    # Creates the process id file path.
    process_id_file_path=$(create_process_id_file_path "${process_id_file_preffix}");
    create_process_id_file_path_result=${?};
    if [ ${create_process_id_file_path_result} -ne ${success} -o -z "${process_id_file_path}" ];
    then
        log ${log_message_type_error} "Could not define the process id file path for \"${process_id_file_preffix}\" process.";
        return ${generic_error}
    fi;

    # Checks if user has permission to write on process if files directory.
    check_write_permission "${process_id_files_directory}";
    check_write_permission_result=${?};
    if [ ${check_write_permission_result} -ne ${success} ];
    then
        log ${log_message_type_error} "User \"$(whoami)\" cannot write on directory \"${process_id_files_directory}\".";
        return ${generic_error};
    fi;

    # Checks if process id already exists.
    check_file_exists "${process_id_file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -eq ${success} ];
    then
        log ${log_message_type_trace} "Process id file \"${process_id_file_path}\" already exists.";

        # Retireves process id on file.
        process_id_on_pid_file=$(cat ${process_id_file_path});
        if [ -z "${process_id_on_pid_file}" ];
        then
            log ${log_message_type_error} "Process id file exists, but it does not have a content.";
            return ${generic_error};
        fi;

        # Checks if process with id retrieved on process id file is still running.
        check_process_is_alive ${process_id_on_pid_file};
        check_process_is_alive_result=${?};
        if [ ${check_process_is_alive_result} -eq ${success} ];
        then
            log ${log_message_type_error} "Process id \"${process_id_on_pid_file}\" writen on file \"${process_id_file_path}\" is still running.";
            return ${generic_error};
        fi;
    fi;

    # Writes the process id on process id file.
    echo "${process_id}" > "${process_id_file_path}";
    echo_result=${?};
    if [ ${echo_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error writing process id on file \"${process_id_file_path}\".";
        return ${generic_error};
    fi;

    return ${success};
}

# Retrieves a process id from a process id file.
#
# Parameters:
#   1. The process identifier.
#
# Returns:
#   SUCCESS - If the process id was retrieved successfully.
#   GENERIC_ERROR - If there was an error while retrieving the process id.
#   It also returns the process id read from file through "echo".
#
retrieve_process_id(){

    local process_identifier;
    local check_file_is_directory_result;
    local check_read_permission_result;
    local process_id_file_path;
    local create_process_id_file_path_result;
    local check_file_exists_result;
    local process_id;
    local cat_result;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        process_identifier="${1}";
    fi;

    # Checks is process id files directory exists.
    check_file_is_directory "${process_id_files_directory}";
    check_file_is_directory_result=${?};
    if [ ${check_file_is_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not find directory \"${process_id_files_directory}\".";
        return ${generic_error};
    fi;

    # Checks if user has permission to read process id files directory content.
    check_read_permission "${process_id_files_directory}";
    check_read_permission_result=${?};
    if [ ${check_read_permission_result} -ne ${success} ];
    then
        log ${log_message_type_error} "User \"$(username)\" does not have permission to read content from directory \"${process_id_files_directory}\".";
        return ${generic_error};
    fi;

    # Creates the process id file path.
    process_id_file_path=$(create_process_id_file_path "${process_identifier}");
    create_process_id_file_path_result=${?};
    if [ ${create_process_id_file_path_result} -ne ${success} -o -z "${process_id_file_path}" ];
    then
        log ${log_message_type_error} "Error while creating process id file path for process \"${process_identifier}\".";
        return ${generic_error};
    fi;

    # Checks if process id file exists.
    check_file_exists "${process_id_file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not find process id file \"${process_id_file_path}\".";
        return ${generic_error};
    fi;

    # Checks if user has permission to read process id file.
    check_read_permission "${process_id_file_path}";
    check_read_permission_result=${?};
    if [ ${check_read_permission_result} -ne ${success} ];
    then
        log ${log_message_type_error} "User \"$(username)\" does not have permission to read content from process id file \"${process_id_file_path}\".";
        return ${generic_error};
    fi;

    # Retrieves the process id.
    process_id=$(cat "${process_id_file_path}");
    cat_result=${?};
    if [ ${cat_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error reading content from file \"${process_id_file_path}\" (${cat_result}).";
        return ${generic_error};
    fi;

    # Checks the process id file content.
    if [ -z "${process_id}" ];
    then
        log ${log_message_type_error} "Process id file \"${process_id_file_path}\" is empty.";
        return ${generic_error}
    fi;

    echo "${process_id}";
    return ${success};
}

# Starts a new process.
#
# Parameters:
#   1. Command to start the new process.
#   2. Preffix to identify the new process id file.
#   3. File input for the new process.
#   4. File output for the new process.
#   5. File error output for the new process.
#
# Returns:
#   SUCCESS - If process was started successfully.
#   GENERIC_ERROR - Otherwise.
#
# Observations:
#    If there is no need to redirect input, output and/or error messages from 
# the new process, just pass an empty string ("") to it. The function will 
# inform the same input and output files used by the current shell.
#
start_process(){

    local new_process_command;
    local process_id_file_preffix;
    local input_file;
    local output_file;
    local error_file;
    local create_process_id_file_path_result;
    local check_file_exists_result;
    local new_process_id;
    local new_process_result;
    local process_id_on_pid_file;
    local cat_result;
    local check_process_is_alive_result;
    local save_process_id_result;

    # Checks function parameters.
    if [ ${#} -ne 5 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        new_process_command="${1}";
        process_id_file_preffix="${2}";
        input_file="${3}";
        output_file="${4}";
        error_file="${5}";
    fi;

    # Creates the process id file path.
    process_id_file_path=$(create_process_id_file_path "${process_id_file_preffix}");
    create_process_id_file_path_result=${?};
    if [ ${create_process_id_file_path_result} -ne ${success} -o -z "${process_id_file_path}" ];
    then
        log ${log_message_type_error} "Could not define the process id file path for \"${process_id_file_preffix}\" process.";
        return ${generic_error}
    fi;

    # Checks if process id file exists.
    check_file_exists "${process_id_file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -eq ${success} ];
    then
        log ${log_message_type_trace} "Process id file \"${process_id_file_path}\" already exists.";

        # Retrieves process id on file.
        process_id_on_pid_file=$(cat ${process_id_file_path});
        cat_result=${?};
        if [ ${cat_result} -ne 0 ];
        then
            log ${log_message_type_error} "The process id file \"${process_id_file_path}\" exists, but it has no content.";
            return ${generic_error};
        fi;

        # Checks if process retrieved from process id file is still running.
        check_process_is_alive ${process_id_on_pid_file};
        check_process_is_alive_result=${?};
        if [ ${check_process_is_alive_result} -eq ${success} ];
        then
            log ${log_message_type_error} "Process id \"${process_id_on_pid_file}\" writen on file \"${process_id_file_path}\" is still running.";
            return ${generic_error};
        fi;
    fi;

    # Informs on log that the process is starting.
    log ${log_message_type_trace} "Starting a new process with command \"${new_process_command}\".";

    # Requests the process start depending on input, output and erro files informed.
    if [ -n "${input_file}" ];
    then

        if [ -n "${output_file}" ];
        then

            if [ -n "${error_file}" ];
            then
                ${new_process_command} <${input_file} 1>>${output_file} 2>>${error_file} &
                new_process_result=${?};
            else
                ${new_process_command} <${input_file} 1>>${output_file} &
                new_process_result=${?};
            fi;
        else
            if [ -n "${error_file}" ];
            then 
                ${new_process_command} <${input_file} 2>>${error_file} &
                new_process_result=${?};
            else
                ${new_process_command} <${input_file} &
                new_process_result=${?};
            fi;
        fi;
    else
        if [ -n "${output_file}" ];
        then
            if [ -n "${error_file}" ];
            then
                ${new_process_command} 1>>${output_file} 2>>${error_file} &
                new_process_result=${?};
            else
                ${new_process_command} 1>>${output_file} &
                new_process_result=${?};
            fi;
        else
            if [ -n "${error_file}" ];
            then
                ${new_process_command} 2>>${error_file} &
                new_process_result=${?};
            else
                ${new_process_command} &
                new_process_result=${?};
            fi;
        fi;
    fi;

    # Retireves the new process id.
    new_process_id=${!};

    # Deattach the new process from current shell running this function.
    disown ${!};

    # If the new process started successfully and its process id was retrieved successfully.
    if [ ${new_process_result} -ne ${success} -o -z "${new_process_result}" ];
    then
        log ${log_message_type_error} "Error starting the new process (${setsid_result}).";
    fi;

    # Saves the new process id on a process id file.
    save_process_id "${process_id_file_preffix}" "${new_process_id}";
    save_process_id_result=${?};
    if [ ${save_process_id_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error while storing the new process id on a process id file.";
        elog ${log_message_type_error} "Killing process ${new_process_id}."
        kill -SIGKILL ${new_process_id};
        return ${generic_error};
    fi;

    return ${success}; 
}

# Sends a signal to a process.
#
# Parameters:
#   1. The process id the send the signal.
#   2. The signal to send.
#
# Returns:
#   SUCCESS - If the signal was sent successfully.
#   GENERIC_ERROR - Otherwise.
#
send_signal_to_process(){

    local process_id;
    local signal;
    local check_process_is_alive_result;
    local kill_result;

    # Checks function parameters.
    if [ ${#} -ne 2 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        process_id=${1};
        signal="${2}";
    fi;

    # Checks the signal informed.
    if [ "${signal}" != "${process_kill_signal}" -a  "${signal}" != "${process_interrupt_signal}" -a "${signal}" != "${process_terminate_signal}" ];
    then
        log ${log_message_type_error} "Invalid signal value to send to process (\"${signal}\").";
        return ${generic_error};
    fi;

    # Checks if process informed is alive.
    check_process_is_alive ${process_id};
    check_process_is_alive_result=${?};
    if [ ${check_process_is_alive_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not find process \"${process_id}\".";
        return ${generic_error};
    fi;

    # Sends the signal to the process.
    kill -${signal} ${process_id};
    kill_result=${?};
    if [ ${kill_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error sending \"${signal}\" signal to process id \"${process_id}\" (${kill_result}).";
        return ${generic_error};
    fi;

    return ${success};
}

# Sends an interrupt signal to a process.
#
# Parameters:
#   1. The process id the send the interrupt signal.
#
# Returns:
#   SUCCESS - If the interrupt signal was sent successfully.
#   GENERIC_ERROR - Otherwise.
#
send_interrupt_signal(){

    local process_id;
    local send_signal_to_process_result;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        process_id=${1};
    fi;

    # Sends the interrupting signal to the process.
    send_signal_to_process ${process_id} "${process_interrupt_signal}";
    send_signal_to_process_result=${?};
    if [ ${send_signal_to_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not send interrupt signal to process ${process_id}.";
        return ${generic_error};
    fi;

    return ${success};
}


# Sends a kill signal to a process.
#
# Parameters:
#   1. The process id the send the kill signal.
#
# Returns:
#   SUCCESS - If the kill signal was sent successfully.
#   GENERIC_ERROR - Otherwise.
#
send_kill_signal(){

    local process_id;
    local send_signal_to_process_result;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        process_id=${1};
    fi;

    # Sends the killing signal to the process.
    send_signal_to_process ${process_id} "${process_kill_signal}";
    send_signal_to_process_result=${?};
    if [ ${send_signal_to_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not send kill signal to process ${process_id}.";
        return ${generic_error};
    fi;

    return ${success};
}

# Stops a process.
#
# Parameters
#   1. The process id to stop.
#
# Returns
#   SUCCESS - If process was stopped sucessfully.
#   GENERIC_ERROR - Otherwise
stop_process() {
    
    local process_id;
    local check_process_is_alive_result;
    local send_kill_signal_result;
    local process_terminated;
    local retries;
    local max_retries;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        process_id=${1};
    fi;

    # Checks if process informed is running.
    check_process_is_alive ${process_id};
    check_process_is_alive_result=${?};
    if [ ${check_process_is_alive_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Process ${process_id} does not exist.";
        return ${generic_error};
    fi;

    # Sends the killing signal to the process.
    send_kill_signal ${process_id};
    send_kill_signal_result=${?};
    if [ ${send_kill_signal_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error sending kill signal to process id ${process_id}.";
        return ${generic_error};
    fi;

    process_terminated="false";
    retries=0;
    max_retries=50;

    # Waits for the process to be terminated.
    while [ "${process_terminated}" == "false" -a ${retries} -lt ${max_retries} ];
    do
        sleep 0.1;

        # Checks if process is alive.
        check_process_is_alive ${process_id};
        check_process_is_alive_result=${?};
        if [ ${check_process_is_alive_result} -eq ${success} ];
        then
            retries=$((retries+1));
        else
            process_terminated="true";
        fi;
    done;

    # Checks if, after waiting for the process to be terminated, it is still alive.
    if [ ${process_terminated} == "false" ];
    then
        log ${log_message_type_error} "Process ${process_id} is still alive.";
        return ${generic_failure};
    fi;

    log ${log_message_type_trace} "Process ${process_id} interrupted.";
    return ${success};
}
