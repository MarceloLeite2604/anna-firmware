#!/bin/bash

# This script contains all constants specific for process controlling.
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
if [-z "${PROCESS_CONSTANTS_SH}" ];
then
    PROCESS_CONSTANTS_SH=1;
else
    return;
fi;


# ###
# Script sources.
# ###

# Loads generic constants script.
source "$(dirname ${BASH_SOURCE})/../generic/constants.sh";


# ###
# Constants.
# ###

# Directory to store process id files.
if [ -z "${process_id_files_directory}" ];
then
    readonly process_id_files_directory="${output_files_directory}pids/";
fi;

# Suffix to identify process id files.
if [ -z "${process_id_files_suffix}" ];
then
    readonly process_id_files_suffix=".pid";
fi;

# Signal sent to kill a process.
if [ -z "${process_kill_signal}" ];
then
    readonly process_kill_signal="SIGKILL";
fi;

# Signal sent to interrupt a process.
if [ -z "${process_interrupt_signal}" ];
then
    readonly process_interrupt_signal="SIGINT";
fi;

# Signal sent to terminate a process.
if [ -z "${process_terminate_signal}" ];
then
    readonly process_terminate_signal="SIGTERM";
fi;
