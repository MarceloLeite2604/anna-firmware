/*
 * This program registers the current instant in a specified file.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/types.h>
#include "general/return_codes.h"
#include "general/time/time.h"
#include "log/log.h"


/*
 * Program's main function.
 * It retrieves the current instant and stores on file specified through program argument.
 *
 * Parameters:
 *  None applicable.
 *
 * Returns:
 *  SUCCESS - If program was executed successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int main(int argc, char** argv) {

    if ( argc < 1 ) {
        fprintf(stderr, "This program must receive the file path to store the current instant.\n");
        return GENERIC_ERROR;
    }

    char* file_path;
    char* instant_read_formatted;
    size_t file_path_size;
    int store_current_instant_result;

    file_path_size = strlen(argv[1]) + sizeof(char);
    file_path = (char*)malloc(file_path_size);

    memset(file_path, 0, file_path_size);
    strcpy(file_path, argv[1]);

    store_current_instant_result = store_current_instant(file_path);
    if ( store_current_instant_result != SUCCESS ) {
        LOG_ERROR("Error while storing current instant on file.");
        return GENERIC_ERROR;
    }

    /*
    instant_t instant;
    int retrieve_instant_from_file_result;
    retrieve_instant_from_file_result = retrieve_instant_from_file(&instant, file_path);
    if ( retrieve_instant_from_file_result != SUCCESS ) {
        LOG_ERROR("Error while retrieving instant from file.");
        return GENERIC_ERROR;
    }

    instant_read_formatted = format_instant_to_read(instant);
    printf("Retrieved instant is %s.\n", instant_read_formatted);

    free(instant_read_formatted);
    */

    free(file_path);
    return SUCCESS;
}
