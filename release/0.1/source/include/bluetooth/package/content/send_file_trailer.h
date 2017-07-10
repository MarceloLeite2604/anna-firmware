/*
 * This header file contains the declaration of all components required to create and manipulate the "send file trailer" bluetooth packages.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef CONTENT_SEND_FILE_TRAILER_H
#define CONTENT_SEND_FILE_TRAILER_H


/*
 * Includes.
 */

#include <stdint.h>

#include "byte_array.h"


/*
 * Structure definitions.
 */

/* The content of a "send file trailer" package. */
typedef struct {
    uint32_t file_trailer;
} send_file_trailer_content_t;


/*
 * Function headers.
 */

/* Converts a byte array to a "send file trailer" package content. */
int convert_byte_array_to_send_file_trailer_content(send_file_trailer_content_t*, byte_array_t);

/* Creates a "send file trailer" package content. */
send_file_trailer_content_t* create_send_file_trailer_content();

/* Creates a byte array containing the "send file trailer" package content. */
byte_array_t create_send_file_trailer_content_byte_array(send_file_trailer_content_t);

/* Deletes the information of a "send file trailer" package content. */
int delete_send_file_trailer_content(send_file_trailer_content_t*);


#endif
