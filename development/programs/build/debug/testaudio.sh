#!/bin/bash

# Script to execute "testaudio" program.
#
# Version: 0.1
# Author: Marcelo Leite

export INPUT_DIRECTORY="../../resources/";
export OUTPUT_DIRECTORY="${INPUT_DIRECTORY}";

$(dirname ${BASH_SOURCE})/bin/testaudio;
