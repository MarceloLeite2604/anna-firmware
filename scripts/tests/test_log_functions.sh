#!/bin/bash

# The objective os this script is to teste functions created on "log_functions.sh" file.

# Load "log_functions.sh" file.
. ../log_functions.sh

# Test function "write_stderr".
test_write_stderr(){
    echo "Testing function \"write_stderr\".";
    # Executes function without an argument.
    write_stderr;

    # Executes function with a single argument.
    write_stderr "test";

    # Executes function with a single argument with space in its content.
    write_stderr "this is a test.";

    # Executes function with multiple arguments.
    write_stderr this is a test with multiple arguments.

    echo -e "Tests of function \"write_stderr\" concluded.\n";
}

# Test function "write_on_file".
test_write_on_file(){
    echo "Testing function \"write_on_file\".";

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

    echo -e "Tests of function \"write_on_file\" concluded.\n";
}

# Test "create_log_file_name" function.
test_create_log_file_name(){
    echo "Testing function \"create_log_file_name\".";

    # Executes function with invalid parameters.
    create_log_file_name;
    create_log_file_name a b;

    # Executes function with valid parameters.
    local readonly temporary_log_file_name="$(create_log_file_name "test")";
    echo "Log file name created: \"${temporary_log_file_name}\".";

    echo -e "Tests of function \"create_log_file_name\" concluded.\n";
}

# Teste "create_log_file" and "finish_log_file" function.
test_create_log_file(){
    echo "Testing functions \"create_log_file\" and \"finish_log_file\".";

    # Executes "create_log_file" function with invalid parameters.
    create_log_file;
    create_log_file "invalid" "test";

    # Executes "create_log_file" function with valid parameters.
    create_log_file "test_log_functions";
    echo -e "\nChecking log file location.";
    ls -la ${log_file_location};
    echo -e "Done.\n";

    # Executes "finish_log_file" with invalid parameters.
    finish_log_file "invalid parameter";

    local readonly temporary_log_file_location=${log_file_location};

    # Executes "finish_log_file" with valid parameters. Also, a log file should be open, so this execution will close it.
    finish_log_file;

    # Executes "finish_log_file" again, but this time an error should be returned once there is no log file opened.
    finish_log_file;

    # Checks log file content.
    echo -e "\nChecking log file \"${temporary_log_file_location}\" content.";
    cat ${temporary_log_file_location};
    echo -e "Done.\n";

    echo -e "Tests of functions \"create_log_file\" and \"finish_log_file\" concluded.\n";
}

# Test "write_log_message" function.
test_write_log_message(){
    echo "Testing function \"write_log_message\".";

    create_log_file "test_write_log_message";

    #Executes function with invalid parameters.
    write_log_message;
    write_log_message "test" 1;
    write_log_message These parameters are invalid;

    # Executes function with valid parameters.
    write_log_message "This message should be written on log file."

    local readonly temporary_log_file_location=${log_file_location};

    finish_log_file;

    echo -e "\nChecking content of file \"${temporary_log_file_location}\".";
    cat ${temporary_log_file_location};
    echo -e "End of content.\n";


    echo -e "Tests of functions \"write_log_message\" concluded.\n";
}

# Test "set_log_level" function.
test_set_log_level(){
    echo "Testing function \"set_log_level\".";

    create_log_file "test_set_log_level";

    # Executes function with invalid arguments.
    set_log_level;
    set_log_level 0;
    set_log_level "a";
    set_log_level invalid arguments;

    # Executes function with valid arguments.
    local readonly original_log_level=${log_level};
    echo "Original log level: ${original_log_level}.";

    echo "Changing to level: ${type_trace}.";
    set_log_level ${type_trace};
    echo "New log level: ${log_level}.";
    trace "This message should be logged.";
    log $type_warning "This message should be logged.";
    log $type_error "This message should be logged.";

    echo "Changing to level: ${type_warning}.";
    set_log_level ${type_warning};
    echo "New log level: ${log_level}.";
    trace "This message should not be logged.";
    log $type_warning "This message should be logged.";
    log $type_error "This message should be logged.";

    echo "Changing to level: ${type_error}.";
    set_log_level ${type_error};
    echo "New log level: ${log_level}.";
    trace "This message should not be logged.";
    log $type_warning "This message should not be logged.";
    log $type_error "This message should be logged.";

    echo "Returning to original log level.";
    set_log_level ${original_log_level};

    finish_log_file;

    echo -e "Tests of functions \"write_log_message\" concluded.\n";
}
# Test "log" function
test_log(){
    echo "Testing function \"log\".";

    create_log_file "test_log";

    echo "Original log level: ${log_level}.";
    set_log_level ${type_trace};
    echo "New log level: ${log_level}.";

    #Executes function with invalid parameters.
    log;
    log 0;
    log $type_error;
    log $type_warning;
    log $type_error "test" 1;

    # Executes function with valid parameters.
    log $type_trace;
    log $type_trace "This message should be written on log file."
    log $type_warning "This warning message should be written on log file."
    log $type_error "This error message should be written on log file."

    local readonly temporary_log_file_location=${log_file_location};

    finish_log_file;

    echo -e "\nChecking content of file \"${temporary_log_file_location}\".";
    cat ${temporary_log_file_location};
    echo -e "End of content.\n";

    echo -e "Tests of functions \"write_log_message\" concluded.\n";
}

# Tests "trace" function.
test_trace(){
    echo "Testing function \"trace\".";

    # Executes function with invalid parameters.
    trace "invalid" "parameters";

    # Executes function with valid parameters.
    trace;
    trace "This trace message should be logged.";

    echo -e "\n\"${log_file_location}\" content:";
    cat ${log_file_location};
    echo -e "End of content.\n";

    echo -e "Tests of function \"trace\" concluded.\n";
}

test_write_stderr;
test_write_on_file;
test_create_log_file_name;
test_create_log_file;
test_set_log_level;
#test_write_log_message;
#test_log;
#test_trace;
