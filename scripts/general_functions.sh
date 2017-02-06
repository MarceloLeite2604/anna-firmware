#!/bin/bash

# This script contains general functions used by other scripts.
#
# Version: 0.1
# Author: Marcelo Leite

# Load configurations file
source $(dirname $BASH_SOURCE)/configuration.sh

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

# Returns current time.
#
# Parameters
#   None
#
# Returns
#    The current time.
get_current_time(){
    echo "$(date +"%Y/%m/%d %H:%M:%S")";
    return ${success};
}
