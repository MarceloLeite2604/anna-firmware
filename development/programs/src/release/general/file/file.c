/*
 * This source file constains the elaboration of all components to manipulate files.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <errno.h>
#include <sys/stat.h>
#include <stdlib.h>
#include "../../general/return_codes.h"
#include "../../log/log.h"
#include "file.h"


/*
 * Function elaborations.
 */

/*
 * Checks if a file exists.
 *
 * Parameters
 *  file_path - Path to the file to be checked.
 *
 * Returns
 *  True if file exists, false otherwise.
 */
bool file_exists(char* file_path) {

    if ( access(file_path, F_OK) != 0 ) {
        LOG_TRACE("File \"%s\" does not exist.", file_path);
        return false;
    }
    else {
        LOG_TRACE("File \"%s\" exists.", file_path);
        return true;
    }
}

/*
 * Checks if a file is readable.
 *
 * Parameters
 *  file_path - Path to the file to be checked.
 *
 * Returns
 *  True if file is readable, false otherwise.
 */
bool file_is_readable(char* file_path) {

    if ( access(file_path, R_OK) != 0 ) {
        LOG_TRACE("Can't read file \"%s\".", file_path);
        return false;
    }
    else {
        LOG_TRACE("File \"%s\" is readable.", file_path);
        return true;
    }
}

/*
 * Returns the size of a file (in bytes).
 *
 * Parameters
 *  file_path - Path to the file to check its size.
 *
 * Returns
 *  The file size in bytes, or -1 if there was an error getting the file size.
 */
size_t get_file_size(char* file_path) {
    size_t result;
    int errno_value;
    int stat_result;
    struct stat file_stat;
    
    stat_result = stat(file_path, &file_stat);

    if ( stat_result != 0 ) {
        errno_value = errno;
        LOG_ERROR("Could not determine \"%s\" file size.", file_path);
        LOG_ERROR("%s", strerror(errno_value));
        return -1;
    }

    result = file_stat.st_size;
    LOG_TRACE("File size: %zu bytes.", result);

    return result;
}

/*
 * Reads a chunk of the specified file.
 *
 * Parameters:
 *  file_path - Path to the file to be read.
 *  buffer - Buffer where the file chunk will be stored.
 *  start_position - Position on file to start read.
 *  chunk_size - Size of the data chunk to be read.
 *
 * Returns:
 *   SUCCESS - If the file chunk was read successfully.
 *   GENERIC_ERROR - Otherwise.
 */
int read_file_chunk(char* file_path, uint8_t* buffer, long int start_position, size_t chunk_size) {
    LOG_TRACE_POINT;

    FILE* file;
    int errno_value;
    int fseek_result;
    char* fgets_result;
    
    file = fopen(file_path, "rb");

    if ( file == NULL ) {
        errno_value = errno;
        LOG_ERROR("Error while opening file \"%s\".", file_path);
        LOG_ERROR("%s", strerror(errno_value));
        return GENERIC_ERROR;
    }

    fseek_result = fseek(file, start_position, SEEK_SET);
    if ( fseek_result != 0 ) {
        errno_value = errno;
        LOG_ERROR("Error while moving to position %ld of file \"%s\".", start_position, file_path);
        LOG_ERROR("%s", strerror(errno_value));
        fclose(file);
        return GENERIC_ERROR; 
    }

    memset(buffer, 0, chunk_size);

    fgets_result = fgets(file_path, chunk_size, file);
    if ( fgets_result == NULL ) {
        errno_value = errno;
        LOG_ERROR("Error while reading %zu bytes from file \"%s\".", chunk_size, file_path);
        LOG_ERROR("%s", strerror(errno_value));
        fclose(file);
        return GENERIC_ERROR;
    }

    /* TODO: Conclude. */ 
}
