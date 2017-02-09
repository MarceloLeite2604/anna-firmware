#!/bin/bash

# The objective of this script is to test all audio functions contained on "audio_functions.sh" file.
#
# Version: 0.1
# Author: Marcelo Leite

# Load log functions.
source $(dirname ${BASH_SOURCE})/../log_functions.sh;

# Load audio functions.
source $(dirname ${BASH_SOURCE})/../audio_functions.sh;

set_log_level ${log_message_type_trace};
record_audio;
