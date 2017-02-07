#!/bin/bash

# This script contains all constants required to record audio.
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

# Path to audio configuration directory.
if [ -z ${audio_configuration_directory+x} ];
then
    readonly audio_configuration_directory="${root_directory}config/";
fi;
