/*
 * This source file contains the elaboration of all components required to execute bash scripts.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

/*
 * Includes.
 */

#include <stdlib.h>
#include <string.h>

#include "../directory/directory.h"
#include "../log/log.h"
#include "script.h"


/*
 * Macros.
 */

/* Path to script directory. */
#define SCRIPT_DIRECTORY "scripts/"


/*
 * Function elaborations.
 */

/*
 * Executes a shell script.
 *
 * Parameters
 *  script_name - Path of the script to be executed.
 *
 * Returns
 *  The exit value received from the script execution or GENERIC_ERROR if there was an error while trying to execute the script.
 */
int execute_script(char* script_name){
    LOG_TRACE_POINT;

    int script_name_length;
    char* input_directory;
    int input_directory_length;
    char* script_path;
    int script_path_length;
    int script_result;

    if ( script_name == NULL ) {
        LOG_ERROR("Script name cannot be null.");
        return GENERIC_ERROR;
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

    LOG_TRACE_POINT;
    return script_result;
}
