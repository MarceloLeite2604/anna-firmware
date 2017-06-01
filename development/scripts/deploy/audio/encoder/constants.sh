#!/bin/bash

# This script contains all constants required by audio encoder functions.
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
if [ -z "${AUDIO_ENCODER_CONSTANTS_SH}" ];
then
    AUDIO_ENCODER_CONSTANTS_SH=1;
else
    return;
fi;


# ###
# Script sources. 
# ###

# Load audio generic constants script.
source "$(dirname ${BASH_SOURCE})/../constants.sh";


# ###
# Constants.
# ###

# Program used to encode audio.
if [ -z "${audio_encoder_program}" ];
then
    readonly audio_encoder_program="lame";
fi;

# Path to audio encoder configuration directory.
if [ -z "${audio_encoder_configuration_directory}" ];
then
    readonly audio_encoder_configuration_directory="${audio_configuration_directory}encode/";
fi;

# Parameter to specify for audio encoder that its input is raw pulse-code modulation (pcm) format.
if [ -z "${audio_encoder_raw_pcm_parameter}" ];
then
    readonly audio_encoder_raw_pcm_parameter="-r";
fi;

# Parameter to specify for audio encoder the sample rate of input.
if [ -z "${audio_encoder_sample_rate_parameter}" ];
then
    readonly audio_encoder_sample_rate_parameter="-s";
fi;

# Path to audio encoder sample rate configuration file.
if [ -z "${audio_encoder_sample_rate_configuration_file}" ];
then
    readonly audio_encoder_sample_rate_configuration_file="${audio_encoder_configuration_directory}sample_rate";
fi;

# Parameter to specify for audio encoder the bit width (sample format) of input.
if [ -z "${audio_encoder_bit_width_parameter}" ];
then
    readonly audio_encoder_bit_width_parameter="--bitwidth";
fi;

# Path to audio encode bit width configuration file.
if [ -z "${audio_encoder_bit_width_configuration_file}" ];
then
    readonly audio_encoder_bit_width_configuration_file="${audio_encoder_configuration_directory}bit_width";
fi;

# Parameter to specify for audio encoder the output channel mode.
if [ -z "${audio_encoder_channel_mode_parameter}" ];
then
    readonly audio_encoder_channel_mode_parameter="-m";
fi;

# Path to audio encoder channel mode configuration file.
if [ -z "${audio_encoder_channel_mode_configuration_file}" ];
then
    readonly audio_encoder_channel_mode_configuration_file="${audio_encoder_configuration_directory}channel_mode";
fi;

# Parameter to specify encoding quality.
if [ -z "${audio_encoder_quality_parameter}" ];
then
    readonly audio_encoder_quality_parameter="-q";
fi;

# Path to audio encoder quality configuration file.
if [ -z "${audio_encoder_quality_configuration_file}" ];
then
    readonly audio_encoder_quality_configuration_file="${audio_encoder_configuration_directory}quality";
fi;

# Parameter to specify the encoded audio comment.
if [ -z "${audio_encoder_comment_parameter}" ];
then
    readonly audio_encoder_comment_parameter="--tc";
fi;

# Path to audio encoder comment configuration file.
if [ -z "${audio_encoder_comment_configuration_file}" ];
then
    readonly audio_encoder_comment_configuration_file="${audio_encoder_configuration_directory}comment";
fi;

# Parameter to specify the output file.
if [ -z "${audio_encoder_output_file_parameter}" ];
then
    readonly audio_encoder_output_file_parameter="-";
fi;

# Preffix to identify audio files.
if [ -z "${audio_file_preffix}" ]; 
then
    readonly audio_file_preffix="audio";
fi;

# Suffix to identify audio files.
if [ -z "${audio_file_suffix}" ]; 
then
    readonly audio_file_suffix=".mp3";
fi;

# String to identify the file which contains the audio encoder process identification.
if [ -z "${audio_encoder_process_identifier}" ];
then
    readonly audio_encoder_process_identifier="audio_encoder";
fi;

# Pattern to find audio files.
if [ -z "${audio_file_pattern}" ];
then
    readonly audio_file_pattern="${audio_directory}${audio_file_preffix}*${audio_file_suffix}";
fi;
