#!/bin/sh

# This script contains all functions required to record audio.
#
# Version: 0.1
# Author: Marcelo Leite

# Load configurations file
source $(dirname ${BASH_SOURCE})/configuration.sh

# Load audio constants file.
source $(dirname ${BASH_SOURCE})/audio_constants.sh

# Load log and trace functions.
source $(dirname ${BASH_SOURCE})/log_functions.sh

# Load general functions.
source $(dirname ${BASH_SOURCE})/general_functions.sh

# Directory where all audio will be stored.
audio_directory="${default_audio_directory}";

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

    if [ $# -ne 0 ]
    then
        log ${type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

	local readonly audio_file_name="${audio_file_preffix}_$(get_current_time_formatted).${audio_file_suffix}";
	echo "${audio_file_name}";
	return ${success};
}

# Reads an audio configuration file.
#
# Parameters
#    1. Configuration file to be read.
#
# Returns
#    0. If confguration file was read and there was content on it.
#    1. Otherwise.
read_audio_configuration_file(){
    if [ $# -ne 1 ]
    then
        log ${type_error} "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return ${general_error};
    fi;

    local readonly file="$1";

    local file_content;
    file_content=$(read_file "${file}");
    if [ $? -ne ${success} ];
    then
        return ${general_failure};
    fi;

    if [ -z "${file_content}" ];
    then
        log ${log_message_type_error} "File \"${audio_channels_configuration_file}\" is empty.";
        return ${general_failure};
    fi;

    echo "${file_content}";

    return ${success};
}

# Start recording an audio.
#
# Parameters
#   None.
#
# Returns
#   Nothing.
record_audio(){
    local record_command="arecord -Dhw:sndrpiwsp  ~/teste.raw";

    # Reads input channels configuration file.
    local channels;
    channels=$(read_audio_configuration_file "${audio_channels_configuration_file}");

    if [ $? -ne ${success} -o -z "${channels}" ];
    then
        log ${log_message_type_error} "Could not define the number of input channels to be read.";
        return ${general_failure};
    fi;

    # Reads sample format configuration file.
    local sample_format;
    sample_format=$(read_audio_configuration_file "${audio_sample_format_configuration_file}");

    if [ $? -ne ${success} -o -z "${sample_format}" ];
    then
        log ${log_message_type_error} "Could not define the audio sample format.";
        return ${general_failure};
    fi;

    # Reads sampling rate configuration file.
    local sampling_rate;
    sampling_rate=$(read_audio_configuration_file "${audio_sampling_rate_configuration_file}");

    if [ $? -ne ${success} -o -z "${sampling_rate}" ];
    then
        log ${log_message_type_error} "Could not define the audio sampling rate.";
        return ${general_failure};
    fi;

    # Reads sampling rate configuration file.
    local record_device;
    record_device=$(read_audio_configuration_file "${audio_record_device_configuration_file}");

    if [ $? -ne ${success} -o -z "${record_device}" ];
    then
        log ${log_message_type_error} "Could not define the audio record device.";
        return ${general_failure};
    fi;

    # Defines the output file name.
    local output_file;
    output_file=$(create_audio_file_name);

    if [ $? -ne ${success} -o -z "${output_file}" ];
    then
        log ${log_mesage_type_error} "Could not define output file name.";
        return ${general_failure};
    fi;

    local readonly command="arecord -v -D \"${record_device}\" -c \"${channels}\" -r \"${sampling_rate}\" -f \"${sample_format}\" -t raw | lame -r  - \"${default_audio_directory}${output_file}\"";

    echo "${command}";
}

