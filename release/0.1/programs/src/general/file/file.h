/*
 * This header file contains all component declarations to manipulate failes.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

#ifndef FILE_H
#define FILE_H

/*
 * Inclusions.
 */

#include <stdbool.h>
#include <unistd.h>

/*
 * Function declarations.
 */

/* Checks if a file exists. */
bool file_exists(char*);

/* Checks if a file is readable. */
bool file_is_readable(char*);

/* Returns the file size in bytes. */
size_t get_file_size(char*);

#endif
