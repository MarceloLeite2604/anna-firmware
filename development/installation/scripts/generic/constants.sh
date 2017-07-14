#!/bin/bash

# This script contains all generic constants required to install the system.
#
# Parameters:
#   None.
#
# Returns:
#   None.
#
# Version:
#   0.1
#
# Author:
#   Marcelo Leite
#

# ###
# Include guard.
# ###
if [ -z "${INSTALLATION_GENERIC_CONSTANTS_SH}" ]
then
    INSTALLATION_GENERIC_CONSTANTS_SH=1;
else
    return;
fi;

# ###
# Constants.
# ###

# Prefix used to identify an error message.
if [ -z "${error_prefix}" ];
then
    readonly error_prefix="[ERROR]:";
fi;

# The company's name.
if [ -z "${company_name}" ];
then
    readonly company_name="astring";
fi;

# The system name.
if [ -z "${system_name}" ];
then
    readonly system_name="anna";
fi;
