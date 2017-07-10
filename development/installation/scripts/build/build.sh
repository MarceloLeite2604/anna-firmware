#!/bin/bash

# Script to build the project's programs.
#
# Parameters:
#   1. The type of build to be done ("debug", "release" or "all").
#   2. The path to the source files to build (optional).
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
source_files_directory=${default_source_files_directory}


# ###
# Function elaborations.
# ###

print_usage(){
    echo -e "Use this script to build the programs of this project.\n"
    echo -e "Usage:"
    echo -e "\t$(basename ${0}) {debug, release, all}\n"
    echo -e "\tdebug - Builds all programs for debug."
    echo -e "\trelease - Builds all programs for release."
    echo -e "\tall - Build all programs for debug and release.\n"
}

build_programs() {

    local makefile_directory;
    local build_target;
    local additional_compile_flags;
    local command_to_execute;
    local make_result;

    # Checks function parameters.
    if [ ${#} -lt 2 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else

        makefile_directory="${1}";
        build_target="${2}";

        if [ ${#} -eq 3 ];
        then
            additional_compile_flags="${3}";
        fi;
    fi;

    # Builds the command to execute.
    command_to_execute="make -C ${makefile_directory} ${make_parameter_target}=${target}";

    # If the third parameter was informed, add it to the command.
    if [ -z "${additional_compile_flags}" ];
    then
        command_to_execute="${command_to_execute} ${make_parameter_additional_compile_flags}=${additional_compile_flags}";
    fi;

    # Concatenate the target to execute.
    command_to_execute="${command_to_execute} all";

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

build_release() {
    echo -e "\nBuilding programs for release.";

    local target="release";
    local build_programs_result;

    build_programs "${source_files_directory}release/" "${target}";
    build_programs_result=${?};
    if [ ${build_programs_result} -ne 0 ];
    then
        return 1;
    fi;

    return 0;
}

build_debug() {
    echo -e "\nBuilding programs for debug.";

    local target="debug";
    local additional_compile_flags="-g";
    local build_programs_result;

    build_programs "${source_files_directory}release/" "${target}" "${additional_compile_flags}";
    build_programs_result=${?};
    if [ ${build_programs_result} -ne 0 ];
    then
        return 1;
    fi;

    build_programs "${source_files_directory}test/" "${target}" "${additional_compile_flags}";
    build_programs_result=${?};
    if [ ${build_programs_result} -ne 0 ];
    then
        return 1;
    fi;

    return 0;
}

build() {

    local build_type;
    local build_result;

    # Checks function parameters.
    if [ ${#} -lt 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else
        build_type="${1}";

        if [ ${#} -ge 2 ];
        then
            source_files_directory="${2}";
        fi;
    fi;

    if [ -z "${build_type}" ];
    then
        print_usage;
        >&2 echo "ERROR: Build type not informed.";
        return 1;
    fi;

    case "${build_type}" in
        "debug")
            build_debug;
            build_result=${?};
            if [ ${build_result} -ne 0 ];
            then
                print_error_message "Error while building for debug.";
                return 1;
            fi;
            ;;

        "release")
            build_release;
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

    return 0;
}

build ${@};
exit ${?};
