#!/bin/bash

# This script contains the constants required to acquire de input, output and 
# binaries directories for script executions.
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

# File which contains the directory path for binaries.
if [ -z "${_directories_binaries_directory_file}" ];
then
    readonly _directories_binaries_directory_file="$(dirname ${BASH_SOURCE})/binaries_directory";
fi;

# File which contains the directory path for input files.
if [ -z "${_directories_input_directory_file}" ];
then
    readonly _directories_input_directory_file="$(dirname ${BASH_SOURCE})/input_directory";
fi;

# File which contains the directory path for output files.
if [ -z "${_directories_output_directory_file}" ];
then
    readonly _directories_output_directory_file="$(dirname ${BASH_SOURCE})/output_directory";
fi;
