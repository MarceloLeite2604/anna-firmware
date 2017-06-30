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
#include <string.h>
#include <stdio.h>
#include "package.h"
#include "codes/codes.h"
#include "../../general/return_codes.h"
#include "../../general/random/random.h"
#include "../../log/log.h"


/*
 * Private function declarations.
 */

/* Converts a byte array to a check connection package content. */
int convert_byte_array_to_check_connection_content(content_t*, byte_array_t);

/* Converts a byte array to a confirmation package content. */
int convert_byte_array_to_confirmation_content(content_t*, byte_array_t);

/* Convert a byte array to a command result content. */
int convert_byte_array_to_command_result_content(content_t*, byte_array_t);

/* Converts a byte array to a package content. */
int convert_byte_array_to_content(content_t*, byte_array_t, uint32_t);

/* Converts a byte array to a disconnect package content. */
int convert_byte_array_to_disconnect_content(content_t*, byte_array_t);

/* Converts a byte array to an error package content. */
int convert_byte_array_to_error_content(content_t*, byte_array_t);

/* Converts a byte array to a request audio file package content. */
int convert_byte_array_to_request_audio_file_content(content_t*, byte_array_t);

/* Converts a byte array to a send file chunk package content. */
int convert_byte_array_to_send_file_chunk_content(content_t*, byte_array_t);

/* Converts a byte array to a send file header package content. */
int convert_byte_array_to_send_file_header_content(content_t*, byte_array_t);

/* Converts a byte array to a send file trailer package content. */
int convert_byte_array_to_send_file_trailer_content(content_t*, byte_array_t);

/* Converts a byte array to a start record package content. */
int convert_byte_array_to_start_record_content(content_t*, byte_array_t);

/* Converts a byte array to a stop record package content. */
int convert_byte_array_to_stop_record_content(content_t*, byte_array_t);

/* Creates a command result package content. */
content_t create_command_result_content(uint32_t, struct timeval);

/* Creates a byte array containing a command result package content. */
byte_array_t create_command_result_content_byte_array(content_t);

/* Creates a confirmation package content. */
content_t create_confirmation_content(uint32_t);

/* Creates a byte array containing the confirmation package content. */
byte_array_t create_confirmation_content_byte_array(content_t);

/* Creates a byte array of a package content. */
byte_array_t create_content_byte_array(content_t, uint32_t);

/* Creates an error package content. */
content_t create_error_content(uint32_t, uint32_t, uint8_t*);

/* Creates a byte array containing the error package content. */
byte_array_t create_error_content_byte_array(content_t);

/* Creates a new package. */
package_t create_package(uint32_t);

/* Crates a new package id. */
uint32_t create_package_id();

/* Creates a send file chunk package content. */
content_t create_send_file_chunk_content(size_t, uint8_t*);

/* Creates a byte array containing a send file chunk package content. */
byte_array_t create_send_file_chunk_content_byte_array(content_t);

/* Creates a send file header package content. */
content_t create_send_file_header_content(uint32_t, uint32_t, uint8_t*);

/* Creates a byte array containing a send file header package content. */
byte_array_t create_send_file_header_content_byte_array(content_t);

/* Creates a send file trailer package content. */
content_t create_send_file_trailer_content();

/* Creates a byte array containing a send file trailer package content. */
byte_array_t create_send_file_trailer_content_byte_array(content_t);

/* Deletes the information of a command result package content. */
int delete_command_result_content(content_t);

/* Deletes the information of a confirmation package content. */
int delete_confirmation_content(content_t);

/* Deletes the information of a package content. */
int delete_content(uint32_t, content_t);

/* Deletes the information of an error package content. */
int delete_error_content(content_t);

/* Deletes the information of a send file chunk package content. */
int delete_send_file_chunk_content(content_t);

/* Deletes the information of a send file header package content. */
int delete_send_file_header_content(content_t);

/* Deletes the information of a send file trailer package content. */
int delete_send_file_trailer_content(content_t);


/*
 * Function elaborations.
 */

/*
 * Converts a byte array to a check connection package content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_check_connection_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    /* This package type does not have a content. */
    return SUCCESS;
}

/*
 * Converts a byte array to a confirmation package content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_confirmation_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    size_t content_size;

    content_size = sizeof(uint32_t);

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The byte array size does not match a confirmation content.");
        return GENERIC_ERROR;
    }

    content->confirmation_content = (confirmation_content_t*)malloc(sizeof(confirmation_content_t));
    memcpy(&content->confirmation_content->package_id, byte_array.data, sizeof(uint32_t));
    return SUCCESS;
}

/*
 * Converts a byte array to a command result package content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_command_result_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    size_t content_size;

    content_size = sizeof(uint32_t);

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The byte array size does not match a command result content.");
        return GENERIC_ERROR;
    }

    content->command_result_content = (command_result_content_t*)malloc(sizeof(command_result_content_t));
    memcpy(&content->command_result_content->result_code, byte_array.data, sizeof(uint32_t));
    return SUCCESS;
}

/*
 * Converts a byte array to a package content.
 *
 * Parameters
 *  content - The content package to store the informations obtained from the byte array.
 *  byte_array - The byte array with the content informations.
 *  package_type_code - The package type of the content byte array.
 *
 * Returns
 *  SUCCESS - If the content was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_content(content_t* content, byte_array_t byte_array, uint32_t package_type_code){
    LOG_TRACE("Byte array size: %zu, package type: 0x%x.", byte_array.size, package_type_code);
    int result;
    int convertion_result;
    content_t temporary_content;

    switch (package_type_code) {
        case CHECK_CONNECTION_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_check_connection_content(&temporary_content, byte_array);
            break;

        case CONFIRMATION_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_confirmation_content(&temporary_content, byte_array);
            break;

        case COMMAND_RESULT_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_command_result_content(&temporary_content, byte_array);
            break;

        case DISCONNECT_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_disconnect_content(&temporary_content, byte_array);
            break;

        case ERROR_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_error_content(&temporary_content, byte_array);
            break;

        case REQUEST_AUDIO_FILE_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_request_audio_file_content(&temporary_content, byte_array);
            break;

        case SEND_FILE_CHUNK_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_send_file_chunk_content(&temporary_content, byte_array);
            break;

        case SEND_FILE_HEADER_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_send_file_header_content(&temporary_content, byte_array);
            break;

        case SEND_FILE_TRAILER_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_send_file_trailer_content(&temporary_content, byte_array);
            break;

        case START_RECORD_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_start_record_content(&temporary_content, byte_array);
            break;

        case STOP_RECORD_CODE:
            LOG_TRACE_POINT;
            convertion_result = convert_byte_array_to_stop_record_content(&temporary_content, byte_array);
            break;

        default:
            LOG_ERROR("Unknown package type: 0x%x.", package_type_code);
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
 * Converts a byte array to disconnect package content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_disconnect_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    /* This package type does not have a content. */
    return SUCCESS;
}

/*
 * Converts a byte array to an error package content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_error_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;

    size_t content_size;
    uint8_t* array_pointer;

    content_size = sizeof(uint32_t);
    content_size += sizeof(uint32_t);
    content_t temporary_content;

    if ( byte_array.size < content_size ) {
        LOG_ERROR("The byte array size does not match an error content.");
        return GENERIC_ERROR;
    }

    array_pointer = byte_array.data;

    temporary_content.error_content = (error_content_t*)malloc(sizeof(error_content_t));

    memcpy(&temporary_content.error_content->error_code, array_pointer, sizeof(uint32_t));
    LOG_TRACE("Error code: 0x%02x.", temporary_content.error_content->error_code);
    array_pointer += sizeof(uint32_t);
    memcpy(&temporary_content.error_content->error_message_size, array_pointer, sizeof(uint32_t));
    LOG_TRACE("Error message size: 0x%02x.", temporary_content.error_content->error_message_size);
    array_pointer += sizeof(uint32_t);

    content_size += temporary_content.error_content->error_message_size;

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The byte array error message length does not match it's message length.");
        free(temporary_content.error_content);
        return GENERIC_ERROR;
    }

    temporary_content.error_content->error_message = (uint8_t*)malloc(temporary_content.error_content->error_message_size*sizeof(uint8_t));
    memcpy(temporary_content.error_content->error_message, array_pointer, temporary_content.error_content->error_message_size*sizeof(uint8_t));

    content->error_content = temporary_content.error_content;

    return SUCCESS;
}

/*
 * Converts a byte array to request audio file package content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_request_audio_file_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    /* This package type does not have a content. */
    return SUCCESS;
}

/*
 * Converts a byte array to an send file chunk content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_send_file_chunk_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    size_t content_size;
    uint8_t* array_pointer;

    content_size = sizeof(uint32_t);
    content_size += sizeof(uint32_t);
    content_t temporary_content;

    if ( byte_array.size < content_size ) {
        LOG_ERROR("The byte array size does not match a send file chunk content.");
        return GENERIC_ERROR;
    }

    array_pointer = byte_array.data;

    temporary_content.send_file_chunk_content = (send_file_chunk_content_t*)malloc(sizeof(send_file_chunk_content_t));

    memcpy(&temporary_content.send_file_chunk_content->file_content, array_pointer, sizeof(uint32_t));

    if ( temporary_content.send_file_chunk_content->file_content != SEND_FILE_CHUNK_CONTENT_CODE ) {
        LOG_ERROR("Could not find the send file chunk content code.");
        return GENERIC_ERROR;
    }

    array_pointer += sizeof(uint32_t);
    memcpy(&temporary_content.send_file_chunk_content->chunk_size, array_pointer, sizeof(uint32_t));
    LOG_TRACE("Chunk size: 0x%02x.", temporary_content.send_file_chunk_content->chunk_size);

    content_size += temporary_content.send_file_chunk_content->chunk_size;

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The chunk size informed on byte array does not match it's chunk size.");
        free(temporary_content.send_file_chunk_content);
        return GENERIC_ERROR;
    }
    array_pointer += sizeof(uint32_t);

    temporary_content.send_file_chunk_content->chunk_data = (uint8_t*)malloc(temporary_content.send_file_chunk_content->chunk_size*sizeof(uint8_t));
    memcpy(temporary_content.send_file_chunk_content->chunk_data, array_pointer, temporary_content.send_file_chunk_content->chunk_size*sizeof(uint8_t));

    content->send_file_chunk_content = temporary_content.send_file_chunk_content;

    return SUCCESS;
}

/*
 * Converts a byte array to a send file header package content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_send_file_header_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    size_t content_size;
    uint8_t* array_pointer;
    content_t temporary_content;

    content_size = sizeof(uint32_t);
    content_size += sizeof(uint32_t);
    content_size += sizeof(uint32_t);

    if ( byte_array.size < content_size ) {
        LOG_ERROR("The byte array size does not match a send file header result content.");
        return GENERIC_ERROR;
    }

    array_pointer = byte_array.data;

    temporary_content.send_file_header_content = (send_file_header_content_t*)malloc(sizeof(send_file_header_content_t));
    memcpy(&temporary_content.send_file_header_content->file_header, array_pointer, sizeof(uint32_t));

    if ( temporary_content.send_file_header_content->file_header != SEND_FILE_HEADER_CONTENT_CODE ) {
        LOG_ERROR("The content header does not match a send file header content.");
        return GENERIC_ERROR;
    }

    array_pointer += sizeof(uint32_t);

    memcpy(&temporary_content.send_file_header_content->file_size, array_pointer, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);

    memcpy(&temporary_content.send_file_header_content->file_name_size, array_pointer, sizeof(uint32_t));

    content_size += temporary_content.send_file_header_content->file_name_size;

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The file name size on byte array does not match is content.");
        free(temporary_content.send_file_header_content);
        return GENERIC_ERROR;
    }

    array_pointer += sizeof(uint32_t);

    temporary_content.send_file_header_content->file_name = (uint8_t*)malloc(temporary_content.send_file_header_content->file_name_size*sizeof(uint8_t));
    memcpy(temporary_content.send_file_header_content->file_name, array_pointer, temporary_content.send_file_header_content->file_name_size*sizeof(uint8_t));

    content->send_file_header_content = temporary_content.send_file_header_content;

    return SUCCESS;
}

/*
 * Converts a byte array to a send file trailer package content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_send_file_trailer_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    size_t content_size;

    content_size = sizeof(uint32_t);

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The byte array size does not match a send file trailer content.");
        return GENERIC_ERROR;
    }

    content->send_file_trailer_content = (send_file_trailer_content_t*)malloc(sizeof(send_file_trailer_content_t));
    memcpy(&content->send_file_trailer_content->file_trailer, byte_array.data, sizeof(uint32_t));
    return SUCCESS;
}

/*
 * Converts a byte array to a start record package content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_start_record_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    /* This package type does not have a content. */
    return SUCCESS;
}

/*
 * Converts a byte array to a stop record package content.
 *
 * Parameters
 *  content - The content where the byte array informations will be stored.
 *  byte_array - The byte array with the content informations.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_stop_record_content(content_t* content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    /* This package type does not have a content. */
    return SUCCESS;
}

/*
 * Converts a byte array to a package.
 *
 * Parameters
 *  package - The variable which will receive the byte array converted as a package.
 *  byte_array - The byte array to be converted as package.
 *
 * Returns
 *  A package_t type with the informations obtained from the byte_array.
 */
int convert_byte_array_to_package(package_t* package, byte_array_t byte_array) {
    LOG_TRACE_POINT;

    package_t temporary_package;
    byte_array_t content_byte_array;
    size_t package_size;
    uint8_t* array_pointer;
    int convert_byte_array_to_content_result;

    package_size = sizeof(uint32_t);
    package_size += sizeof(uint32_t);
    package_size += sizeof(uint32_t);
    package_size += sizeof(uint32_t);

    if ( byte_array.size < package_size ) {
        LOG_ERROR("Invalid package size. It must be at least %zu bytes to be a package.", package_size);
        return GENERIC_ERROR;
    }

    array_pointer = byte_array.data;
    memcpy(&temporary_package.header, array_pointer, sizeof(uint32_t));

    if (temporary_package.header != PACKAGE_HEADER) {
        LOG_ERROR("Byte array is not a package.");
        return GENERIC_ERROR;
    }

    array_pointer += sizeof(uint32_t);

    memcpy(&temporary_package.id, array_pointer, sizeof(uint32_t));
    LOG_TRACE("Package id: 0x%x.", temporary_package.id);
    array_pointer += sizeof(uint32_t);

    memcpy(&temporary_package.type_code, array_pointer, sizeof(uint32_t));
    LOG_TRACE("Package type: 0x%x.", temporary_package.type_code);
    array_pointer += sizeof(uint32_t);

    content_byte_array.size = byte_array.size - package_size;
    LOG_TRACE("Package content size: %zu bytes.", content_byte_array.size);

    if ( content_byte_array.size > 0 ) {
        content_byte_array.data = (uint8_t*)malloc(content_byte_array.size*sizeof(uint8_t));
        memcpy(content_byte_array.data, array_pointer, content_byte_array.size*sizeof(uint8_t));
    }

    convert_byte_array_to_content_result = convert_byte_array_to_content(&temporary_package.content, content_byte_array, temporary_package.type_code);
    if ( convert_byte_array_to_content_result != SUCCESS ) {
        LOG_ERROR("Error while converting byte array data to package content.");
        return GENERIC_ERROR;
    }

    array_pointer += content_byte_array.size*sizeof(uint8_t);
    memcpy(&temporary_package.trailer, array_pointer, sizeof(uint32_t));

    if ( content_byte_array.size > 0 ) {
        delete_byte_array(&content_byte_array);
    }

    package->header = temporary_package.header;
    package->id = temporary_package.id;
    package->type_code = temporary_package.type_code;
    package->content = temporary_package.content;
    package->trailer = temporary_package.trailer;

    return SUCCESS;
}

/*
 * Converts a package to a byte array.
 *
 * Parameters
 *  byte_array - The byte array where the package informations will be stored.
 *  package - The package with the informations to be copied to the byte array.
 *
 * Returns
 *  SUCCESS - If the conversion was made successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_package_to_byte_array(byte_array_t* byte_array, package_t package) {
    LOG_TRACE_POINT;

    byte_array_t temporary_byte_array;

    temporary_byte_array.size = 0;
    temporary_byte_array.size += sizeof(uint32_t);
    temporary_byte_array.size += sizeof(uint32_t);
    temporary_byte_array.size += sizeof(uint32_t);
    temporary_byte_array.size += sizeof(uint32_t);

    byte_array_t content_byte_array = create_content_byte_array(package.content, package.type_code);

    temporary_byte_array.size += content_byte_array.size;

    temporary_byte_array.data = (uint8_t*)malloc(temporary_byte_array.size*sizeof(uint8_t));

    uint8_t* array_pointer = temporary_byte_array.data;
    memcpy(array_pointer, &package.header, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &package.id, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &package.type_code, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, content_byte_array.data, content_byte_array.size);
    array_pointer += content_byte_array.size;
    memcpy(array_pointer, &package.trailer, sizeof(uint32_t));

    delete_byte_array(&content_byte_array);

    byte_array->size = temporary_byte_array.size;
    byte_array->data = (uint8_t*)malloc(temporary_byte_array.size*sizeof(uint8_t));
    memcpy(byte_array->data, temporary_byte_array.data, temporary_byte_array.size*sizeof(uint8_t));

    delete_byte_array(&temporary_byte_array);

    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Creates a check connection package.
 * 
 * Parameters
 *  None
 *
 * Returns
 *  A check connection package.
 */
package_t create_check_connection_package() {
    LOG_TRACE_POINT;

    package_t package = create_package(CHECK_CONNECTION_CODE);

    LOG_TRACE_POINT;
    return package;
}

/*
 * Creates a command result content for a package.
 *
 * Parameters
 *  result_code - The command result code to be stored in the content.
 *  execution_delay - The command execution delay to be stored in the content.
 *
 * Returns
 *  A command result package content with the command result code informed.
 */
content_t create_command_result_content(uint32_t result_code, struct timeval execution_delay) {
    LOG_TRACE("Result code: 0x%x, Execution delay: %ld.%06ld.", result_code, execution_delay.tv_sec, execution_delay.tv_usec);

    content_t content;

    content.command_result_content = (command_result_content_t*)malloc(sizeof(command_result_content_t));
    content.command_result_content->result_code = result_code;
    content.command_result_content->execution_delay = execution_delay;
    LOG_TRACE_POINT;
    return content;
}

/*
 * Creates a byte array containing a command result package content.
 *
 * Parameters
 *  content - The command result package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the command result package content informations.
 */
byte_array_t create_command_result_content_byte_array(content_t content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = sizeof(uint32_t) + sizeof(struct timeval);

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    uint8_t* array_pointer = byte_array.data;

    memcpy(array_pointer, &content.command_result_content->result_code, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);

    memcpy(array_pointer, &content.command_result_content->execution_delay, sizeof(struct timeval));

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Creates a command result package.
 * 
 * Parameters
 *  command_result - The command result to be informed on the package.
 *  execution_delay - The command execution delay to be informed on the package.
 *
 * Returns
 *  A command result package with the information provided.
 */
package_t create_command_result_package(uint32_t command_result, struct timeval execution_delay) {
    LOG_TRACE("Command result: 0x%x, Execution delay: %ld.%06ld.", command_result, execution_delay.tv_sec, execution_delay.tv_usec);

    package_t package = create_package(COMMAND_RESULT_CODE);
    package.content = create_command_result_content(command_result, execution_delay);

    LOG_TRACE_POINT;
    return package;
}

/*
 * Creates a confirmation package content.
 *
 * Parameters
 *  package_id - The package id to confirm its delivery.
 *
 * Returns
 *  A confirmation package content with the id of the delivered package.
 */
content_t create_confirmation_content(uint32_t package_id){
    LOG_TRACE("Package id: 0x%x.", package_id);

    content_t content;

    content.confirmation_content = (confirmation_content_t*)malloc(sizeof(confirmation_content_t));
    content.confirmation_content->package_id = package_id;

    LOG_TRACE_POINT;
    return content;
}

/*
 * Creates a byte array containing the confirmation package content.
 *
 * Parameters
 *  content - The confirmation package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the confirmation package content informations.
 */
byte_array_t create_confirmation_content_byte_array(content_t content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = sizeof(uint32_t);
    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    memcpy(byte_array.data, &content.confirmation_content->package_id, sizeof(uint32_t));

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Creates a confirmation package.
 *
 * Parameters
 *  package_id - ID of the package to be confirmed.
 *
 * Returns
 *  A confirmation package with the ID informed.
 */
package_t create_confirmation_package(uint32_t package_id) {
    LOG_TRACE("Package id: 0x%x.", package_id);

    package_t package = create_package(CONFIRMATION_CODE);
    package.content = create_confirmation_content(package_id);

    LOG_TRACE_POINT;
    return package;
}

/*
 * Creates a byte array of a package content.
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
            byte_array = create_confirmation_content_byte_array(content);
            break;
        case ERROR_CODE:
            LOG_TRACE_POINT;
            byte_array = create_error_content_byte_array(content);
            break;
        case COMMAND_RESULT_CODE:
            LOG_TRACE_POINT;
            byte_array = create_command_result_content_byte_array(content);
            break;
        case SEND_FILE_CHUNK_CODE:
            LOG_TRACE_POINT;
            byte_array = create_send_file_chunk_content_byte_array(content);
            break;
        case SEND_FILE_HEADER_CODE:
            LOG_TRACE_POINT;
            byte_array = create_send_file_header_content_byte_array(content);
            break;
        case SEND_FILE_TRAILER_CODE:
            LOG_TRACE_POINT;
            byte_array = create_send_file_trailer_content_byte_array(content);
            break;
        default:
            LOG_TRACE_POINT;
            LOG_ERROR("Unkown package type.");
            byte_array.size = 0;
            byte_array.data = NULL;
            break;
    }

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Creates a disconnect package.
 *
 * Parameters
 *  None
 *
 * Returns
 *  A disconnect package.
 */
package_t create_disconnect_package() {
    LOG_TRACE_POINT;

    package_t package = create_package(DISCONNECT_CODE);

    LOG_TRACE_POINT;
    return package;
}

/*
 * Creates an error content for a package.
 *
 * Parameters
 *  error_code         - The error code to be stored in the content.
 *  error_message_size - Size of the error message to be stored in the content.
 *  error_message      - The error message to be stored in the content.
 *
 * Returns
 *  An error package content with the error code and message informed.
 */
content_t create_error_content(uint32_t error_code, uint32_t error_message_size, uint8_t* error_message) {
    LOG_TRACE("Error code: 0x%x, error message size: 0x%x.", error_code, error_message_size);
    content_t content;

    content.error_content = (error_content_t*)malloc(sizeof(error_content_t));

    content.error_content->error_code = error_code;
    content.error_content->error_message_size = error_message_size;
    content.error_content->error_message = (uint8_t*)malloc(error_message_size*sizeof(uint8_t));
    memcpy(content.error_content->error_message, error_message, error_message_size);

    LOG_TRACE_POINT;
    return content;
}

/*
 * Creates a byte array containing the error package content.
 *
 * Parameters
 *  content - The error package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the error package content informations.
 */
byte_array_t create_error_content_byte_array(content_t content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += content.error_content->error_message_size;

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    uint8_t* array_pointer = byte_array.data;
    memcpy(array_pointer, &content.error_content->error_code, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &content.error_content->error_message_size, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, content.error_content->error_message, content.error_content->error_message_size);

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 *  Creates an error package.
 *
 * Parameters
 *  error_code - The error code to be inserted on the package.
 *  error_message - The error message to be inserted on the package.
 *
 * Return
 *  An error package with the informations provided.
 */
package_t create_error_package(uint32_t error_code, const char* error_message) {
    LOG_TRACE("Error code: 0x%x, error message: \"%s\".", error_code, error_message);

    size_t error_message_size = strlen(error_message);
    LOG_TRACE("Error message size: %zu.", error_message_size);
    uint8_t* error_message_content = (uint8_t*)malloc(error_message_size*sizeof(uint8_t));
    memcpy(error_message_content, error_message, error_message_size);

    package_t package = create_package(ERROR_CODE);
    package.content = create_error_content(error_code, error_message_size, error_message_content);

    free(error_message_content);

    LOG_TRACE_POINT;
    return package;
}

/*
 * Creates a new bluetooth communication package.
 *
 * Parameters
 *  package_code - The code to identify the package type.
 *
 * Returns
 *  A new package containing de type code informed.
 */
package_t create_package(uint32_t package_type_code) {
    LOG_TRACE("Package type code: 0x%x.", package_type_code);
    package_t package;

    package.header = PACKAGE_HEADER;
    package.id = create_package_id();
    package.type_code = package_type_code;
    package.trailer = PACKAGE_TRAILER;

    LOG_TRACE_POINT;
    return package;
}

/*
 * Creates a package id.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  A bluetooth communication package id.
 */
uint32_t create_package_id() {
    LOG_TRACE_POINT;

    uint32_t new_id;
    uint8_t* random_bytes = generate_random_bytes(sizeof(uint32_t));
    memcpy(&new_id, random_bytes, sizeof(uint32_t));
    free(random_bytes);

    LOG_TRACE("Package ID created: 0x%x.", new_id);
    return new_id;
}

/*
 * Creates the content of a "send file chunk" package.
 *
 * Parameters
 *  chunk_size - Size of the file chunk to be stored on content.
 *  chunk_data - The data chunk to be stored on content.
 *
 * Returns
 *  A "send file chunk" package content with the chunk data and its size.
 */
content_t create_send_file_chunk_content(size_t chunk_size, uint8_t* chunk_data) {
    LOG_TRACE("Chunk size: %zu bytes.", chunk_size);
    content_t content;

    content.send_file_chunk_content = (send_file_chunk_content_t*)malloc(sizeof(send_file_chunk_content_t));

    content.send_file_chunk_content->file_content = SEND_FILE_CHUNK_CONTENT_CODE;
    content.send_file_chunk_content->chunk_size = chunk_size;
    content.send_file_chunk_content->chunk_data = (uint8_t*)malloc(content.send_file_chunk_content->chunk_size*sizeof(uint8_t));
    memcpy(content.send_file_chunk_content->chunk_data, chunk_data, chunk_size);

    LOG_TRACE_POINT;
    return content;
}

/*
 * Creates a byte array containing the "send file chunk" package content.
 *
 * Parameters
 *  content - The "send file chunk" package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the "send file chunk" package content informations.
 */
byte_array_t create_send_file_chunk_content_byte_array(content_t content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += content.send_file_chunk_content->chunk_size;

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    uint8_t* array_pointer = byte_array.data;

    memcpy(array_pointer, &content.send_file_chunk_content->file_content, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &content.send_file_chunk_content->chunk_size, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, content.send_file_chunk_content->chunk_data, content.send_file_chunk_content->chunk_size);

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Creates a send file chunk package.
 *
 * Parameters
 *  chunk_size - Size of the chunk to be informed on the package.
 *  chunk_data - The chunk data to be informed on the package.
 *
 * Returns
 *  A "send file chunk" package with the informations provided.
 */
package_t create_send_file_chunk_package(size_t chunk_size, uint8_t* chunk_data){
    LOG_TRACE("Chunk size: %zu bytes.", chunk_size);

    package_t package = create_package(SEND_FILE_CHUNK_CODE);
    LOG_TRACE_POINT;

    package.content = create_send_file_chunk_content(chunk_size, chunk_data);

    LOG_TRACE_POINT;
    return package;
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
content_t create_send_file_header_content(uint32_t file_size, uint32_t file_name_size, uint8_t* file_name) {
    LOG_TRACE("File size: 0x%x bytes, file name size: 0x%x.", file_size, file_name_size);
    content_t content;

    content.send_file_header_content = (send_file_header_content_t*)malloc(sizeof(send_file_header_content_t));

    content.send_file_header_content->file_header = SEND_FILE_HEADER_CONTENT_CODE;
    content.send_file_header_content->file_size = file_size;
    content.send_file_header_content->file_name_size = file_name_size;

    content.send_file_header_content->file_name = (uint8_t*)malloc(file_name_size*sizeof(uint8_t));

    memcpy(content.send_file_header_content->file_name, file_name, file_name_size);

    LOG_TRACE_POINT;
    return content;
}

/*
 * Creates a byte array containing the "send file header" package content.
 *
 * Parameters
 *  content - The send file header package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the send file header package content informations.
 */
byte_array_t create_send_file_header_content_byte_array(content_t content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += content.send_file_header_content->file_name_size;

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    uint8_t* array_pointer = byte_array.data;

    memcpy(array_pointer, &content.send_file_header_content->file_header, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &content.send_file_header_content->file_size, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &content.send_file_header_content->file_name_size, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, content.send_file_header_content->file_name, content.send_file_header_content->file_name_size);

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Creates a "send file header" package.
 *
 * Parameters
 *  file_size - The file size to be informed on the package.
 *  file_name - The file name to be informed on the package.
 *
 * Returns
 *  A send file header package with the information provided.
 */
package_t create_send_file_header_package(size_t file_size, const char* file_name){
    LOG_TRACE("File size: %zu bytes, file name: \"%s\".", file_size, file_name);

    size_t file_name_size = strlen(file_name);
    uint8_t* file_name_content = (uint8_t*)malloc(file_name_size*sizeof(uint8_t));
    memcpy(file_name_content, file_name, file_name_size);

    package_t package = create_package(SEND_FILE_HEADER_CODE);
    package.content = create_send_file_header_content(file_size, file_name_size, file_name_content);

    free(file_name_content);

    LOG_TRACE_POINT;
    return package;
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
content_t create_send_file_trailer_content() {
    LOG_TRACE_POINT;

    content_t content;
    content.send_file_trailer_content = (send_file_trailer_content_t*)malloc(sizeof(send_file_trailer_content_t));
    content.send_file_trailer_content->file_trailer = SEND_FILE_TRAILER_CONTENT_CODE;

    LOG_TRACE_POINT;
    return content;
}

/*
 * Creates a byte array containing the "send file trailer" package content.
 *
 * Parameters
 *  content - The "send file trailer" package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the "send file trailer" package content informations.
 */
byte_array_t create_send_file_trailer_content_byte_array(content_t content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));

    memcpy(byte_array.data, &content.send_file_trailer_content->file_trailer, sizeof(uint32_t));

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Creates a "send file trailer" package.
 *
 * Parameters
 *  None
 *
 * Returns
 *  A send file trailer package.
 */
package_t create_send_file_trailer_package() {
    LOG_TRACE_POINT;
    package_t package = create_package(SEND_FILE_TRAILER_CODE);
    package.content = create_send_file_trailer_content();

    LOG_TRACE_POINT;
    return package;
}

/*
 * Deletes a byte array containing a "command result" package content.
 * 
 * Parameters
 *  content - The "command result" package content to be deleted.
 *
 * Returns
 *  SUCCESS - If the content was deleted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int delete_command_result_content(content_t content) {
    /* This package content does not contain any allocated memory to be deleted. */
    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Deletes a "confirmation" package content.
 *
 * Parameters
 *  content - The "confirmation" package content to be deleted.
 *
 * Returns
 *  SUCCESS - If the content was deleted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int delete_confirmation_content(content_t content) {
    /* This package content does not contain any allocated memory to be deleted. */
    LOG_TRACE_POINT;
    return SUCCESS;
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
            LOG_TRACE_POINT("This package type doesn't have a content.");
            break;
        case CONFIRMATION_CODE:
            LOG_TRACE_POINT;
            result = delete_confirmation_content(content);
            LOG_TRACE_POINT;
            free(content.confirmation_content);
            break;
        case COMMAND_RESULT_CODE:
            LOG_TRACE_POINT;
            result = delete_command_result_content(content);
            LOG_TRACE_POINT;
            free(content.command_result_content);
            break;
        case ERROR_CODE:
            LOG_TRACE_POINT;
            result = delete_error_content(content);
            LOG_TRACE_POINT;
            free(content.error_content);
            break;
        case SEND_FILE_CHUNK_CODE:
            LOG_TRACE_POINT;
            result = delete_send_file_chunk_content(content);
            LOG_TRACE_POINT;
            free(content.send_file_chunk_content);
            break;
        case SEND_FILE_HEADER_CODE:
            LOG_TRACE_POINT;
            result = delete_send_file_header_content(content);
            LOG_TRACE_POINT;
            free(content.send_file_header_content);
            break;
        case SEND_FILE_TRAILER_CODE:
            LOG_TRACE_POINT;
            result = delete_send_file_trailer_content(content);
            LOG_TRACE_POINT;
            free(content.send_file_trailer_content);
            break;
        default:
            LOG_ERROR("Unknown package type.");
            result = GENERIC_ERROR;
            break;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Deletes an "error" package content.
 * 
 * Parameters
 *  content - The "error" package content to be deleted.
 *
 * Returns
 *  SUCCESS - If the content was deleted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int delete_error_content(content_t content) {
    LOG_TRACE_POINT;

    free(content.error_content->error_message);
    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Deletes a package.
 *
 * Parameters
 *  package - The package to be deleted.
 *
 * Returns
 *  SUCCESS - If the package was deleted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int delete_package(package_t package) {
    LOG_TRACE_POINT;

    int result;

    result = delete_content(package.type_code, package.content);
    LOG_TRACE_POINT;
    return result;
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
int delete_send_file_chunk_content(content_t content){
    LOG_TRACE_POINT;

    free(content.send_file_chunk_content->chunk_data);
    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Deletes the information of a send file header package content.
 * 
 * Parameters
 *  content - The send file header package content to be deleted.
 *
 * Returns
 *  SUCCESS - If the content was delete successfully.
 *  GENERIC ERROR - Otherwise.
 */
int delete_send_file_header_content(content_t content) {
    LOG_TRACE_POINT;
    free(content.send_file_header_content->file_name);
    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Deletes the information of a send file trailer package content.
 * 
 * Parameters
 *  content - The send file trailer package content to be deleted.
 *
 * Returns
 *  SUCCESS - If the content was delete successfully.
 *  GENERIC ERROR - Otherwise.
 */
int delete_send_file_trailer_content(content_t content){
    /* This package content does not contain any allocated memory to be deleted. */
    LOG_TRACE_POINT;
    return SUCCESS;
}

