#!/bin/bash

# This script starts a log file.
#
# Parameters:
#   1. The log file name preffix.
#   2. The log level to be used.
#
# Returns:
#   SUCCESS - If log was started.
#   GENERIC_ERROR - Otherwise.
#
# Version: 
#   0.1
#
# Author: 
#   Marcelo Leite
#
# Observations:
#   This script accepts a log file preffix as a parameter. If not parameter is informed, it will use a default preffix.
#


# ###
# Script source.
# ###

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";


# ###
# Constants.
# ###

# Default log file preffix.
if [ -z "${default_log_file_preffix}" ];
then
    readonly default_log_file_preffix="start_log";
fi;


# ###
# Functions elaboration.
# ###

# Starts a new log file.
#
# Parameters:
#  1. The log file name preffix.
#  2. The log level (optional).
#
# Returns:
#   SUCCESS - If log started successfully.
#   GENERIC_ERROR - Otherwise.
#
# Observations:
#   If no parameter was informed, the function will create a log file with a default preffix and log all messages.
#
start_log(){

    local result=${success};
    local log_file_preffix;
    local log_level;
    local is_log_defined_result;
    local continue_log_file_result;
    local finish_log_file_result;
    local set_log_level_result;

    # Checks function parameters.
    if [ ${#} -ge 2 ];
    then
        log_file_preffix="${1}";
        log_level=${2};
    else
        if [ ${#} -eq 1 ];
        then
            log_file_preffix="${1}";
        else
            log_file_preffix=${default_log_file_preffix};
        fi;
    fi;

    # Checks if log is defined.
    is_log_defined;
    is_log_defined_result=${?};
    if [ ${is_log_defined_result} -eq ${success} ];
    then

        # Continues previous log file.
        continue_log_file;
        continue_log_file_result=${?};
        if [ ${continue_log_file_result} -eq ${success} ];
        then

            # Finished previous log file.
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

        # Creates a new log file.
        create_log_file "${log_file_preffix}";
        create_log_file_result=${?};
        if [ ${create_log_file_result} -eq ${success} ];
        then

            # If log level was informed.
            if [ -n "${log_level}" ];
            then

                # Defines the log level.
                set_log_level ${log_level};
                set_log_level_result=${?};
                if [ ${set_log_level_result} -eq ${success} ];
                then
                    result=${success};
                else
                    result=${generic_error};
                fi;
            else
                result=${success};
            fi;
        else
            result=${generic_error};
        fi;
    fi;

    return ${result};
}

# Starts a new log file.
start_log ${@};
exit ${?};
