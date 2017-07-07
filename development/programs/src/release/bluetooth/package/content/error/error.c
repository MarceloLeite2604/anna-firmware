/*
 * This source file contains the elaboration of all components required to create and manipulate "error" package contents.
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

#include "bluetooth/package/content/error/error.h"
#include "general/return_codes.h"


/*
 * Function elaborations.
 */

/*
 * Converts a byte array to an "error" package content.
 *
 * Parameters
 *  error_content - The variable which will store the "error" content created with the byte array informations.
 *  byte_array - The byte array with the "error" package content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_error_content(error_content_t* error_content, byte_array_t byte_array) {
    LOG_TRACE_POINT;

    size_t content_size;
    uint8_t* array_pointer;
    error_content_t* temporary_error_content;

    content_size = sizeof(uint32_t);
    content_size += sizeof(uint32_t);

    if ( byte_array.size < content_size ) {
        LOG_ERROR("The byte array size does not match an error content.");
        return GENERIC_ERROR;
    }

    array_pointer = byte_array.data;
    temporary_error_content = (error_content_t*)malloc(sizeof(error_content_t));

    memcpy(&temporary_error_content->error_code, array_pointer, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(&temporary_error_content->error_message_size, array_pointer, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);

    content_size += temporary_error_content->error_message_size;

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The byte array error message length does not match it's message length.");
        free(temporary_error_content);
        return GENERIC_ERROR;
    }

    temporary_error_content->error_message = (uint8_t*)malloc(temporary_error_content->error_message_size*sizeof(uint8_t));
    memcpy(temporary_error_content->error_message, array_pointer, temporary_error_content->error_message_size*sizeof(uint8_t));

    memcpy(error_content, temporary_error_content, sizeof(error_content_t));
    free(temporary_error_content);

    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Creates an "error" package content.
 *
 * Parameters
 *  error_code - The error code to be stored in the content.
 *  error_message_size - Size of the error message to be stored in the content.
 *  error_message - The error message to be stored in the content.
 *
 * Returns
 *  An error package content with the error code and message informed.
 */
error_content_t* create_error_content(uint32_t error_code, uint32_t error_message_size, uint8_t* error_message) {
    LOG_TRACE("Error code: 0x%x, error message size: 0x%x.", error_code, error_message_size);

    error_content_t* error_content;

    error_content = (error_content_t*)malloc(sizeof(error_content_t));

    error_content->error_code = error_code;
    error_content->error_message_size = error_message_size;
    error_content->error_message = (uint8_t*)malloc(error_message_size*sizeof(uint8_t));
    memcpy(error_content->error_message, error_message, error_message_size);

    LOG_TRACE_POINT;
    return error_content;
}

/*
 * Creates a byte array containing an "error" package content.
 *
 * Parameters
 *  error_content - The error package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the error package content informations.
 */
byte_array_t create_error_content_byte_array(error_content_t error_content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += error_content.error_message_size;

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    uint8_t* array_pointer = byte_array.data;
    memcpy(array_pointer, &error_content.error_code, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &error_content.error_message_size, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, error_content.error_message, error_content.error_message_size);


    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Deletes an "error" package content.
 * 
 * Parameters
 *  error_content - The "error" package content to be deleted.
 *
 * Returns
 *  SUCCESS - If the content was deleted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int delete_error_content(error_content_t* error_content) {
    LOG_TRACE_POINT;

    free(error_content->error_message);
    free(error_content);

    LOG_TRACE_POINT;
    return SUCCESS;
}
