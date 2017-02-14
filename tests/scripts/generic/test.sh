#!/bin/bash

# The objective of this script is to test the generic functions created.
#
# Version: 0.1
# Author: Marcelo Leite

# Loads generic functions script.
source "$(dirname ${BASH_SOURCE})/../../../scripts/generic/functions.sh";

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

set_log_level ${log_message_type_trace};

test_get_current_time;
test_get_current_time_formatted;
test_find_program;
