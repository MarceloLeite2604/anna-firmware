#!/bin/bash

# This file contains all constants required to use log functions.
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
if [ -z ${LOG_CONSTANTS_SH} ];
then
    LOG_CONSTANTS_SH=1;
else
    return;
fi;


# ###
# Constants.
# ###

# Suffix to identify log files.
if [ -z "${_log_file_suffix}" ]; 
then
    readonly _log_file_suffix="log";
fi;

# Code to identify trace messages.
if [ -z "${log_message_type_trace}" ]; 
then
    readonly log_message_type_trace=105;
fi;

# Code to identify warning messages.
if [ -z "${log_message_type_warning}" ]; 
then
    readonly log_message_type_warning=110;
fi;

# Code to identify error messages.
if [ -z "${log_message_type_error}" ]; 
then
    readonly log_message_type_error=115;
fi;

# Preffix used to identify trace messages.
if [ -z "${_log_trace_message_preffix}" ]; 
then
    readonly _log_trace_message_preffix="TRACE";
fi;

# Preffix used to identify warning messages.
if [ -z "${_log_warning_message_preffix}" ]; 
then
    readonly _log_warning_message_preffix="WARN";
fi;

# Preffix used to identify error messages.
if [ -z "${_log_error_message_preffix}" ]; 
then
    readonly _log_error_message_preffix="ERROR";
fi;

# Name of trace function.
if [ -z "${_log_trace_function_name}" ]; 
then
    readonly _log_trace_function_name="trace";
fi;

# Directory which log files are stored.
if [ -z "${log_files_directory}" ];
then
    readonly log_files_directory="${output_files_directory}logs/";
fi;

# Pattern to identify log files.
if [ -z "${log_files_pattern}" ];
then
    readonly log_files_pattern="${log_files_directory}*${_log_file_suffix}";
fi;

# Path to the "log path" file.
if [ -z "${_log_path_file_path}" ];
then
    readonly _log_path_file_path="${log_files_directory}log_path";
fi;

# Path to the "log level" file.
if [ -z "${_log_level_file_path}" ];
then
    readonly _log_level_file_path="${log_files_directory}log_level";
fi;

# Path to the "start log level" file.
if [ -z "${_log_start_log_level_file_path}" ];
then
    readonly _log_start_log_level_file_path="${output_files_directory}logs/start_log_level";
fi;

# Preffix to identify log tarball files.
if [ -z "${log_tarball_file_preffix}" ];
then
    readonly log_tarball_file_preffix="previous_logs";
fi;

# Suffix to identify tarball files.
if [ -z "${tarball_file_suffix}" ];
then
    readonly tarball_file_suffix=".tar";
fi;

# Pattern to find log tarball files.
if [ -z "${log_tarball_files_pattern}" ];
then
    readonly log_tarball_files_pattern="${log_files_directory}${log_tarball_file_preffix}*${tarball_file_suffix}";
fi;

# Limit of a log tarball size (in bytes).
if [ -z "${log_tarball_file_size_limit}" ];
then
    let "_temporary_log_tarball_file_size_limit = 10 * 1024 * 1024";
    readonly log_tarball_file_size_limit=${_temporary_log_tarball_file_size_limit};
fi;
