#!/bin/bash

# Load configurations file.
. ./configuration.sh

# Load log functions.
. ./log_functions.sh

# Indicates if trace is enable during execution.
trace_enabled=0;

# Enables or disables execution with trace.
#
# Parameters:
#   1 - If this parameter contains "1", trace will be enabled. Otherwise trace
#       will be disabled.
#
# Returns:
#    0 - If trace was activated or deactivated correctly. 
#   -1 - Otherwise.
enable_trace() {
    
    if [ $# -ne 1 ];
    then
        log_error "Not enough parameters to execute \"${FUNCNAME[0]}\" function.";
        return ${general_failure};
    fi;
    
    if [ $1 -eq 1 ];
    then
        trace_enabled=1;
    else
        trace_enabled=0;
    fi;
    
    return ${success};
}


# Register a trace point on log file.
#
# Parameters:
#   1     - Trace index (e. g. line number).
#   2 ... - Message to be registered. (optional)
#
# Returns:
#   0 - If message was recorded sucessfully.
#  -1 - Otherwise.
trace() {

    if [ $# -lt 1 ];
    then
        echo_error "Not enough parameters to execute \"${FUNCNAME[0]}\" function.";
        return ${general_failure};
    fi;

    local readonly trace_identification=${FUNCNAME[1]};
    local readonly trace_index=$1;
    shift 1;
    local readonly message=$(format_log_message ${trace_identification} ${trace_index} ${trace_preffix} $@);
    local result="";
    
    if [ $? -ne ${success} ];
    then
        result=$?;
        echo_error "${trace_identification} ${trace_index} $@";
    else
        write_log_message "${message}";    
        result=$?;
    fi;
    
    return ${result};
};
