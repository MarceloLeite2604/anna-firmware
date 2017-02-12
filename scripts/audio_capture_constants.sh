#!/bin/bash

# This script contains all constants used by the audio capture process.
#
# Version: 0.1
# Author: Marcelo Leite

# Load generic audio constants.
source $(dirname ${BASH_SOURCE})/audio_generic_constants.sh;

# Program used to capture audio.
if [ -z ${audio_capture_program+x} ];
then
    readonly audio_capture_program="arecord";
fi;

# Path to audio capture confguration directory.
if [ -z ${audio_capture_configuration_directory+x} ];
then
    readonly audio_capture_configuration_directory="${audio_configuration_directory}capture/";
fi;

# Parameter to execute audio capture program on verbose mode.
if [ -z ${audio_capture_verbose_parameter+x} ];
then
    readonly audio_capture_verbose_parameter="-v";
fi;

# Parameter to define the number of channels on audio capture program.
if [ -z ${audio_capture_channel_parameter+x} ];
then
    readonly audio_capture_channel_parameter="-c";
fi;

# Path to audio capture channels configuration file.
if [ -z ${audio_capture_channels_configuration_file+x} ];
then
    readonly audio_capture_channels_configuration_file="${audio_capture_configuration_directory}channels";
fi;

# Parameter to define the number of channels on audio capture program.
if [ -z ${audio_capture_sampling_rate_parameter} ];
then
    readonly audio_capture_sampling_rate_parameter="-r";
fi;

# Path to audio capture sampling rate configuration.
if [ -z ${audio_capture_sampling_rate_configuration_file+x} ];
then
    readonly audio_capture_sampling_rate_configuration_file="${audio_capture_configuration_directory}sampling_rate";
fi;

# Parameter to define the sample format on audio capture program.
if [ -z ${audio_capture_sample_format_parameter} ];
then
    readonly audio_capture_sample_format_parameter="-f";
fi;

# Path to audio capture sample format configuration.
if [ -z ${audio_capture_sample_format_configuration_file+x} ];
then
    readonly audio_capture_sample_format_configuration_file="${audio_capture_configuration_directory}sample_format";
fi;

# Parameter to define the record device on audio capture program.
if [ -z ${audio_capture_record_device_parameter} ];
then
    readonly audio_capture_record_device_parameter="-f";
fi;

# Path to audio capture record device configuration.
if [ -z ${audio_capture_record_device_configuration_file+x} ];
then
    readonly audio_capture_record_device_configuration_file="${audio_capture_configuration_directory}record_device";
fi;
