#!/bin/bash

# Load configuration file.
source $(dirname $BASH_SOURCE)/configuration.sh

# Suffix to identify log files.
if [ -z ${log_file_suffix+x} ]; then
	readonly log_file_suffix="log";
fi;

# Path to log files.
#if [ -z ${log_path+x} ]; then
#    readonly log_path="${root_path}log/";
#fi;

# Preffix used to identify error messages.
if [ -z ${error_preffix+x} ]; then
    readonly error_preffix="ERROR";
fi;

# Preffix used to identify information messages.
if [ -z ${info_preffix+x} ]; then
    readonly info_preffix="INFO";
fi;

# Preffix used to identify warning messages.
if [ -z ${warn_preffix+x} ]; then
    readonly warn_preffix="WARN";
fi;

# Preffix used to identify trace messages.
if [ -z ${trace_preffix+x} ]; then
    readonly trace_preffix="TRACE";
fi;


