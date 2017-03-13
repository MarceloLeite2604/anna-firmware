#!/bin/bash

# This script start the audio record processes.
#
# Version: 0.1
# Author: Marcelo Leite

# Load audio capture functions.
source "$(dirname ${BASH_SOURCE})/audio/capture/functions.sh";

# Load audio encoder functions.
source "$(dirname ${BASH_SOURCE})/audio/encoder/functions.sh";

# Load log functions.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";

# Set log level.
set_log_level ${log_message_type_trace};

# Set log directory.
set_log_directory "$(dirname ${BASH_SOURCE})/../logs/";

# Create a log file.
create_log_file "start_audio_record";

start_audio_capture_process;
if [ ${?} -ne ${success} ];
then
    log ${log_message_type_error} "Could not start audio capture process."
    exit ${generic_error};
fi;

start_audio_encoder_process;
if [ ${?} -ne ${success} ];
then
    log ${log_message_type_error} "Could not start audio encoder process."
    exit ${generic_error};
fi;

log ${log_message_type_trace} "Audio record started.";

exit ${success};
