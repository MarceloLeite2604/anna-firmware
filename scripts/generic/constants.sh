#!/bin/bash

# This script contains all generic constants used throughout other scripts.
#
# Version: 0.1
# Author: Marcelo Leite

# The company's name.
if [ -z "${company}" ]; 
then
	readonly company="marcelo";
fi;

# The project name.
if [ -z "${project}" ]; 
then
	readonly project="projeto_anna";
fi;

# Root directory.
if [ -z "${root_directory}" ]; 
then
    readonly root_directory="$(dirname ${BASH_SOURCE})/../../";
fi;

# Configuration directory.
if [ -z "${configuration_directory}" ];
then
    readonly configuration_directory="${root_directory}configuration/";
fi;

# Indicates that the process was not executed.
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
    readonly audio_directory="${root_directory}audio/";
fi;

# Temporary directory.
if [ -z "${temporary_directory}" ];
then
    readonly temporary_directory="${root_directory}temporary/";
fi;
