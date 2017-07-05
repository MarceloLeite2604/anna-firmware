#!/bin/bash

# Generic constants used on project controlling.
#
# Version: 
#   0.1
#
# Author:
#   Marcelo Leite

# ###
# Include guard.
# ###
if [ -z "${DEVELOPMENT_GENERIC_CONSTANTS_SH}" ];
then
    DEVELOPMENT_GENERIC_CONSTANTS_SH=1;
else
    return;
fi;


# ###
# Constants.
# ###

# Current project's version to release.
if [ -z "${current_release_version}" ];
then
    current_release_version="0.1";
fi;

# Path to project's development directory.
if [ -z "${development_directory_path}" ];
then
    development_directory_path="$(dirname ${BASH_SOURCE})/development/";
fi;

# Project's release directory.
if [ -z "${release_versions_directory_path}" ];
then
    release_versions_directory_path="$(dirname ${BASH_SOURCE})/release/";
fi;

# Path to development directory of "configuration" project's subdivision.
if [ -z "${subdivision_configuration_directory_path}" ];
then
    subdivision_configuration_directory_path="${development_directory_path}configuration/";
fi;

# Path to development directory of "scripts" project's subdivision.
if [ -z "${subdivision_scripts_directory_path}" ];
then
    subdivision_scripts_directory_path="${development_directory_path}scripts/";
fi;

# Path to development directory of "programs" project's subdivision.
if [ -z "${subdivision_programs_directory_path}" ];
then
    subdivision_programs_directory_path="${development_directory_path}programs/";
fi;

# Path to development directory of "installation" project's subdivision.
if [ -z "${subdivision_installation_directory_path}" ];
then
    readonly subdivision_installation_directory_path="${development_directory_path}installation/";
fi;

# Path to directory which the current release version are being stored.
if [ -z "${current_release_version_directory}" ];
then
    readonly current_release_version_directory="${release_versions_directory_path}${current_release_version}/";
fi;

# Preffix used to identify error messages.
if [ -z "${error_messages_preffix}" ];
then
    readonly error_message_preffix="[ERROR]:";
fi;

