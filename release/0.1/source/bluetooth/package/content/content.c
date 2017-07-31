/*
 * This source file contains the elaboration of all components required to create and manipulate bluetooth package contents.
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

#include "bluetooth/package/codes.h"
#include "bluetooth/package/content/content.h"
#include "log.h"
#include "return_codes.h"


/*
 * Function elaborations.
 */

/*
 * Converts a byte array to a package content.
 *
 * Parameters
 *  content - The package content variable to store the informations obtained from the byte array.
 *  byte_array - The byte array with the package content informations.
 *  package_type_code - The type of the package content stored by the byte array.
 *
 * Returns
 *  SUCCESS - If the content was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_content(content_t* content, byte_array_t byte_array, uint32_t package_type_code){
    LOG_TRACE("Byte array size: %zu, package type: 0x%x.", byte_array.size, package_type_code);

    int convertion_result;
    content_t temporary_content;

    switch (package_type_code) {
        case CHECK_CONNECTION_CODE:
        case DISCONNECT_CODE:
        case REQUEST_AUDIO_FILE_CODE:
        case START_RECORD_CODE:
        case STOP_RECORD_CODE:
            LOG_TRACE_POINT;
            /* These types of package does not have content. */
            convertion_result = SUCCESS;
            break;

        case CONFIRMATION_CODE:
            LOG_TRACE_POINT;

            temporary_content.confirmation_content = (confirmation_content_t*)malloc(sizeof(confirmation_content_t)); 
            convertion_result = convert_byte_array_to_confirmation_content(temporary_content.confirmation_content, byte_array);
            LOG_TRACE_POINT;
            break;

        case COMMAND_RESULT_CODE:
            LOG_TRACE_POINT;

            temporary_content.command_result_content = (command_result_content_t*)malloc(sizeof(command_result_content_t));
            convertion_result = convert_byte_array_to_command_result_content(temporary_content.command_result_content, byte_array);
            LOG_TRACE_POINT;
            break;

        case ERROR_CODE:
            LOG_TRACE_POINT;

            temporary_content.error_content = (error_content_t*)malloc(sizeof(error_content_t));
            convertion_result = convert_byte_array_to_error_content(temporary_content.error_content, byte_array);
            LOG_TRACE_POINT;
            break;

        case SEND_FILE_CHUNK_CODE:
            LOG_TRACE_POINT;

            temporary_content.send_file_chunk_content = (send_file_chunk_content_t*)malloc(sizeof(send_file_chunk_content_t));
            convertion_result = convert_byte_array_to_send_file_chunk_content(temporary_content.send_file_chunk_content, byte_array);
            LOG_TRACE_POINT;
            break;

        case SEND_FILE_HEADER_CODE:
            LOG_TRACE_POINT;

            temporary_content.send_file_header_content = (send_file_header_content_t*)malloc(sizeof(send_file_header_content_t));
            convertion_result = convert_byte_array_to_send_file_header_content(temporary_content.send_file_header_content, byte_array);
            LOG_TRACE_POINT;
            break;

        case SEND_FILE_TRAILER_CODE:
            LOG_TRACE_POINT;

            temporary_content.send_file_trailer_content = (send_file_trailer_content_t*)malloc(sizeof(send_file_trailer_content_t));
            convertion_result = convert_byte_array_to_send_file_trailer_content(temporary_content.send_file_trailer_content, byte_array);
            LOG_TRACE_POINT;
            break;

        default:
            LOG_WARNING("Unknown package type: 0x%x.", package_type_code);
            convertion_result = GENERIC_ERROR;
            break;
    }

    if ( convertion_result != SUCCESS ) {
        LOG_ERROR("Error while converting byte array to content.");
        return GENERIC_ERROR;
    }

    content->confirmation_content = temporary_content.confirmation_content;
    return SUCCESS;
}

/*
 * Creates a byte array storing the informations of the package content.
 *
 * Parameters
 *  content - The package content with the informations to create the byte array.
 *  package_type - Type of the package which the content was extracted.
 *
 * Returns
 *  A byte array with the informations of the package content.
 */
byte_array_t create_content_byte_array(content_t content, uint32_t package_type) {
    LOG_TRACE("Package type: 0x%x.", package_type);

    byte_array_t byte_array;
    byte_array.size = 0;
    byte_array.data = NULL;

    switch (package_type) {
        case CHECK_CONNECTION_CODE:
        case DISCONNECT_CODE:
            LOG_TRACE("This type of package does not have a content.");
            break;
        case CONFIRMATION_CODE:
            LOG_TRACE_POINT;

            byte_array = create_confirmation_content_byte_array(*content.confirmation_content);
            LOG_TRACE_POINT;
            break;

        case ERROR_CODE:
            LOG_TRACE_POINT;

            byte_array = create_error_content_byte_array(*content.error_content);
            LOG_TRACE_POINT;
            break;

        case COMMAND_RESULT_CODE:
            LOG_TRACE_POINT;

            byte_array = create_command_result_content_byte_array(*content.command_result_content);
            LOG_TRACE_POINT;

            break;
        case SEND_FILE_CHUNK_CODE:
            LOG_TRACE_POINT;

            byte_array = create_send_file_chunk_content_byte_array(*content.send_file_chunk_content);
            LOG_TRACE_POINT;

            break;
        case SEND_FILE_HEADER_CODE:
            LOG_TRACE_POINT;

            byte_array = create_send_file_header_content_byte_array(*content.send_file_header_content);
            LOG_TRACE_POINT;
            break;

        case SEND_FILE_TRAILER_CODE:
            LOG_TRACE_POINT;

            byte_array = create_send_file_trailer_content_byte_array(*content.send_file_trailer_content);
            LOG_TRACE_POINT;
            break;

        default:
            LOG_ERROR("Unkown package type.");
            byte_array.size = 0;
            byte_array.data = NULL;
            break;
    }

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Deletes the content of a package.
 *
 * Parameters
 *  content - The package content to be deleted.
 *
 * Returns
 *  SUCCESS - If the content was deleted correctly.
 *  GENERIC ERROR - Otherwise.
 */
int delete_content(uint32_t package_type, content_t content){
    LOG_TRACE("Package type: 0x%x.", package_type);

    int result;

    switch(package_type) {
        case CHECK_CONNECTION_CODE:
        case DISCONNECT_CODE:
        case REQUEST_AUDIO_FILE_CODE:
        case START_RECORD_CODE:
        case STOP_RECORD_CODE:
            LOG_TRACE("This package type doesn't have a content.");
            break;

        case CONFIRMATION_CODE:
            LOG_TRACE_POINT;

            result = delete_confirmation_content(content.confirmation_content);
            LOG_TRACE_POINT;
            break;

        case COMMAND_RESULT_CODE:
            LOG_TRACE_POINT;

            result = delete_command_result_content(content.command_result_content);
            LOG_TRACE_POINT;
            break;

        case ERROR_CODE:
            LOG_TRACE_POINT;

            result = delete_error_content(content.error_content);
            LOG_TRACE_POINT;
            break;

        case SEND_FILE_CHUNK_CODE:
            LOG_TRACE_POINT;

            result = delete_send_file_chunk_content(content.send_file_chunk_content);
            LOG_TRACE_POINT;
            break;

        case SEND_FILE_HEADER_CODE:
            LOG_TRACE_POINT;

            result = delete_send_file_header_content(content.send_file_header_content);
            LOG_TRACE_POINT;
            break;

        case SEND_FILE_TRAILER_CODE:
            LOG_TRACE_POINT;

            result = delete_send_file_trailer_content(content.send_file_trailer_content);
            LOG_TRACE_POINT;
            break;

        default:
            LOG_ERROR("Unknown package type.");
            result = GENERIC_ERROR;
            break;
    }

    LOG_TRACE_POINT;
    return result;
}

