#!/bin/bash

# This script checks if device is recording.
#
# Version: 0.1
# Author: Marcelo Leite
#
# Observation:
#   If device is recording this scripts returns 0. Otherwise it returns 1.

# Load audio capture functions.
source "$(dirname ${BASH_SOURCE})/audio/capture/functions.sh";

# Load audio encoder functions.
source "$(dirname ${BASH_SOURCE})/audio/encoder/functions.sh";

is_audio_capture_process_running;
audio_capture_process_alive=${?};

is_audio_encoder_process_running;
audio_encoder_process_alive=${?};

if [ ${audio_capture_process_alive} -eq 0 -a ${audio_encoder_process_alive} -eq 0 ];
then
    exit 0;
else
    exit 1;
fi;

