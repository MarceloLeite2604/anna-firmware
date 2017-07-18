#!/bin/bash

command_script="$(dirname ${BASH_SOURCE})/bluetoothctl_commands.sh";

${command_script} | bluetoothctl >/dev/null;
exit ${?};
