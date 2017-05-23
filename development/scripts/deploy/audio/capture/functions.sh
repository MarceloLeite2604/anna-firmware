#!/bin/bash

# This script contains all functions required create and configure audio capture
# process.
#
# Version: 0.1
# Author: Marcelo Leite

# Load audio capture constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load audio generic functions script.
source "$(dirname ${BASH_SOURCE})/../functions.sh"

# Load log functions.
source "$(dirname ${BASH_SOURCE})/../../log/functions.sh";

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

    # Reads format type configuration file for capture program.
    local format_type;
    format_type=$(read_audio_configuration_file "${audio_capture_format_type_configuration_file}");
    if [ ${?} -ne ${success} -o -z "${format_type}" ];
    then
        log ${log_message_type_error} "Could not define the audio format type.";
        return ${generic_error};
    fi;

    local readonly audio_format_parameter="${audio_capture_format_type_parameter} ${format_type}";

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
    start_audio_capture_command+=" ${record_device_parameter}";
    start_audio_capture_command+=" ${audio_format_parameter}";
    # TODO: Add a new configuration file to determine the buffer length.
    start_audio_capture_command+=" -B 5000000";
    #start_audio_capture_command+=" 1> ${audio_pipe_file}";

    local error_file="";
    if [ -n "${audio_capture_log_file}" ];
    then
        error_file="${audio_capture_log_file}";
    fi;

    local start_process_result;
    # start_process "${start_audio_capture_command}" "${audio_capture_process_identifier}" "" "${audio_pipe_file}" "${error_file}";
    start_process "${start_audio_capture_command}" "${audio_capture_process_identifier}" "" "${audio_pipe_file}" "${error_file}";
    $(dirname ${BASH_SOURCE})/../../store_instant.sh "${audio_start_instant_file}";
    start_process_result=${?};
    if [ ${start_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not start audio capture process.";
    fi;

    return ${success};
}


# Stops audio capture process.
#
# Parameters
#    None.
#
# Returns
#    0. If audio capture program was stopped correctly.
#    1. Otherwise.
stop_audio_capture_process(){

    local retrieve_processs_id_result;
    local audio_capture_process_id;
    audio_capture_process_id=$(retrieve_process_id "${audio_capture_process_identifier}");
    retrieve_process_id_result=${?};
    if [ ${retrieve_process_id_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not retrieve audio capture process id.";
        return ${generic_error};
    fi;

    if [ -z "${audio_capture_process_id}" ];
    then
        log ${log_message_type_error} "Audio capture process id retrieved is empty.";
        return ${generic_error};
    fi;

    local stop_process_result;
    stop_process ${audio_capture_process_id};
    stop_process_result=${?};
    if [ ${stop_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not stop audio capture process.";
        return ${generic_error};
    fi;

    log ${log_message_type_trace} "Audio capture process stopped.";

    return ${success};
}

# Checks if audio capture process is executing.
#
# Parameters
#   None.
#
# Returns
#  0. If audio capture process is running.
#  1. Otherwise.
is_audio_capture_process_running(){

    local result;
    local audio_capture_process_id;

    # Retrieve audio capture process id.
    audio_capture_process_id=$(retrieve_process_id "${audio_capture_process_identifier}");
    retrieve_process_id_result=${?};
    if [ ${retrieve_process_id_result} -ne ${success} -o -z "${audio_capture_process_id}" ];
    then
        log ${log_message_type_error} "Could not find audio capture process id."
        exit ${generic_error};
    fi;

    check_process_is_alive ${audio_capture_process_id};
    result=${?};

    return ${result};
}
