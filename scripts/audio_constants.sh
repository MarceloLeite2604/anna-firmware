#!/bin/bash

# Preffix to identify audio files.
if [ -z ${audio_file_preffix+x} ]; 
then
	readonly audio_file_preffix="audio";
fi;

# Suffix to identify audio files.
if [ -z ${audio_file_suffix+x} ]; 
then
	readonly audio_file_suffix="mp3";
