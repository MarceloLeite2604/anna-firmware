/*
 * This header file contains the declaration of all components required to create and manipulate the "error" package content.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef CONTENT_ERROR_H
#define CONTENT_ERROR_H


/*
 * Includes.
 */
#include <stdint.h>

#include "../../../../general/byte_array/byte_array.h"

/*
 * Structure definitions.
 */

/* The content of an "error" package. */
typedef struct {
    uint32_t error_code;
    uint32_t error_message_size;
    uint8_t* error_message;
} error_content_t;


/*
 * Function headers.
 */

/* Converts a byte array to an "error" package content. */
int convert_byte_array_to_error_content(error_content_t*, byte_array_t);

/* Creates an "error" package content. */
error_content_t* create_error_content(uint32_t, uint32_t, uint8_t*);

/* Creates a byte array containing an "error" package content. */
byte_array_t create_error_content_byte_array(error_content_t);

/* Deletes the information of an error package content. */
int delete_error_content(error_content_t*);

#endif
