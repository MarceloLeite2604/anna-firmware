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

test_get_current_time;
