#!/bin/sh

# Load configurations file
. ./configuration.sh

# Return current time formatted as a string
#
# Parameters:
#   None.
#
# Returns:
#   The current time formatted as a string.
get_current_time_formatted() {
    echo "$(date +"%Y%m%d_%H%M%S")";
    return SUCCESS;
}

create_audio_file_name() {
	local audio_file_name="${audio_file_preffix}_$(date +"%Y%m%d_%H%M%S")".${audio_file_suffix}
	echo "${audio_file_name}"
	return SUCESS;
}
