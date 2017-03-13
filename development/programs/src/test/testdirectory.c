/*
 * The objetive of this source file is to test all directory functions. 
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
#include <sys/stat.h>
#include "directory/directory.h"

/*
 * Definitions.
 */
#define LOG_ROOT_DIRECTORY "../../output/tests/logs/"

/*
 * Function headers.
 */
void test_get_input_output_directory();


/*
 * Function elaborations.
 */

/*
 * Main function.
 */
int main(int argc, char** argv){

    test_get_input_output_directory();
    return 0;
}


/*
 * Tests "get_input_directory" and "get_output_directory" functions.
 */
void test_get_input_output_directory(){
    printf("Testing \"get_input_directory\" and \"get_output_directory\" functions.\n");

    char* directory;

    directory = get_input_directory();

    if ( directory != 0 ) {
        printf("Input directory is \"%s\".\n", directory);
    } else {
        printf("Failed to get input directory.\n");
    }

    directory = get_output_directory();

    if ( directory != 0 ) {
        printf("Output directory is \"%s\".\n", directory);
    } else {
        printf("Failed to get output directory.\n");
    }

    printf("Test of functions \"get_input_directory\" and \"get_output_directory\" concluded.\n\n");
}

