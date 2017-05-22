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
        fprintf(stderr, "This program must receive the file name to store the current instant.\n");
        return GENERIC_ERROR;
    }

    char* filename;
    size_t filename_size;
    FILE* output_file;
    int errno_value;
    int fclose_result;
    uint8_t* pointer;
    instant_t instant;
    size_t instant_size;
    int counter;

    filename_size = strlen(argv[1]) + sizeof(char);
    filename = (char*)malloc(filename_size);

    memset(filename, 0, filename_size);
    strcpy(filename, argv[1]);

    output_file = fopen(filename, "wb");

    if ( output_file == NULL ) {
        errno_value = errno;
        fprintf(stderr, "Error while opening file \"%s\".\n", filename);
        fprintf(stderr, "%s\n.", strerror(errno_value));
        return GENERIC_ERROR;
    }

    instant = get_instant();
    pointer = (uint8_t*)&instant;
    instant_size = sizeof(instant_t);
    for (counter = 0; counter < instant_size; counter++) {
        /* TODO: Is this cast correct? */
        fputc((int)*pointer, output_file);
        pointer += sizeof(uint8_t);
    }

    fclose_result = fclose(output_file);

    if (fclose_result != 0 ) {
        errno_value = errno;
        fprintf(stderr, "Error while closing file \"%s\".\n", filename);
        fprintf(stderr, "%s\n.", strerror(errno_value));
        free(filename);
        return GENERIC_ERROR;
    }

    free(filename);
    return SUCCESS;
}
