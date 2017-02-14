#!/bin/bash

# This script contains generic functions related with processes.
#
# Version: 0.1
# Author: Marcelo Leite

# Load process constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load log functions script.
source "$(dirname ${BASH_SOURCE})/../log/functions.sh";

# Checks if a process is alive.
#
# Parameters
#   1. The id of the process.
#
# Returns
#   0. If the process is alive.
#   1. Otherwise.
check_process_is_alive(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly process_id=${1};

    local process_count;
    process_count=$(ps -o pid= -p ${process_id} | wc -l);

    if [ ${process_count} -eq 0 ];
    then
        return ${generic_error};
    fi;

    return ${success};


}

# Creates the process id file path.
#
# Parameters.
#   1. The preffix with identifies the process id file.
#
# Returns
#   0. If process id file path was created successfully.
#   1. Otherwise
#   It also returns the process id file path through "echo".
create_process_id_file_path(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local process_id_file_preffix="${1}";

    local process_id_file_name=${process_id_file_preffix}${process_id_files_suffix};

    local check_file_is_directory_result;
    check_file_is_directory "${process_id_files_directory}";
    check_file_is_directory_result=${?};
    if [ ${check_file_is_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not find directory \"${process_id_files_directory}\".";
        return ${generic_error};
    fi;

    local readonly process_id_file_path="${process_id_files_directory}${process_id_file_name}";

    echo "${process_id_file_path}";

    return ${success};
}

# Saves a process id on a process id file.
#
# Parameters
#   1. The process id file preffix.
#   2. The process id to be written on process_id file.
#
# Returns
#   0. If the process id was successfully written on process_id file.
#   1. Otherwise.
save_process_id() {

    if [ ${#} -ne 2 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly process_id_file_preffix="${1}";
    local readonly process_id=${2};

    local create_process_id_file_path_result;
    process_id_file_path=$(create_process_id_file_path "${process_id_file_preffix}");
    create_process_id_file_path_result=${?};
    if [ ${create_process_id_file_path_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    if [ -z "${process_id_file_path}" ];
    then
        log ${log_message_type_error} "Could not define the process id file path for \"${process_id_file_preffix}\" process.";
        return ${generic_error}
    fi;

    local check_write_permission_result;
    check_write_permission "${process_id_files_directory}";
    check_write_permission_result=${?};
    if [ ${check_write_permission_result} -ne ${success} ];
    then
        log ${log_message_type_error} "User \"$(whoami)\" cannot write on directory \"${process_id_files_directory}\".";
        return ${generic_error};
    fi;

    local check_file_exists_result;
    check_file_exists "${process_id_file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -eq ${success} ];
    then
        log ${log_message_type_trace} "Process id file \"${process_id_file_path}\" already exists.";

        local process_id_on_pid_file=$(cat ${process_id_file_path});

        local check_process_is_alive_result;
        check_process_is_alive ${process_id_on_pid_file};
        check_process_is_alive_result=${?};
        if [ ${check_process_is_alive_result} -eq ${success} ];
        then
            log ${log_message_type_error} "Process id \"${process_id_on_pid_file}\" writen on file \"${process_id_file_path}\" is still running.";
            return ${generic_error};
        fi;
    fi;

    local echo_result;
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
# Parameters
#   1. The process identifier
#
# Returns
#   0. If the process id was retrieved successfully.
#   1. If there was an error while retrieving the process id.
#   It also returns the process id read from file through "echo".
retrieve_process_id(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly process_identifier="${1}";

    local check_file_is_directory_result;
    check_file_is_directory "${process_id_files_directory}";
    check_file_is_directory_result=${?};
    if [ ${check_file_is_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not find directory \"${process_id_files_directory}\".";
        return ${generic_error};
    fi;

    local check_read_permission_result;
    check_read_permission "${process_id_files_directory}";
    check_read_permission_result=${?};
    if [ ${check_read_permission_result} -ne ${success} ];
    then
        log ${log_message_type_error} "User \"$(username)\" does not have permission to read content from directory \"${process_id_files_directory}\".";
        return ${generic_error};
    fi;
        
    local readonly process_id_file_path=$(create_process_id_file_path "${process_identifier}");

    local check_file_exists_result;
    check_file_exists "${process_id_file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not find process id file \"${process_id_file_path}\".";
        return ${generic_error};
    fi;

    check_read_permission "${process_id_file_path}";
    check_read_permission_result=${?};
    if [ ${check_read_permission_result} -ne ${success} ];
    then
        log ${log_message_type_error} "User \"$(username)\" does not have permission to read content from process id file \"${process_id_file_path}\".";
        return ${generic_error};
    fi;

    local process_id;
    local cat_result;
    process_id=$(cat "${process_id_file_path}");
    cat_result=${?};
    if [ ${cat_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error reading content from file \"${process_id_file_path}\" (${cat_result}).";
        return ${generic_error};
    fi;

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
# Parameters
#   1. Command to start the new process.
#   2. Preffix to identify the new process id file.
#   3. File input for the new process.
#   4. File output for the new process.
#   5. File error output for the new process.
#
# Returns
#   0. If process was started successfully.
#   1. Otherwise.
#
# Observations
#    If there is no need to redirect input, output and/or error messages from 
# the new process, just pass an empty string ("") to it. The function will 
# inform the same input and output files used by the current shell.
start_process(){

    if [ ${#} -ne 5 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly new_process_command="${1}";
    local readonly process_id_file_preffix="${2}";
    local readonly input_file="${3}";
    local readonly output_file="${4}";
    local readonly error_file="${5}";

    local create_process_id_file_path_result;
    process_id_file_path=$(create_process_id_file_path "${process_id_file_preffix}");
    create_process_id_file_path_result=${?};
    if [ ${create_process_id_file_path_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    if [ -z "${process_id_file_path}" ];
    then
        log ${log_message_type_error} "Could not define the process id file path for \"${process_id_file_preffix}\" process.";
        return ${generic_error}
    fi;
    

    local check_file_exists_result;
    check_file_exists "${process_id_file_path}";
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -eq ${success} ];
    then
        log ${log_message_type_trace} "Process id file \"${process_id_file_path}\" already exists.";

        local process_id_on_pid_file=$(cat ${process_id_file_path});

        local check_process_is_alive_result;
        check_process_is_alive ${process_id_on_pid_file};
        check_process_is_alive_result=${?};
        if [ ${check_process_is_alive_result} -eq ${success} ];
        then
            log ${log_message_type_error} "Process id \"${process_id_on_pid_file}\" writen on file \"${process_id_file_path}\" is still running.";
            return ${generic_error};
        fi;
    fi;

    local new_process_id;
    local new_process_result;
    log ${log_message_type_trace} "Starting a new process with command \"${new_process_command}\".";

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

    new_process_id=${!};

    disown ${!};

    if [ ${new_process_result} -ne ${success} -o -z "${new_process_result}" ];
    then
        log ${log_message_type_error} "Error starting the new process (${setsid_result}).";
    fi;

    local save_process_id_result;
    save_process_id "${process_id_file_preffix}" "${new_process_id}";
    save_process_id_result=${?};
    if [ ${save_process_id_result} -ne ${success} ];
    then
        echo "Killing process ${new_process_id}."
        kill -SIGKILL ${new_process_id};
        return ${generic_error};
    fi;

    return ${success}; 
}

# Send a signal to a process.
#
# Parameters
#   1. The process id the send the signal.
#   2. The signal to send.
#
# Returns
#   0. If the signal was sent successfully.
#   1. Otherwise.
send_signal_to_process(){

    if [ ${#} -ne 2 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly process_id=${1};
    local readonly signal="${2}";

    if [ "${signal}" != "${process_kill_signal}" -a  "${signal}" != "${process_interrupt_signal}" -a "${signal}" != "${process_terminate_signal}" ];
    then
        log ${log_message_type_error} "Invalid signal value to send to process (\"${signal}\").";
        return ${generic_error};
    fi;

    local check_process_is_alive_result;
    check_process_is_alive ${process_id};
    check_process_is_alive_result=${?};
    if [ ${check_process_is_alive_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not find process \"${process_id}\".";
        return ${generic_error};
    fi;

    local kill_result;
    kill -${signal} ${process_id};
    kill_result=${?};
    if [ ${kill_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error sending \"${signal}\" signal to process id \"${process_id}\" (${kill_result}).";
        return ${generic_error};
    fi;

    return ${success};
}

# Send an interrupt signal to a process.
#
# Parameters
#   1. The process id the send the interrupt signal.
#
# Returns
#   0. If the interrupt signal was sent successfully.
#   1. Otherwise.
send_interrupt_signal(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly process_id=${1};

    local send_signal_to_process_result;
    send_signal_to_process ${process_id} "${process_interrupt_signal}";
    send_signal_to_process_result=${?};
    if [ ${send_signal_to_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not send interrupt signal to process ${process_id}.";
        return ${generic_error};
    fi;

    return ${success};
}


# Send an kill signal to a process.
#
# Parameters
#   1. The process id the send the kill signal.
#
# Returns
#   0. If the kill signal was sent successfully.
#   1. Otherwise.
send_kill_signal(){

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly process_id=${1};

    local send_signal_to_process_result;
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
#   0. If process was stopped sucessfully.
#   1. Otherwise
stop_process() {

    if [ ${#} -ne 1 ];
    then
        log ${log_message_type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly process_id=${1};

    local check_process_is_alive_result;
    check_process_is_alive ${process_id};
    check_process_is_alive_result=${?};
    if [ ${check_process_is_alive_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Process ${process_id} does not exist.";
        return ${generic_error};
    fi;

    local send_kill_signal_result;
    send_kill_signal ${process_id};
    send_kill_signal_result=${?};
    if [ ${send_kill_signal_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error sending kill signal to process id ${process_id}.";
        return ${generic_error};
    fi;

    local process_terminated="false";
    local retries=0;
    local max_retries=50;
    while [ "${process_terminated}" == "false" -a ${retries} -lt ${max_retries} ];
    do
        sleep 0.1;

        check_process_is_alive ${process_id};
        check_process_is_alive_result=${?};
        if [ ${check_process_is_alive_result} -eq ${success} ];
        then
            retries=$((retries+1));
        else
            process_terminated="true";
        fi;
    done;

    if [ ${process_terminated} = "false" ];
    then
        log ${log_message_type_error} "Process ${process_id} is still alive.";
        return ${generic_failure};
    fi;

    log ${log_message_type_trace} "Process ${process_id} interrupted.";
    return ${success};
}
