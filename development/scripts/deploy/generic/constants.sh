#!/bin/bash

# This script contains all generic constants used throughout other scripts.
#
# Parameters:
#   None.
#
# Returns:
#   1 - If this script could not find the input or ouput directories.
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
if [ -z "${GENERIC_CONSTANTS_SH}" ];
then
    GENERIC_CONSTANTS_SH=1;
else
    return;
fi;

# ###
# Script sources.
# ###

# Loads directory functions.
source "$(dirname ${BASH_SOURCE})/../directories/functions.sh";

# ###
# Constants.
# ###

# The company name.
if [ -z "${company}" ]; 
then
    readonly company="marcelo";
fi;

# The project name.
if [ -z "${project}" ]; 
then
	readonly project="anna";
fi;

# Directory which contains the input files.
if [ -z "${input_files_directory}" ];
then
    _temporary_input_files_directory="$(get_input_files_directory)";
    if [ ${?} -ne 0 ];
    then
        exit 1;
    fi;
    readonly input_files_directory="${_temporary_input_files_directory}";
fi;

# Directory which contains the output files.
if [ -z "${output_files_directory}" ];
then
    _temporary_output_files_directory="$(get_output_files_directory)";
    if [ ${?} -ne 0 ];
    then
        exit 1;
    fi;
    readonly output_files_directory="${_temporary_output_files_directory}";
fi;

# Directory which contains the project configuration.
if [ -z "${configuration_directory}" ];
then
    readonly configuration_directory="${input_files_directory}configuration/";
fi;

# Indicates that a process was not executed.
if [ -z "${not_executed}" ]; 
then
    readonly not_executed=255;
fi;

# Indicates success on function/script execution.
if [ -z "${success}" ]; 
then
    readonly success=0;
fi;

# Indicates a generic error on function/script execution.
if [ -z "${generic_error}" ]; 
then
    readonly generic_error=1;
fi;

# Main directory structure used by the scripts.
if [ -z "${directory_structure}" ]; 
then
    readonly directory_structure="./${company}/${project}/";
fi;

# Directory where audio files will be stored.
if [ -z "${audio_directory}" ];
then
    readonly audio_directory="${output_files_directory}audio/";
fi;

# Temporary directory.
if [ -z "${temporary_directory}" ];
then
    readonly temporary_directory="${output_files_directory}temporary/";
fi;

# Path to the file where the latest audio record file name is stored.
if [ -z "${latest_audio_record_file_name_file}" ];
then
    readonly latest_audio_record_file_name_file="${audio_directory}latest_audio_record";
fi;
