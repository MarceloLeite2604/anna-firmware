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

set_log_level ${log_message_type_trace};

test_get_current_time;
test_get_current_time_formatted;
test_check_file_exists;
test_check_write_permission;
test_check_read_permission;
test_check_file_is_directory;
test_read_file;
