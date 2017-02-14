#!/bin/bash

# This file contains all constants required to use log and trace functions.
#
# Version: 0.1
# Author: Marcelo Leite

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

