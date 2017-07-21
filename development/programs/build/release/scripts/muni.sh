#!/bin/bash

# Script to execute "muni" program.
#
# Version: 0.1
# Author: Marcelo Leite

# Defines the input and output directories for program execution.
source "$(dirname ${BASH_SOURCE})/set_input_output_directories.sh";

#command_preffix="";

#if [ $# -eq 1 ];
#then
#    option=${1};
#    if [[ "${option}" -eq "valgrind" ]];
#    then
#        command_preffix="valgrind --leak-check=yes";
#    fi;
#fi;

${command_preffix} $(dirname ${BASH_SOURCE})/../bin/muni -l TRACE;
program_exit_code=${?};
echo "Program finished with value "${program_exit_code}".";
exit ${program_exit_code};
