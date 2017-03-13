/*
 * This source file contains all functions required to execute shell scripts to record audio.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include "audio.h"
#include "../directory/directory.h"

/*
 * Definitions.
 */

// Path to script directory.
#define SCRIPT_DIRECTORY "scripts/"

// Script to start audio record.
#define START_RECORD_AUDIO "start_record.sh"

// Script to stop audio record.
#define STOP_RECORD_AUDIO "stop_record.sh"


/*
 * Function elaborations.
 */
int start_record(){

    char* input_directory;
    char* start_record_script_path;
    int start_record_script_path_length;

    input_directory=get_input_directory();
    start_record_script_path_length=strlen(input_directory);

    start_record_script_path_length+=strlen(SCRIPT_DIRECTORY);
    start_record_script_path_length+=strlen(START_RECORD_AUDIO);

    start_record_script_path=malloc((start_record_script_path_length+1)*sizeof(char));

    strcpy(start_record_script_path, input_directory);
    strcat(start_record_script_path, SCRIPT_DIRECTORY);
    strcat(start_record_script_path, START_RECORD_AUDIO);

}
