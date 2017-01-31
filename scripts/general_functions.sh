#!/bin/bash

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
    return ${success};
};
