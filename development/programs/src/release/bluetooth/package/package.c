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

/* Creates a new package. */
package_t create_package(uint32_t);

/* Crates a new package id. */
uint32_t create_package_id();


/*
 * Function elaborations.
 */

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
    package.content.command_result_content = create_command_result_content(command_result, execution_delay);

    LOG_TRACE_POINT;
    return package;
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
    package.content.confirmation_content = create_confirmation_content(package_id);

    LOG_TRACE_POINT;
    return package;
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
    package.content.error_content = create_error_content(error_code, error_message_size, error_message_content);
    printf("Error content pointer: %p.\n", package.content.error_content);
    printf("Error message pointer: %p.\n", package.content.error_content->error_message);
    

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

    package.content.send_file_chunk_content = create_send_file_chunk_content(chunk_size, chunk_data);

    LOG_TRACE_POINT;
    return package;
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
    package.content.send_file_header_content = create_send_file_header_content(file_size, file_name_size, file_name_content);

    free(file_name_content);

    LOG_TRACE_POINT;
    return package;
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
    package.content.send_file_trailer_content = create_send_file_trailer_content();

    LOG_TRACE_POINT;
    return package;
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
