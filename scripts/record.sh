#!/bin/sh

# Load configuration variables.
. ./configuration.sh

# Load funcitons.
. ./functions.sh

create_audio_file_name

audio_file_name=$?

echo "Audio file name is \"${audio_file_name}.\""
