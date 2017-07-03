/*
 * This source file contains all the components required to create and manipulate bluetooth communication data.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */

#include <stdlib.h>

#include "../../../../general/return_codes.h"
#include "../codes/codes.h"
#include "send_file_header.h"


/*
 * Function elaborations.
 */

/*
 * Converts a byte array to a "send file header" package content.
 *
 * Parameters
 *  send_file_header_content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_send_file_header_content(send_file_header_content_t* send_file_header_content, byte_array_t byte_array) {
    LOG_TRACE_POINT;

    size_t content_size;
    uint8_t* array_pointer;
    send_file_header_content_t* temporary_send_file_header_content;

    content_size = sizeof(uint32_t);
    content_size += sizeof(uint32_t);
    content_size += sizeof(uint32_t);

    if ( byte_array.size < content_size ) {
        LOG_ERROR("The byte array size does not match a send file header result content.");
        return GENERIC_ERROR;
    }

    array_pointer = byte_array.data;

    temporary_send_file_header_content = (send_file_header_content_t*)malloc(sizeof(send_file_header_content_t));
    memcpy(&temporary_send_file_header_content->file_header, array_pointer, sizeof(uint32_t));

    if ( temporary_send_file_header_content->file_header != SEND_FILE_HEADER_CONTENT_CODE ) {
        LOG_ERROR("The content header does not match a send file header content.");
        return GENERIC_ERROR;
    }

    array_pointer += sizeof(uint32_t);

    memcpy(&temporary_send_file_header_content->file_size, array_pointer, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);

    memcpy(&temporary_send_file_header_content->file_name_size, array_pointer, sizeof(uint32_t));

    content_size += temporary_send_file_header_content->file_name_size;

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The file name size on byte array does not match is content.");
        free(temporary_send_file_header_content);
        return GENERIC_ERROR;
    }

    array_pointer += sizeof(uint32_t);

    temporary_send_file_header_content->file_name = (uint8_t*)malloc(temporary_send_file_header_content->file_name_size*sizeof(uint8_t));
    memcpy(temporary_send_file_header_content->file_name, array_pointer, temporary_send_file_header_content->file_name_size*sizeof(uint8_t));
    memcpy(send_file_header_content, temporary_send_file_header_content, sizeof(send_file_header_content_t));

    return SUCCESS;
}

/*
 * Creates a "send file header" content for a package.
 *
 * Parameters
 *  file_size - Size of the file to be informed on the content.
 *  file_name_size - Size of the file name to be informed on the content.
 *  file_name - Name of the file to be informed on the content.
 *
 * Returns
 *  A "send file header" content with the file informations.
 */
send_file_header_content_t* create_send_file_header_content(uint32_t file_size, uint32_t file_name_size, uint8_t* file_name) {
    LOG_TRACE("File size: 0x%x bytes, file name size: 0x%x.", file_size, file_name_size);
    send_file_header_content_t* send_file_header_content;

    send_file_header_content = (send_file_header_content_t*)malloc(sizeof(send_file_header_content_t));

    send_file_header_content->file_header = SEND_FILE_HEADER_CONTENT_CODE;
    send_file_header_content->file_size = file_size;
    send_file_header_content->file_name_size = file_name_size;

    send_file_header_content->file_name = (uint8_t*)malloc(file_name_size*sizeof(uint8_t));

    memcpy(send_file_header_content->file_name, file_name, file_name_size);

    LOG_TRACE_POINT;
    return send_file_header_content;
}

/*
 * Creates a byte array containing the "send file header" package content.
 *
 * Parameters
 *  send_file_header_content - The send file header package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the send file header package content informations.
 */
byte_array_t create_send_file_header_content_byte_array(send_file_header_content_t send_file_header_content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += send_file_header_content.file_name_size;

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    uint8_t* array_pointer = byte_array.data;

    memcpy(array_pointer, &send_file_header_content.file_header, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &send_file_header_content.file_size, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &send_file_header_content.file_name_size, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, send_file_header_content.file_name, send_file_header_content.file_name_size);

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Deletes the information of a send file header package content.
 * 
 * Parameters
 *  send_file_header_content - The send file header package content to be deleted.
 *
 * Returns
 *  SUCCESS - If the content was delete successfully.
 *  GENERIC ERROR - Otherwise.
 */
int delete_send_file_header_content(send_file_header_content_t* send_file_header_content) {
    LOG_TRACE_POINT;
    free(send_file_header_content->file_name);
    free(send_file_header_content);
    LOG_TRACE_POINT;
    return SUCCESS;
}
