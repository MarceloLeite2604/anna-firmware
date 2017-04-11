/*
 * This source file contains the functions used to get the directories for input and output files.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "directory.h"

/*
 * Definitions.
 */

// Default directory for input and output files.
#define DEFAULT_INPUT_OUTPUT_DIRECTORY "./"

// Name of the environment variable which contains the input directory location.
#define INPUT_DIRECTORY_VARIABLE_NAME "INPUT_DIRECTORY"

// Name of the environment variable which contains the output directory location.
#define OUTPUT_DIRECTORY_VARIABLE_NAME "OUTPUT_DIRECTORY"


/*
 * Functions.
 */

/*
 * Returns the input directory
 *
 * Parameters:
 *  None.
 * 
 * Returns:
 *  The input directory location.
 */
char* get_input_directory() {
    char* result;
    size_t input_directory_size;
    char* input_directory;

    input_directory = getenv(INPUT_DIRECTORY_VARIABLE_NAME);

    if ( input_directory == NULL ) {
        input_directory=malloc((strlen(DEFAULT_INPUT_OUTPUT_DIRECTORY)+1)*sizeof(char));
        strcpy(input_directory, DEFAULT_INPUT_OUTPUT_DIRECTORY);
        result = input_directory;
    } else {
        input_directory_size = strlen(input_directory);
        result = (char*)malloc((input_directory_size+1)*sizeof(char));
        strcpy(result, input_directory);
        result[input_directory_size] = 0;
    }

    return result;
}

/*
 * Returns the output directory
 *
 * Parameters:
 *  None.
 * 
 * Returns:
 *  The output directory location.
 */
char* get_output_directory() {
    char* result;
    size_t output_directory_size;
    char* output_directory;

    output_directory = getenv(OUTPUT_DIRECTORY_VARIABLE_NAME);

    if ( output_directory == NULL ) {
        output_directory=malloc((strlen(DEFAULT_INPUT_OUTPUT_DIRECTORY)+1)*sizeof(char));
        strcpy(output_directory, DEFAULT_INPUT_OUTPUT_DIRECTORY);
        result = output_directory;
    } else {
        output_directory_size = strlen(output_directory);
        result = (char*)malloc((output_directory_size+1)*sizeof(char));
        strcpy(result, output_directory);
        result[output_directory_size] = 0;
    }
    return output_directory;
}
