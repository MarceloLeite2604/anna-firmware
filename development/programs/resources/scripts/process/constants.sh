#!/bin/bash

# This script contains all constants specific for process functions.
#
# Version: 0.1
# Author: Marcelo Leite

# Loads generic constants script.
source "$(dirname ${BASH_SOURCE})/../generic/constants.sh";

# Process id files directory.
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
if [ -z ${process_kill_signal+x} ];
then
    readonly process_kill_signal="SIGKILL";
fi;

# Signal sent to interrupt a process.
if [ -z ${process_interrupt_signal+x} ];
then
    readonly process_interrupt_signal="SIGINT";
fi;

# Signal sent to terminate a process.
if [ -z ${process_terminate_signal+x} ];
then
    readonly process_terminate_signal="SIGTERM";
fi;
