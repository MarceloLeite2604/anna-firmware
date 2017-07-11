#!/bin/bash

# This script installs the script which defines the system variables required for Anna to execute.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the script was deployed successfully.
#   1 - Otherwise.
#
# Version:
#   0.1
#
# Author:
#   Marcelo Leite


# ###
# Script sources.
# ###

# Load functions.
source "$(dirname ${BASH_SOURCE})/functions.sh";


# ###
# Function elaborations.
# ###

# Deploys the script created.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the script was deployed successfully.
#   1 - Otherwise.
#
deploy_script() {

    local cp_result;
    local chmod_result;

    echo -e "Deploying the script.";

    cp "${temporary_variables_script_path}" "${deployed_variables_script_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying script \"${temporary_variables_script_path}\" to \"${deployed_variables_script_path}\": ${cp_result}.";
        return 1;
    fi;

    chmod 644 "${deployed_variables_script_path}";
    chmod_result=${?};
    if [ ${chmod_result} -ne 0 ];
    then
        print_error_message "Error while defining permissions on file \"${deployed_variables_script_path}\".";
        return 1;
    fi;

    return 0;
}

# Replaces the terms on script.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the terms were replaced successfully.
#   1 - Otherwise.
#
replace_terms_on_script() {

    local replace_string;
    local sed_result;

    echo -e "Adjusting the script according to the installation.";

    # On the "system destination directory" variable, precedes the forward slashes with backward slashes (escape character to "sed" command).
    replace_string="${system_destination_directory//\//\\/}";

    # Replaces the "input files location value" term by its value.
    sed -i -e "s/${input_files_location_value_term}/${replace_string}/g" ${temporary_variables_script_path};
    sed_result=${?};
    if [ ${sed_result} -ne 0 ];
    then
        print_error_message "Error replacing \"input files location value\" term on temporary script file \"${temporary_variables_script_path}\": ${sed_result}.";
        return 1;
    fi;

    # Replaces the "output files location value" term by its value.
    sed -i -e "s/${output_files_location_value_term}/${replace_string}/g" ${temporary_variables_script_path};
    sed_result=${?};
    if [ ${sed_result} -ne 0 ];
    then
        print_error_message "Error replacing \"output files location value\" term on temporary script file \"${temporary_variables_script_path}\": ${sed_result}.";
        return 1;
    fi;

    return 0;
}

# Copies the script template to the tmeporary script directory.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the script was copied successfully.
#   1 - Otherwise.
#
copy_script_template() {

    local cp_result;

    echo -e "Copying script template to temporary directory.";

    cp "${variables_script_template_path}" "${temporary_variables_script_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying template script \"${variables_script_template_path}\" to \"${temporary_variables_script_path}\": ${cp_result}.";
        return 1;
    fi;

    return 0;
}

# Installs the script which defined the system variables required for Anna to execute.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the script was deployed successfully.
#   1 - Otherwise.
#
install_variables_script() {

    local copy_script_template_result;
    local replace_terms_on_script_result;
    local deploy_script_result;

    # Checks if current user has permission to write on deploy directory.
    if [ ! -w "${script_deploy_directory_path}" ];
    then
        print_error_message "User \"$(whoami)\" does not have permission to write on directory \"${script_deploy_directory_path}\".";
        return 1;
    fi;

    copy_script_template;
    copy_script_template_result=${?};
    if [ ${copy_script_template_result} -ne 0 ];
    then
        print_error_message "Error while copying the script template.";
        return 1;
    fi;

    replace_terms_on_script;
    replace_terms_on_script_result=${?};
    if [ ${replace_terms_on_script_result} -ne 0 ];
    then
        print_error_message "Error while replacing terms on variables script.";
        return 1;
    fi;

    deploy_script;
    deploy_script_result=${?};
    if [ ${deploy_script_result} -ne 0 ];
    then
        print_error_message "Error while deploying variables script.";
        return 1;
    fi;

    return 0;
}

install_variables_script ${@};
exit ${?};
