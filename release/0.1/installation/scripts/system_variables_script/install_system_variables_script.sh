#!/bin/bash

# This script creates and installs the script which defines the system variables required for the system to execute.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the system variables' script was installed successfully.
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

# Loads system variables' script creation constants.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Loads installation functions.
source "$(dirname ${BASH_SOURCE})/../functions.sh";


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

    cp "${temporary_system_variables_script_path}" "${deployed_system_variables_script_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying script \"${temporary_system_variables_script_path}\" to \"${deployed_system_variables_script_path}\": ${cp_result}.";
        return 1;
    fi;

    chmod 644 "${deployed_system_variables_script_path}";
    chmod_result=${?};
    if [ ${chmod_result} -ne 0 ];
    then
        print_error_message "Error while defining permissions on file \"${deployed_system_variables_script_path}\".";
        return 1;
    fi;

    return 0;
}

# Copies the script template to the temporary script directory.
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

    echo -e "Copying system variables' script template to temporary directory.";

    cp "${system_variables_script_template_path}" "${temporary_system_variables_script_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying template script \"${system_variables_script_template_path}\" to \"${temporary_system_variables_script_path}\": ${cp_result}.";
        return 1;
    fi;

    return 0;
}

# Installs the script which defines the system variables required for the system to execute.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the system variables' script was installed successfully.
#   1 - Otherwise.
#
install_system_variables_script() {

    local copy_script_template_result;
    local replace_terms_result;
    local deploy_script_result;

    # Checks if current user has permission to write on deploy directory.
    if [ ! -w "${system_variables_script_deploy_directory_path}" ];
    then
        print_error_message "User \"$(whoami)\" does not have permission to write on directory \"${system_variables_script_deploy_directory_path}\".";
        return 1;
    fi;

    copy_script_template;
    copy_script_template_result=${?};
    if [ ${copy_script_template_result} -ne 0 ];
    then
        print_error_message "Error while copying the script template.";
        return 1;
    fi;

    replace_terms "${temporary_system_variables_script_path}";
    replace_terms_result=${?};
    if [ ${replace_terms_result} -ne 0 ];
    then
        print_error_message "Error while replacing terms on system variables' script.";
        return 1;
    fi;

    deploy_script;
    deploy_script_result=${?};
    if [ ${deploy_script_result} -ne 0 ];
    then
        print_error_message "Error while deploying system variables' script.";
        return 1;
    fi;

    return 0;
}

install_system_variables_script ${@};
exit ${?};
