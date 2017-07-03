/*
 * This header file contains the declaration of all components required to create and manipulate the "send file header" package content.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef CONTENT_SEND_FILE_HEADER_H
#define CONTENT_SEND_FILE_HEADER_H


/*
 * Includes.
 */

#include <stdint.h>

#include "../../../../general/byte_array/byte_array.h"

/*
 * Structure definitions.
 */

/* The content of a "send file header" package. */
typedef struct {
    uint32_t file_header;
    uint32_t file_size;
    uint32_t file_name_size;
    uint8_t* file_name;
} send_file_header_content_t;


/*
 * Function headers.
 */

/* Converts a byte array to a "send file header" package content. */
int convert_byte_array_to_send_file_header_content(send_file_header_content_t*, byte_array_t);

/* Creates a "send file header" package content. */
send_file_header_content_t* create_send_file_header_content(uint32_t, uint32_t, uint8_t*);

/* Creates a byte array containing a "send file header" package content. */
byte_array_t create_send_file_header_content_byte_array(send_file_header_content_t);

/* Deletes the information of a "send file header" package content. */
int delete_send_file_header_content(send_file_header_content_t*);

#endif
