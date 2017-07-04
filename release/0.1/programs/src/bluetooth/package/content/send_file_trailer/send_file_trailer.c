/*
 * This source file contains the elaboration of all components required to create and manipulate "send file trailer" package contents.
 *
 * Version:
 *  0.1
 *
 * Author:
 *  Marcelo Leite
 */

/*
 * Includes.
 */

#include <stdlib.h>

#include "../../../../general/return_codes.h"
#include "../../../../log/log.h"
#include "../codes/codes.h"
#include "send_file_trailer.h"


/*
 * Function elaborations.
 */

/*
 * Converts a byte array to a "send file trailer" package content.
 *
 * Parameters
 *  send_file_trailer_content - The variable where the "send file trailer" package content create will be stored.
 *  byte_array - The byte array with the informations to create the "send file trailer" package content.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_send_file_trailer_content(send_file_trailer_content_t* send_file_trailer_content, byte_array_t byte_array) {
    LOG_TRACE_POINT;

    size_t content_size;

    content_size = sizeof(uint32_t);

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The byte array size does not match a send file trailer content.");
        return GENERIC_ERROR;
    }

    memcpy(&send_file_trailer_content->file_trailer, byte_array.data, sizeof(uint32_t));

    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Creates a "send file trailer" package content.
 *
 * Parameters
 *  None
 *
 * Returns
 *  A "send file trailer" package content.
 */
send_file_trailer_content_t* create_send_file_trailer_content() {
    LOG_TRACE_POINT;

    send_file_trailer_content_t* send_file_trailer_content;

    send_file_trailer_content = (send_file_trailer_content_t*)malloc(sizeof(send_file_trailer_content_t));
    send_file_trailer_content->file_trailer = SEND_FILE_TRAILER_CONTENT_CODE;

    LOG_TRACE_POINT;
    return send_file_trailer_content;
}

/*
 * Creates a byte array containing the "send file trailer" package content.
 *
 * Parameters
 *  send_file_trailer_content - The "send file trailer" package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the "send file trailer" package content informations.
 */
byte_array_t create_send_file_trailer_content_byte_array(send_file_trailer_content_t send_file_trailer_content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));

    memcpy(byte_array.data, &send_file_trailer_content.file_trailer, sizeof(uint32_t));

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Deletes the information of a "send file trailer" package content.
 * 
 * Parameters
 *  send_file_trailer_content - The send file trailer package content to be deleted.
 *
 * Returns
 *  SUCCESS - If the content was delete successfully.
 *  GENERIC ERROR - Otherwise.
 */
int delete_send_file_trailer_content(send_file_trailer_content_t* send_file_trailer_content){
    LOG_TRACE_POINT;

    free(send_file_trailer_content);

    LOG_TRACE_POINT;
    return SUCCESS;
}

