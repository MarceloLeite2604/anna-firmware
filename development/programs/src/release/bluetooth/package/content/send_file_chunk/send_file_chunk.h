/*
 * This header file contains the declaration of all components required to create and manipulate the "send file chunk" packages content.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef CONTENT_SEND_FILE_CHUNK_H
#define CONTENT_SEND_FILE_CHUNK_H


/*
 * Includes.
 */

#include <stdint.h>

#include "../../../../general/byte_array/byte_array.h"

/*
 * Structure definitions.
 */

/* The content of a "send file chunk" package. */
typedef struct {
    uint32_t file_content;
    uint32_t chunk_size;
    uint8_t* chunk_data;
} send_file_chunk_content_t;


/*
 * Function headers.
 */

/* Converts a byte array to a "send file chunk" package content. */
int convert_byte_array_to_send_file_chunk_content(send_file_chunk_content_t*, byte_array_t);

/* Creates a "send file chunk" package content. */
send_file_chunk_content_t* create_send_file_chunk_content(size_t, uint8_t*);

/* Creates a byte array containing a "send file chunk" package content. */
byte_array_t create_send_file_chunk_content_byte_array(send_file_chunk_content_t);

/* Deletes the information of a "send file chunk" package content. */
int delete_send_file_chunk_content(send_file_chunk_content_t*);

#endif
