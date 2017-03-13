#!/bin/bash

# The purpose of this script is to deploy the project divisions.
#
# Version: 0.1
# Author: Marcelo Leite

release_version="0.1";

development_directory="$(dirname ${BASH_SOURCE})/development";

release_directory="$(dirname ${BASH_SOURCE})/release";

configuration_development_directory="${development_directory}/configuration";

scripts_development_directory="${development_directory}/scripts";

programs_development_directory="${development_directory}/programs";

release_version_directory="${release_directory}/${release_version}";


create_release_version_directory(){

    if [ ! -d "${release_version_directory}" ];
    then
        mkdir -p "${release_version_directory}";
    fi;

    return 0;
}

deploy_configuration(){
    echo -e "Deploying \"configuration\" project division.";

    rm -rf ${scripts_development_directory}/resources/configuration;
    cp -r ${configuration_development_directory} ${scripts_development_directory}/resources/configuration;

    rm -rf ${programs_development_directory}/resources/configuration;
    cp -r ${configuration_development_directory} ${programs_development_directory}/resources/configuration;

    create_release_version_directory;
    rm -rf ${release_version_directory}/configuration;
    cp -r ${configuration_development_directory} ${release_version_directory}/configuration;

    return 0;
}

deploy_scripts(){
    echo -e "Deploying \"scripts\" project division.";


    rm -rf ${programs_development_directory}/resources/scripts;
    cp -r ${scripts_development_directory}/deploy ${programs_development_directory}/resources/scripts;

    create_release_version_directory;
    rm -rf ${release_version_directory}/scripts;
    cp -r ${development_directory}/scripts/deploy ${release_version_directory}/scripts;
    return 0;
}

deploy_program() {
    echo -e "To be done.";
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
        "program")
            deploy_program;
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
