#!/bin/bash

# This script contains all functions and variables required to log and trace functions.
#
# Version: 0.1
# Author: Marcelo Leite

# Load generic constants script.
source "$(dirname ${BASH_SOURCE})/../generic/constants.sh";

# Load log constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Log directory.
_log_directory="${output_files_directory}logs/";

# Log file location.
_log_file_location="";

# Indicates if the log file creation was successful.
_log_file_creation_result=${not_executed};

# Indicates the log level.
_log_level=${log_message_type_warning};

# Returns the current time formatted.
#
# Parameters
#   None.
#
# Returns
#    The current time formatted through "echo".
_log_get_current_time(){
    echo "$(date +"%Y/%m/%d %H:%M:%S.%N" | awk '{print $1" "substr($2, 1, 12)}')";
    return ${success};
}

# Writes a message on "stderr".
#
# Parameters
#  1. Message to be written.
#
# Returns
#  Code returned from "echo" writing on "stderr".
_log_write_stderr(){

    for parameter in "$@"
    do
        local stderr_message=${stderr_message}${parameter}" ";
    done;

    local result=${success};
    if [ -n "${stderr_message}" ]; then
        $(>&2 echo ${stderr_message});
        local result=${?};
    fi;

    return ${result};
}

# Writes a message on a file.
#
# Parameters
#  1. File path to write the message.
#  2. Message to be written.
#
# Returns
#   0. If message was successfully written.
#   1. Otherwise.
_log_write_on_file(){

    if [ ${#} -ne 2 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Not enough parameters to execute \"${FUNCNAME[O]}\".";
        return ${generic_error};
    fi;

    local readonly file_path="$1";
    local readonly message="$2";

    # If the file does not exists.
    if [ ! -f ${file_path} ];
    then
        _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Could not find file \"${file_path}\".";
        return ${generic_error};
    fi;

    # Check if user was write permission on file.
    if [ ! -w ${file_path} ];
    then
        _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: User \"$(whoami)\" does not have write permission on  \"${file_path}\".";
        return ${generic_error};
    fi;

    # Write message on file.
    echo "${message}" >> ${file_path};
    local echo_result=${?};
    if [ ${echo_result} -ne 0 ];
    then
        _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Error writing message on \"${file_path}\" (${echo_result}).";
        return ${generic_error};
    fi; 
}


# Creates a log filename based on preffix informed and current time.
#
# Parameters
#	1. Log file preffix.
#
# Returns
#   0. If log filename was created sucessfully.
#   1. Otherwise
#
#	It also returns the log file name created trough "echo".
_log_create_log_file_name() {

    if [ ${#} -ne 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly log_file_preffix="$1";

    local readonly log_file_name="${log_file_preffix}_$(date +"%Y%m%d_%H%M%S").${_log_file_suffix}";

    echo "${log_file_name}";

    return ${success};
}

# Creates the log file based on a preffix informed.
#
# Parameters
#   1. Preffix to identify log file.	
#
# Returns
#	0. If log file was created.
#   1. Otherwise.
create_log_file() {

    if [ ${#} -ne 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        _log_file_location="";
        _log_file_creation_result=${generic_error};
        return ${generic_error};
    fi;

    local readonly log_file_preffix="$1";
    local readonly log_file_name=$(_log_create_log_file_name ${log_file_preffix});

    local readonly temporary_log_file_location=$(get_log_directory)${log_file_name};

    # If log file does not exist.
    if [ ! -f "${temporary_log_file_location}" ];
    then

        # If log directory does not exist.
        if [ ! -d "$(get_log_directory)" ];
        then
            _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Invalid log directory \"$(get_log_directory)\".";
            _log_file_location="";
            _log_file_creation_result=${generic_error};
            return ${generic_error};
        fi;

        # If user does not have write permission on log directory.
        if [ ! -w "$(get_log_directory)" ];
        then
            _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: User \"$(whoami)\" does not have write permission on directory. \"${_log_directory}\".";
            _log_file_location="";
            _log_file_creation_result=${generic_error};
            return ${generic_error};
        fi;

        # Creates the log file.
        touch ${temporary_log_file_location};

        # If, after creation, the file is still missing.
        if [ ! -f "${temporary_log_file_location}" ];
        then
            _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Could not create file \"${temporary_log_file_location}\".";
            _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Log messages will be redirected to \"stderr\".";
            _log_file_location="";
            _log_file_creation_result=${generic_error};
            return ${generic_error};
        fi;
    fi;

    # If user does not have write permission on log file.
    if [ ! -w "${temporary_log_file_location}" ];
    then
        _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: User \"$(whoami)\" does not have write access on \"${temporary_log_file_location}.";
        _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Log messages will be redirected to \"stderr\".";
        _log_file_location="";
        _log_file_creation_result=${generic_error};
    fi;

    _log_file_location=${temporary_log_file_location};
    _log_file_creation_result=${success};

    # Stores the log file path.
    _log_store_log_file_path;

    # Stores the log level.
    _log_store_log_level;

    _log_write_on_file ${_log_file_location} "[$(_log_get_current_time)] Log started.";
    return ${success};

}

# Finishes log file.
#
# Parameters
#  None.
#
# Returns
#   0. If log was finished successfully.
#   1. Otherwise.
finish_log_file(){

    local delete_log_file_path_result;
    local delete_log_level_result;
    local write_on_file_result;

    if [ ${#} -ne 0 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;
    if [ -z "${_log_file_location}" -o ${_log_file_creation_result} -ne ${success} ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: No log file to finish.";
        return ${generic_error};
    fi;
    local readonly finish_message="[$(_log_get_current_time)] Log finished.";

    _log_write_on_file ${_log_file_location} "${finish_message}";
    write_on_file_result=${?}

    if [ ${write_on_file_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    unset _log_file_location;
    _log_file_creation_result=${not_executed};

    # Deletes the log path file.
    _log_delete_log_path_file;
    delete_log_file_path_result=${?};
    if [ ${delete_log_file_path_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    # Deletes the log level file.
    _log_delete_log_level_file;
    delete_log_level_file_result=${?}
    if [ ${delete_log_level_file_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Writes a message on log file.
#
# Parameters
#   1. Message to be written.
#
# Returns
#   0. If message was correctly written.
#   1. Otherwise.
_log_write_log_message() {
    if [ ${#} -ne 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly message_content="[$(_log_get_current_time)] $1";
    local write_on_stderr="false";

    # If log file location is not specified.
    if [ -z ${_log_file_location} ];
    then
        write_on_stderr="true";
    fi;

    if [ "${write_on_stderr}" == "true" ];
    then
        _log_write_stderr ${message_content};
    else
        # Print message on log file.    
        echo "${message_content}" >> ${_log_file_location};
    fi;
}

# Log a message.
#
# Parameters
#   1. Message type (trace, info, warning, error).
#   2. Message content. (optional for trace messages, mandatory for other message types).
#
# Returns
#   0. If message was successfully logged.
#   1. Otherwise.
log() {
    local result;

    # Check function parameters.
    if [ ${#} -lt 1 -o ${#} -gt 2 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly message_type=$1;
    local readonly message_content="$2";

    case ${message_type} in
        ${log_message_type_trace})
            local readonly preffix=${_log_trace_message_preffix};
            ;;
        ${log_message_type_warning})
            local readonly preffix=${_log_warning_message_preffix};
            ;;
        ${log_message_type_error})
            local readonly preffix=${_log_error_message_preffix};
            ;;
        *)
            _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid log message type (${message_type}).";
            return ${generic_error};
            ;;
    esac;

    if [ "${FUNCNAME[1]}" == "${_log_trace_function_name}" ];
    then
        local readonly message_tag=${FUNCNAME[2]};
        local readonly message_index=${BASH_LINENO[1]};
    else
        local readonly message_tag="${FUNCNAME[1]}";
        local readonly message_index=${BASH_LINENO[0]};
    fi;

    if [ ${message_type} -ne ${log_message_type_trace} -a -z "${message_content}" ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Only trace log messages are allowed to be written without content.";
        return ${generic_error};
    fi;

    # If message level is lower than current log level.
    if [ ${message_type} -lt ${_log_level} ];
    then
        # Then the message should not be logged.
        return ${success};
    fi;

    local log_message="${preffix}: ${message_tag} (${message_index})";

    if [ -n "${message_content}" ];
    then
        local log_message=${log_message}": ${message_content}";
    fi;

    _log_write_log_message "${log_message}";

    result=${?};
    return ${result};
}

# This function register a trace point on log file.
#
# Parameters
#   1. Message (optional). 
#
# Returns
#   0. If trace was logged correctly.
#   1. Otherwise.
trace(){

    if [ ${#} -gt 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    if [ ${#} -eq 1 ];
    then
        local readonly trace_message="$1";
    fi;

    log ${log_message_type_trace} "${trace_message}";

    return ${?};
}

# Set the log level.
#
# Parameters
#   1. The log level to be defined.
#
# Returns
#   0. If log level was defined correctly.
#   1. Otherwise.
#
# Observation
#   To define correctly the log level, use the constants defines on
# "log_constants.sh".
set_log_level(){

    local readonly numeric_regex="^[0-9]+$";

    if [ ${#} -ne 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly temporary_log_level=$1;

    if ! [[ ${temporary_log_level} =~ ${numeric_regex} ]];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid log level value (${temporary_log_level}).";
        return ${generic_error};
    fi;

    if [ ${temporary_log_level} -ne ${log_message_type_trace} -a ${temporary_log_level} -ne ${log_message_type_warning} -a ${temporary_log_level} -ne ${log_message_type_error} ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid log level value (${temporary_log_level}).";
        return ${generic_error};
    fi;

    _log_level=${temporary_log_level};

    # Stores the log level.
    _log_store_log_level;

    return ${success};
}

# Returns the log level.
#
# Parameters
#   None.
#
# Returns
#    The current log level through echo.
get_log_level(){
    echo "${_log_level}";
    return ${success};
}

# Set the directory to write log files.
#
# Parameters
#   1. Relative or complete path to directory to store log files.
#
# Returns
#   0. If log directory was updated correctly.
#  -1. Otherwise.
#
# Observations
#   If the directory does not exists, this function willi not create it. 
# It will return and error and log directory will not be updated.
set_log_directory(){

    if [ ${#} -ne 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    local readonly temporary_log_directory="$1";

    if [ ! -d "${temporary_log_directory}" ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Unknown or invalid directory \"${temporary_log_directory}\".";
        return ${generic_error};
    fi;

    if [ ! -w "${temporary_log_directory}" ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: User \"$(whoami)\" does not have write permission on directory \"${temporary_log_directory}\".";
        return ${generic_error};
    fi;

    _log_directory=${temporary_log_directory};
    return ${success};
}

# Returns the log directory.
#
# Parametes
#    None.
#
# Returns
#    The current log directory through echo.
get_log_directory(){
    echo ${_log_directory};
    return ${success};
}

# Return the path to the log file.
#
# Parameters
#   None.
#
# Returns
#    The path to the current log file through echo.
get_log_path(){
    echo "${_log_file_location}";
    return ${success};
}

# Stores the log file path on "log path" file.
#
# Parameters
#   None.
#
# Returns
#  0. If log file path was stored successfully.
#  1. Otherwise.
_log_store_log_file_path() {
    local result;
    local echo_result;

    echo -e "${_log_file_location}" > ${_log_path_file_path};
    echo_result=${?};

    if [ ${echo_result} -eq ${success} ];
    then
        result=${success};
    else
        result=${generic_error};
    fi;

    return ${result};
}

# Retrieves the log file path from "log path" file.
#
# Parameters
#   None.
#
# Returns
#  0. If log file path was retrieved successfully.
#  1. Otherwise.
#  
# Obvervations
#  When retrieved, the log file path will be stored on "_log_file_location" variable.
_log_retrieve_log_file_path() {
    local result;
    local is_log_path_file_defined_result;
    local temporary_log_file_path;

    # Check if "log path" file is defined.
    _log_is_log_path_file_defined;
    is_log_path_file_defined_result=${?};
    if [ ${is_log_path_file_defined_result} -eq ${success} ];
    then

        # Retrieves log path from "log path" file.
        temporary_log_file_path=$(cat "${_log_path_file_path}");
        cat_result=${?};
        if [ ${cat_result} -eq ${success} ];
        then
            # Define the log file path.
            _log_file_location="${temporary_log_file_path}";
            result=${success};
        else
            result=${generic_error};
        fi;
    else
        result=${generic_error};
    fi;

    return ${result};
}

# Deletes the "log path" file.
#
# Parameters
#   None.
#
# Returns
#   0. If "log path" file was deleted successfully.
#   1. Otherwise.
_log_delete_log_path_file() {
    local result;
    local rm_result;

    # Checks if "log path" file exists.
    if [ -f "${_log_path_file_path}"  ];
    then

        # Deletes "log path" file.
        rm "${_log_path_file_path}";
        rm_result=${?};
        if [ ${rm_result} -eq ${success} ];
        then
            result=${success};
        else
            result=${generic_error};
        fi;
    fi;

    return ${result};
}

# Checks if "log path" file is defined.
#
# Parameters
#   None.
#
# Returns
#   0. If "log path" is defined.
#   1. If "log path" is not defined.
#   2. If there was an error.
_log_is_log_path_file_defined() {
    local result;
    local log_path_file_defined;

    # Checks if "log path" file exists.
    if [ -f "${_log_path_file_path}" ];
    then
        # Check if "log path" file has content.
        log_path_file_defined=$(cat ${_log_path_file_path} | wc -l);
        if [ ${log_path_file_defined} -eq 1 ];
        then
            result=${success};
        else
            result=${generic_error};
        fi;
    else
        result=${generic_error};
    fi; 

    return ${result};
}

# Stores the log level on "log level" file.
#
# Parameters
#   None.
#
# Returns
#  0. If log level was stored successfully.
#  1. Otherwise.
_log_store_log_level() {
    local result;
    local echo_result;

    echo -e "${_log_level}" > ${_log_level_file_path};
    echo_result=${?};

    if [ ${echo_result} -eq ${success} ];
    then
        result=${success};
    else
        result=${failure};
    fi;

    return ${result};
}

# Retrieves the log level from "log level" file.
#
# Parameters
#   None.
#
# Returns
#  0. If log level was retrieved successfully.
#  1. Otherwise.
#  
# Obvervations
#  When retrieved, the log level will be stored on "_log_level" variable.
_log_retrieve_log_level() {
    local result=${success};
    local is_log_level_file_defined_result;
    local temporary_log_level;

    # Check if "log level" file is defined.
    _log_is_log_level_file_defined;
    is_log_level_file_defined_result=${?};
    if [ ${is_log_level_file_defined_result} -eq ${success} ];
    then

        # Retrieves log level from "log level" file.
        temporary_log_level=$(cat "${_log_level_file_path}");
        cat_result=${?};
        if [ ${cat_result} -eq ${success} ];
        then
            # Define the log file path.
            _log_level="${temporary_log_level}";
            result=${success};
        else
            result=${generic_error};
        fi;
    else
        result=${generic_error};
    fi;

    return ${result};
}

# Deletes the "log level" file.
#
# Parameters
#   None.
#
# Returns
#   0. If "log level" file was deleted successfully.
#   1. Otherwise.
_log_delete_log_level_file() {
    local result;
    local rm_result;

    # Checks if "log level" file exists.
    if [ -f "${_log_level_file_path}" ];
    then

        # Deletes "log level" file.
        rm "${_log_level_file_path}";
        rm_result=${?};
        if [ ${rm_result} -eq ${success} ];
        then
            result=${success};
        else
            result=${generic_error};
        fi;
    fi;

    return ${result};
}

# Checks if "log level" file is defined.
#
# Parameters
#   None.
#
# Returns
#   0. If "log level" is defined.
#   1. If "log level" is not defined.
#   2. If there was an error.
_log_is_log_level_file_defined() {
    local result;
    local log_level_file_defined;

    # Checks if "log level" file exists.
    if [ -f "${_log_level_file_path}" ];
    then
        # Check if "log path" file has content.
        log_level_file_defined=$(cat ${_log_level_file_path} | wc -l);
        if [ ${log_level_file_defined} -eq 1 ];
        then
            result=${success};
        else
            result=${generic_error};
        fi;
    else
        result=${generic_error};
    fi; 

    return ${result};
}

# Checks if a log is already defined.
#
# Parameters
#  None.
#
# Returns
#  0. If a log is already defined.
#  1. Otherwise.
is_log_defined(){
    local result;
    local is_log_path_file_defined_result;

    # Checks if "log path" is defined.
    _log_is_log_path_file_defined;
    is_log_path_file_defined_result=${?};
    if [ ${is_log_path_file_defined_result} -eq ${success} ];
    then
        result=${success};
    else
        result=${generic_error};
    fi;

    return ${result};
}

# Continues a log file that is already defined.
#
# Parameters
#   None.
#
# Returns
#   0. If log file was continued successfully.
#   1. Otherwise.
continue_log_file(){
    local result;
    local is_log_defined_result;
    local retrieve_log_file_path_result;
    local retrieve_log_level_result;

    # Checks if log file is defined.
    is_log_defined;
    is_log_defined_result=${?};
    if [ ${is_log_defined_result} -eq ${success} ];
    then

        # Retrieves log file path.
        _log_retrieve_log_file_path;
        retrieve_log_file_path_result=${?};
        if [ ${retrieve_log_file_path_result} -eq ${success} ];
        then
            
            # Retrieves log level.
            _log_retrieve_log_level;
            retrieve_log_level_result=${?};

            # If could not retrieve log level.
            if [ ${retrieve_log_level_result} -ne ${success} ];
            then

                # Set log level to "trace".
                set_log_level ${log_message_type_trace};
            fi;

            result=${success};
        fi;
    else
        result=${generic_error};
    fi;

    _log_file_creation_result=${result};

    return ${result};
}
