/*
 * This header file contains the declaration of all components required to manipulate the bluetooth data packages.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef BLUETOOTH_PACKAGE_H
#define BLUETOOTH_PACKAGE_H


/*
 * Includes.
 */
#include <stdint.h>
#include <time.h>

#include "../../general/byte_array/byte_array.h"


/*
 * Structure definitions.
 */

/* Confirmation package content. */
typedef struct {
    uint32_t package_id;
} confirmation_content_t;

/* Command result package content. */
typedef struct {
    uint32_t result_code;
    struct timeval execution_delay;
} command_result_content_t;

/* Error package content. */
typedef struct {
    uint32_t error_code;
    uint32_t error_message_size;
    uint8_t* error_message;
} error_content_t;

/* Send file chunk package content. */
typedef struct {
    uint32_t file_content;
    uint32_t chunk_size;
    uint8_t* chunk_data;
} send_file_chunk_content_t;

/* Send file header package content. */
typedef struct {
    uint32_t file_header;
    uint32_t file_size;
    uint32_t file_name_size;
    uint8_t* file_name;
} send_file_header_content_t;

/* Send file trailer package content. */
typedef struct {
    uint32_t file_trailer;
} send_file_trailer_content_t;

/* Union of package content pointers. */
typedef union {
    confirmation_content_t* confirmation_content;
    error_content_t* error_content;
    command_result_content_t* command_result_content;
    send_file_header_content_t* send_file_header_content;
    send_file_chunk_content_t* send_file_chunk_content;
    send_file_trailer_content_t* send_file_trailer_content;
} content_t;

/* Bluetooth communication package. */
typedef struct {
    uint32_t header;
    uint32_t id;
    uint32_t type_code;
    content_t content;
    uint32_t trailer;
} package_t;


/*
 * Function headers.
 */

/* Converts a byte array to a package. */
int convert_byte_array_to_package(package_t*, byte_array_t);

/* Converts a package to a byte array. */
int convert_package_to_byte_array(byte_array_t*, package_t);

/* Creates a check connection package. */
package_t create_check_connection_package();

/* Creates a command result package. */
package_t create_command_result_package(uint32_t, struct timeval);

/* Creates a confirmation package. */
package_t create_confirmation_package(uint32_t);

/* Creates a disconnect package. */
package_t create_disconnect_package();

/* Creates an error package. */
package_t create_error_package(uint32_t, const char*);

/* Creates a send file chunk package. */
package_t create_send_file_chunk_package(size_t, uint8_t*);

/* Creates a send file header package. */
package_t create_send_file_header_package(size_t, const char*);

/* Creates a send file trailer package. */
package_t create_send_file_trailer_package();

/* Deletes a package. */
int delete_package(package_t);

#endif
