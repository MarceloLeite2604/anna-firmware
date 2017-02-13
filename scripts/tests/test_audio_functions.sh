#!/bin/bash

# The objective of this script is to test all audio functions contained on "audio_functions.sh" file.
#
# Version: 0.1
# Author: Marcelo Leite

# Load log functions.
source $(dirname ${BASH_SOURCE})/../log_functions.sh;

# Load audio functions.
source $(dirname ${BASH_SOURCE})/../audio_capture_functions.sh;

set_log_level ${log_message_type_trace};
#set_log_directory "$(dirname ${BASH_SOURCE})/../../tests/log/";
#create_log_file "test_audio_functions";

start_audio_capture_process;

#cat "$(get_log_path)";
