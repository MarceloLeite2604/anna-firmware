#!/bin/sh

# This script contains all functions required to record audio.
#
# Version: 0.1
# Author: Marcelo Leite

# Load audio capture constants file.
source $(dirname ${BASH_SOURCE})/audio_capture_constants.sh

# Load audio general functions file.
source $(dirname ${BASH_SOURCE})/audio_general_functions.sh

# Load log and trace functions.
source $(dirname ${BASH_SOURCE})/log_functions.sh

# Starts audio capture process.
#
# Parameters
#    None.
#
# Returns
#    0. If audio capture program was started correctly.
#    1. Otherwise.
start_audio_capture_process(){

    # Searches for audio capture program.
    local audio_capture_program_path;
    audio_capture_program_path=$(find_program "${audio_capture_program}");
    if [ ${?} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not find audio capture program \"${audio_capture_program}\".";
        return ${generic_error};
    fi;

    # Reads input channels configuration file.
    local channels;
    channels=$(read_audio_configuration_file "${audio_capture_channels_configuration_file}");

    if [ ${?} -ne ${success} -o -z "${channels}" ];
    then
        log ${log_message_type_error} "Could not define the number of input channels to be read.";
        return ${generic_error};
    fi;

    local readonly channels_parameter="${audio_capture_channel_parameter} ${channels}";

    # Reads sample format configuration file for capture program.
    local sample_format;
    sample_format=$(read_audio_configuration_file "${audio_capture_sample_format_configuration_file}");

    if [ ${?} -ne ${success} -o -z "${sample_format}" ];
    then
        log ${log_message_type_error} "Could not define the audio sample format.";
        return ${generic_error};
    fi;

    local readonly sample_format_parameter="${audio_capture_sample_format_parameter} ${sample_format}";

    # Reads sampling rate configuration file for capture program.
    local sampling_rate;
    sampling_rate=$(read_audio_configuration_file "${audio_capture_sampling_rate_configuration_file}");

    if [ ${?} -ne ${success} -o -z "${sampling_rate}" ];
    then
        log ${log_message_type_error} "Could not define the audio sampling rate.";
        return ${generic_error};
    fi;

    local readonly sampling_rate_parameter="${audio_capture_sampling_rate_parameter} ${sampling_rate}";

    # Reads record device configuration file for capture program.
    local record_device;
    record_device=$(read_audio_configuration_file "${audio_capture_record_device_configuration_file}");
    if [ ${?} -ne ${success} -o -z "${record_device}" ];
    then
        log ${log_message_type_error} "Could not define the audio record device.";
        return ${generic_error};
    fi;

    local readonly record_device_parameter="${audio_capture_record_device_parameter} ${record_device}";

    # Check if temporary directory exists.
    check_file_is_directory "${temporary_directory}";
    if [ ${?} -ne ${success} ];
    then
        log ${log_message_type_error} "Temporary directory \"${temporary_directory}\" not found.";
        return ${generic_error};
    fi;

    # Check if pipe file exists.
    check_file_exists "${audio_pipe_file}";
    if [ ${?} -ne ${success} ];
    then
        log ${log_message_type_warning} "Pipe file \"${audio_pipe_file}\" not found.";
        create_pipe_file "${audio_pipe_file}";
        if [ ${?} -ne ${success} ];
        then
            log ${log_message_type_error} "Could not create pipe file \"${audio_pipe_file}\".";
            return ${generic_error};
        else
            log ${log_message_type_warning} "Pipe file \"${audio_pipe_file}\" created successfully.";
        fi;
    fi;

    local readonly audio_capture_log_file=$(get_log_path);

    local start_audio_capture_command;
    start_audio_capture_command="${audio_capture_program_path}";
    start_audio_capture_command+=" ${audio_capture_verbose_parameter}";
    start_audio_capture_command+=" ${channels_parameter}";
    start_audio_capture_command+=" ${sample_format_parameter}";
    start_audio_capture_command+=" ${sampling_rate_parameter}";
    start_audio_capture_command+=" ${device_parameter}";
    start_audio_capture_command+=" 1>${audio_pipe_file}";

    if [ -n "${audio_capture_log_file}" ];
    then
        start_audio_capture_command+=" 2>${audio_capture_log_file}";
    fi;

    local start_process_result;
    local audio_capture_process_id;
    # audio_capture_process_id=$(start_process "${start_audio_capture_command}");
    # start_process_result=${?};

    if [ ${start_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not start audio capture process.";
        return ${generic_error};
    else
        log ${log_message_type_trace} "Audio capture process ID: ${audio_capture_process_id}";
        save_process_id "${audio_capture_process_id_file}" "${audio_capture_process_id}";
    fi;

    
    echo "${start_audio_capture_command}"; 
}
