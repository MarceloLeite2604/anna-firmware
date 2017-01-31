#!/bin/bash

# Load configuration file.
. ./configuration.sh

# Load constants used by log funcionts..
. ./log_constants.sh

# Load general functions.
. ./general_functions.sh

# Log file location.
log_file_location="";

# Indicates if the log file creation was successful.
log_file_creation_result=${not_executed};

# Writes a warning message on stderr using "echo" program.
#
# Parameters:
#   1 - Message to be written.
#
# Returns:
#   The output code returned from "echo".
echo_warn() {
    local readonly result=$(>&2 echo "$warn_preffix $@");
    return ${result};
}

# Writes an error message on stderr using "echo" program.
#
# Parameters:
#   1 - Message to be written.
#
# Returns:
#   The output code returned from "echo".
echo_info() {
    local readonly result=$(>&2 echo "$info_preffix $@");
    return ${result};
}


# Writes an information message on stderr using "echo" program.
#
# Parameters:
#   1 - Message to be written.
#
# Returns:
#   The output code returned from "echo".
echo_error() {
    local readonly result=$(>&2 echo "$error_preffix $@");
    return ${result};
}


# Creates a log filename based on preffix informed and current time.
#
# Parameters:
#	1 - Log file preffix.
#
# Returns:
#	The log file name created.
create_log_file_name() {
	
	if [ $# -eq 0 ];
	then
	    echo_error ${FUNCNAME[0]} $LINENO "Log file preffix not informed.";
        log_file_location="";
        log_file_creation_result=${general_failure};
        return ${general_failure};
    else
        local log_file_preffix="$1";
    fi;
    
    local log_file_name="${log_file_preffix}_$(get_current_time_formatted).${log_file_suffix}";
    
    echo "$log_file_name";
    
    return ${success};
}

# Creates the log file.
#
# Parameters:
#	None.
#
# Returns:
#	0 - If log file was created.
#  -1 - Otherwise.
create_log_file() {
	
	if [ $# -eq 0 ];
	then
	    echo_error ${FUNCNAME[0]} $LINENO "Preffix not informed.";
        log_file_location="";
        log_file_creation_result=${general_failure};
        return ${general_failure};
    else
        local readonly log_file_preffix="$1";
    fi;
    
    local readonly log_file_name=$(create_log_file_name $log_file_preffix);
    
    log_file_location=${log_path}${log_file_name};
    
    # If log file does not exist.
    if [ ! -f ${log_file_location} ];
    then
        # If log folder path does not exists.
        if [ ! -d ${log_path} ];
        then
        
            # Creates log folder path.
            mkdir -p ${log_path};
            
            # If, after the creaton command, the folder does not exists.
            if [ ! -d ${log_path} ];
            then
        	    echo_error ${FUNCNAME[0]} $LINENO "Could not create path \"${log_path}\".";
                log_file_location="";
                log_file_creation_result=${general_failure};
                return ${general_failure};
            fi;
        fi;
    
        # Creates the log file.
        touch ${log_file_location};
        
        # If, after creation, the file is still missing.
        if [ ! -f ${log_file_location} ];
        then
            echo_error "Could not create log file \"${log_file_location}\"."
            echo_error "Log messages will be redirected to \"stderr\"."
            log_file_location="";
            log_file_creation_result=${general_failure};
            return ${general_failure};
        fi;
    fi;
    
    log_file_creation_result=${success};
    return ${success};
}

# Writes a message on log file.
#
# Parameters:
#   1 - Message to be written.
#
# Returns:
#    0 - If message was correctly written.
#   -1 - Otherwise.
write_log_message() {

    if [ $# -ne 1 ];
    then
        echo_error "Not enough parameters to execute \"${FUNCNAME[0]}\" function.";
        return ${general_failure};
    else
        local message="[$(date +"%Y/%m/%d %H:%M:%S")] - $1";
    fi;
    
    # If log file location is not specified.
    if [ -z ${log_file_location+x} ];
    then
        # If log file creation was not executed.
        if [ $log_file_creation_result -eq $not_executed ];
        then
            # Creates log file.
            create_log_file "undefined";
            
            # If there was an error on log creation.
            if [ $? -ne $success ];
            then
                # Print message on stderror.
                echo_error $message;
            fi;
            
        # If log file creation was previously executed with failure.
        else
            # Print message on stderror.
            echo_error $message;
        fi;
    
    else
        # Print message on log file.    
        echo "${message}" >> ${log_file_location};
    fi;
}

# Register a warning message on log file.
#
# Parameters:
#   1 - Message identification.
#   2 - Message index (e. g. line number).
#   3 - Message to be registered.
#
# Results:
#   This function retuns the result obtained from "log" function.
log_warn() {

    if [ $# -lt 3 ];
    then
        echo_error "Not enough parameters to execute \"${FUNCNAME[0]}\" function.";
        return ${general_failure};
    fi;

    local readonly message_identification=$1;
    local readonly message_index=$2;
    shift 2;
    local readonly message=$(format_log_message ${message_identification} ${message_index} ${warn_preffix} $@);
    local result="";
    
    if [ $? -ne ${success} ];
    then
        result=$?;
        echo_warn "${message_identification} ${message_index} $@";
    else
        write_log_message "${message}";    
        result=$?;
    fi;
    
    return ${result};
};

# Register an error message on log file.
#
# Parameters:
#   1 - Message identification.
#   2 - Message index (e. g. line number).
#   3 - Message to be registered.
#
# Results:
#   This function retuns the result obtained from "log" function.
log_error() {

    if [ $# -lt 3 ];
    then
        echo_error "Not enough parameters to execute \"${FUNCNAME[0]}\" function.";
        return ${general_failure};
    fi;

    local readonly message_identification=$1;
    local readonly message_index=$2;
    shift 2;
    local readonly message=$(format_log_message ${message_identification} ${message_index} ${error_preffix} $@);
    local result="";
    
    if [ $? -ne ${success} ];
    then
        result=$?;
        echo_error "${message_identification} ${message_index} $@";
    else
        write_log_message "${message}";    
        result=$?;
    fi;
    
    return ${result};
};

# Register an error message on log file.
#
# Parameters:
#   1 - Message identification.
#   2 - Message index (e. g. line number).
#   3 - Message to be registered.
#
# Returns:
#   This function retuns the result obtained from "log" function.
log() {

    if [ $# -lt 3 ];
    then
        echo_error "Not enough parameters to execute \"${FUNCNAME[0]}\" function.";
        return ${general_failure};
    fi;

    local readonly message_identification=$1;
    local readonly message_index=$2;
    shift 2;
    local readonly message=$(format_log_message ${message_identification} ${message_index} ${info_preffix} $@);
    local result="";
    
    if [ $? -ne ${success} ];
    then
        result=$?;
        echo_info "${message_identification} ${message_index} $@";
    else
        write_log_message "${message}";    
        result=$?;
    fi;
    
    return ${result};
};

# Formats a message to be registered.
#
# Parameters:
#   1     - Message identification.
#   2     - Message index (e. g. line number).
#   3     - Message preffix type.
#   4 ... - Message to be registered.
#
# Returns:
#   Returns the message formatted to be registered on log.
format_log_message() {
    
    if [ $# -lt 3 ];
    then
        error_echo "Not enough parameters to execute function \"${FUNCNAME[0]}\".";
        return ${general_failure};
    fi;
    
    local readonly message_identification=$1;
    local readonly message_index=$2;
    local readonly message_preffix=$3
    shift 3;
    local readonly message="[$message_identification, $message_index] $message_preffix $@";
    
    echo ${message};
    return ${success};
}

# Check is a log file is defined.
#
# Parameters:
#   None.
#
# Result:
#  0 - If the is no log file defined.
#  1 - If the log file is defined.
check_log_file(){
    local result=0;
    
    if [ ! -z ${log_file_location} ] && [ ${log_file_creation_result} -eq ${success} ];
    then
        result=1;
    fi;
    
    return ${result};
};
