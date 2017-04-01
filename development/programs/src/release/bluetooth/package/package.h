/*
 * This header file contains all components required to manipulate the bluetooth communication data packages.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdint.h>

/*
 * Structure definitions.
 */

/* Confirmation package content. */
typedef struct {
    uint32_t package_id;
} confirmation_content_t;

/* Error package content. */
typedef struct {
    uint32_t error_code;
    uint8_t* error_message;
} error_content_t;

/* Result package content. */
typedef struct {
    uint32_t result_code;
} result_content_t;

/* Send file header package content. */
typedef struct {
    uint32_t file_header;
    uint32_t file_size;
    uint8_t* file_name;
} send_file_header_content_t;

/* Send file chunk package content. */
typedef struct {
    uint32_t file_content;
    uint32_t chunk_size;
    uint8_t* chunk_data;
} send_file_chunk_content_t;

/* Send file trailer package content. */
typedef struct {
    uint32_t file_trailer;
} send_file_trailer_content_t;

/* Union of package content pointers. */
typedef union {
    confirmation_content_t* confirmation_content;
    error_content_t* error_content;
    result_content_t* result_content;
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

/* Structure to store a byte array. */
typedef struct {
    uint8_t* data;
    size_t size;
} byte_array_t;


/*
 * Function headers.
 */

/* Creates a confirmation package. */
/* TODO: Implement. */
package_t create_confirmation_package(uint32_t);

/* Creates an error package. */
/* TODO: Implement. */
package_t create_error_package(uint32_t, uint8_t*);

/* Creates a command result package. */
/* TODO: Implement. */
package_t create_command_result_package(uint32_t);

/* Creates a byte array containing a package content. */
byte_array_t create_package_byte_array(package_t package);

/* Creates a send file chunk package. */
/* TODO: Implement. */
package_t create_send_file_chunk_package(size_t, uint8_t*);

/* Creates a send file header package. */
/* TODO: Implement. */
package_t create_send_file_header_package(size_t, char*);

/* Creates a send file trailer package. */
/* TODO: Implement. */
package_t create_send_file_trailer_package();

