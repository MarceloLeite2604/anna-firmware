#!/bin/bash

# Script to build the project's programs.
#
# Parameters:
#   1. The type of build to be done ("debug", "release" or "all").
#
# Returns:
#   0 - If the programs were built successfully.
#   1 - If there was an error while building the programs.
#
# Version: 
#   0.1
#
# Author:
#   Marcelo Leite

# create_directory() {
# 
#     local mkdir_result="";
#     local result=1;
# 
#     local directory="${1}";
# 
#     if [ ! -d "${directory}" ];
#     then
#         # echo "Directory \"${directory}\" does not exist.";
#         mkdir -p "${directory}"
#         mkdir_result=${?};
#         if [ ${mkdir_result} -ne 0 ];
#         then
#             echo "Could not create directory \"${directory}\".";
#             result=1;
#         else
#             echo "Directory \"${directory}\" created.";
#             result=0;
#         fi;
#     else
#         result=0;
#     fi;
# 
#     return ${result};
# }

# build_programs() {
# 
#     local output_directory="${1}";
#     local additional_arguments="${2}";
# 
#     local source_directory="../src/";
#     local release_source_directory="${source_directory}release/";
#     local test_source_directory="${source_directory}test/";
#     local objects_directory="${output_directory}objects/";
#     local binary_folder="${output_directory}bin/";
# 
#     create_directory "${objects_directory}";
#     create_directory "${binary_folder}";
#     
#     echo "creating \"time\" object.";
#     gcc -c ${release_source_directory}general/time/time.c -o ${objects_directory}time.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "error creating \"time\" object.";
#         return 1;
#     fi;
#     echo "creating \"log\" object.";
#     gcc -c ${release_source_directory}log/log.c -o ${objects_directory}log.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "error creating \"log\" object.";
#         return 1;
#     fi;
# 
#     echo "Creating \"directory\" object.";
#     gcc -c ${release_source_directory}directory/directory.c -o ${objects_directory}directory.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"directory\" object.";
#         return 1;
#     fi;
# 
#     echo "creating \"file\" object.";
#     gcc -c ${release_source_directory}general/file/file.c -o ${objects_directory}file.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "error creating \"file\" object.";
#         return 1;
#     fi;
# 
#     echo "Creating \"wait time\" object.";
#     gcc -c ${release_source_directory}general/wait_time/wait_time.c -o ${objects_directory}wait_time.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"wait time\" object.";
#         return 1;
#     fi;
#     
#     echo "creating \"byte array\" object.";
#     gcc -c ${release_source_directory}general/byte_array/byte_array.c -o ${objects_directory}byte_array.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "error creating \"byte_array\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"script\" object.";
#     gcc -c ${release_source_directory}script/script.c -o ${objects_directory}script.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"script\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"audio\" object.";
#     gcc -c ${release_source_directory}audio/audio.c -o ${objects_directory}audio.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"audio\" object.";
#         return 1;
#     fi;
#     
#     # echo "Creating \"bluetooth\" object.";
#     # gcc -c ${release_source_directory}bluetooth/bluetooth.c -o ${objects_directory}bluetooth.o ${additional_arguments};
#     # if [ $? -ne 0 ];
#     # then
#     #     echo "Error creating \"bluetooth\" object.";
#     #     return 1;
#     # fi;
#     
#     # echo "Creating \"bluetooth package codes\" object.";
#     # gcc -c ${release_source_directory}bluetooth/package/codes/codes.c -o ${objects_directory}bluetooth_package_codes.o ${additional_arguments};
#     # if [ $? -ne 0 ];
#     # then
#     #     echo "Error creating \"bluetooth package codes\" object.";
#     #     return 1;
#     # fi;
# 
#     echo "Creating \"command result content\" object.";
#     gcc -c ${release_source_directory}bluetooth/package/content/command_result/command_result.c -o ${objects_directory}command_result_content.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"command result content\" object.";
#         return 1;
#     fi; 
# 
#     echo "Creating \"confirmation content\" object.";
#     gcc -c ${release_source_directory}bluetooth/package/content/confirmation/confirmation.c -o ${objects_directory}confirmation_content.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"confirmation content\" object.";
#         return 1;
#     fi; 
# 
#     echo "Creating \"error content\" object.";
#     gcc -c ${release_source_directory}bluetooth/package/content/error/error.c -o ${objects_directory}error_content.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"error content\" object.";
#         return 1;
#     fi; 
# 
#     echo "Creating \"send file chunk content\" object.";
#     gcc -c ${release_source_directory}bluetooth/package/content/send_file_chunk/send_file_chunk.c -o ${objects_directory}send_file_chunk_content.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"send file chunk content\" object.";
#         return 1;
#     fi; 
# 
#     echo "Creating \"send file header content\" object.";
#     gcc -c ${release_source_directory}bluetooth/package/content/send_file_header/send_file_header.c -o ${objects_directory}send_file_header_content.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"send file header content\" object.";
#         return 1;
#     fi; 
# 
#     echo "Creating \"send file trailer content\" object.";
#     gcc -c ${release_source_directory}bluetooth/package/content/send_file_trailer/send_file_trailer.c -o ${objects_directory}send_file_trailer_content.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"send file trailer content\" object.";
#         return 1;
#     fi; 
# 
#     echo "Creating \"bluetooth package content\" object.";
#     gcc -c ${release_source_directory}bluetooth/package/content/content.c -o ${objects_directory}bluetooth_package_content.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"bluetooth package content\" object.";
#         return 1;
#     fi; 
#     echo "Creating \"bluetooth package\" object.";
#     gcc -c ${release_source_directory}bluetooth/package/package.c -o ${objects_directory}bluetooth_package.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"bluetooth package\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"bluetooth connection\" object.";
#     gcc -c ${release_source_directory}bluetooth/connection/connection.c -o ${objects_directory}bluetooth_connection.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"bluetooth connection\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"bluetooth communication\" object.";
#     gcc -c ${release_source_directory}bluetooth/communication/communication.c -o ${objects_directory}bluetooth_communication.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"bluetooth communication\" object.";
#         return 1;
#     fi;
#     echo "Creating \"bluetooth service\" object.";
#     gcc -c ${release_source_directory}bluetooth/service/service.c -o ${objects_directory}bluetooth_service.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"bluetooth service\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"error messages\" object.";
#     gcc -c ${release_source_directory}general/error_messages/error_messages.c -o ${objects_directory}error_messages.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"error messages\" object.";
#         return 1;
#     fi;
# 
#     echo "Creating \"random\" object.";
#     gcc -c ${release_source_directory}general/random/random.c -o ${objects_directory}random.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"random\" object.";
#         return 1;
#     fi;
# 
#     echo "Creating \"testlog\" object.";
#     gcc -c ${test_source_directory}testlog.c -o ${objects_directory}testlog.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testlog\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"testlog\" program.";
#     gcc -o ${binary_folder}testlog ${objects_directory}directory.o ${objects_directory}script.o ${objects_directory}time.o ${objects_directory}log.o ${objects_directory}testlog.o -lm ${additional_arguments};
#     
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testlog\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"testdirectory\" object.";
#     gcc -c ${test_source_directory}testdirectory.c -o ${objects_directory}testdirectory.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testdirectory\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"testdirectory\" program.";
#     gcc -o ${binary_folder}testdirectory ${objects_directory}directory.o ${objects_directory}time.o ${objects_directory}log.o ${objects_directory}script.o ${objects_directory}testdirectory.o -lm ${additional_arguments};
#     
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testdirectory\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"testscript\" object.";
#     gcc -c ${test_source_directory}testscript.c -o ${objects_directory}testscript.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testdirectory\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"testscript\" program.";
#     gcc -o ${binary_folder}testscript ${objects_directory}script.o ${objects_directory}time.o ${objects_directory}log.o ${objects_directory}directory.o ${objects_directory}testscript.o -lm ${additional_arguments};
#     
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testscript\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"testaudio\" object.";
#     gcc -c ${test_source_directory}testaudio.c -o ${objects_directory}testaudio.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testaudio\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"testaudio\" program.";
#     gcc -o ${binary_folder}testaudio ${objects_directory}file.o ${objects_directory}time.o ${objects_directory}log.o ${objects_directory}directory.o ${objects_directory}script.o ${objects_directory}audio.o ${objects_directory}testaudio.o -lm ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testaudio\" program.";
#         return 1;
#     fi;
# 
#     echo "Creating \"testwaittime\" object.";
#     gcc -c ${test_source_directory}testwaittime.c -o ${objects_directory}testwaittime.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testwaittime\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"testwaittime\" program.";
#     gcc -o ${binary_folder}testwaittime ${objects_directory}testwaittime.o ${objects_directory}directory.o ${objects_directory}script.o ${objects_directory}time.o ${objects_directory}log.o ${objects_directory}wait_time.o -lm ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testwaittime\" program.";
#         return 1;
#     fi;
# 
#     echo "Creating \"testpackage\" object.";
#     gcc -c ${test_source_directory}testpackage.c -o ${objects_directory}testpackage.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testpackage\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"testpackage\" program.";
#     gcc -o ${binary_folder}testpackage ${objects_directory}directory.o ${objects_directory}script.o ${objects_directory}error_messages.o ${objects_directory}random.o ${objects_directory}byte_array.o ${objects_directory}bluetooth_package_content.o ${objects_directory}command_result_content.o ${objects_directory}confirmation_content.o ${objects_directory}error_content.o ${objects_directory}send_file_chunk_content.o ${objects_directory}send_file_header_content.o ${objects_directory}send_file_trailer_content.o ${objects_directory}bluetooth_package.o ${objects_directory}time.o ${objects_directory}log.o ${objects_directory}testpackage.o -lm ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"testpackage\" program.";
#         return 1;
#     fi;
# 
#     # echo "Creating \"testbluetooth\" object.";
#     # gcc -c ${test_source_directory}testbluetooth.c -o ${objects_directory}testbluetooth.o ${additional_arguments};
#     # if [ $? -ne 0 ];
#     # then
#     #     echo "Error creating \"testbluetooth\" object.";
#     #     return 1;
#     # fi;
#     
#     # echo "Creating \"testbluetooth\" program.";
#     # gcc -o ${binary_folder}testbluetooth ${objects_directory}error_messages.o ${objects_directory}random.o ${objects_directory}byte_array.o ${objects_directory}bluetooth_package.o ${objects_directory}directory.o ${objects_directory}script.o ${objects_directory}bluetooth_package_codes.o ${objects_directory}time.o ${objects_directory}log.o ${objects_directory}bluetooth.o ${objects_directory}testbluetooth.o -lbluetooth -lm ${additional_arguments};
#     # if [ $? -ne 0 ];
#     # then
#     #     echo "Error creating \"testbluetooth\" program.";
#     #     return 1;
#     # fi;
# 
#     echo "Creating \"muni\" object.";
#     gcc -c ${release_source_directory}muni.c -o ${objects_directory}muni.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"muni\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"muni\" program.";
#     gcc -o ${binary_folder}muni ${objects_directory}muni.o ${objects_directory}time.o ${objects_directory}log.o ${objects_directory}bluetooth_service.o ${objects_directory}script.o ${objects_directory}bluetooth_connection.o ${objects_directory}bluetooth_communication.o ${objects_directory}bluetooth_package.o ${objects_directory}bluetooth_package_content.o ${objects_directory}command_result_content.o ${objects_directory}confirmation_content.o ${objects_directory}error_content.o ${objects_directory}send_file_chunk_content.o ${objects_directory}send_file_header_content.o ${objects_directory}send_file_trailer_content.o ${objects_directory}byte_array.o ${objects_directory}wait_time.o ${objects_directory}random.o ${objects_directory}directory.o ${objects_directory}audio.o ${objects_directory}file.o -lbluetooth -lm ${additional_arguments};
#     
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"muni\" program.";
#         return 1;
#     fi;
# 
#     echo "Creating \"store_instant\" object.";
#     gcc -c ${release_source_directory}store_instant.c -o ${objects_directory}store_instant.o ${additional_arguments};
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"store_instant\" object.";
#         return 1;
#     fi;
#     
#     echo "Creating \"store_instant\" program.";
#     gcc -o ${binary_folder}store_instant ${objects_directory}store_instant.o ${objects_directory}time.o ${objects_directory}log.o ${objects_directory}script.o ${objects_directory}directory.o -lm ${additional_arguments};
#     
#     if [ $? -ne 0 ];
#     then
#         echo "Error creating \"store_instant\" program.";
#         return 1;
#     fi;
# }

print_usage(){
    echo -e "Use this script to build the programs of this project.\n"
    echo -e "Usage:"
    echo -e "\t$(basename ${0}) {debug, release, all}\n"
    echo -e "\tdebug - Builds all programs for debug."
    echo -e "\trelease - Builds all programs for release."
    echo -e "\tall - Build all programs for debug and release.\n"
}

buid_programs() {

    local makefile_directory;
    local output_files_directory;
    local additional_compile_flags;
    local command_to_execute;
    local make_result;

    # Checks function parameters.
    if [ ${#} -lt 2 ];
    then
        print_error_message "Invalid parameters to execute \"${FUNCNAME[0]}\".";
        return 1;
    else

        makefile_directory="${1}";
        output_files_directory="${2}";

        if [ ${#} -eq 3 ];
        then
            additional_compile_flags="${3}";
        fi;
    fi;

    # Builds the command to execute.
    command_to_execute="${makefile_directory}make ${make_parameter_include_directory}=${source_files_directory}../include ${make_parameter_output_files_directory}=${output_files_directory}";

    # If the third parameter was informed, add it to the command.
    if [ -z "${additional_compile_flags}" ];
    then
        command_to_execute="${command_to_execute} ${make_parameter_additional_compile_flags}=${additional_compile_flags}";
    fi;

    # Concatenate the target to execute.
    command_to_execute="${command_to_execute} all";

    # Executes the command.
    ${command_to_execute};
    make_result=${?};
    if [ ${make_result} -ne 0 ];
    then
        print_error_message "Error while buiding the programs.";
        return 1;
    fi;

    return 0;
}

build_release() {
    echo -e "\nBuilding programs for release.";

    local output_files_directory="$(dirname ${BASH_SOURCE})/../release/";
    local build_programs_result;

    build_programs "${source_file}release/" "${output_files_directory}";
    build_programs_result=${?};
    if [ ${build_programs_result} -ne 0 ];
    then
        return 1;
    fi;

    return 0;
}

build_debug() {
    echo -e "\nBuilding programs for debug.";

    local output_files_directory="$(dirname ${BASH_SOURCE})/../debug/";
    local additional_compile_flags="-g";
    local build_programs_result;

    build_programs "${source_file}release/" "${output_files_directory}" "${additional_compile_flags}";
    build_programs_result=${?};
    if [ ${build_programs_result} -ne 0 ];
    then
        return 1;
    fi;

    build_programs "${source_file}test/" "${output_files_directory}" "${additional_compile_flags}";
    build_programs_result=${?};
    if [ ${build_programs_result} -ne 0 ];
    then
        return 1;
    fi;

    return 0;
}

build() {

    local build_type="${1}";

    local makefile_directory;
    local output_files_directory;
    local additional_compile_flags;

    local build_result;

    if [ -z "${build_type}" ];
    then
        print_usage;
        >&2 echo "ERROR: Build type not informed.";
        return 1;
    fi;

    case "${build_type}" in
        "debug")
            build_debug();
            build_result=${?};
            if [ ${build_result} -ne 0 ];
            then
                print_error_message "Error while building for debug.";
                return 1;
            fi;
            ;;

        "release")
            build_release();
            build_result=${?};
            if [ ${build_result} -ne 0 ];
            then
                print_error_message "Error while building for release.";
                return 1;
            fi;
            ;;

        "all")
            build_debug();
            build_result=${?};
            if [ ${build_result} -ne 0 ];
            then
                print_error_message "Error while building for debug.";
                return 1;
            fi;

            build_release();
            build_result=${?};
            if [ ${build_result} -ne 0 ];
            then
                print_error_message "Error while building for release.";
                return 1;
            fi;
            ;;

        "help"|"-h")
            print_usage;
            ;;

        *)
            print_usage;
            >&2 echo "ERROR: Unknown build type \"${build_type}\".";
            return 1;
            ;;
    esac

    return 0;
}

build ${@};
exit ${?};
