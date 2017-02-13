#!/bin/bash

# This script contains all functions required to encode audio.
#
# Version: 0.1
# Author: Marcelo Leite

# Load audio generic constants file.
source $(dirname ${BASH_SOURCE})/audio_encode_constants.sh;

# Load audio generic functions script.
source $(dirname ${BASH_SOURCE})/audio_generic_functions.sh;

# Load log and trace functions.
source $(dirname ${BASH_SOURCE})/log_functions.sh;

# Creates the audio file name based on current instant.
#
# Parameters
#   None.
#
# Returns
#   0. If audio file name was created successfully.
#  -1. Otherwise.
#   It also returns the file name created through "echo".
create_audio_file_name() {

    if [ ${#} -ne 0 ]
    then
        log ${type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

	local readonly audio_file_name="${audio_file_preffix}_$(get_current_time_formatted).${audio_file_suffix}";
	echo "${audio_file_name}";
	return ${success};
}

# Starts the audio encode process.
#
# Parameters
#   None.
#
# Returns
#   0. If audio encode process was successfully started.
#   1. Otherwise.
start_audio_encode_process(){

    # Searches for audio encoder program.
    local audio_encoder_program_path;
    audio_encoder_program_path=$(find_program "${audio_encoder_program}");

    # Reads input sample rate configuration file.
    local sample_rate;
    sample_rate=$(read_audio_configuration_file "${audio_encode_sample_rate_configuration_file}");
    if [ ${?} -ne ${success} -o -z "${sample_rate}" ];
    then
        log ${log_message_type_error} "Could not define the input sample rate for audio encoder.";
        return ${generic_error};
    fi;

    local readonly sample_rate_parameter="${audio_encode_sample_rate_parameter} ${sample_rate}";

    # Reads input bit width configuration file.
    local bit_width;
    bit_width=$(read_audio_configuration_file "${audio_encode_bit_width_configuration_file}");

    if [ ${?} -ne ${success} -o -z "${bit_width}" ];
    then
        log ${log_message_type_error} "Could not define the input bit width for audio encoder.";
        return ${generic_error};
    fi;

    local readonly bit_width_parameter="${audio_encode_bit_width_parameter} ${bit_width}";

    # Reads the channel mode configuration file.
    local channel_mode;
    channel_mode=$(read_audio_configuration_file "${audio_encode_channel_mode_configuration_file}");

    if [ ${?} -ne ${success} -o -z "${channel_mode}" ];
    then
        log ${log_message_type_error} "Could not define the channel mode for audio encoder.";
        return ${generic_error};
    fi;

    local readonly channel_mode_parameter="${audio_encode_channel_mode_parameter} ${channel_mode}";

    # Reads the encoding quality configuration file.
    local encode_quality;
    encode_quality=$(read_audio_configuration_file "${audio_encode_quality_configuration_file}");

    if [ ${?} -ne ${success} -o -z "${encode_quality}" ];
    then
        log ${log_message_type_error} "Could not define the quality audio encoder.";
        return ${generic_error};
    fi;

    local readonly encode_quality_parameter="${audio_encode_quality_parameter} ${encode_quality}";

    # Reads the comment configuration file.
    local audio_comment;
    audio_comment=$(read_audio_configuration_file "${audio_encode_comment_configuration_file}");

    if [ ${?} -ne ${success} -o -z "${audio_comment}" ];
    then
        log ${log_message_type_error} "Could not define the comment to be written on output file.";
        return ${generic_error};
    fi;

    local readonly audio_comment_parameter="${audio_encode_comment_parameter} \"${audio_comment}\"";

    local create_audio_file_name_result;
    local readonly file_output_name=$(create_audio_file_name);
    create_audio_file_name_result=${?};
    if [ ${create_audio_file_name_result} -ne ${success} -o -z "${file_output_name}" ];
    then
        log ${log_message_type_error} "Could not define file output name.";
        return ${generic_error};
    fi;

    local check_file_is_directory_result;
    check_file_is_directory "${audio_directory}"
    check_file_is_directory_result=${?};
    if [ ${check_file_is_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not locate directory \"${audio_directory}\".";
        return ${generic_error};
    fi;

    local check_write_permission_result;
    check_write_permission "${audio_directory}";
    check_write_permission_result=${?};
    if [ ${check_write_permission_result} -ne ${success} ];
    then
        log ${log_message_type_error} "User \"$(whoami)\" does not have permission to write on \"${audio_directory}\".";
        return ${generic_error};
    fi;

    local output_file_path="${audio_directory}${file_output_name}";
    local output_file_parameter="${audio_encode_output_file_parameter} ${output_file_path}";

    local check_file_exists_result;
    check_file_exists "${audio_pipe_file}"
    check_file_exists_result=${?};
    if [ ${check_file_exists_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not locate pipe file \"${audio_directory}\".";
        return ${generic_error};
    fi;

    local check_read_permission_result;
    check_read_permission "${audio_pipe_file}";
    check_read_permission_result=${?};
    if [ ${check_read_permission_result} -ne ${success} ];
    then
        log ${log_message_type_error} "User \"$(whoami)\" does not have permission to read file \"${audio_pipe}\".";
        return ${generic_error};
    fi;

    local audio_encoder_command;
    audio_encoder_command="${audio_encoder_program_path}";
    audio_encoder_command+=" ${audio_encode_raw_pcm_parameter}";
    audio_encoder_command+=" ${sample_rate_parameter}";
    audio_encoder_command+=" ${bit_width_parameter}";
    audio_encoder_command+=" ${channel_mode_parameter}";
    audio_encoder_command+=" ${encode_quality_parameter}";
    #audio_encoder_command+=" ${audio_comment_parameter}";
    audio_encoder_command+=" ${output_file_parameter}";

    local start_process_result;
    start_process "${audio_encoder_command}" "audio_encoder" "${audio_pipe_file}" "" "";
    start_process_result=${?};
    if [ ${start_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not start audio encoder process.";
        return ${generic_error};
    fi;

    return ${success};
}

