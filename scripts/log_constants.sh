#!/bin/bash

# This file contains all constants required to use log and trace functions.
#
# Version: 0.1
# Author: Marcelo Leite

# Load configuration file.
source $(dirname $BASH_SOURCE)/configuration.sh

# Suffix to identify log files.
if [ -z ${log_file_suffix+x} ]; 
then
    readonly log_file_suffix="log";
fi;

# Code to identify trace messages.
if [ -z ${type_trace+x} ]; 
then
    readonly type_trace=105;
fi;

# Code to identify warning messages.
if [ -z ${type_warning+x} ]; 
then
    readonly type_warning=110;
fi;

# Code to identify error messages.
if [ -z ${type_error+x} ]; 
then
    readonly type_error=115;
fi;

# Preffix used to identify trace messages.
if [ -z ${trace_preffix+x} ]; 
then
    readonly trace_preffix="TRACE";
fi;

# Preffix used to identify warning messages.
if [ -z ${warn_preffix+x} ]; 
then
    readonly warning_preffix="WARN";
fi;

# Preffix used to identify error messages.
if [ -z ${error_preffix+x} ]; 
then
    readonly error_preffix="ERROR";
fi;

# Name of trace function.
if [ -z ${trace_function_name+x} ]; 
then
    readonly trace_function_name="trace";
fi;
