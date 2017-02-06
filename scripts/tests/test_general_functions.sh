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

test_get_current_time;
test_get_current_time_formatted;
