#!/bin/bash

# This script cleans up the system directories.
#
# Parameters:
#   None.
#
# Return:
#   SUCCESS - If system directories were clean up successfully.
#   GENERIC_ERROR - Otherwise.
#
# Version:
#   0.1
#
# Author: 
#   Marcelo Leite
#


# ###
# Source scripts.
# ###

# Load generic constants script.
source "$(dirname ${BASH_SOURCE})/generic/constants.sh";

# Load audio encoder constants script.
source "$(dirname ${BASH_SOURCE})/audio/encoder/constants.sh";

# Load log functions script.
source "$(dirname ${BASH_SOURCE})/log/functions.sh";

# ###
# Functions elaboration.
# ###

# Empties trash directory
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If trash directory was emptied successfully.
#   GENERIC_ERROR - Otherwise.
empty_trash_directory() {

    local rm_result;

    # Remove files from trash directory.
    rm ${trash_directory}/*;
    rm_result=${?};
    if [ ${rm_result} -ne 0 ];
    then
        log ${log_message_type_error} "Error while removing files from trash directory.";
        return ${generic_error};
    fi;

    return ${success}
}

# Creates a new log tarball file.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If log tarball file was created successfully.
#   GENERIC_ERROR - Otherwiser.
#   It also returns the new log tarball file path through "echo".
create_new_log_tarball_file(){

    local date_result;
    local log_tarball_file_name;
    local touch_result;

    # Retrives current time.
    current_time="$(date +"%Y%m%d_%H%M%S")";
    date_result=${?};
    if [ ${date_result} -ne 0 ];
    then
        log ${log_message_type_error} "Error while retrieving current time: ${date_result}."
        return ${generic_error};
    fi;

    # Elaborates the log tarball file name.
    log_tarball_file_path="${log_files_directory}${log_tarball_file_preffix}_${current_time}${tarball_file_suffix}";

    # Creates the log tarball file name.
    touch ${log_tarball_file_path};
    touch_result=${?};
    if [ ${touch_result} -ne 0 ];
    then
        log ${log_message_type_error} "Could not create log tarball file \"${log_tarball_file_name}\": ${touch_result}.";
        return ${generic_error};
    fi;

    echo "${log_tarball_file_path}";

    return ${success};
}

# Retrieves the path to the latest tarball log file created.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If the path to the latest tarball log file created was retrieved successfully.
#   GENERIC_ERROR - Otherwise.
#   It also returns the latest log tarball file path through "echo".
#
retrieve_latest_log_tarball_file_path() {

    local latest_log_tarball_file_path;
    local command_result;
    local file_exists;

    # Checks if a log tarball file exists.
    file_exists=$(ls -1 ${log_tarball_files_pattern} 2>/dev/null | wc -l);
    if [ ${file_exists} -le 0 ];
    then
        return ${success};
    fi;

    # Retrieves the latest tarball file path name.
    latest_log_tarball_file_path=$(ls -A1tr ${log_tarball_files_pattern} | tail -n 1);
    command_result=${?};
    if [ ${command_result} -ne 0 ];
    then
        log ${log_message_type_error} "Could not retrieve latest log tarball file path: ${command_result}";
        return ${generic_error};
    fi;

    echo -ne "${latest_log_tarball_file_path}";

    return ${success};
}

# Compress all the log files, except for the latest one.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If all log files were compressed successfully.
#   GENERIC_ERROR - Otherwise.
#
compress_log_files() {

    local latest_tarball_file;
    local retrieve_latest_tarball_log_result;
    local latest_tarball_file_size;
    local stat_result;
    local gzip_result;
    local tar_result;

    # Checks if a log file exists.
    file_exists=$(ls -A1tr ${log_files_pattern} 2>/dev/null | wc -l);
    if [ ${file_exists} -le 0 ];
    then
        return ${success};
    fi;

    # Retrieve latest tarball created.
    latest_tarball_file=$(retrieve_latest_log_tarball_file_path);
    retrieve_latest_tarball_log_result=${?};
    if [ ${retrieve_latest_tarball_log_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Could not retrieve latest log tarball file path.";
        return ${generic_error};
    fi;

    # If a log tarball file was retrieved.
    if [ -n "${latest_tarball_file}" ];
    then

        # Retrieves the latest log tarball file size.
        latest_tarball_file_size=$(stat -c%s "${latest_tarball_file}");
        stat_result=${?};
        if [ ${stat_result} -ne 0 -o -z "${latest_tarball_file_size}" ];
        then
            log ${log_message_type_error} "Could not retrieve latest log tarball file size.";
            return ${generic_error};
        fi;

        # If latest tarball file size exceeds the limit.
        if [ ${latest_tarball_file_size} -ge ${log_tarball_file_size_limit} ];
        then

            # Zips the current tarball file.
            gzip "${latest_tarball_file}";
            gzip_result=${?};
            if [ ${gzip_result} -ne 0 ];
            then
                log ${log_message_type_error} "Error while compressing previous log tarball file: ${gzip_result}";
                return ${generic_error};
            fi;

            # Creates a new tarball file.
            latest_tarball_file="$(create_new_log_tarball_file)";
            create_new_log_tarball_file_result=${?};
            if [ ${create_new_log_tarball_file_result} -ne ${success} -o -z "${latest_tarball_file}" ];
            then 
                log ${log_message_type_error} "Could not create a new log tarball file.";
                return ${generic_error};
            fi;
        fi;
    else
        # Creates a new tarball file.
        latest_tarball_file=$(create_new_log_tarball_file);
        create_new_log_tarball_file_result=${?};
        if [ ${create_new_log_tarball_file_result} -ne ${success} -o -z "${latest_tarball_file}" ];
        then 
            log ${log_message_type_error} "Could not create a new log tarball file.";
            return ${generic_error};
        fi;
    fi;

    # Adds the log files to the latest log tarball file.
    tar -rf "${latest_tarball_file}" ${log_files_pattern} 2>/dev/null;
    tar_result=${?}
    if [ ${tar_result} -ne 0 ];
    then
        log ${log_message_type_error} "Error while creating a tarball with log files: ${tar_result}.";
        return ${generic_error};
    fi;

    # Removes the log files from log directory.
    $(ls -1 ${log_files_pattern} | xargs -i mv {} "${trash_directory}" );
    command_result=${?};
    if [ ${command_result} -ne 0 ];
    then
        log ${log_message_type_error} "Error while moving log files to tash directory.";
        return ${generic_error};
    fi;

    return ${success};
}

# Cleans up the audio directory, removing all the audio files except the latest one.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If audio directory was cleaned up successfully.
#   GENERIC_ERROR - Otherwise.
#
clean_up_audio_directory() {

    local command_result;
    local file_exists;

    # Checks if a audio files exists.
    file_exists=$(ls -1 ${audio_file_pattern} 2>/dev/null | wc -l);
    if [ ${file_exists} -le 1 ];
    then
        return ${success};
    fi;

    # $(eval ls -A1tr ${audio_file_pattern} | head -n -1 | xargs echo );
    $(ls -1 ${audio_file_pattern} | head -n -1 | xargs -i mv {} "${trash_directory}" );
    command_result=${?};
    if [ ${command_result} -ne 0 ];
    then
        log ${log_messsage_type_error} "Error while cleaning up audio directory: ${clean_up_audio_directory_result}.";
        return ${generic_error};
    fi;

    return ${success};
}


# Cleans up the system directories.
#
# Parameters:
#   None.
#
# Returns:
#   SUCCESS - If system directories were clean up successfully.
#   GENERIC_ERROR - Otherwise.
#
clean_up_directories(){

    local clean_up_audio_directory_result;

    # Cleans up audio directory.
    clean_up_audio_directory;
    clean_up_audio_directory_result=${?};
    if [ ${clean_up_audio_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error while cleaning up audio directory.";
        return ${generic_error};
    fi;

    # Compress log files.
    compress_log_files;
    compress_log_files_result=${?};
    if [ ${compress_log_files_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error while compressing log files.";
        return ${generic_error};
    fi;

    # Empties trash directory.
    empty_trash_directory;
    empty_trash_directory_result=${?};
    if [ ${empty_trash_directory_result} -ne ${success} ];
    then
        log ${log_message_type_error} "Error while emptying trash directory.";
        return ${generic_error};
    fi;

    return ${success};
}

# Requests to clean up directories.
clean_up_directories ${@};
exit ${?};
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
