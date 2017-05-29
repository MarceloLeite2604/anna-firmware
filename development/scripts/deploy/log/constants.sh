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

# Path to the "log path" file.
if [ -z "${_log_path_file_path}" ];
then
    readonly _log_path_file_path="${output_files_directory}logs/log_path";
fi;

# Path to the "log level" file.
if [ -z "${_log_level_file_path}" ];
then
    readonly _log_level_file_path="${output_files_directory}logs/log_level";
fi;

# Path to the "start log level" file.
if [ -z "${_log_start_log_level_file_path}" ];
then
    readonly _log_start_log_level_file_path="${output_files_directory}logs/start_log_level";
fi;
