#!/bin/sh

# The company's name.
if [ -z ${company+x} ]; then
	readonly company=marcelo
fi

# The project name.
if [ -z ${project+x} ]; then
	readonly project=projeto_anna
fi

# Main directory structure used by the scripts.
if [ -z ${directory_structure+x} ]; then
	readonly directory_structure=./$company/$project
fi

# Preffix to identify audio files.
if [ -z ${audio_file_preffix+x} ]; then
	readonly audio_file_preffix="audio"
fi

# Suffix to identify audio files.
if [ -z ${audio_file_suffix+x} ]; then
	readonly audio_file_suffix="mp3"
fi
