#!/bin/bash

# This script contains all constants used by the audio capture functions.
#
# Parameters:
#   None.
#
# Returns:
#   None.
#
# Version:
#   0.1
#
# Author: 
#   Marcelo Leite

# ###
# Include guard.
# ###
if [ -z "${AUDIO_CAPTURE_CONSTANTS_SH}" ];
then
    AUDIO_CAPTURE_CONSTANTS_SH=1;
else
    return;
fi;

# ###
# Script sources. 
# ###

# Load generic audio constants script.
source "$(dirname ${BASH_SOURCE})/../constants.sh";


# ###
# Constants.
# ###

# Program used to capture audio.
if [ -z "${audio_capture_program}" ];
then
    readonly audio_capture_program="arecord";
fi;

# Path to audio capture configuration directory.
if [ -z "${audio_capture_configuration_directory}" ];
then
    readonly audio_capture_configuration_directory="${audio_configuration_directory}capture/";
fi;

# Parameter to execute audio capture program on verbose mode.
if [ -z "${audio_capture_verbose_parameter}" ];
then
    readonly audio_capture_verbose_parameter="-v";
fi;

# Parameter to define the number of channels on audio capture program.
if [ -z "${audio_capture_channel_parameter}" ];
then
    readonly audio_capture_channel_parameter="-c";
fi;

# Path to audio capture channels configuration file.
if [ -z "${audio_capture_channels_configuration_file}" ];
then
    readonly audio_capture_channels_configuration_file="${audio_capture_configuration_directory}channels";
fi;

# Parameter to define the sampling rate on audio capture program.
if [ -z "${audio_capture_sampling_rate_parameter}" ];
then
    readonly audio_capture_sampling_rate_parameter="-r";
fi;

# Path to audio capture sampling rate configuration file.
if [ -z "${audio_capture_sampling_rate_configuration_file}" ];
then
    readonly audio_capture_sampling_rate_configuration_file="${audio_capture_configuration_directory}sampling_rate";
fi;

# Parameter to define the sample format on audio capture program.
if [ -z "${audio_capture_sample_format_parameter}" ];
then
    readonly audio_capture_sample_format_parameter="-f";
fi;

# Path to audio capture sample format configuration.
if [ -z "${audio_capture_sample_format_configuration_file}" ];
then
    readonly audio_capture_sample_format_configuration_file="${audio_capture_configuration_directory}sample_format";
fi;

# Parameter to define the record device on audio capture program.
if [ -z "${audio_capture_record_device_parameter}" ];
then
    readonly audio_capture_record_device_parameter="-D";
fi;

# Path to audio capture record device configuration file.
if [ -z "${audio_capture_record_device_configuration_file}" ];
then
    readonly audio_capture_record_device_configuration_file="${audio_capture_configuration_directory}record_device";
fi;

# Parameter to define the audio format on audio capture program.
if [ -z "${audio_capture_format_type_parameter}" ];
then
    readonly audio_capture_format_type_parameter="-t";
fi;

# Path to audio capture format type configuration file.
if [ -z "${audio_capture_format_type_configuration_file}" ];
then
    readonly audio_capture_format_type_configuration_file="${audio_capture_configuration_directory}format_type";
fi;

# Parameter to define the buffer length on audio capture program.
if [ -z "${audio_capture_buffer_length_parameter}" ];
then
    readonly audio_capture_buffer_length_parameter="-B";
fi;

# Path to audio capture buffer length configuration file.
if [ -z "${audio_capture_buffer_length_configuration_file}" ];
then
    readonly audio_capture_buffer_length_configuration_file="${audio_capture_configuration_directory}buffer_length";
fi;

# String to identify the file which contains the audio capture process identification.
if [ -z "${audio_capture_process_identifier}" ];
then
    readonly audio_capture_process_identifier="audio_capture";
fi;
