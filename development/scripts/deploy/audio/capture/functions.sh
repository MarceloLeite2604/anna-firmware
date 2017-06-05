#!/bin/bash

# This script contains all functions required to configure, start and stop audio
# capture process.
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
if [ -z "${AUDIO_CAPTURE_FUNCTIONS_SH}" ];
then
    AUDIO_CAPTURE_FUNCTIONS_SH=1;
else
    return;
fi;


# ###
# Script sources.
# ###

# Load audio capture constants script.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Load audio generic functions script.
source "$(dirname ${BASH_SOURCE})/../functions.sh"

# Load log functions script.
source "$(dirname ${BASH_SOURCE})/../../log/functions.sh";


# ###
# Function elaborations.
# ###

# Starts the audio capture process.
#
# Parameters:
#    None.
#
# Returns:
#    SUCCESS - If audio capture program was started successfully.
#    GENERIC_ERROR - Otherwise.
#
start_audio_capture_process(){

    local audio_capture_program_path;
    local channels;
    local channels_parameter;
    local sample_format;
    local sample_format_parameter;
    local sampling_rate;
    local sampling_rate_parameter;
    local record_device;
    local record_device_parameter;
    local format_type;
    local audio_format_parameter;
    local buffer_length;
    local buffer_length_parameter;
    local audio_capture_log_file;
    local start_audio_capture_command;
    local error_file;
    local start_process_result;
    local store_instant_result;

    # Searches for audio capture program.
    audio_capture_program_path="$(find_program "${audio_capture_program}")";
    if [ ${?} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not find audio capture program \"${audio_capture_program}\".";
        return ${generic_error};
    fi;

    # Reads input channels configuration file.
    channels="$(read_audio_configuration_file "${audio_capture_channels_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${channels}" ];
    then
        log ${log_message_type_error} "Could not define the number of input channels to be read.";
        return ${generic_error};
    else
        channels_parameter="${audio_capture_channel_parameter} ${channels}";
    fi;

    # Reads sample format configuration file.
    sample_format="$(read_audio_configuration_file "${audio_capture_sample_format_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${sample_format}" ];
    then
        log ${log_message_type_error} "Could not define the audio sample format.";
        return ${generic_error};
    else
        sample_format_parameter="${audio_capture_sample_format_parameter} ${sample_format}";
    fi;

    # Reads sampling rate configuration file.
    sampling_rate="$(read_audio_configuration_file "${audio_capture_sampling_rate_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${sampling_rate}" ];
    then
        log ${log_message_type_error} "Could not define the audio sampling rate.";
        return ${generic_error};
    else
        sampling_rate_parameter="${audio_capture_sampling_rate_parameter} ${sampling_rate}";
    fi;

    # Reads record device configuration file.
    record_device="$(read_audio_configuration_file "${audio_capture_record_device_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${record_device}" ];
    then
        log ${log_message_type_error} "Could not define the audio record device.";
        return ${generic_error};
    else
        record_device_parameter="${audio_capture_record_device_parameter} ${record_device}";
    fi;

    # Reads format type configuration file.
    format_type="$(read_audio_configuration_file "${audio_capture_format_type_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${format_type}" ];
    then
        log ${log_message_type_error} "Could not define the audio format type.";
        return ${generic_error};
    else
        audio_format_parameter="${audio_capture_format_type_parameter} ${format_type}";
    fi;

    # Reads buffer length configuration file.
    buffer_length="$(read_audio_configuration_file "${audio_capture_buffer_length_configuration_file}")";
    if [ ${?} -ne ${success} -o -z "${buffer_length}" ];
    then
        log ${log_message_type_error} "Could not define the buffer length.";
        return ${generic_error};
    else
        buffer_length_parameter="${audio_capture_buffer_length_parameter} ${buffer_length}";
    fi;

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

        # Creates the pipe file.
        create_pipe_file "${audio_pipe_file}";
        if [ ${?} -ne ${success} ];
        then
            log ${log_message_type_error} "Could not create pipe file \"${audio_pipe_file}\".";
            return ${generic_error};
        else
            log ${log_message_type_warning} "Pipe file \"${audio_pipe_file}\" created successfully.";
        fi;
    fi;

    # Elaborates the start audio capture process command.
    start_audio_capture_command="${audio_capture_program_path}";
    start_audio_capture_command+=" ${audio_capture_verbose_parameter}";
    start_audio_capture_command+=" ${channels_parameter}";
    start_audio_capture_command+=" ${sample_format_parameter}";
    start_audio_capture_command+=" ${sampling_rate_parameter}";
    start_audio_capture_command+=" ${record_device_parameter}";
    start_audio_capture_command+=" ${audio_format_parameter}";
    start_audio_capture_command+=" ${buffer_length_parameter}";

    # Retrieves current log file path.
    audio_capture_log_file="$(get_log_path)";
    if [ -n "${audio_capture_log_file}" ];
    then
        error_file="${audio_capture_log_file}";
    else
        error_file="";
    fi;

    # Starts the audio capture process.
    start_process "${start_audio_capture_command}" "${audio_capture_process_identifier}" "" "${audio_pipe_file}" "${error_file}";
    start_process_result=${?};
    if [ ${start_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not start audio capture process.";
        return ${generic_error};
    fi;

    # Store audio capture process start instant.
    $(dirname ${BASH_SOURCE})/../../store_instant.sh "${audio_start_instant_file}";
    store_instant_result=${?};
    if [ ${store_instant_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not store audio capture start instant.";
        return ${generic_error};
    fi;

    return ${success};
}


# Stops audio capture process.
#
# Parameters:
#    None.
#
# Returns:
#    SUCCESS - If audio capture program was stopped successfully.
#    GENERIC_ERROR - Otherwise.
#
stop_audio_capture_process(){

    local retrieve_processs_id_result;
    local audio_capture_process_id;
    local stop_process_result;

    # Retrieve audio capture process id.
    audio_capture_process_id=$(retrieve_process_id "${audio_capture_process_identifier}");
    retrieve_process_id_result=${?};
    if [ ${retrieve_process_id_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not retrieve audio capture process id.";
        return ${generic_error};
    fi;

    # Check if audio capture process id is not empty.
    if [ -z "${audio_capture_process_id}" ];
    then
        log ${log_message_type_error} "Audio capture process id retrieved is empty.";
        return ${generic_error};
    fi;

    # Stop audio capture process.
    stop_process ${audio_capture_process_id};
    stop_process_result=${?};
    if [ ${stop_process_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not stop audio capture process.";
        return ${generic_error};
    else
        log ${log_message_type_trace} "Audio capture process stopped.";
    fi;

    return ${success};
}

# Checks if audio capture process is executing.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If audio capture process is running.
#   GENERIC_ERROR - Otherwise.
#
is_audio_capture_process_running(){

    local result;
    local audio_capture_process_id;
    local check_process_is_alive_result;

    # Retrieve audio capture process id.
    audio_capture_process_id=$(retrieve_process_id "${audio_capture_process_identifier}");
    retrieve_process_id_result=${?};
    if [ ${retrieve_process_id_result} -ne ${success} -o -z "${audio_capture_process_id}" ];
    then
        log ${log_message_type_error} "Could not find audio capture process id."
        return ${generic_error};
    fi;

    # Check if process is alive.
    check_process_is_alive ${audio_capture_process_id};
    check_process_is_alive_result=${?};
    if [ ${check_process_is_alive_result} -ne ${success} ];
    then
        result=${generic_error};
    else
        result=${success};
    fi;

    return ${result};
}
