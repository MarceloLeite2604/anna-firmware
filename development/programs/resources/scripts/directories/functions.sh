#!/bin/bash

# This script contains functions to get the input and output directories for 
# script executions.
#
# Version: 0.1
# Author: Marcelo Leite

# Load directory constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Returns the input files directory path.
#
# Parameters
#   None.
#
# Returns
#   0. If input directory was acquired and returned correctly.
#   1. Otherwise.
#   It also returns the input files directory path through "echo".
get_input_files_directory(){

    if [ ! -f "${_directories_input_directory_file}" ];
    then
        $(>&2 echo "Could not find input directory file \"${_directories_input_directory_file}\".");
        return 1;
    fi;

    local result=$(cat "${_directories_input_directory_file}");

    if [ -z "${result}" ];
    then
        $(>&2 echo "Input directory file \"${_directories_input_directory_file}\" is empty.");
        return 1;
    fi;

    result="$(dirname ${BASH_SOURCE})/${result}";

    echo "${result}";
    return 0;
}

# Returns the output files directory path.
#
# Parameters
#   None.
#
# Returns
#   0. If output directory was acquired and returned correctly.
#   1. Otherwise.
#   It also returns the output files directory path through "echo".
get_output_files_directory(){

    if [ ! -f "${_directories_output_directory_file}" ];
    then
        $(>&2 echo "Could not find output directory file \"${_directories_output_directory_file}\".");
        return 1;
    fi;

    local result=$(cat "${_directories_output_directory_file}");

    if [ -z "${result}" ];
    then
        $(>&2 echo "Output directory file \"${_directories_output_directory_file}\" is empty.");
        return 1;
    fi;

    result="$(dirname ${BASH_SOURCE})/${result}";

    echo "${result}";
    return 0;
}
