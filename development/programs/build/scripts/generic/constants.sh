#!/bin/bash

# Constants used on project controlling and development.
#
# Version: 
#   0.1
#
# Author:
#   Marcelo Leite

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
# Constants.
# ###

# Preffix used to identify error messages.
if [ -z "${error_messages_preffix}" ];
then
    readonly error_message_preffix="[ERROR]:";
fi;

# Makefile parameter which defines the path to "include" directory.
if [ -z "${make_parameter_include_directory}" ];
then
    readonly make_parameter_include_directory="INCLUDE_FILES_DIRECTORY";
fi;

# Makefile parameter which defines the output directory's path.
if [ -z "${make_parameter_output_files_directory}" ];
then
    readonly make_parameter_output_files_directory="OUTPUT_FILES_DIRECTORY";
fi;

# Makefile parameter which defines the additional flags to build objects.
if [ -z "${make_parameter_additional_compile_flags}" ];
then
    readonly make_parameter_additional_compile_flags="ADDITIONAL_C_FLAGS_OBJECTS";
fi;

# Path to source file's directory.
if [ -z "${source_files_directory}" ];
then
    readonly source_files_directory="$(dirname ${BASH_SOURCE})/../../src/";
fi;
