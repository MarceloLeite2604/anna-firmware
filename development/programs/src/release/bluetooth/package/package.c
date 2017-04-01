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
#include "../../general/random/random.h"
#include "../../log/log.h"

/*
 * Private function declarations.
 */

/* Creates a confirmation package content. */
content_t create_confirmation_content(uint32_t);

/* Creates a byte array containing the confirmation package content. */
byte_array_t create_confirmation_content_byte_array(content_t);

/* Creates a byte array of a package content. */
byte_array_t create_content_byte_array(content_t, uint32_t);

/* Creates an error package content. */
content_t create_error_content(uint32_t, uint8_t*);

/* Creates a byte array containing the error package content. */
byte_array_t create_error_content_byte_array(content_t);

/* Creates a command result package content. */
content_t create_command_result_content(uint32_t);

/* Creates a byte array containing a command result package content. */
byte_array_t create_command_result_content_byte_array(content_t);

/* Creates a new package. */
package_t create_package(uint32_t);

/* Crates a new package id. */
uint32_t create_package_id();

/* Creates a send file chunk package content. */
content_t create_send_file_chunk_content(size_t, uint8_t*);

/* Creates a byte array containing a send file chunk package content. */
byte_array_t create_send_file_chunk_content_byte_array(content_t);

/* Creates a send file header package content. */
content_t create_send_file_header_content(size_t, char*);

/* Creates a byte array containing a send file header package content. */
byte_array_t create_send_file_header_content_byte_array(content_t);

/* Creates a send file trailer package content. */
content_t create_send_file_trailer_content();

/* Creates a byte array containing a send file trailer package content. */
byte_array_t create_send_file_trailer_content_byte_array(content_t);

/* deletes a byte array containing the confirmation package content. */
/* TODO: implement. */
int delete_confirmation_content_byte_array(content_t);

/* Deletes a byte array of a package content. */
/* TODO: Implement. */
int delete_content_byte_array(content_t);

/* Deletes a byte array containing the error package content. */
/* TODO: implement. */
int delete_error_content_byte_array(content_t);

/* Deletes a byte array containing a command result package content. */
/* TODO: implement. */
int delete_command_result_content_byte_array(content_t);

/* Deletes a byte array containing a send file chunk package content. */
/* TODO: implement. */
int delete_send_file_chunk_content_byte_array(content_t);

/* Deletes a byte array containing a send file header package content. */
/* TODO: implement. */
int delete_send_file_header_content_byte_array(content_t);

/* Deletes a byte array containing a send file trailer package content. */
/* TODO: implement. */
int delete_send_file_trailer_content_byte_array(content_t);



/*
 * Package elaborations.
 */

/*
 * Creates a confirmation content for a package.
 *
 * Parameters
 *  package_id - The package id to confirm its delivery.
 *
 * Returns
 *  A confirmation package content with the id of the delivered package.
 */
content_t create_confirmation_content(uint32_t package_id){

    content_t content;

    content.confirmation_content = (confirmation_content_t*)malloc(sizeof(confirmation_content_t));

    content.confirmation_content->package_id = package_id;
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

    byte_array_t byte_array;

    byte_array.size = sizeof(uint32_t);

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));

    memcpy(byte_array.data, &content.confirmation_content->package_id, sizeof(uint32_t));

    return byte_array;
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

    byte_array_t byte_array;

    switch (package_type) {
        case CONFIRMATION_CODE:
            byte_array = create_confirmation_content_byte_array(content);
            break;
        case ERROR_CODE:
            byte_array = create_error_content_byte_array(content);
            break;
        case COMMAND_RESULT_CODE:
            byte_array = create_command_result_content_byte_array(content);
            break;
        case SEND_FILE_CHUNK_CODE:
            byte_array = create_send_file_chunk_content_byte_array(content);
            break;
        case SEND_FILE_HEADER_CODE:
            byte_array = create_send_file_header_content_byte_array(content);
            break;
        case SEND_FILE_TRAILER_CODE:
            byte_array = create_send_file_trailer_content_byte_array(content);
            break;
        default:
            LOG_ERROR("Unkown package type.");
            byte_array.size = 0;
            byte_array.data = NULL;
            break;
    }

    return byte_array;
}

/*
 * Creates an error content for a package.
 *
 * Parameters
 *  error_code - The error code to be stored in the content.
 *  erro_message - The error message to be stored in the content.
 *
 * Returns
 *  An error package content with the error code and message informed.
 */
content_t create_error_content(uint32_t error_code, uint8_t* error_message) {
    content_t content;

    content.error_content = (error_content_t*)malloc(sizeof(error_content_t));

    content.error_content->error_code = error_code;
    size_t error_message_size = strlen(error_message);
    content.error_content->error_message = (uint8_t*)malloc(error_message_size*sizeof(uint8_t));
    strcpy(content.error_content->error_message, error_message);

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

    byte_array_t byte_array;
    size_t error_message_size = strlen(content.error_content->error_message);

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.size += error_message_size;

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    memcpy(byte_array.data, &content.error_content->error_code, sizeof(uint32_t));
    memcpy((byte_array.data+sizeof(uint32_t)), content.error_content->error_message, error_message_size);

    return byte_array;
}

/*
 * Creates a command result content for a package.
 *
 * Parameters
 *  result_code - The command result code to be stored in the content.
 *
 * Returns
 *  A result package content with the command result code informed.
 */
content_t create_command_result_content(uint32_t result_code) {
    content_t content;

    content.result_content = (result_content_t*)malloc(sizeof(result_content_t));
    content.result_content->result_code = result_code;
    return content;
}

/*
 * Creates a byte array containing the command result package content.
 *
 * Parameters
 *  content - The command result package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the command result package content informations.
 */
byte_array_t create_command_result_content_byte_array(content_t content) {

    byte_array_t byte_array;

    byte_array.size = sizeof(uint32_t);

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));

    memcpy(byte_array.data, &content.result_content->result_code, sizeof(uint32_t));

    return byte_array;
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
    package_t package;

    package.header = PACKAGE_HEADER;
    package.id = create_package_id();
    package.type_code = package_type_code;
    package.trailer = PACKAGE_TRAILER;

    return package;
}

/*
 * Creates a byte array with the package content.
 *
 * Parameters
 *  package - The package with the informations to be copied to the byte array.
 *
 * Returns
 *  A byte array with the package informations.
 */
byte_array_t create_package_byte_array(package_t package) {

    byte_array_t byte_array;

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);

    byte_array_t content_byte_array = create_content_byte_array(package.content, package.type_code);

    byte_array.size += content_byte_array.size;

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));

    uint8_t* array_pointer = byte_array.data;
    memcpy(array_pointer, &package.header, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &package.id, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &package.type_code, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, content_byte_array.data, content_byte_array.size);
    array_pointer += content_byte_array.size;
    memcpy(array_pointer, &package.trailer, sizeof(uint32_t));
   
    return byte_array;
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

    uint32_t new_id;
    uint8_t* random_bytes = generate_random_bytes(sizeof(uint32_t));
    memcpy(&new_id, random_bytes, sizeof(uint32_t));
}

/*
 * Creates a send file chunk content for a package.
 *
 * Parameters
 *  chunk_size - Size of the file chunk to be stored on content.
 *  chunk_data - The data chunk to be stores on content.
 *
 * Returns
 *  A send file chunk content with the chunk data and its size.
 */
content_t create_send_file_chunk_content(size_t chunk_size, uint8_t* chunk_data) {
    content_t content;

    content.send_file_chunk_content = (send_file_chunk_content_t*)malloc(sizeof(send_file_chunk_content_t));

    content.send_file_chunk_content->file_content = SEND_FILE_CHUNK_CONTENT_CODE;
    content.send_file_chunk_content->chunk_size = chunk_size;
    content.send_file_chunk_content->chunk_data = (uint8_t*)malloc(content.send_file_chunk_content->chunk_size*sizeof(uint8_t));
    memcpy(content.send_file_chunk_content->chunk_data, chunk_data, chunk_size);

    return content;
}

/*
 * Creates a byte array containing the send file chunk package content.
 *
 * Parameters
 *  content - The send file chunk package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the send file chunk package content informations.
 */
byte_array_t create_send_file_chunk_content_byte_array(content_t content) {

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

    return byte_array;
}

/*
 * Creates a send file header content for a package.
 *
 * Parameters
 *  file_size - Size of the file that will be send.
 *  file_name - Name of the file that will be send.
 *
 * Returns
 *  A send file header content with the file informations.
 */
content_t create_send_file_header_content(size_t file_size, char* file_name) {
    content_t content;

    content.send_file_header_content = (send_file_header_content_t*)malloc(sizeof(send_file_header_content_t));

    content.send_file_header_content->file_header = SEND_FILE_HEADER_CONTENT_CODE;
    content.send_file_header_content->file_size = file_size;

    size_t file_name_size = strlen(file_name);

    content.send_file_header_content->file_name = (uint8_t*)malloc(file_name_size*sizeof(uint8_t));

    memcpy(content.send_file_header_content->file_name, file_name, file_name_size);

    return content;
}

/*
 * Creates a byte array containing the send file header package content.
 *
 * Parameters
 *  content - The send file header package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the send file header package content informations.
 */
byte_array_t create_send_file_header_content_byte_array(content_t content) {

    byte_array_t byte_array;
    size_t file_name_size = strlen(content.send_file_header_content->file_name);

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);
    byte_array.size += sizeof(uint32_t);
    byte_array.size += file_name_size;

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    uint8_t* array_pointer = byte_array.data;

    memcpy(array_pointer, &content.send_file_header_content->file_header, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, &content.send_file_header_content->file_size, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);
    memcpy(array_pointer, content.send_file_header_content->file_name, file_name_size);

    return byte_array;
}

/*
 * Creates a send file trailer content for a package.
 *
 * Parameters
 *  None
 *
 * Returns
 *  A send file trailer content with the file informations.
 */
content_t create_send_file_trailer_content() {
    content_t content;

    content.send_file_trailer_content = (send_file_trailer_content_t*)malloc(sizeof(send_file_trailer_content_t));

    content.send_file_trailer_content->file_trailer = SEND_FILE_TRAILER_CONTENT_CODE;

    return content;
}

/*
 * Creates a byte array containing the send file trailer package content.
 *
 * Parameters
 *  content - The send file trailer package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the send file trailer package content informations.
 */
byte_array_t create_send_file_trailer_content_byte_array(content_t content) {

    byte_array_t byte_array;

    byte_array.size = 0;
    byte_array.size += sizeof(uint32_t);

    memcpy(byte_array.data, &content.send_file_trailer_content->file_trailer, sizeof(uint32_t));

    return byte_array;
}
