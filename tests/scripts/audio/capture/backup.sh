#!/bin/bash

# The objective of this script is to test all audio capture functions.
#
# Version: 0.1
# Author: Marcelo Leite

# Load audio capture functions.
source "$(dirname ${BASH_SOURCE})/../../../scripts/audio/capture/functions.sh";

# Load log functions.
source "$(dirname ${BASH_SOURCE})/../../../scrpits/log/functions.sh";

set_log_level ${log_message_type_trace};
#set_log_directory "$(dirname ${BASH_SOURCE})/../../tests/log/";
#create_log_file "test_audio_functions";

start_audio_capture_process;
if [ ${?} -ne ${success} ];
then
    echo "Audio capture process failed."
    return ${generic_error};
fi;
