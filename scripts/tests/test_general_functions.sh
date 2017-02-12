#!/bin/bash

# The objective of this script is to test general functions written on "general_functions.sh" script.
#
# Version: 0.1
# Author: Marcelo Leite

# Loads script with general functions.
source $(dirname ${BASH_SOURCE})/../general_functions.sh;

# Tests "get_current_time" function.
test_get_current_time(){
    echo "Testing function \"get_current_time\".";

    # Executes function with invalid arguments.
    get_current_time 0;
    get_current_time "a" "b";
    get_current_time those are invalid parameters;

    # Executes function with valid arguments.
    echo "Current time is: $(get_current_time)";

    echo -e "Tests of function \"get_current_time\" concluded.\n";
}

# Tests "get_current_time_formatted" function.
test_get_current_time_formatted(){
    echo "Testing function \"get_current_time_formatted\".";

    # Executes function with invalid arguments.
    get_current_time_formatted 0;
    get_current_time_formatted "a" "b";
    get_current_time_formatted those are invalid parameters;

    # Executes function with valid arguments.
    echo "Current time formatted is: $(get_current_time_formatted)";

    echo -e "Tests of function \"get_current_time_formatted\" concluded.\n";
}

# Tests "check_file_exists" function.
test_check_file_exists(){
    echo "Testing function \"check_file_exists\".";

    local readonly root_test_directory="/tmp/projeto-anna/tests/check_file_exists/";
    local readonly valid_file="${root_test_directory}valid_file";
    local readonly invalid_file="${root_test_directory}invalid_file";

    if [ ! -d "${root_test_directory}" ];
    then
        echo "Directory \"${root_test_directory}\" does not exist.";
        mkdir -p "${root_test_directory}";
        echo "Directory \"${root_test_directory}\" created.";
    else
        echo "Directory \"${root_test_directory}\" already exists.";
    fi;

    if [ ! -f "${valid_file}" ];
    then
        echo "File \"${valid_file}\" does not exist.";
        touch "${valid_file}";
        echo "File \"${valid_file}\" created.";
    else
        echo "File \"${valid_file}\" already exists.";
    fi;

    # Executes function with invalid parameters.
    check_file_exists;
    check_file_exists invalid parameters;

    # Executes function with valid parameters.
    check_file_exists ${valid_file};
    echo "Check a valid file returned \"$?\".";

    check_file_exists ${invalid_file};
    echo "Check an invalid file returned \"$?\".";

    echo -e "Tests of function \"check_file_exists\" concluded.\n";
}

# Tests "check_write_permission" function.
test_check_write_permission(){
    echo "Testing function \"check_write_permission\".";

    local readonly root_test_directory="/tmp/projeto-anna/tests/check_write_permission/";
    local readonly writeable_file="${root_test_directory}writeable_file";
    local readonly unwriteable_file="${root_test_directory}unwriteable_file";

    if [ ! -d "${root_test_directory}" ];
    then
        echo "Directory \"${root_test_directory}\" does not exist.";
        mkdir -p "${root_test_directory}";
        echo "Directory \"${root_test_directory}\" created.";
    else
        echo "Directory \"${root_test_directory}\" already exists.";
    fi;

    if [ ! -f "${writeable_file}" ];
    then
        echo "File \"${writeable_file}\" does not exist.";
        touch "${writeable_file}";
        echo "File \"${writeable_file}\" created.";
    else
        echo "File \"${writeable_file}\" already exists.";
    fi;

    if [ ! -f "${unwriteable_file}" ];
    then
        echo "File \"${unwriteable_file}\" does not exist.";
        touch "${unwriteable_file}";
        echo "File \"${unwriteable_file}\" created.";
    else
        echo "File \"${unwriteable_file}\" already exists.";
    fi;

    chmod u-w "${unwriteable_file}";

    # Executes function with invalid parameters.
    check_write_permission;
    check_write_permission invalid parameters;

    # Executes function with valid parameters.
    check_write_permission ${writeable_file};
    echo "Check a writeable file returned \"$?\".";

    check_write_permission ${unwriteable_file};
    echo "Check an unwriteable file returned \"$?\".";

    echo -e "Tests of function \"check_write_permission\" concluded.\n";
}

# Tests "check_read_permission" function.
test_check_read_permission(){
    echo "Testing function \"check_read_permission\".";

    local readonly root_test_directory="/tmp/projeto-anna/tests/check_read_permission/";
    local readonly readable_file="${root_test_directory}readable_file";
    local readonly unreadable_file="${root_test_directory}unreadable_file";

    if [ ! -d "${root_test_directory}" ];
    then
        echo "Directory \"${root_test_directory}\" does not exist.";
        mkdir -p "${root_test_directory}";
        echo "Directory \"${root_test_directory}\" created.";
    else
        echo "Directory \"${root_test_directory}\" already exists.";
    fi;

    if [ ! -f "${readable_file}" ];
    then
        echo "File \"${readable_file}\" does not exist.";
        touch "${readable_file}";
        echo "File \"${readable_file}\" created.";
    else
        echo "File \"${readable_file}\" already exists.";
    fi;

    if [ ! -f "${unreadable_file}" ];
    then
        echo "File \"${unreadable_file}\" does not exist.";
        touch "${unreadable_file}";
        echo "File \"${unreadable_file}\" created.";
    else
        echo "File \"${unreadable_file}\" already exists.";
    fi;

    chmod u-r "${unreadable_file}";

    # Executes function with invalid parameters.
    check_read_permission;
    check_read_permission invalid parameters;

    # Executes function with valid parameters.
    check_read_permission ${readable_file};
    echo "Check a readable file returned \"$?\".";

    check_read_permission ${unreadable_file};
    echo "Check an unreadable file returned \"$?\".";

    echo -e "Tests of function \"check_read_permission\" concluded.\n";
}

# Tests "check_file_is_directory" function.
test_check_file_is_directory(){
    echo "Testing function \"check_file_is_directory\".";

    local readonly root_test_directory="/tmp/projeto-anna/tests/check_file_is_directory/";
    local readonly directory="${root_test_directory}directory/";
    local readonly file="${root_test_directory}file";

    if [ ! -d "${root_test_directory}" ];
    then
        echo "Directory \"${root_test_directory}\" does not exist.";
        mkdir -p "${root_test_directory}";
        echo "Directory \"${root_test_directory}\" created.";
    else
        echo "Directory \"${root_test_directory}\" already exists.";
    fi;

    if [ ! -d "${directory}" ];
    then
        echo "Directory \"${directory}\" does not exist.";
        mkdir -p "${directory}";
        echo "Directory \"${directory}\" created.";
    else
        echo "Directory \"${directory}\" already exists.";
    fi;

    if [ ! -f "${file}" ];
    then
        echo "File \"${file}\" does not exist.";
        touch "${file}";
        echo "File \"${file}\" created.";
    else
        echo "File \"${file}\" already exists.";
    fi;

    # Executes function with invalid parameters.
    check_file_is_directory;
    check_file_is_directory invalid parameters;

    # Executes function with valid parameters.
    check_file_is_directory ${directory};
    echo "Check a directory returned \"$?\".";

    check_file_is_directory ${file};
    echo "Check a file returned \"$?\".";

    echo -e "Tests of function \"check_file_is_directory\" concluded.\n";
}

# Tests "read_file" function.
test_read_file(){
    echo "Testing function \"read_file\".";

    local readonly root_test_directory="/tmp/projeto-anna/tests/read_file/";
    local readonly file="${root_test_directory}file_to_read";

    if [ ! -d "${root_test_directory}" ];
    then
        echo "Directory \"${root_test_directory}\" does not exist.";
        mkdir -p "${root_test_directory}";
        echo "Directory \"${root_test_directory}\" created.";
    else
        echo "Directory \"${root_test_directory}\" already exists.";
    fi;

    if [ ! -f "${file}" ];
    then
        echo "File \"${file}\" does not exist.";
        touch "${file}";
        echo "File \"${file}\" created.";
    else
        echo "File \"${file}\" already exists.";
    fi;

    echo "This content should be read." > "${file}";

    # Executes function with invalid parameters.
    read_file;
    read_file invalid parameters;

    # Executes function with valid parameters.
    read_file "invalid file path";
    local result=$?;
    echo "Result returned when an invalid file was read: ${result}";

    read_file "${root_test_directory}";
    echo "Result returned when a directory was informed: ${result}";

    local readonly content_read=$(read_file "${file}");
    local result=$?;
    echo "Result returned when an valid file was read: ${result}";
    echo "Content read from \"${file}\" is \"${content_read}\".";


    echo -e "Tests of function \"check_file_is_directory\" concluded.\n";
}

# Tests "find_program" function.
test_find_program(){
    echo "Testing function \"find_program\".";

    # Executes function with invalid parameters.
    find_program;
    find_program invalid parameters;

    # Executes function with valid parameters.
    local program="vim";
    local result;
    path_to_program=$(find_program "${program}");
    result=${?};
    echo "Program \"${program}\" returned the path \"${path_to_program}\" and it's result was \"${result}\".";

    local program="invalid_program";
    path_to_program=$(find_program "${program}");
    result=${?};
    echo "Program \"${program}\" returned the path \"${path_to_program}\" and it's result was \"${result}\".";

    echo -e "Tests of function \"find_program\" concluded.\n";
}

# Tests "create_pipe_file" function.
test_create_pipe_file(){
    echo "Testing function \"create_pipe_file\".";

    local readonly root_test_directory="/tmp/projeto-anna/tests/create_pipe_file/";
    local readonly pipe_file="${root_test_directory}pipe_file";
    local readonly invalid_pipe_file="${root_test_directory}invalid_path/invalid_pipe_file";

    if [ ! -d "${root_test_directory}" ];
    then
        echo "Directory \"${root_test_directory}\" does not exist.";
        mkdir -p "${root_test_directory}";
        echo "Directory \"${root_test_directory}\" created.";
    else
        echo "Directory \"${root_test_directory}\" already exists.";
    fi;

    local check_file_exists_result;
    check_file_exists "${pipe_file}";
    check_file_exists_result=${?};

    if [ ${check_file_exists_result} -eq ${success}  ];
    then
        echo "Pipe file \"${pipe_file}\" already exists.";
        rm -rf "${pipe_file}";
        echo "Pipe file \"${pipe_file}\" removed.";
    fi;

    # Executes function with invalid paramters.
    create_pipe_file;
    create_pipe_file invalid parameters;

    # Executes function with valid parameters.
    local result;
    create_pipe_file "${pipe_file}";
    result=${?};
    echo "Creation of pipe file \"${pipe_file}\" returned with value \"${result}\".";

    create_pipe_file "${pipe_file}";
    result=${?};
    echo "Recreation of pipe file \"${pipe_file}\" returned with value \"${result}\".";

    create_pipe_file "${invalid_pipe_file}";
    result=${?};
    echo "Creation of invalid pipe file \"${invalid_pipe_file}\" returned with value \"${result}\".";

    echo -e "Tests of function \"create_pipe_file\" concluded.\n";
}

# Tests "check_file_is_pipe" function.
test_check_file_is_pipe() {
    echo "Testing function \"check_file_is_pipe\".";

    local readonly root_test_directory="/tmp/projeto-anna/tests/check_file_is_pipe/";
    local readonly pipe_file="${root_test_directory}pipe_file";
    local readonly common_file="${root_test_directory}common_file";

    if [ ! -d "${root_test_directory}" ];
    then
        echo "Directory \"${root_test_directory}\" does not exist.";
        mkdir -p "${root_test_directory}";
        echo "Directory \"${root_test_directory}\" created.";
    else
        echo "Directory \"${root_test_directory}\" already exists.";
    fi;

    if [ ! -f "${pipe_file}" ];
    then
        echo "Pipe file \"${pipe_file}\" does not exist.";
        create_pipe_file "${pipe_file}";
        echo "Pipe file \"${pipe_file}\" created.";
    else
        echo "Pipe file \"${pipe_file}\" already exists.";
    fi;

    if [ ! -f "${common_file}" ];
    then
        echo "File \"${common_file}\" does not exist.";
        touch "${common_file}";
        echo "File \"${common_file}\" created.";
    else
        echo "File \"${common_file}\" already exists.";
    fi;

    # Executes function with invalid parameters.
    check_file_is_pipe;
    check_file_is_pipe invalid parameters;

    # Executes function with valid parameters.
    local result;
    check_file_is_pipe "${pipe_file}";
    result=${?};
    echo "Check if pipe file \"${pipe_file}\" is a pipe returned \"${result}\".";

    check_file_is_pipe "${common_file}";
    result=${?};
    echo "Check if pipe file \"${common_file}\" is a pipe returned \"${result}\".";

    echo -e "Tests of function \"check_file_is_pipe\" concluded.\n";
}

set_log_level ${log_message_type_trace};

test_get_current_time;
test_get_current_time_formatted;
test_check_file_exists;
test_check_write_permission;
test_check_read_permission;
test_check_file_is_directory;
test_read_file;
test_find_program;
test_create_pipe_file;
test_check_file_is_pipe;
