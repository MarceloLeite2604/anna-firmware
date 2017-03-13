#!/bin/bash

# The objective of this script is to test process functions.
#
# Version: 0.1
# Author: Marcelo Leite

# Loads process functions script.
source "$(dirname ${BASH_SOURCE})/../../../scripts/process/functions.sh";

# Tests "start_process" function.
test_start_process() {
    echo "Testing function \"start_process\".";

    # Executes function with invalid paramters.
    start_process;
    start_process invalid arguments;

    # Executes function with valid parameters.
    local process_id;
    local result;

    local process_command="ls -la > /dev/null";
    process_id=$(start_process "${process_command}");
    result=${?};
    echo "Function \"start_process\" executing command \"${process_command}\" returned \"${process_id}\" and its result is \"${result}\".";

    
    local process_command="invalid command";
    process_id=$(start_process "${process_command}");
    result=${?};
    echo "Function \"start_process\" executing command \"${process_command}\" returned \"${process_id}\" and its result is \"${result}\".";

    echo -e "Tests of function \"start_process\" concluded.\n";
}

set_log_level ${log_message_type_trace};

# TODO: Modify "test_start_process" to comply with new parameters.
test_start_process;
# TODO: Test "check_process_is_alive" function.
# TODO: Test "create_process_id_file_path" function.
# TODO: Test "save_process_id" function.
