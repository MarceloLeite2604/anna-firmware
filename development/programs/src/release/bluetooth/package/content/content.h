/*
 * This header file contains the declaration of all components required to create and manipulate bluetooth package contents.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef PACKAGE_CONTENT_H
#define PACKAGE_CONTENT_H


/*
 * Includes.
 */
#include "confirmation/confirmation.h"
#include "command_result/command_result.h"
#include "error/error.h"
#include "send_file_chunk/send_file_chunk.h"
#include "send_file_header/send_file_header.h"
#include "send_file_trailer/send_file_trailer.h"

/*
 * Structure definitions.
 */

/* Union of package content pointers. */
typedef union {
    confirmation_content_t* confirmation_content; 
    error_content_t* error_content;
    command_result_content_t* command_result_content;
    send_file_chunk_content_t* send_file_chunk_content;
    send_file_header_content_t* send_file_header_content;
    send_file_trailer_content_t* send_file_trailer_content;
} content_t;


/*
 * Function declarations.
 */


/* Converts a byte array to a package content. */
int convert_byte_array_to_content(content_t*, byte_array_t, uint32_t);

/* Creates a byte array of a package content. */
byte_array_t create_content_byte_array(content_t, uint32_t);

/* Deletes the information of a package content. */
int delete_content(uint32_t, content_t);


#endif
