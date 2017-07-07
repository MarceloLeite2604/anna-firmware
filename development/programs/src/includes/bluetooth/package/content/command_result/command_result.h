/*
 * This header file contains the declaration of all components required to create and manipulate the "command result" package content.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef CONTENT_COMMAND_RESULT_H
#define CONTENT_COMMAND_RESULT_H


/*
 * Includes.
 */

#include <stdint.h>
#include <sys/time.h>
#include <time.h>

#include "../../../../general/byte_array/byte_array.h"


/*
 * Structure definitions.
 */

/* The content of a "command result" package. */
typedef struct {
    uint32_t result_code;
    struct timeval execution_delay;
} command_result_content_t;


/*
 * Function headers.
 */

/* Converts a byte array to a "command result" package content. */
int convert_byte_array_to_command_result_content(command_result_content_t*, byte_array_t);

/* Creates a "command result" package content. */
command_result_content_t* create_command_result_content(uint32_t, struct timeval);

/* Creates a byte array containing a "command result" package content. */
byte_array_t create_command_result_content_byte_array(command_result_content_t);

/* Deletes the information of a "command result" package content. */
int delete_command_result_content(command_result_content_t*);

#endif
