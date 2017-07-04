#!/bin/bash

# This script contains all functions and variables required to elaborate and 
# store log messages.
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
if [ -z "${LOG_FUNCTIONS_SH}" ];
then
    LOG_FUNCTIONS_SH=1;
else
    return;
fi;


# ###
# Script sources.
# ###

# Load generic constants script.
source "$(dirname ${BASH_SOURCE})/../generic/constants.sh";

# Load log constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";


# ###
# Variables.
# ###

# Current log directory.
_log_directory="${output_files_directory}logs/";

# Current log file location.
_log_file_location="";

# Indicates if the log file creation was done successfully.
_log_file_creation_result=${not_executed};

# Indicates the log level.
_log_level=${log_message_type_warning};


# ###
# Functions elaboration.
# ###

# Returns the current time formatted as a readable format.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If time was retrieved successfully.
#   GENERIC_ERROR - Otherwise.
#   It also returns the current time in a readable format through "echo".
#
_log_get_current_time(){
    echo "$(date +"%Y/%m/%d %H:%M:%S.%N" | awk '{print $1" "substr($2, 1, 12)}')";
    return ${success};
}

# Writes a message on "stderr".
#
# Parameters:
#   1. Message to be written.
#
# Returns:
#   SUCCESS - If message was successfully written on stderr.
#   GENERIC_ERROR - Otherwise.
#
_log_write_stderr(){

    local message;
    local echo_result;

    # Checks function parameters.
    #for parameter in "$@"
    #do
    #    local stderr_message=${stderr_message}${parameter}" ";
    #done;
    if [ ${#} -ne 1 ];
    then
        return ${generic_error};
    else
        message="${1}";
    fi;

    # Writes message on stderr.
    $(>&2 echo ${stderr_message});
    echo_result=${?};
    if [ ${echo_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Writes a message on a file.
#
# Parameters:
#   1. Path to file which the message will be written.
#   2. Message to be written.
#
# Returns:
#   SUCCESS - If message was successfully written.
#   GENERIC_ERROR - Otherwise.
#
_log_write_on_file(){

    local file_path;
    local message;
    local echo_result;

    # Checks function parameters.
    if [ ${#} -ne 2 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Not enough parameters to execute \"${FUNCNAME[O]}\".";
        return ${generic_error};
    else
        file_path="${1}";
        message="${2}";
    fi;

    # Checks if file exists.
    if [ ! -f "${file_path}" ];
    then
        _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Could not find file \"${file_path}\".";
        return ${generic_error};
    fi;

    # Checks if user has write permission on file.
    if [ ! -w "${file_path}" ];
    then
        _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: User \"$(whoami)\" does not have write permission on  \"${file_path}\".";
        return ${generic_error};
    fi;

    # Writes the message on file.
    echo "${message}" >> "${file_path}";
    echo_result=${?};
    if [ ${echo_result} -ne 0 ];
    then
        _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Error writing message on \"${file_path}\" (${echo_result}).";
        return ${generic_error};
    fi; 

    return ${success};
}


# Creates a log filename based on preffix informed and current time.
#
# Parameters:
#	1. Log file preffix.
#
# Returns:
#   SUCCESS - If log filename was created sucessfully.
#   GENERIC_ERROR - Otherwise
#	It also returns the log file name created trough "echo".
#
_log_create_log_file_name() {
    local log_file_preffix;
    local log_file_name;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        log_file_preffix="${1}";
    fi;

    # Creates the log file name.
    log_file_name="${log_file_preffix}_$(date +"%Y%m%d_%H%M%S").${_log_file_suffix}";

    echo "${log_file_name}";
    return ${success};
}

# Creates the log file based on a preffix informed.
#
# Parameters
#   1. Preffix to identify log file.
#
# Returns
#	SUCCESS - If log file was created.
#   GENERIC_ERROR - Otherwise.
#
create_log_file() {

    local log_file_preffix;
    local log_file_name;
    local temporary_log_file_path;
    local touch_result;
    local initialize_log_level_result;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        _log_file_location="";
        _log_file_creation_result=${generic_error};
        return ${generic_error};
    else
        log_file_preffix="${1}";
    fi;

    # Elaborates log file name.
    log_file_name="$(_log_create_log_file_name ${log_file_preffix})";

    # Elaborates log file path.
    temporary_log_file_path="$(get_log_directory)${log_file_name}";

    # Checks if log file does not exists.
    if [ ! -f "${temporary_log_file_path}" ];
    then

        # Checks if log directory exists.
        if [ ! -d "$(get_log_directory)" ];
        then
            _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Invalid log directory \"$(get_log_directory)\".";
            _log_file_location="";
            _log_file_creation_result=${generic_error};
            return ${generic_error};
        fi;

        # Checks if user has permission to write on log directory.
        if [ ! -w "$(get_log_directory)" ];
        then
            _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: User \"$(whoami)\" does not have write permission on directory. \"${_log_directory}\".";
            _log_file_location="";
            _log_file_creation_result=${generic_error};
            return ${generic_error};
        fi;

        # Creates the log file.
        touch "${temporary_log_file_path}";
        touch_result=${?};
        if [ ${touch_result} -ne 0 ];
        then
            _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Could not create file \"${temporary_log_file_path}\".";
            _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Log messages will be redirected to \"stderr\".";
            _log_file_location="";
            _log_file_creation_result=${generic_error};
            return ${generic_error};
        fi;
    fi;

    # Checks if user has permission to write on log file.
    if [ ! -w "${temporary_log_file_path}" ];
    then
        _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: User \"$(whoami)\" does not have write access on \"${temporary_log_file_path}.";
        _log_write_stderr "[${FUNCNAME[0]}, ${LINENO[0]}] ${_log_error_message_preffix}: Log messages will be redirected to \"stderr\".";
        _log_file_location="";
        _log_file_creation_result=${generic_error};
    fi;

    # Initializes the log level.
    _log_initialize_log_level;
    initialize_log_level_result=${?};
    if [ ${initialize_log_level_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    _log_file_location="${temporary_log_file_path}";
    _log_file_creation_result=${success};

    # Stores the log file path.
    _log_store_log_file_path;

    # Stores the log level.
    _log_store_log_level;

    # Writes a message on log file to inform that log has started.
    _log_write_on_file "${_log_file_location}" "[$(_log_get_current_time)] Log started.";

    return ${success};

}

# Finishes the log file.
#
# Parameters:
#  None.
#
# Returns:
#   SUCCESS - If log was finished successfully.
#   GENERIC_ERROR - Otherwise.
finish_log_file(){

    local finish_message;
    local _log_write_on_file_result;
    local _log_delete_log_file_path_result;
    local _log_delete_log_level_result;

    # Checks function parameters.
    if [ ${#} -ne 0 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    # Checks if log was previously started.
    if [ -z "${_log_file_location}" -o ${_log_file_creation_result} -ne ${success} ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: No log file to finish.";
        return ${generic_error};
    fi;

    # Elaborates the message to inform that log file is closed.
    finish_message="[$(_log_get_current_time)] Log finished.";

    # Writes the message on log file.
    _log_write_on_file ${_log_file_location} "${finish_message}";
    _log_write_on_file_result=${?}
    if [ ${_log_write_on_file_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    #unset _log_file_location;
    _log_file_location="";
    _log_file_creation_result=${not_executed};

    # Deletes the log path file.
    _log_delete_log_path_file;
    _log_delete_log_file_path_result=${?};
    if [ ${_log_delete_log_file_path_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    # Deletes the log level file.
    _log_delete_log_level_file;
    _log_delete_log_level_file_result=${?}
    if [ ${_log_delete_log_level_file_result} -ne ${success} ];
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
#   SUCCESS - If message was correctly written.
#   GENERIC_ERROR - Otherwise.
#
_log_write_log_message() {

    local message;
    local message_content;
    local write_on_stderr;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        message="${1}";
    fi;

    message_content="[$(_log_get_current_time)] ${message}";

    # Checks if log file has been specified.
    if [ -z "${_log_file_location}" ];
    then
        # Writes message on stderr.
        _log_write_stderr ${message_content};
    else
        # Writes messsage on log file.
        echo "${message_content}" >> ${_log_file_location};
    fi;

    return ${success};
}

# Log a message.
#
# Parameters:
#   1. Message type (trace, info, warning, error).
#   2. Message content. (optional for trace messages, mandatory for other message types).
#
# Returns
#   0. If message was successfully logged.
#   1. Otherwise.
#
# Observations:
#   Values accepted on first parameter are defined on "constants.sh" file.
#
log() {
    local message_type;
    local message_content;
    local preffix;
    local message_tag;
    local message_index;
    local log_message;
    local _log_write_log_message_result;

    # Check function parameters.
    if [ ${#} -lt 1 -o ${#} -gt 2 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        message_type=${1};
        message_content="${2}";
    fi;

    # Selects the log message preffix.
    case ${message_type} in
        ${log_message_type_trace})
            preffix=${_log_trace_message_preffix};
            ;;
        ${log_message_type_warning})
            preffix=${_log_warning_message_preffix};
            ;;
        ${log_message_type_error})
            preffix=${_log_error_message_preffix};
            ;;
        *)
            _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid log message type (${message_type}).";
            return ${generic_error};
            ;;
    esac;

    # Checks if function execution was requested from "trace" function.
    if [ "${FUNCNAME[1]}" == "${_log_trace_function_name}" ];
    then
        message_tag=${FUNCNAME[2]};
        message_index=${BASH_LINENO[1]};
    else
        message_tag="${FUNCNAME[1]}";
        message_index=${BASH_LINENO[0]};
    fi;

    # Checks if message type informed is different from "trace" and a message content was informed.
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

    # Elaborates the log message.
    log_message="${preffix}: ${message_tag} (${message_index})";

    # If a message content was informed.
    if [ -n "${message_content}" ];
    then
        log_message+=": ${message_content}";
    fi;

    # Writes the message on log file.
    _log_write_log_message "${log_message}";
    _log_write_log_message_result=${?};
    if [ ${_log_write_log_message_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Registers a trace point on current log.
#
# Parameters:
#   1. Message (optional). 
#
# Returns:
#   SUCCESS - If trace was logged correctly.
#   GENERIC_ERROR - Otherwise.
#
trace(){

    local message;
    local log_result;

    # Checks function parameters.
    if [ ${#} -gt 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    fi;

    # Checks if a message was informed.
    if [ ${#} -eq 1 ];
    then
        message="${1}";
    fi;

    # Writes trace point on log.
    log ${log_message_type_trace} "${trace_message}";
    log_result=${?};
    if [ ${log_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Sets the log level.
#
# Parameters:
#   1. The log level to be defined.
#
# Returns:
#   SUCCESS - If log level was defined correctly.
#   GENERIC_ERROR - Otherwise.
#
# Observations:
#   To define correctly the log level, use the constants defines on
# "constants.sh".
#
set_log_level(){

    local readonly numeric_regex="^[0-9]+$";
    local temporary_log_level;
    local _log_store_log_level_result;

    # Checks function parameters:
    if [ ${#} -ne 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        temporary_log_level=${1};
    fi;

    # Checks if log level informed is a number.
    if ! [[ ${temporary_log_level} =~ ${numeric_regex} ]];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid log level value (${temporary_log_level}).";
        return ${generic_error};
    fi;

    # Checks if log level informed is a valid value.
    if [ ${temporary_log_level} -ne ${log_message_type_trace} -a ${temporary_log_level} -ne ${log_message_type_warning} -a ${temporary_log_level} -ne ${log_message_type_error} ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid log level value (${temporary_log_level}).";
        return ${generic_error};
    fi;

    # Defines the log level.
    _log_level=${temporary_log_level};

    # Stores the log level on log level file.
    _log_store_log_level;
    _log_store_log_level_result=${?};
    if [ ${_log_store_log_level_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Returns the log level.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If log level was returned though "echo" successfully.
#   GENERIC_ERROR - Otherwise.
#   It also returns the current log level through echo.
#
get_log_level(){
    local echo_result;

    echo "${_log_level}";
    echo_result=${?};
    if [ ${echo_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Sets the directory to write log files.
#
# Parameters:
#   1. Path to directory to store log files.
#
# Returns:
#   SUCCESS - If log directory was updated correctly.
#   GENERIC_ERROR - Otherwise.
#
# Observations:
#   If the directory does not exists, this function will not create it. 
# It will return and error and log directory will not be updated.
#
set_log_directory(){

    local temporary_log_directory;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${generic_error};
    else
        temporary_log_directory="${1}";
    fi;

    # Checks if directory exists.
    if [ ! -d "${temporary_log_directory}" ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: Unknown or invalid directory \"${temporary_log_directory}\".";
        return ${generic_error};
    fi;

    # Checks if uses has permission to write on directory.
    if [ ! -w "${temporary_log_directory}" ];
    then
        _log_write_stderr "[${FUNCNAME[1]}, ${BASH_LINENO[0]}] ${_log_error_message_preffix}: User \"$(whoami)\" does not have write permission on directory \"${temporary_log_directory}\".";
        return ${generic_error};
    fi;

    # Defines the log directory.
    _log_directory="${temporary_log_directory}";

    return ${success};
}

# Returns the current log directory.
#
# Parametes:
#    None.
#
# Returns:
#   SUCCESS - If current log directory was returned through "echo" successfully.
#   GENERIC_ERROR - Otherwise.
#   It also returns the current log directory through echo.
#
get_log_directory(){
    local echo_result;

    # Returns the current log directory through "echo".
    echo "${_log_directory}";
    echo_result=${?};
    if [ ${echo_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Returns the path to current log file.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If current log file path was returned through "echo" successfully.
#   GENERIC_ERROR - Otherwise.
#   It also returns the path to the current log file through "echo".
#
get_log_path(){
    local echo_result;

    # Returns the current log file path through "echo".
    echo "${_log_file_location}";
    echo_result=${?};
    if [ ${echo_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Stores the log file path on "log path" file.
#
# Parameters:
#   None.
#
# Returns:
#  SUCCESS - If log file path was stored successfully.
#  GENERIC_ERROR - Otherwise.
#
_log_store_log_file_path() {

    local echo_result;

    # Writes current log file path on "log path" file.
    echo -e "${_log_file_location}" > ${_log_path_file_path};
    echo_result=${?};
    if [ ${echo_result} -ne ${success} ];
    then
        return ${success};
    fi;

    return ${result};
}

# Retrieves the current log file path from "log path" file.
#
# Parameters:
#   None.
#
# Returns:
#  SUCCESS - If current log file path and was retrieved successfully, or if there is no "log path" file defined.
#  GENERIC_ERROR - Otherwise.
#  
# Obvervations:
#   When retrieved, the log file path will be stored on "_log_file_location" variable.
#   If "log path" file does not exists, the function considers that there is not log 
# defined, thus accepting current log path stored and returning "SUCCESS".
#
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
        temporary_log_file_path="$(cat "${_log_path_file_path}")";
        cat_result=${?};
        if [ ${cat_result} -eq ${success} ];
        then
            # Defines the log file path.
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
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If "log path" file was deleted successfully.
#   GENERIC_ERROR - Otherwise.
#
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
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If "log path" is defined.
#   GENERIC_ERROR - If "log path" is not defined or there was an error checking "log path" file.
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

# Stores the current log level on "log level" file.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If current log level was stored successfully.
#   GENERIC_ERROR - Otherwise.
#
_log_store_log_level() {

    local result;
    local echo_result;

    # Stores current log level on "log level" file.
    echo -e "${_log_level}" > ${_log_level_file_path};
    echo_result=${?};
    if [ ${echo_result} -eq ${success} ];
    then
        return ${generic_error};
    fi;

    return ${result};
}

# Retrieves the log level from "log level" file.
#
# Parameters:
#   None.
#
# Returns:
#  SUCCESS - If log level was retrieved successfully.
#  GENERIC_ERROR - Otherwise.
#  
# Obvervations:
#  When retrieved, the log level will be stored on "_log_level" variable.
#
_log_retrieve_log_level() {

    local result=${success};
    local is_log_level_file_defined_result;
    local temporary_log_level;

    # Checks if "log level" file is defined.
    _log_is_log_level_file_defined;
    is_log_level_file_defined_result=${?};
    if [ ${is_log_level_file_defined_result} -eq ${success} ];
    then

        # Retrieves log level from "log level" file.
        temporary_log_level=$(cat "${_log_level_file_path}");
        cat_result=${?};
        if [ ${cat_result} -eq ${success} ];
        then
            # Defines the log file path.
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
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If "log level" file was deleted successfully.
#   GENERIC_ERROR - Otherwise.
#
_log_delete_log_level_file() {

    local result=${success};
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
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If "log level" file is defined.
#   GENERIC_ERROR - If "log level" file is not defined or if there was an error while checking it.
#
_log_is_log_level_file_defined() {

    local result;
    local log_level_file_defined;

    # Checks if "log level" file exists.
    if [ -f "${_log_level_file_path}" ];
    then

        # Check if "log level" file has content.
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

# Sets the start log level on "start log level" file.
#
# Parameters:
#   The start log level value.
#
# Returns:
#  SUCCESS - If start log level was defined successfully.
#  GENERIC_ERROR -  Otherwise.
#
set_start_log_level() {

    local result;
    local echo_result;
    local start_log_level;

    # Checks function parameters.
    if [ ${#} -ne 1 ];
    then
        return ${generic_error};
    else
        start_log_level=${1};
    fi;

    # Writes start log level on "start log level" file.
    echo -e "${start_log_level}" > ${_log_start_log_level_file_path};
    echo_result=${?};
    if [ ${echo_result} -eq ${success} ];
    then
        result=${success};
    else
        result=${failure};
    fi;

    return ${result};
}

# Retrieves the start log level from "start log level" file.
#
# Parameters:
#   None.
#
# Returns:
#  SUCCESS - If start log level was retrieved successfully.
#  GENERIC_ERROR - Otherwise.
#  It also returns the start log level through "echo".
#
_log_retrieve_start_log_level() {
    local result;
    local is_start_log_level_file_defined_result;
    local start_log_level;

    # Checks if "start log level" file is defined.
    _log_is_start_log_level_file_defined;
    is_start_log_level_file_defined_result=${?};
    if [ ${is_start_log_level_file_defined_result} -eq ${success} ];
    then

        # Retrieves start log level from "start log level" file.
        start_log_level=$(cat "${_log_start_log_level_file_path}");
        cat_result=${?};
        if [ ${cat_result} -eq ${success} ];
        then
            # Defines the log file path.
            echo "${start_log_level}";
            result=${success};
        else
            result=${generic_error};
        fi;
    else
        result=${generic_error};
    fi;

    return ${result};
}

# Deletes the "start log level" file.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If "start log level" file was deleted successfully.
#   GENERIC_ERROR - Otherwise.
#
delete_start_log_level_file() {
    local result;
    local rm_result;

    # Checks if "start log level" file exists.
    if [ -f "${_log_start_log_level_file_path}" ];
    then

        # Deletes "start log level" file.
        rm -f "${_log_start_log_level_file_path}";
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

# Checks if "start log level" file is defined.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If "start log level" is defined.
#   GENERIC_ERROR - If "start log level" is not defined or there was an error while checking "start log level" file existance.
#
_log_is_start_log_level_file_defined() {

    local result;
    local log_level_file_defined;

    # Checks if "start log level" file exists.
    if [ -f "${_log_start_log_level_file_path}" ];
    then

        # Check if "start log level" file has content.
        start_log_level_file_defined=$(cat ${_log_start_log_level_file_path} | wc -l);
        if [ ${start_log_level_file_defined} -eq 1 ];
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
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If a log is already defined.
#   GENERIC_ERRO - Otherwise.
is_log_defined(){

    local is_log_path_file_defined_result;

    # Checks if "log path" file is defined.
    _log_is_log_path_file_defined;
    is_log_path_file_defined_result=${?};
    if [ ${is_log_path_file_defined_result} -ne ${success} ];
    then
        return ${generic_error};
    fi;

    return ${success};
}

# Continues a log file that is already defined.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If log file was continued successfully.
#   GENERIC_ERROR - Otherwise.
#
continue_log_file(){

    local result;
    local is_log_defined_result;
    local retrieve_log_file_path_result;
    local retrieve_log_level_result;
    local intialize_log_level_result;

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

                # Initializes log level.
                _log_initialize_log_level;
                initialize_log_level_result=${?};
                if [ ${initialize_log_level_result} -ne ${success} ];
                then
                    result=${generic_error};
                fi;
            else
                result=${success};
            fi;
        else
            result=${generic_error};
        fi;
    else
        result=${generic_error};
    fi;

    _log_file_creation_result=${result};

    return ${result};
}

# Initializes the log level.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If log level was initialized successfully.
#   GENERIC_ERROR - Otherwise
#
_log_initialize_log_level() {
    local is_start_log_level_defined;
    local start_log_level;
    local retrieve_start_log_level_result;
    local new_log_level;

    # Checks if "start log level" file is defined.
    _log_is_start_log_level_file_defined;
    is_start_log_level_file_defined_result=${?};
    if [ ${is_start_log_level_file_defined_result} -eq ${success} ];
    then

        # Retrieves the start log level.
        start_log_level=$(_log_retrieve_start_log_level);
        retrieve_start_log_level_result=${?};
        if [ ${retrieve_start_log_level_result} -eq ${success} -a -n "${start_log_level}" ];
        then
            new_log_level=${start_log_level};
        else
            new_log_level=${log_message_type_trace};
        fi;
    else
        new_log_level=${log_message_type_trace};
    fi;

    set_log_level ${new_log_level};

    return ${success};
}
