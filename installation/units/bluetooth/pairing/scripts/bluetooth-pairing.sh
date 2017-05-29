#!/bin/bash

command_script="$(dirname ${BASH_SOURCE})/bluetoothctl-commands.sh";

${command_script} | bluetoothctl;
exit ${?};
