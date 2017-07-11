#!/bin/bash

# Script to execute "testbluetooth" program.
#
# Version: 0.1
# Author: Marcelo Leite

# Defines the input and output directories for program execution.
source "$(dirname ${BASH_SOURCE})/set_input_output_directories.sh";

$(dirname $BASH_SOURCE)/bin/testbluetooth;
