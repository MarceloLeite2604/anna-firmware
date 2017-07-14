#!/bin/bash

# This script contains the functions used throughout the system services' creation.
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
if [ -z "${CREATE_SERVICES_FUNCTIONS_SH}" ]
then
    CREATE_SERVICES_FUNCTIONS_SH=1;
else
    return;
fi;


# ###
# Source scripts.
# ###

# Loads service creation constants.
source "$(dirname ${BASH_SOURCE})/constants.sh";

# Loads generic installation functions.
source "$(dirname ${BASH_SOURCE})/../generic/functions.sh";


# ###
# Functions elaborations.
# ###

# Disables a service.
#
# Parameters:
#   1. The service name.
#
# Returns:
#   0 - If the service was disabled successfully.
#   1 - Otherwise.
#
disable_service() {

    local service_name;
    local systemctl_disable_result;
   
    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        service_name="${1}";
    fi;
    
    # Enables the service.
    systemctl disable ${service_name};
    systemctl_disable_result=${?};
    if [ ${systemctl_disable_result} -ne 0 ];
    then
        print_error_message "Error while disabling service \"${service_name}\": ${systemctl_disable_result}.";
        return 1;
    fi;
    
    return 0;
}

# Enables a service.
#
# Parameters:
#   1. The service name.
#
# Returns:
#   0 - If the service was enabled successfully.
#   1 - Otherwise.
#
enable_service() {

    local service_name;
    local systemctl_enable_result;
   
    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        service_name="${1}";
    fi;
    
    # Enables the service.
    systemctl enable ${service_name};
    systemctl_enable_result=${?};
    if [ ${systemctl_enable_result} -ne 0 ];
    then
        print_error_message "Error while enabling service \"${service_name}\": ${systemctl_enable_result}.";
        return 1;
    fi;
    
    return 0;
}

# Starts a service.
#
# Parameters:
#   1. The service to activate.
#
# Returns:
#   0 - If service was successfully activated.
#   1 - Otherwise.
#
start_service() {

    local service_name;
    local enable_service_result;
    local systemctl_start_result;
   
    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        service_name="${1}";
    fi;
    
    # Enables the service.
    enable_service "${service_name}";
    enable_service_result=${?};
    if [ ${enable_service_result} -ne 0 ];
    then
        print_error_message "Error while enabling service.";
        return 1;
    fi;
    
    # Activates the service.
    systemctl start ${service_name};
    systemctl_start_result=${?};
    if [ ${systemctl_start_result} -ne 0 ];
    then
        print_error_message "Error while starting service \"${service_name}\": ${systemctl_start_result}.";
        return 1;
    fi;
    
    return 0;
}

# Creates the directory to store the services' shell scripts.
#
# Parameters:
#   None.
#
# Returns:
#   0 - If the directory to store the services' shell scripts was created successfully.
#   1 - Otherwise.
#
create_services_scripts_directory() {
    local mkdir_result;
    
    # If services' shell script directory does not exist.
    if [ ! -d "${destination_services_scripts_directory_path}" ]
    then
       
        echo "Creating services' shell scripts' directory.";
       
        mkdir -p "${destination_services_scripts_directory_path}";
        mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            print_error_message "Error creating the directory \"${destination_services_scripts_directory_path}\" to store the services' shell script on destination directory: ${mkdir_result}.";
            return 1;
        fi;
        
    else
        echo "Services' shell scripts' directory already exists.";
    fi;
    
    return 0;
}

# Deploys a systemd unit file.
#
# Parameters:
#   1. The systemd unit file to deploy.
#
# Returns:
#   0 - If systemd unit file was deployed successfully.
#   1 - Otherwise.
#
deploy_systemd_unit() {
    
    local unit_file_path;
    local cp_result;
    local chmod_result;
    local systemctl_reload_result;

    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        unit_file_path="${1}";
    fi;
    
    # Copies the file to systemd units file location.
    cp "${unit_file_path}" "${systemd_unit_files_deploy_directory_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying unit file \"${unit_file_path}\" to \"${systemd_unit_files_deploy_directory_path}\": ${cp_result}.";
        return 1;
    fi;
    
    deployed_systemd_unit_file_path="${systemd_unit_files_deploy_directory_path}${unit_file_path}";
    
    # Changes the unit file permission.
    chmod 644 "${deployed_systemd_unit_file_path}";
    chmod_result=${?};
    if [ ${chmod_result} -ne 0 ];
    then
        print_error_message "Error while changing file permissions on \"${deployed_systemd_unit_file_path}\": ${chmod_result}.";
        return 1;
    fi;
    
    # Requests systemctl to update its list of units.
    systemctl daemon-reload;
    systemctl_reload_result=${?};
    if [ ${systemctl_reload_result} -ne 0 ];
    then
        print_error_message "Error while reloading list of units on systemctl: ${systemctl_reload_result}.";
        return 1;
    fi;
    
    return 0;
}

# Replaces the substitution terms on a systemd unit model file.
#
# Parameters:
#   1. The path to the systemd unit file model.
#
# Returns:
#   0 - If the term were substituted successfully.
#   1 - Otherwise.
#
replace_systemd_unit_model_terms() {

    local unit_model_file_path;
    local replacement_string;

    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        unit_file_model_path="${1}";
    fi;
    
    # Elaborates the replacement string to the "service' shell scripts' directory path" substitution term.
    # Observation: Precedes the forward slashes with backward slashes (escape character to "sed" command).
    replacement_string="${destination_services_scripts_directory_path//\//\\/}";

    # Replaces the "system services' shell scripts' directory path" substitution term by its value.
    sed -i -e "s/${term_destination_services_scripts_directory_path}/${replacement_string}/g" "${unit_file_model_path}";
    sed_result=${?};
    if [ ${sed_result} -ne 0 ];
    then
        print_error_message "Error replacing the \"system services' shell scripts' directory path\" substitution term on unit file model \"${unit_file_model_path}\": ${sed_result}.";
        return 1;
    fi;
    
    return 0;
}

# Creates the systemd unit file.
#
# Parameters:
#   1. The path to the systemd unit file model to be used.
#
# Returns:
#   0 - If systemd unit file was created successfully.
#   1 - Otherwise.
#
create_systemd_unit_file() {

    local unit_file_model_path;
    local unit_file_model_name;
    local temporary_unit_file_model_path;
    local replace_systemd_unit_model_terms_result;
    local deploy_system_unit_result;

    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        unit_file_model_path="${1}";
        unit_file_model_name="$(basename ${unit_file_model_path})";
    fi;
    
    # Copies the unit model to the temporary directory.
    cp "${unit_file_model_path}" "${temporary_unit_files_directory_path}";
    cp_result=${?};
    if [ ${cp_result} -ne 0 ];
    then
        print_error_message "Error while copying unit model file \"${unit_file_model_path}\" to temporary directory \"${temporary_unit_files_directory_path}\": ${cp_result}.";
        return 1;
    fi;
    
    temporary_unit_file_model_path="${temporary_unit_files_directory_path}${unit_file_model_name}";
    
    # Replaces the substitution terms on systemd unit file model.
    replace_systemd_unit_model_terms "${temporary_unit_file_model_path}";
    replace_systemd_unit_model_terms_result=${?};
    if [ ${replace_systemd_unit_model_terms_result} -ne 0 ];
    then
        print_error_message "Error while replacing substitution terms on unit file model \"${temporary_unit_file_model_path}\".";
        return 1;
    fi;
    
    # Deploys the systemd unit file.
    deploy_systemd_unit "${temporary_unit_file_model_path}";
    deploy_system_unit_result=${?};
    if [ ${deploy_system_unit_result} -ne 0 ];
    then
        print_error_message "Error while deploying systemd unit file \"${temporary_unit_file_model_path}\".";
        return 1;
    fi;
    
    return 0;
}

# Installs a service script on destination directory.
#
# Parameters:
#   1 - The path to the service script.
#
# Returns:
#   0 - If the service script was installed successfully.
#   1 - Otherwise.
#
install_service_script() {

    local service_script_path;
    local service_script_name;
    
    # Check function parameters.
    if [ ${#} -ne 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else
        service_script_path="${1}";
        service_script_name="$(basename ${service_script_path})";
    fi;
    
    # TODO: Conclude.
    
    return 0;
}

# Creates a service.
#
# Parameters:
#   1. The path to the service's unit model file.
#   2. The name of the array which stores the service's scripts (optional).
#
# Result:
#   0 - If the service was created successfully.
#   1 - Otherwise.
#
create_service() {

    local service_unit_model_file_path;
    local service_name;
    local service_scripts_path;
    local install_service_script_result;
    local create_systemd_unit_file_result;
    local start_service_result;

    # Check function parameters.
    if [ ${#} -lt 1 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\" function.";
        return 1;
    else

        service_unit_model_file_path="${1}";
        service_name="$(basename ${service_unit_model_file_path})";

        if [ ${#} -ge 2];
        then
            service_scripts_path=("${!${2[@]}}");
        fi;
    fi;

    # If the service has shell scripts to install.
    if [ -z "${service_scripts_path[@]}" ];
    then
        # Installs the service's scripts.
        for service_script_path in ${service_scripts_path[@]}
        do
            echo "Installing service script \"$(basename ${service_script_path})\".";
            install_service_script "${service_script_path}";
            install_service_script_result=${?};
            if [ ${install_service_script_result} -ne 0 ];
            then
                print_error_message "Error while installing service script \"${service_script_path}\".";
                return 1;
            fi;
        done;
    fi;

    echo "Creating service's systemd unit file from model \"${service_unit_model_file_path}\".";

    # Creates the service's systemd unit file.
    create_systemd_unit_file "${service_unit_model_file_path}";
    create_systemd_unit_file_result=${?};
    if [ ${create_systemd_unit_files_result} -ne 0 ];
    then
        print_error_message "Error while creating service's systemd unit file from model \"${service_unit_model_file_path}\".";
        return 1;
    fi;

    # Starts the service.
    start_service "${service_name}";
    start_service_result=${?};
    if [ ${start_service_result} -ne 0];
    then
        print_error_message "Error while starting service \"${service_name}\".";
        return 1;
    fi;
    
    return 0;
}
