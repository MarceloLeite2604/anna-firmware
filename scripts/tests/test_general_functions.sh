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

# Tests "check_directory_permissions" function.
test_check_directory_permissions(){
    echo "Testing function \"check_directory_permissions\".";

    # local readonly root_test_directory="$(dirname ${BASH_SOURCE})/../../tests/check_directory_permissions/";
    local readonly root_test_directory="/tmp/projeto-anna/tests/check_directory_permissions/";

    local readonly invalid_directory="${root_test_directory}tests/invalid_directory/";
    local readonly unwritable_directory="${root_test_directory}unwritable_directory/";
    local readonly unreadable_directory="${root_test_directory}unreadable_directory/";

    if [ ! -d "${root_test_directory}" ];
    then
        echo "Directory \"${root_test_directory}\" does not exist.";
        mkdir -p "${root_test_directory}";
        echo "Directory \"${root_test_directory}\" created.";
    else
        echo "Directory \"${root_test_directory}\" already exists.";
    fi;

    if [ ! -d "${unwritable_directory}" ];
    then
        echo "Directory \"${unwritable_directory}\" does not exist.";
        mkdir -p "${unwritable_directory}";
        echo "Directory \"${unwritable_directory}\" created.";
    else
        echo "Directory \"${unwritable_directory}\" already exists.";
    fi;

    chmod u-w "${unwritable_directory}";

    if [ ! -d "${unreadable_directory}" ];
    then
        echo "Directory \"${unreadable_directory}\" does not exist.";
        mkdir -p "${unreadable_directory}";
        echo "Directory \"${unreadable_directory}\" created.";
    else
        echo "Directory \"${unreadable_directory}\" already exists.";
    fi;

    chmod u-r "${unreadable_directory}";

    # Executes function with invalid parameters.
    check_directory_permissions;
    check_directory_permissions invalid parameters;

    # Executes function with valid parameters.
    check_directory_permissions "${root_test_directory}";

    # Executes function with valid parameters, but an invalid path
    check_directory_permissions "this is not a valid path";

    # Executes function informing an invalid path.
    check_directory_permissions "${invalid_directory}";

    # Executes function informing an unwritable directory.
    check_directory_permissions "${unwritable_directory}";

    # Executes function informing an unreadable directory.
    check_directory_permissions "${unreadable_directory}";
    
    echo -e "Tests of function \"check_directory_permissions\" concluded.\n";
}

set_log_level ${log_message_type_trace};

test_get_current_time;
test_get_current_time_formatted;
test_check_directory_permissions;
