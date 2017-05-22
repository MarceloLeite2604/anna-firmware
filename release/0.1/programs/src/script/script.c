/*
 * This source file contains all functions required to execute bash scripts.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <string.h>
#include <stdlib.h>
#include "script.h"
#include "../directory/directory.h"
#include "../log/log.h"

/*
 * Definitions.
 */

// Path to script directory.
#define SCRIPT_DIRECTORY "scripts/"

/*
 * Function elaborations.
 */
int execute_script(char* script_name){

    int script_name_length;

    char* input_directory;
    int input_directory_length;

    char* script_path;
    int script_path_length;

    int script_result;

    if ( script_name == NULL ) {
        LOG_ERROR("Script name cannot be null.");
        return 1;
    }

    script_name_length=strlen(script_name);

    input_directory=get_input_directory();
    input_directory_length=strlen(input_directory);

    input_directory_length+=strlen(SCRIPT_DIRECTORY);

    script_path_length=input_directory_length+script_name_length;

    script_path=malloc((script_path_length+1)*sizeof(char));

    strcpy(script_path, input_directory);
    strcat(script_path, SCRIPT_DIRECTORY);
    strcat(script_path, script_name);
    LOG_TRACE("%s", script_path);

    script_result = system(script_path);
    return script_result;
}
