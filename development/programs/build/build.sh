#!/bin/bash

build_programs() {

    local output_directory="${1}";
    local additional_arguments="${2}";

    local source_directory="../src/";
    local release_source_directory="${source_directory}release/";
    local test_source_directory="${source_directory}test/";
    local objects_directory="${output_directory}objects/";
    local binary_folder="${output_directory}bin/";
    
    echo "Creating \"log\" object.";
    gcc -c ${release_source_directory}log/log.c -o ${objects_directory}log.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"log\" object.";
        return 1;
    fi;
    
    echo "Creating \"directory\" object.";
    gcc -c ${release_source_directory}directory/directory.c -o ${objects_directory}directory.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"directory\" object.";
        return 1;
    fi;
    
    echo "Creating \"script\" object.";
    gcc -c ${release_source_directory}script/script.c -o ${objects_directory}script.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"script\" object.";
        return 1;
    fi;
    
    echo "Creating \"audio\" object.";
    gcc -c ${release_source_directory}audio/audio.c -o ${objects_directory}audio.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"audio\" object.";
        return 1;
    fi;
    
    echo "Creating \"bluetooth\" object.";
    gcc -c ${release_source_directory}bluetooth/bluetooth.c -o ${objects_directory}bluetooth.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"bluetooth\" object.";
        return 1;
    fi;
    
    echo "Creating \"bluetooth package codes\" object.";
    gcc -c ${release_source_directory}bluetooth/package/codes/codes.c -o ${objects_directory}bluetooth_package_codes.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"bluetooth package codes\" object.";
        return 1;
    fi;

    echo "Creating \"bluetooth package\" object.";
    gcc -c ${release_source_directory}bluetooth/package/package.c -o ${objects_directory}bluetooth_package.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"bluetooth package\" object.";
        return 1;
    fi;
    
    echo "Creating \"error messages\" object.";
    gcc -c ${release_source_directory}general/error_messages/error_messages.c -o ${objects_directory}error_messages.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"error messages\" object.";
        return 1;
    fi;

    echo "Creating \"random\" object.";
    gcc -c ${release_source_directory}general/random/random.c -o ${objects_directory}random.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"random\" object.";
        return 1;
    fi;

    echo "Creating \"testlog\" object.";
    gcc -c ${test_source_directory}testlog.c -o ${objects_directory}testlog.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testlog\" object.";
        return 1;
    fi;
    
    echo "Creating \"testlog\" program.";
    gcc -o ${binary_folder}testlog ${objects_directory}log.o ${objects_directory}testlog.o ${additional_arguments};
    
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testlog\" object.";
        return 1;
    fi;
    
    echo "Creating \"testdirectory\" object.";
    gcc -c ${test_source_directory}testdirectory.c -o ${objects_directory}testdirectory.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testdirectory\" object.";
        return 1;
    fi;
    
    echo "Creating \"testdirectory\" program.";
    gcc -o ${binary_folder}testdirectory ${objects_directory}directory.o ${objects_directory}testdirectory.o ${additional_arguments};
    
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testdirectory\" object.";
        return 1;
    fi;
    
    echo "Creating \"testscript\" object.";
    gcc -c ${test_source_directory}testscript.c -o ${objects_directory}testscript.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testdirectory\" object.";
        return 1;
    fi;
    
    echo "Creating \"testscript\" program.";
    gcc -o ${binary_folder}testscript ${objects_directory}script.o ${objects_directory}log.o ${objects_directory}directory.o ${objects_directory}testscript.o ${additional_arguments};
    
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testscript\" object.";
        return 1;
    fi;
    
    echo "Creating \"testaudio\" object.";
    gcc -c ${test_source_directory}testaudio.c -o ${objects_directory}testaudio.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testaudio\" object.";
        return 1;
    fi;
    
    echo "Creating \"testaudio\" program.";
    gcc -o ${binary_folder}testaudio ${objects_directory}log.o ${objects_directory}directory.o ${objects_directory}script.o ${objects_directory}audio.o ${objects_directory}testaudio.o ${additional_arguments};
    
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testaudio\" object.";
        return 1;
    fi;

    echo "Creating \"testpackage\" object.";
    gcc -c ${test_source_directory}testpackage.c -o ${objects_directory}testpackage.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testpackage\" object.";
        return 1;
    fi;
    
    echo "Creating \"testpackage\" program.";
    gcc -o ${binary_folder}testpackage ${objects_directory}error_messages.o ${objects_directory}random.o ${objects_directory}bluetooth_package.o ${objects_directory}bluetooth_package_codes.o ${objects_directory}log.o ${objects_directory}testpackage.o ${additional_arguments};

    echo "Creating \"testbluetooth\" object.";
    gcc -c ${test_source_directory}testbluetooth.c -o ${objects_directory}testbluetooth.o ${additional_arguments};
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testbluetooth\" object.";
        return 1;
    fi;
    
    echo "Creating \"testbluetooth\" program.";
    gcc -o ${binary_folder}testbluetooth ${objects_directory}error_messages.o ${objects_directory}random.o ${objects_directory}bluetooth_package.o ${objects_directory}bluetooth_package_codes.o ${objects_directory}log.o ${objects_directory}bluetooth.o ${objects_directory}testbluetooth.o -lbluetooth ${additional_arguments};
    
    if [ $? -ne 0 ];
    then
        echo "Error creating \"testbluetooth\" object.";
        return 1;
    fi;
}

print_usage(){
    echo -e "Use this script to build the programs of this project.\n"
    echo -e "Usage:"
    echo -e "\t$(basename ${0}) {debug, release, all}\n"
    echo -e "\tdebug - Builds all programs for debug."
    echo -e "\trelease - Builds all programs for release."
    echo -e "\tall - Build all programs for debug and release.\n"
}

build() {

    local build_type="${1}";

    local debug_directory="./debug/";
    local release_directory="./release/";

    if [ -z "${build_type}" ];
    then
        print_usage;
        >&2 echo "ERROR: Build type not informed.";
        return 1;
    fi;

    case "${build_type}" in
        "debug")
            echo -e "\nBuilding programs for debug.";
            build_programs "${debug_directory}" "-g";
            if [ ${?} -ne 0 ];
            then
                return 1;
            fi;
            ;;
        "release")
            echo -e "\nBuilding programs for release.";
            build_programs "${release_directory}";
            if [ ${?} -ne 0 ];
            then
                return 1;
            fi;
            ;;
        "all")
            echo -e "\nBuilding programs for debug.";
            build_programs "${debug_directory}" "-g";
            if [ ${?} -ne 0 ];
            then
                return 1;
            fi;

            echo -e "\nBuilding programs for release.";
            build_programs "${release_directory}";
            if [ ${?} -ne 0 ];
            then
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
