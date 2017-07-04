/*
 * This source file contains the elaboration of all components required to create and manipulate "send file chunk" package contents.
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
#include "send_file_chunk.h"


/*
 * Function elaborations.
 */

/*
 * Converts a byte array to a "send file chunk" package content.
 *
 * Parameters
 *  send_file_chunk_content - The variable where the "send file chunk" package content created will be stored.
 *  byte_array - The byte array with the information to create the "send file chunk" package content.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_send_file_chunk_content(send_file_chunk_content_t* send_file_chunk_content, byte_array_t byte_array) {
    LOG_TRACE_POINT;

    size_t content_size;
    uint8_t* array_pointer;

    content_size = sizeof(uint32_t);
    content_size += sizeof(uint32_t);
    send_file_chunk_content_t* temporary_send_file_chunk_content;

    if ( byte_array.size < content_size ) {
        LOG_ERROR("The byte array size does not match a send file chunk content.");
        return GENERIC_ERROR;
    }

    array_pointer = byte_array.data;

    temporary_send_file_chunk_content = (send_file_chunk_content_t*)malloc(sizeof(send_file_chunk_content_t));

    memcpy(&temporary_send_file_chunk_content->file_content, array_pointer, sizeof(uint32_t));

    if ( temporary_send_file_chunk_content->file_content != SEND_FILE_CHUNK_CONTENT_CODE ) {
        LOG_ERROR("Could not find the send file chunk content code.");
        return GENERIC_ERROR;
    }

    array_pointer += sizeof(uint32_t);
    memcpy(&temporary_send_file_chunk_content->chunk_size, array_pointer, sizeof(uint32_t));
    LOG_TRACE("Chunk size: 0x%02x.", temporary_send_file_chunk_content->chunk_size);

    content_size += temporary_send_file_chunk_content->chunk_size;

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The chunk size informed on byte array does not match it's chunk size.");
        free(temporary_send_file_chunk_content);
        return GENERIC_ERROR;
    }
    array_pointer += sizeof(uint32_t);

    temporary_send_file_chunk_content->chunk_data = (uint8_t*)malloc(temporary_send_file_chunk_content->chunk_size*sizeof(uint8_t));
    memcpy(temporary_send_file_chunk_content->chunk_data, array_pointer, temporary_send_file_chunk_content->chunk_size*sizeof(uint8_t));

    memcpy(send_file_chunk_content, temporary_send_file_chunk_content, sizeof(send_file_chunk_content_t));
    free(temporary_send_file_chunk_content);

    return SUCCESS;
}

/*
 * Creates a "send file chunk" package content.
 *
 * Parameters
 *  chunk_size - Size of the file chunk to be stored on content.
 *  chunk_data - The data chunk to be stored on content.
 *
 * Returns
 *  A "send file chunk" package content with the informations provided.
 */
send_file_chunk_content_t* create_send_file_chunk_content(size_t chunk_size, uint8_t* chunk_data) {
    LOG_TRACE("Chunk size: %zu bytes.", chunk_size);
    send_file_chunk_content_t* send_file_chunk_content;

    send_file_chunk_content = (send_file_chunk_content_t*)malloc(sizeof(send_file_chunk_content_t));

    send_file_chunk_content->file_content = SEND_FILE_CHUNK_CONTENT_CODE;
    send_file_chunk_content->chunk_size = chunk_size;
    send_file_chunk_content->chunk_data = (uint8_t*)malloc(send_file_chunk_content->chunk_size*sizeof(uint8_t));
    memcpy(send_file_chunk_content->chunk_data, chunk_data, chunk_size);

    LOG_TRACE_POINT;
    return send_file_chunk_content;
}

/*
 * Creates a byte array containing a "send file chunk" package content.
 *
 * Parameters
 *  send_file_chunk_content - The "send file chunk" package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the "send file chunk" package content informations.
 */
byte_array_t create_send_file_chunk_content_byte_array(send_file_chunk_content_t send_file_chunk_content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += send_file_chunk_content.chunk_size;

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    uint8_t* array_pointer = byte_array.data;

    memcpy(array_pointer, &send_file_chunk_content.file_content, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &send_file_chunk_content.chunk_size, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, send_file_chunk_content.chunk_data, send_file_chunk_content.chunk_size);

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Deletes a "send file chunk" package content.
 * 
 * Parameters
 *  content - The "send file chunk" package content to be deleted.
 *
 * Returns
 *  SUCCESS - If the content was delete successfully.
 *  GENERIC ERROR - Otherwise.
 */
int delete_send_file_chunk_content(send_file_chunk_content_t* send_file_chunk_content){
    LOG_TRACE_POINT;

    free(send_file_chunk_content->chunk_data);
    free(send_file_chunk_content);
    LOG_TRACE_POINT;
    return SUCCESS;
}
