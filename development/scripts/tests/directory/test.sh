#!/bin/bash

# The objective of this script is to test all directory functions.
#
# Version: 0.1
# Author: Marcelo Leite

# Load directories functions.
source "$(dirname ${BASH_SOURCE})/../../deploy/directories/functions.sh";

# Test "get_input_files_directory" and "get_output_files_directory" functions.
test_directory() {
    echo "Testing functions \"get_input_files_directory\" and \"get_output_files_directory\" functions.";

    echo "Input file directory is \"$(get_input_files_directory)\".";
    echo "Output file directory is \"$(get_output_files_directory)\".";

    echo -e "Tests of functions \"get_input_files_directory\" and \"get_output_files_directory\" concluded.\n";
}

test_directory;
