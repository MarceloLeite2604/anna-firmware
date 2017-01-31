#!/bin/sh

# Load configurations file
. ./configuration.sh

create_audio_file_name() {
	local audio_file_name="${audio_file_preffix}_$(date +"%Y%m%d_%H%M%S")".${audio_file_suffix}
	return "${audio_file_name}"
}
