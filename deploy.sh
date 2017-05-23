#!/bin/bash

# The purpose of this script is to deploy the project divisions.
#
# Version: 0.1
# Author: Marcelo Leite

release_version="0.1";

development_directory="$(dirname ${BASH_SOURCE})/development/";

release_directory="$(dirname ${BASH_SOURCE})/release/";

configuration_development_directory="${development_directory}configuration/";

scripts_development_directory="${development_directory}scripts/";

programs_development_directory="${development_directory}programs/";

release_version_directory="${release_directory}${release_version}/";

create_directory() {

    local directory="${1}";
    if [ ! -d "${directory}" ];
    then
        echo -e "Creating directory \"${directory}\".";
        mkdir -p "${directory}";
        local mkdir_result=${?};
        if [ ${mkdir_result} -ne 0 ];
        then
            echo -e "Error creating directory \"${directory}\" (${mkdir_result}).";
            return 1;
        fi;
    fi;

    return 0;
}

create_directory_structure(){

    local root_directory="${1}";

    create_directory "${root_directory}temporary/";
    local create_directory_result=${?};
    if [ ${create_directory_result} -ne 0 ];
    then
        return ${create_directory_result};
    fi;

    create_directory "${root_directory}pids/";
    local create_directory_result=${?};
    if [ ${create_directory_result} -ne 0 ];
    then
        return ${create_directory_result};
    fi;

    create_directory "${root_directory}audio/";
    local create_directory_result=${?};
    if [ ${create_directory_result} -ne 0 ];
    then
        return ${create_directory_result};
    fi;

    create_directory "${root_directory}logs/";
    local create_directory_result=${?};
    if [ ${create_directory_result} -ne 0 ];
    then
        return ${create_directory_result};
    fi;

    return 0;
}

define_input_output_directories() {

    local source_directory="${1}";
    local input_output_directory="${2}";

    echo "${input_output_directory}" > ${source_directory}input_directory;
    echo "${input_output_directory}" > ${source_directory}output_directory;
    echo "${input_output_directory}../build/release/bin/" > ${source_directory}binaries_directory;

    return 0;
}

create_release_version_directory(){

    if [ ! -d "${release_version_directory}" ];
    then
        echo "Creating release version directory.";
        mkdir -p "${release_version_directory}";
    fi;

    create_directory_structure "${release_version_directory}";

    return 0;
}

deploy_configuration(){
    echo -e "Deploying \"configuration\" project division.";

    rm -rf ${scripts_development_directory}resources/configuration;
    cp -r ${configuration_development_directory} ${scripts_development_directory}resources/configuration;

    rm -rf ${programs_development_directory}resources/configuration;
    cp -r ${configuration_development_directory} ${programs_development_directory}resources/configuration;

    create_release_version_directory;
    rm -rf ${release_version_directory}configuration;
    cp -r ${configuration_development_directory} ${release_version_directory}configuration;

    return 0;
}

deploy_scripts(){
    echo -e "Deploying \"scripts\" project division.";

    create_release_version_directory;

    echo "Deploying scripts to release version directory.";
    rm -rf ${release_version_directory}scripts;
    cp -r ${scripts_development_directory}deploy ${release_version_directory}scripts;

    echo -e "Defining input and output directories on release version directory.";
    define_input_output_directories "${release_version_directory}scripts/directories/" "../../"

    echo "Deploying scripts to \"programs\" division.";
    rm -rf ${programs_development_directory}resources/scripts;
    cp -r ${scripts_development_directory}deploy ${programs_development_directory}resources/scripts;

    echo -e "Defining input and output directories on \"programs\" subdivision.";
    define_input_output_directories "${programs_development_directory}resources/scripts/directories/" "../../"

    create_directory_structure "${programs_development_directory}resources/";

    return 0;
}

deploy_programs() {
    echo -e "Deploying \"programs\" project division.";

    create_release_version_directory;

    echo "Deploying programs to release version directory.";
    rm -rf ${release_version_directory}programs;
    cp -r ${programs_development_directory}/build/release ${release_version_directory}programs;

    echo "Deploying source files to release version directory."
    rm -rf ${release_version_directory}programs/src;
    cp -r ${programs_development_directory}/src/release ${release_version_directory}programs/src;

    echo "Deploying programs to \"scripts\" division.";
    rm -rf ${scripts_development_directory}resources/programs;
    cp -r ${programs_development_directory}/build/release ${scripts_development_directory}resources/programs;

    return 0;
}

print_usage(){
    echo -e "Use this script to deploy the project divisions.\n"
    echo -e "Usage:"
    echo -e "\t$(basename ${0}) {configuration, scripts, program}"
    echo -e "\tDepending on parameter informed the script will deploy a project division.\n"
}

deploy(){

    local project_division="${1}";

    if [ -z "${project_division}" ];
    then
        print_usage;
        >&2 echo "ERROR: Project division not informed.";
        return 0;
    fi;

    case "${project_division}" in
        "configuration")
            deploy_configuration;
            ;;
        "scripts")
            deploy_scripts;
            ;;
        "programs")
            deploy_programs;
            ;;
        "help"|"-h")
            print_usage;
            ;;
        *)
            print_usage;
            >&2 echo "ERROR: Unknown project division \"${project_division}\".";
            return 1;
            ;;
    esac

    return 0;
}

deploy ${@};
exit ${?};
