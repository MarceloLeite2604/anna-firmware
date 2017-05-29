#!/bin/bash

# This script constains the constants required to acquire de input and output file directories for script executions.
#
# Version: 0.1
# Author: Marcelo Leite

# File which contains the directory path for binaries files.
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
