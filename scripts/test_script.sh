#!/bin/bash

new_line() {
    echo "";
};

load_file() {
    local readonly file="$1";
    echo "Loading \"${file}\".";
    . ${file};
};

check_variable() {
    local readonly variable_name="$1";
    local readonly variable_value=${!variable_name};
    echo "${variable_name}=$variable_value";
};

check_function() {
    local readonly function="$1";
    local readonly command="$@";
    local readonly result=$($command);
    local readonly return_value=$?;
    
    echo "Command \"${command}\" returned ${return_value}.";
    if [ -n "${result}" ];
    then
        echo "Result obtained: \"${result}\".";
    fi;
    
    new_line;
};


# Load configuration file.
load_file "./configuration.sh";
check_variable "company";
check_variable "project";
check_variable "root_path";
check_variable "not_executed";
check_variable "success";
check_variable "general_failure";
check_variable "directory_structure";
new_line;

# Load general functions.
load_file "./general_functions.sh";
check_function "get_current_time_formatted";
new_line;

# Load log constants.
load_file "./log_constants.sh";
check_variable "log_file_suffix";
check_variable "log_path";
check_variable "error_preffix";
check_variable "info_preffix";
new_line

# Load log functions.
load_file "./log_functions.sh";
check_function "echo_error Ignore this message";
check_function "echo_info Ignore this message";
check_function "echo_warn Ignore this message";
check_function "create_log_file_name test_scripts";
check_function "create_log_file test_scripts";
check_log_file;

create_log_file test_scripts
log ${BASH_SOURCE} $LINENO This is an info message;
log_error ${BASH_SOURCE} $LINENO This is an error message;
log_warn ${BASH_SOURCE} $LINENO This is a warning message;
new_line;

# Load trace functions.
load_file "./trace_functions.sh";
