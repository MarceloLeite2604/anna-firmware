#!/bin/bash

# The objective os this script is to teste functions created on "log_functions.sh" file.

# Load "log_functions.sh" file.
. ../log_functions.sh

# Test function "write_stderr".
test_write_stderr(){
    # Executes function without an argument.
    write_stderr;

    # Executes function with a single argument.
    write_stderr "test";

    # Executes function with a single argument with space in its content.
    write_stderr "this is a test.";

    # Executes function with multiple arguments.
    write_stderr this is a test with multiple arguments.
}

# Test function "write_on_file".
test_write_on_file(){

    local valid_test_file_path="../../tests/log/test_log_file.log";
    local invalid_test_file_path="../../tests/log/invalid_test_log_file.log";
    local no_access_test_file_path="/tmp/unaccessable_test_log_file.log";

    if [ -f ${valid_test_file_path} ];
    then
        echo "File \"${valid_test_file_path}\" already exists. It will be recreated.";
        rm -f ${valid_test_file_path};
    fi;
    touch ${valid_test_file_path};

    if [ -f ${invalid_test_file_path} ];
    then
        echo "File \"${invalid_test_file_path}\" already exists. It will be recreated.";
        rm -f ${invalid_test_file_path};
    fi;

    if [ -f ${no_access_test_file_path} ];
    then
        echo "File \"${no_access_test_file_path}\" already exists. It will be recreated.";
        rm -f ${no_access_test_file_path};
    fi;
    touch ${no_access_test_file_path};
    chmod u-w ${no_access_test_file_path};

    # Executes function without enough parameters.
    write_on_file;
    write_on_file $valid_test_file_path;

    # Executes function writing on a valid file.
    write_on_file ${valid_test_file_path} "This message should be written correctly."

    # Executes function writing on a invalid file.
    write_on_file ${invalid_test_file_path} "This message should not be written."

    # Executes function on a existing file wich user does not have write permission.
    write_on_file ${no_access_test_file_path} "This message also should not be written.";
}

# Test "create_log_file_name" function.
test_create_log_file_name(){

    # Executes function with invalid parameters.
    create_log_file_name;
    create_log_file_name a b;

    # Executes function with valid parameters.
    create_log_file_name "test";
}

# Teste "create_log_file" function.
test_create_log_file(){

    # Executes function with invalid parameters.
    create_log_file;
    create_log_file "invalid" "test";

    # Executes function with valid parameters.
    create_log_file "test_log_functions";
    ls -la ${log_file_location};
}

# Test "write_log_message" function.
test_write_log_message(){
    # Executes function with invalid parameters.
    write_log_message;
    write_log_message "test" "second parameter";

    # Executes function with valid parameters.
    write_log_message "This message should be written on log file.";
    cat ${log_file_location};

} 

test_write_stderr;
test_write_on_file;
test_create_log_file_name;
test_create_log_file;
test_write_log_message;
