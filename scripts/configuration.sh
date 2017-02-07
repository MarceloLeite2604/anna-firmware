#!/bin/bash

# The company's name.
if [ -z ${company+x} ]; 
then
	readonly company="marcelo";
fi;

# The project name.
if [ -z ${project+x} ]; 
then
	readonly project="projeto_anna";
fi;

# Root directory.
if [ -z ${root_directory+x} ]; 
then
    readonly root_directory="$(dirname ${BASH_SOURCE})/../";
fi;

# Configuration directory.
if [ -z ${configuration_directory+x} ];
then
    readonly configuration_directory="${root_directory}configuration/";
fi;

# Indicates that the process was not executed.
if [ -z ${not_executed+v} ]; 
then
    readonly not_executed=255;
fi;

# Indicates success on function/script execution.
if [ -z ${success+v} ]; 
then
    readonly success=0;
fi;

# Indicates general failure on function/script execution.
if [ -z ${general_failure} ]; 
then
    readonly general_failure=1;
fi;

# Main directory structure used by the scripts.
if [ -z ${directory_structure+x} ]; 
then
	readonly directory_structure="./${company}/${project}/";
fi;

# Default audio directory.
if [ -z ${default_audio_directory+x} ];
then
    readonly default_audio_directory="${root_directory}audio/";
fi;
