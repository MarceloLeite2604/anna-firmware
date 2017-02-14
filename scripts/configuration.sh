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

# Indicates a generic error on function/script execution.
if [ -z ${generic_error} ]; 
then
    readonly generic_error=1;
fi;

# Main directory structure used by the scripts.
if [ -z ${directory_structure+x} ]; 
then
	readonly directory_structure="./${company}/${project}/";
fi;

# Directory where audio files will be stored.
if [ -z ${audio_directory+x} ];
then
    readonly audio_directory="${root_directory}audio/";
fi;

# Temporary directory.
if [ -z ${temporary_directory+x} ];
then
    readonly temporary_directory="${root_directory}temporary/";
fi;

# Process id files directory.
if [ -z ${process_id_files_directory+x} ];
then
    readonly process_id_files_directory="${root_directory}pids/";
fi;

# Suffix to identify process id files.
if [ -z ${process_id_files_suffix+x} ];
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
