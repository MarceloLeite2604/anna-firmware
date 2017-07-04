#!/bin/bash

# This script creates the additional directories required to execute the system.
#
# Parameters:
#   1. The directory which the additional directories will be created on.
#
# Version:
#   0.1
#
# Author:
#   Marcelo Leite

# Names of the additional directories required to execute the system.
readonly additional_directories_name="audio logs pids temporary";

# Creates the additional directories required to execute the system.
#
# Parametes:
#   1. The directory which the additional directories will be created on.
#
# Returns:
#   0 - If the additional directories were created successfully.
#   1 - Otherwise.
create_additional_directories() {

    local base_directory;
    local mkdir_result;

    if [ ${#} -ne 1 ];
    then
        >&2 echo "Invalid parameters informed to create the additional directories.";
        return 1;
    else
        base_directory="${1}";
    fi;

    # Adds the ending forward slash on base directory if it does not have it.
    if [[ ${base_directory} != */ ]];
    then
        base_directory="${base_directory}/";
    fi;

    # Checks if base directory exists.
    if [ ! -d "${base_directory}" ];
    then
        >&2 echo "Directory \"${base_directory}\" does not exist.";
        return 1;
    fi;

    # Creates each of the additional directories.
    for directory_name in "${additional_directories_name}";
    do
        mkdir ${base_directory}${directory_name};
        mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            >&2 echo "Error creating additional directory \"${directory_name}\" on \"${base_directory}\".";
            return 1;
        fi;
    done;

    return 0;
}

create_additional_directories ${@};
exit ${?};
