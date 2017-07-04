#!/bin/bash

# This script creates the objects of all source files in the project.
#
# Version:
#   0.1
#
# Parameters:
#   1. Path to the source files' root directory.
#   2. Path to directory where the objects will be stored.
#   3. Additional arguments to inform on object creation.
#
# Author:
#   Marcelo Leite
#

# Preffix used to identify error messages.
if [ -z "${error_messages_preffix}" ];
then
    readonly error_message_preffix="[ERROR]:";
fi;

# Prints an error message.
#
# Parameters:
#   1. The error message to print.
#
# Returns:
#   The result of this method is always 0.
print_error_message() {

    local error_message;

    if [ ${#} -ge 1 ];
    then
        error_message="${1}";
        >&2 echo "${error_message_preffix} ${error_message}";
    fi;

    return 0;
}

# Creates a directory.
#
# Parameters:
#   1. Path to directory to create.
#
# Returns:
#   0 - If directory was created successfully.
#   1 - Otherwise.
#
create_directory() {

    local directory;
    local mkdir_result;

    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else
        directory="${1}";
    fi;

    if [ ! -d "${directory}" ];
    then
        echo -e "Creating directory \"${directory}\".";
        mkdir -p "${directory}";
        local mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "Error creating directory \"${directory}\" (${mkdir_result}).";
            return 1;
        fi;
    fi;

    return 0;
}

# Create an object from a source file.
#
# Parameters:
#   1. The input source file path.
#   2. The output object file path.
#   3. The additional arguments for compilation.
#
# Returns:
#   0 - If object was created successfully.
#   1 - Otherwise.
#
create_object() {

    local source_file;
    local object_file;
    local object_name;
    local dependencies;
    local additional_arguments;
    local gcc_result;

    if [ ${#} -lt 2 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else
        source_file="${1}";
        object_file="${2}";
        additional_arguments="${3}";
    fi;

    object_name=$(basename ${object_file});
    object_name=${object_name%%.*};

    echo -e "Creating \"${object_name}\" object.";
    gcc -c ${source_file} -o ${object_file} ${dependencies} ${additional_arguments};
    gcc_result=${?};
    if [ ${gcc_result} -ne 0 ];
    then
        print_error_message "Error creating \"${object_name}\" object.";
        return 1;
    fi;

    return 0;
}

# Prints this script usage
#
# Parameters:
#   None.
#
# Returns:
#  0 - Any case.
print_usage(){
    echo -e "Use this script to create objects for all source files.\n";
    echo -e "Usage:";
    echo -e "\t$(basename ${0}) {source file root directory} {object files directory} [additional arguments]";
    echo -e "Where:";
    echo -e "\tsource file root directory - Path to the root directory where source files are stored.";
    echo -e "\tobject files directory - Path to the directory where the object files created will be stored.";
    echo -e "\tadditional arguments - Additional arguments used on source files compilation.\n";
    return 0;
}


# Create objects for all source files in project.
#
# Parameters:
#   1. Path to the source files' root directory.
#   2. Path to directory where the objects will be stored.
#   3. Additional arguments to inform on object creation (optional).
#
# Returns:
#   0 - If all object files were created successfully.
#   1 - Otherwise.
#
create_objects() {

    local source_files_root_directory;
    local source_files;
    local objects_directory;
    local object_name;
    local object_file;
    local object_file_path;
    local additional_arguments;
    local create_object_result;

    if [ ${#} -lt 2 ];
    then
        print_usage;
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else
        source_files_root_directory="${1}";
        objects_directory="${2}";
        additional_arguments="${3}";
    fi;

    create_directory "${objects_directory}";

    source_files=$(find ${source_files_root_directory} -name \*.c | xargs echo);

    for source_file in ${source_files};
    do
        object_file="$(basename "${source_file}")";
        object_file="${object_file%%.*}.o";
        object_file_path="${objects_directory}${object_file}";

        create_object "${source_file}" "${object_file_path}" "${additional_arguments}";
        create_object_result=${?};
        if [ ${create_object_result} -ne 0 ];
        then
            print_error_message "Error creating object for \"${source_file}\" source file.";
            return 1;
        fi;
    done;
    
    return 0;
}

create_objects ${@};
exit ${?};
