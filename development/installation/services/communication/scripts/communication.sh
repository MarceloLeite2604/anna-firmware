#!/bin/bash

# This script defines the system variables and starts the communication program
#
# Version: 
#   0.1
#
# Author: 
#   Marcelo Leite
#

export ANNA_INPUT_DIRECTORY="<ANNA_INPUT_DIRECTORY_VALUE>";
export ANNA_OUTPUT_DIRECTORY="<ANNA_OUTPUT_DIRECTORY_VALUE>";
<SYSTEM_BINARIES_DIRECTORY>muni -l ERROR;
exit ${?};
