#!/bin/bash

# This script contains the generic constants required by the audio capture process.
#
# Version: 0.1
# Author: Marcelo Leite

# Load project configurations.
source $(dirname ${BASH_SOURCE})/configuration.sh;

# Preffix to identify audio files.
if [ -z ${audio_file_preffix+x} ]; 
then
	readonly audio_file_preffix="audio";
fi;

# Suffix to identify audio files.
if [ -z ${audio_file_suffix+x} ]; 
then
	readonly audio_file_suffix="mp3";
fi;

# Path to audio confguration directory.
if [ -z ${audio_configuration_directory+x} ];
then
    readonly audio_configuration_directory="${configuration_directory}audio/";
fi;

# Pipe file connecting audio capture and audio coding process.
if [ -z ${audio_pipe_file} ];
then
    readonly audio_pipe_file=${temporary_directory}audio_pipe;
fi;

# Program used to encode audio.
if [ -z ${audio_encoder_program+x} ];
then
    readonly audio_encoder_program="lame";
fi;
