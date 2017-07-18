#!/bin/bash

# This script contains functions used throughout the system installation.
#
# Parameters:
#   None.
#
# Returns:
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
if [ -z "${INSTALLATION_FUNCTIONS_SH}" ]
then
    INSTALLATION_FUNCTIONS_SH=1;
else
    return;
fi;


# ###
# Source scripts.
# ###

# Loads installation constants.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Loads generic installation functions.
source "$(dirname ${BASH_SOURCE})/generic/functions.sh";


# ###
# Functions elaborations.
# ###

# Replace a substitution term on the content of a file.
#
# Parameters:
#   1. The file where the term must be replaced.
#   2. The term to be replaced.
#   3. The text by which the term will be replaced.
#
# Returns:
#   0 - If the term was replaced successfully.
#   1 - Otherwise.
#
replace_term() {

    local file_path;
    local substitution_term;
    local replacement_text;

    # Check function parameters.
    if [ ${#} -ne 3 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        file_path="${1}";
        substitution_term="${2}";
        replacement_text="${3}";
    fi;

    # Precedes the forward slashes with backward slashes (escape character to "sed" command).
    replacement_text="${replacement_text//\//\\/}";

    # Replaces the substitution term by the text informed.
    sed -i -e "s/${substitution_term}/${replacement_text}/g" "${file_path}";
    sed_result=${?};
    if [ ${sed_result} -ne 0 ];
    then
        print_error_message "Error replacing the substitution term \"${substitution_term}\" by \"${replacement_text}\" on file \"${file_path}\": ${sed_result}.";
        return 1;
    fi;

    return 0;
}

# Replaces the substitution terms on the content of a file.
#
# Parameters:
#   1. The path to the file.
#
# Returns:
#   0 - If the terms were replaced successfully.
#   1 - Otherwise.
#
replace_terms() {

    local file_path;
    local replacement_string;
    local replace_term_result;

    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        file_path="${1}";
    fi;

    echo "Replacing terms on file \"${file_path}\".";
    
    # Replaces the "system services' shell scripts' directory path" substitution term by its value.
    replace_term "${file_path}" "${term_destination_services_scripts_directory_path}" "${destination_services_scripts_directory_path}";
    replace_term_result=${?};
    if [ ${replace_term_result} -ne 0 ];
    then
        print_error_message "Error replacing the \"system services' shell scripts' directory path\" substitution term on file \"${file_path}\".";
        return 1;
    fi;

    # Replaces the "system services' shell scripts' directory path" substitution term by its value.
    replace_term "${file_path}" "${term_destination_scripts_directory_path}" "${destination_scripts_directory_path}";
    replace_term_result=${?};
    if [ ${replace_term_result} -ne 0 ];
    then
        print_error_message "Error replacing the \"system' shell scripts' directory path\" substitution term on file \"${file_path}\".";
        return 1;
    fi;

    # Replaces the "system binaries directory path" substitution term by its value.
    replace_term "${file_path}" "${term_destination_binaries_directory_path}" "${destination_binaries_directory_path}";
    replace_term_result=${?};
    if [ ${replace_term_result} -ne 0 ];
    then
        print_error_message "Error replacing the \"system binaries directory path\" substitution term on file \"${file_path}\": ${sed_result}.";
        return 1;
    fi;

    # Replaces the "input files location value" term by its value.
    replace_term "${file_path}" "${input_files_location_value_term}" "${destination_directory_path}";
    replace_term_result=${?};
    if [ ${replace_term_result} -ne 0 ];
    then
        print_error_message "Error replacing \"input files location value\" term on file \"${file_path}\".";
        return 1;
    fi;

    # Replaces the "output files location value" term by its value.
    replace_term "${file_path}" "${output_files_location_value_term}" "${destination_directory_path}";
    replace_term_result=${?};
    if [ ${replace_term_result} -ne 0 ];
    then
        print_error_message "Error replacing \"output files location value\" term on file \"${file_path}\".";
        return 1;
    fi;

    return 0;
}


