#!/bin/bash

# This script contains all constants required to encode audio.
#
# Version: 0.1
# Author: Marcelo Leite

# Load audio generic constants file.
source $(dirname ${BASH_SOURCE})/audio_generic_constants.sh;

# Program used to encode audio.
if [ -z ${audio_encode_program+x} ];
then
    readonly audio_encode_program="lame";
fi;

# Path to audio encode confguration directory.
if [ -z ${audio_encode_configuration_directory+x} ];
then
    readonly audio_encode_configuration_directory="${audio_configuration_directory}encode/";
fi;

# Parameter to specify for audio encoder that input is raw pulse-code modulation (pcm) format.
if [ -z ${audio_encode_raw_pcm_parameter+x} ];
then
    readonly audio_encode_raw_pcm_parameter="-r";
fi;

# Parameter to specify for audio encoder the sample rate of input.
if [ -z ${audio_encode_sample_rate_parameter+x} ];
then
    readonly audio_encode_sample_rate_parameter="-s";
fi;

# Path to audio encode sample rate configuration file.
if [ -z ${audio_encode_sample_rate_configuration_file+x} ];
then
    readonly audio_encode_sample_rate_configuration_file="${audio_encode_configuration_directory}sample_rate";
fi;

# Parameter to specify for audio encoder the bit width (sample format) of input.
if [ -z ${audio_encode_bit_width_parameter+x} ];
then
    readonly audio_encode_bit_width_parameter="--bitwidth";
fi;

# Path to audio encode bit width configuration file.
if [ -z ${audio_encode_bit_width_configuration_file+x} ];
then
    readonly audio_encode_bit_width_configuration_file="${audio_encode_configuration_directory}bit_width";
fi;

# Parameter to specify for audio encoder output channel mode.
if [ -z ${audio_encode_channel_mode_parameter+x} ];
then
    readonly audio_encode_channel_mode_parameter="-m";
fi;

# Path to audio encode channel mode configuration file.
if [ -z ${audio_encode_channel_mode_configuration_file+x} ];
then
    readonly audio_encode_channel_mode_configuration_file="${audio_encode_configuration_directory}channel_mode";
fi;

# Parameter to specify encoding quality.
if [ -z ${audio_encode_quality_parameter+x} ];
then
    readonly audio_encode_quality_parameter="-q";
fi;

# Path to audio encode quality configuration file.
if [ -z ${audio_encode_quality_configuration_file+x} ];
then
    readonly audio_encode_quality_configuration_file="${audio_encode_configuration_directory}quality";
fi;

# Parameters to specify the encoded audio comment.
if [ -z ${audio_encode_comment_parameter+x} ];
then
    readonly audio_encode_comment_parameter="--tc";
fi;

# Path to audio encoded audio comment configuration file.
if [ -z ${audio_encode_comment_configuration_file+x} ];
then
    readonly audio_encode_comment_configuration_file="${audio_encode_configuration_directory}comment";
fi;

# Parameter to specify the output file.
if [ -z ${audio_encode_output_file_parameter+x} ];
then
    readonly audio_encode_output_file_parameter="-";
fi;

# Suffix to identify audio files.
if [ -z ${audio_file_suffix+x} ]; 
then
	readonly audio_file_suffix="mp3";
fi;

