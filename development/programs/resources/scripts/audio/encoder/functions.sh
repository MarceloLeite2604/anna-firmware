#!/bin/bash

# This script contains all functions required to configure, start and stop
# audio encoder process.
#
# Parameters:
#   None.
#
# Return:
#   None.
#
# Version: 
#   0.1
#
# Author:
#   Marcelo Leite
#

# ###
# Include guard.
# ###
if [ -z "${AUDIO_ENCODER_FUNCTIONS_SH}" ];
then
    AUDIO_ENCODER_FUNCTIONS_SH=1;
else
    return;
fi;


# ###
# Script sources.
# ###

# Load audio encoder constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load audio generic functions script.
source "$(dirname ${BASH_SOURCE})/../functions.sh";

# Load process functions script.
source "$(dirname ${BASH_SOURCE})/../../process/functions.sh";

# Load log functions script .
source "$(dirname ${BASH_SOURCE})/../../log/functions.sh";


# ###
# Function elaborations.
# ###

# Creates the audio file name based on current instant.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If audio file name was created successfully.
#   GENERIC_ERROR - Otherwise.
#   It also returns the file name created through "echo".
#
create_audio_file_name() {

    local audio_file_name;

    # Check function parameters.
    if [ ${#} -ne 0 ]
    then
        log ${type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

    # Elaborates the audio file name.
    audio_file_name="${audio_file_preffix}_$(get_current_time_formatted)${audio_file_suffix}";

    # Returns the audio file name through "echo".
    echo "${audio_file_name}";

    return ${success};
}

# Starts the audio encode process.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If audio encode process started successfully.
#   GENERIC_ERROR - Otherwise.
#
start_audio_encoder_process(){

    local audio_encoder_program_path;
    local sample_rate;
    local sample_rate_parameter;
    local bit_width;
    local bit_width_parameter;
    local channel_mode;
    local channel_mode_parameter;
    local encode_quality;
    local encode_quality_parameter;
    local audio_comment;
    local audio_comment_parameter;
    local create_audio_file_name_result;
    local file_output_name;
    local check_file_is_directory_result;
    local check_write_permission_result;
    local output_file_path;
    local output_file_parameter;
    local check_file_exists_result;
    local check_read_permission_result;
    local audio_encoder_log_file;
    local audio_encoder_command;
    local output_file;
    local error_file;
    local start_process_result;

    # Searches for audio encoder program.
    audio_encoder_program_path="$(find_program "${audio_encoder_program}")";

    # Reads input sample rate configuration file.
    sample_rate="$(read_audio_configuration_file "${audio_encoder_sample_rate_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${sample_rate}" ];
    then
        log ${log_message_type_error} "Could not define the input sample rate for audio encoder.";
        return ${generic_error};
    fi;
    sample_rate_parameter="${audio_encoder_sample_rate_parameter} ${sample_rate}";

    # Reads input bit width configuration file.
    bit_width="$(read_audio_configuration_file "${audio_encoder_bit_width_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${bit_width}" ];
    then
        log ${log_message_type_error} "Could not define the input bit width for audio encoder.";
        return ${generic_error};
    fi;
    bit_width_parameter="${audio_encoder_bit_width_parameter} ${bit_width}";

    # Reads the channel mode configuration file.
    channel_mode="$(read_audio_configuration_file "${audio_encoder_channel_mode_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${channel_mode}" ];
    then
        log ${log_message_type_error} "Could not define the channel mode for audio encoder.";
        return ${generic_error};
    fi;
    channel_mode_parameter="${audio_encoder_channel_mode_parameter} ${channel_mode}";

    # Reads the encoding quality configuration file.
    encode_quality="$(read_audio_configuration_file "${audio_encoder_quality_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${encode_quality}" ];
    then
        log ${log_message_type_error} "Could not define the quality audio encoder.";
        return ${generic_error};
    fi;
    encode_quality_parameter="${audio_encoder_quality_parameter} ${encode_quality}";

    # Reads the comment configuration file.
    audio_comment="$(read_audio_configuration_file "${audio_encoder_comment_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${audio_comment}" ];
    then
        log ${log_message_type_error} "Could not define the comment to be written on output file.";
        return ${generic_error};
    fi;
    audio_comment_parameter="${audio_encoder_comment_parameter} \"${audio_comment}\"";

    # Creates the audio file name.
    file_output_name="$(create_audio_file_name)";
    create_audio_file_name_result=${?};
    if [ ${create_audio_file_name_result} -ne ${success} -o -z "${file_output_name}" ];
    then
        log ${log_message_type_error} "Could not define file output name.";
        return ${generic_error};
    fi;

    # Check is audio directory exists.
    check_file_is_directory "${audio_directory}"
    check_file_is_directory_result=${?};
    if [ ${check_file_is_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not locate directory \"${audio_directory}\".";
        return ${generic_error};
    fi;

    # Check if user has permission to write on audio directory.
    check_write_permission "${audio_directory}";
    check_write_permission_result=${?};
    if [ ${check_write_permission_result} -ne ${success} ];
    then
        log ${log_message_type_error} "User \"$(whoami)\" does not have permission to write on \"${audio_directory}\".";
        return ${generic_error};
    fi;

    # Elaborates the output file path parameter.
    output_file_path="${audio_directory}${file_output_name}";
    output_file_parameter="${audio_encoder_output_file_parameter} ${output_file_path}";

    # Check if audio pipe file exists.
    check_file_exists "${audio_pipe_file}"
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not locate pipe file \"${audio_directory}\".";
        return ${generic_error};
    fi;

    # Check if user has read permission on pipe file.
    check_read_permission "${audio_pipe_file}";
    check_read_permission_result=${?};
    if [ ${check_read_permission_result} -ne ${success} ];
    then
        log ${log_message_type_error} "User \"$(whoami)\" does not have permission to read file \"${audio_pipe}\".";
        return ${generic_error};
    fi;

    # Get the current log file path.
    audio_encoder_log_file="$(get_log_path)";

    # Elaborates the command to start audio encoder.
    audio_encoder_command="${audio_encoder_program_path}";
    audio_encoder_command+=" ${audio_encoder_raw_pcm_parameter}";
    audio_encoder_command+=" ${sample_rate_parameter}";
    audio_encoder_command+=" ${bit_width_parameter}";
    audio_encoder_command+=" ${channel_mode_parameter}";
    audio_encoder_command+=" ${encode_quality_parameter}";
    #audio_encoder_command+=" ${audio_comment_parameter}";
    audio_encoder_command+=" ${output_file_parameter}";

    # If log file is defined, the output and error messages should be redirected to it.
    if [ -n "${audio_encoder_log_file}" ];
    then
        output_file="${audio_encoder_log_file}";
        error_file="${audio_encoder_log_file}";
    else
        output_file="";
        error_file="";
    fi;

    # Starts audio encoder process.
    start_process "${audio_encoder_command}" "${audio_encoder_process_identifier}" "${audio_pipe_file}" "${output_file}" "${error_file}";
    start_process_result=${?};
    if [ ${start_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not start audio encoder process.";
        return ${generic_error};
    fi;

    return ${success};
}

# Stops audio encoder process.
#
# Parameters:
#    None.
#
# Returns:
#    SUCCESS - If audio encoder program was stopped correctly.
#    GENERIC_ERROR - Otherwise.
#
stop_audio_encoder_process(){

    local retrieve_processs_id_result;
    local audio_encoder_process_id;
    local stop_process_result;

    # Retrieves the audio encoder process id.
    audio_encoder_process_id="$(retrieve_process_id "${audio_encoder_process_identifier}")";
    retrieve_process_id_result=${?};
    if [ ${retrieve_process_id_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not retrieve audio encoder process id.";
        return ${generic_error};
    fi;

    # Checks if audio encoder process id was retrieved successfully.
    if [ -z "${audio_encoder_process_id}" ];
    then
        log ${log_message_type_error} "Audio encoder process id retrieved is empty.";
        return ${generic_error};
    fi;

    # Stops the audio encoder process.
    stop_process ${audio_encoder_process_id};
    stop_process_result=${?};
    if [ ${stop_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not stop audio encoder process.";
        return ${generic_error};
    fi;

    log ${log_message_type_trace} "Audio encoder process stopped.";

    return ${success};
}

# Checks if audio encoder process is running.
#
# Parameters:
#   None.
#
# Returns:
#  SUCCESS - If audio encoder process is running.
#  GENERIC_ERROR - Otherwise.
is_audio_encoder_process_running(){

    local result;
    local audio_encoder_process_id;
    local check_process_is_alive_result;

    # Retrieve audio encoder process id.
    audio_encoder_process_id=$(retrieve_process_id "${audio_encoder_process_identifier}");
    retrieve_process_id_result=${?};
    if [ ${retrieve_process_id_result} -ne ${success} -o -z "${audio_encoder_process_id}" ];
    then
        log ${log_message_type_error} "Could not find audio capture process id."
        exit ${generic_error};
    fi;

    # Check if process is alive.
    check_process_is_alive ${audio_encoder_process_id};
    check_process_is_alive_result=${?};
    if [ ${check_process_is_alive_result} -ne ${success} ];
    then
        result=${generic_error};
    else
        result=${success};
    fi;

    return ${result};
}
