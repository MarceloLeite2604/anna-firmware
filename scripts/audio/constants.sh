#!/bin/bash

# This script contains generic constants used on audio functions.
#
# Version: 0.1
# Author: Marcelo Leite

# Loads generic constants script.
source "$(dirname ${BASH_SOURCE})/../generic/constants.sh";

# Path to audio confguration directory.
if [ -z "${audio_configuration_directory}" ];
then
    readonly audio_configuration_directory="${configuration_directory}audio/";
fi;

# Pipe file connecting audio capture and audio coding process.
if [ -z "${audio_pipe_file}" ];
then
    readonly audio_pipe_file=${temporary_directory}audio_pipe;
fi;
