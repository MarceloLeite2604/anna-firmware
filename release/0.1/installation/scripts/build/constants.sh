#!/bin/bash

# Constants used on program building.
#
# Version: 
#   0.1
#
# Author:
#   Marcelo Leite

# ###
# Include guard.
# ###
if [ -z "${BUILD_CONSTANTS_SH}" ];
then
    BUILD_CONSTANTS_SH=1;
else
    return;
fi;


# ###
# Constants.
# ###

# Makefile parameter which defines the target to build.
if [ -z "${make_parameter_target}" ];
then
    readonly make_parameter_target="TARGET";
fi;

# Makefile parameter which defines the additional flags to build objects.
if [ -z "${make_parameter_additional_compile_flags}" ];
then
    readonly make_parameter_additional_compile_flags="ADDITIONAL_C_FLAGS_OBJECTS";
fi;

# Makefile parameter which defines the directory where the files should be created.
if [ -z "${make_parameter_output_files_directory}" ];
then
    readonly make_parameter_output_files_directory="OUTPUT_FILES_DIRECTORY";
fi;

# Deafault path to source file's directory.
if [ -z "${default_source_files_directory}" ];
then
    readonly default_source_files_directory="$(dirname ${BASH_SOURCE})/../../src/";
fi;
