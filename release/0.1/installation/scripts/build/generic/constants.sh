#!/bin/bash

# Constants used on project controlling and development.
#
# Version: 
#   0.1
#
# Author:
#   Marcelo Leite

# ###
# Include guard.
# ###
if [ -z "${GENERIC_CONSTANTS_SH}" ];
then
    GENERIC_CONSTANTS_SH=1;
else
    return;
fi;


# ###
# Constants.
# ###

# Preffix used to identify error messages.
if [ -z "${error_messages_preffix}" ];
then
    readonly error_message_preffix="[ERROR]:";
fi;
