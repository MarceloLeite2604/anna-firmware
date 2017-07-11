#!/bin/bash

# Script to build the project's programs.
#
# Parameters:
#   1. The type of build to be done ("debug", "release" or "all").
#   2. The path to the source files to build (optional).
#   3. The path to the output directory to build the files (optional).
#   4. The target to run on makefile script (optional).
#
# Returns:
#   0 - If the programs were built successfully.
#   1 - If there was an error while building the programs.
#
# Version: 
#   0.1
#
# Author:
#   Marcelo Leite

# ###
# Source scripts.
# ###

# Load generic functions script.
source "$(dirname ${BASH_SOURCE})/generic/functions.sh";

# Load build constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# ###
# Variables.
# ###

# Path to the source files to build.
source_files_directory=${default_source_files_directory};


# ###
# Function elaborations.
# ###

print_usage(){
    echo -e "Use this script to build the programs of this project.\n"
    echo -e "Usage:"
    echo -e "\t$(basename ${0}) {type} [target] [{source path} {output path}]\n"
    echo -e "\tWhere:";
    echo -e "\t\ttype - Type of build to execute. It can be \"debug\", \"release\" or \"all\".";
    echo -e "\t\ttarget - Target to execute on makefile (p. ex. \"all\").";
    echo -e "\t\tsource path - Path to the directory which the source files to compile are."
    echo -e "\t\toutput path - Path to directory where the binaries will be created.\n"
}

# Executes the makefile in a specified folder with the parameters informed.
#
# Parameters:
#   1. The path to the directory where the makefile to be executed is.
#   2. The output directory for binaries created by the makefile.
#   3. The target to run on makefile script.
#   4. The list of additional arguments to inform on the object creation (optional).
#   
# Returns:
#   0 - If the programs were build successfully.
#   1 - Otherwise.
#
build_programs() {

    local makefile_directory;
    local additional_compile_flags;
    local command_to_execute;
    local make_result;

    # Checks function parameters.
    if [ ${#} -lt 3 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else

        makefile_directory="${1}";
        output_directory="${2}";
        makefile_target="${3}";

        if [ ${#} -ge 4 ];
        then
            additional_compile_flags="${4}";
        fi;
    fi;

    # Builds the command to execute.
    command_to_execute="make -C ${makefile_directory} ${make_parameter_output_files_directory}=${output_directory}";

    # If the third parameter was informed, add it to the command.
    if [ -n "${additional_compile_flags}" ];
    then
        command_to_execute="${command_to_execute} ${make_parameter_additional_compile_flags}=${additional_compile_flags}";
    fi;

    # Concatenate the target to execute.
    command_to_execute="${command_to_execute} ${makefile_target}";

    # Executes the command.
    ${command_to_execute};
    make_result=${?};
    if [ ${make_result} -ne 0 ];
    then
        print_error_message "Error while buiding the programs.";
        return 1;
    fi;

    return 0;
}

# Builds the programs for release.
#
# Parameters:
#   1. The path to the source files to build.
#   2. The path to the output directory to build the files.
#   3. The target to run on makefile script.
#   
# Returns:
#   0 - If the programs were build successfully.
#   1 - Otherwise.
#
build_release() {
    echo -e "Building programs for release.";

    local source_files_directory;
    local output_files_directory;
    local makefile_target;
    local build_programs_result;

    # Checks function parameters.
    if [ ${#} -lt 2 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else
        source_files_directory="${1}";
        output_files_directory="${2}";
        makefile_target="${3}";
    fi;

    build_programs "${source_files_directory}release/" "${output_files_directory}" "${makefile_target}";
    build_programs_result=${?};
    if [ ${build_programs_result} -ne 0 ];
    then
        return 1;
    fi;

    return 0;
}

# Builds the programs for debug.
#
# Parameters:
#   1. The path to the source files to build.
#   2. The path to the output directory to build the files.
#   3. The target to run on makefile script.
#   
# Returns:
#   0 - If the programs were build successfully.
#   1 - Otherwise.
#
build_debug() {

    local source_files_directory;
    local output_files_directory;
    local makefile_target;
    local additional_compile_flags;
    local build_programs_result;

    # Checks function parameters.
    if [ ${#} -lt 3 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else
        source_files_directory="${1}";
        output_files_directory="${2}";
        makefile_target="${3}";
    fi;

    echo -e "Building programs for debug.";

    additional_compile_flags="-g";

    build_programs "${source_files_directory}release/" "${output_files_directory}" "${makefile_target}" "${additional_compile_flags}";
    build_programs_result=${?};
    if [ ${build_programs_result} -ne 0 ];
    then
        return 1;
    fi;

    build_programs "${source_files_directory}test/" "${output_files_directory}" "${makefile_target}" "${additional_compile_flags}";
    build_programs_result=${?};
    if [ ${build_programs_result} -ne 0 ];
    then
        return 1;
    fi;

    return 0;
}

# Builds the programs.
#
# Parameters:
#   1. The type of build to be done ("debug", "release" or "all").
#   2. The path to the source files to build (optional).
#   3. The path to the output directory to build the files (optional).
#   4. The target to run on makefile script (optional).
#   
# Returns:
#   0 - If the programs were build successfully.
#   1 - Otherwise.
#
build() {

    local build_type;
    local build_result;
    local source_files_directory;
    local output_files_directory;
    local makefile_target;

    if [ ${#} -ne 1 -a ${#} -ne 2 -a ${#} -ne 4 ];
    then
        print_usage;
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    fi;

    build_type="${1}";

    # Checks function parameters.
    if [ ${#} -ge 2 ];
    then
        makefile_target="${2}";

        if [ ${#} -eq 4 ];
        then
            source_files_directory="${3}";
            output_files_directory="${4}";
        else
            source_files_directory="${default_source_files_directory}";
            output_files_directory="${default_output_files_directory}${build_type}/";
        fi;

    else
        makefile_target="${default_makefile_target}";
        source_files_directory="${default_source_files_directory}";
        output_files_directory="${default_output_files_directory}${build_type}/";
    fi;

    case "${build_type}" in
        "debug")
            build_debug "${source_files_directory}" "${output_files_directory}" "${makefile_target}";
            build_result=${?};
            if [ ${build_result} -ne 0 ];
            then
                print_error_message "Error while building for debug.";
                return 1;
            fi;
            ;;

        "release")
            build_release "${source_files_directory}" "${output_files_directory}" "${makefile_target}";
            build_result=${?};
            if [ ${build_result} -ne 0 ];
            then
                print_error_message "Error while building for release.";
                return 1;
            fi;
            ;;

        "all")
            build_debug;
            build_result=${?};
            if [ ${build_result} -ne 0 ];
            then
                print_error_message "Error while building for debug.";
                return 1;
            fi;

            build_release;
            build_result=${?};
            if [ ${build_result} -ne 0 ];
            then
                print_error_message "Error while building for release.";
                return 1;
            fi;
            ;;

        "help"|"-h")
            print_usage;
            ;;

        *)
            print_usage;
            >&2 echo "ERROR: Unknown build type \"${build_type}\".";
            return 1;
            ;;
    esac
set +x;
    return 0;
}

build ${@};
exit ${?};
