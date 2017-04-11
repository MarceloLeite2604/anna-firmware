#!/bin/bash

# This script starts a log file.
#
# Version: 0.1
# Author: Marcelo Leite
#
# Observations
#   This script accepts a log file preffix as a parameter. If not parameter is informed, it will use a default preffix.

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";

# Default log file preffix.
default_log_file_preffix="start_log";

# Default log level.
default_log_level=${log_message_type_trace};

# Starts a new log.
#
# Parameters
#  1. The log file name preffix.
#  2. The log level.
#
# Returns
#   0. If log started successfully.
#   1. Otherwise.
#
# Observations
#   If no parameter was informed, the function will create a log file with a default preffix and log all messages.
start_log(){
    local result=${success};
    local log_file_preffix;
    local log_level;
    local is_log_defined_result;
    local continue_log_file_result;
    local finish_log_file_result;
    local set_log_level_result;

    if [ ${#} -ge 2 ];
    then
        log_file_preffix=${1};
        log_level=${2}
    else
        if [ ${#} -eq 1 ];
        then
            log_file_preffix=${1};
            log_level=${default_log_level};
        else
            log_file_preffix=${default_log_file_preffix};
            log_level=${default_log_level};
        fi;
    fi;

    is_log_defined;
    is_log_defined_result=${?};
    if [ ${is_log_defined_result} -eq ${success} ];
    then
        continue_log_file;
        continue_log_file_result=${?};
        if [ ${continue_log_file_result} -eq ${success} ];
        then
            finish_log_file;
            finish_log_file_result=${?};
            if [ ${finish_log_file_result} -ne ${success} ];
            then
                result=${generic_error};
            fi;
        else
            result=${generic_error};
        fi;
    fi;

    if [ ${result} -eq ${success} ];
    then
        set_log_level ${log_level};
        set_log_level_result=${?};
        if [ ${set_log_level_result} -eq ${success} ];
        then
            create_log_file "${log_file_preffix}";
            create_log_file_result=${?};
            if [ ${create_log_file_result} -eq ${success} ];
            then
                result=${success};
            else
                result=${generic_error};
            fi;
        else
            result=${generic_error};
        fi;
    fi;

    return ${result};
}

start_log ${@};
exit ${?};
