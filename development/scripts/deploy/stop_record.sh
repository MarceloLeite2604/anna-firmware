#!/bin/bash

# This script stop the audio record processes.
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
create_log_file "stop_audio_record";

stop_audio_encoder_process;
if [ ${?} -ne ${success} ];
then
    log ${log_message_type_error} "Could not stop audio encoder process.";
    exit ${generic_error};
fi;

# Retrieve audio capture process id.
audio_capture_process_id=$(retrieve_process_id "${audio_capture_process_identifier}");
retrieve_process_id_result=${?};
if [ ${retrieve_process_id_result} -ne ${success} -o -z "${audio_capture_process_id}" ];
then
    log ${log_message_type_error} "Could not find audio capture process id."
    exit ${generic_error};
fi;

# Check if audio capture process is still alive.
check_process_is_alive ${audio_capture_process_id};
audio_capture_process_id=${?};
if [ ${audio_capture_process_id} -eq ${success} ];
then

    # Stop audio capture process.
    stop_audio_capture_process;
    if [ ${?} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not stop audio capture process.";
        exit ${generic_error};
    else
        log ${log_message_type_trace} "Audio capture process stopped.";
    fi;
else
    log ${log_message_type_trace} "Audio capture process has already stopped.";
fi;

log ${log_message_type_trace} "Audio record stopped.";

exit ${success};

