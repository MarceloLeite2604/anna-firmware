/*
 * This header file contains all components required to manipulate the bluetooth communication data packages.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

#include <stdint.h>

typedef struct {
    uint32_t package_id;
} confirmation_content_t;

typedef struct {
    uint32_t error_code;
    uint8_t* error_message;
} error_content_t;

typedef struct {
    uint32_t result_code;
} result_content_t;

typedef struct {
    uint32_t file_header;
    uint32_t file_size;
    uint8_t* file_name;
} send_file_header_content_t;

typedef struct {
    uint32_t file_content;
    uint32_t chunk_size;
    uint8_t* chunk_data;
} send_file_chunk_content_t;

typedef struct {
    uint32_t file_trailer;
} send_file_trailer_content_t;

typedef union {
    confirmation_content_t* confirmation_content;
    error_content_t* error_content;
    result_content_t* result_content;
    send_file_header_content_t* send_file_header_content;
    send_file_chunk_content_t* send_file_chunk_content;
    send_file_trailer_content_t* send_file_trailer_content;
} content_t;

typedef struct {
    uint32_t header;
    uint32_t code;
    content_t content;
    uint32_t trailer;
} package_t;

typedef struct {
    uint8_t* data;
    size_t size;
} byte_array_t;

package_t create_new_package(uint32_t);
content_t create_confirmation_content(uint32_t);
content_t create_error_content(uint32_t, uint8_t*);
byte_array_t create_error_content_byte_array(content_t);
byte_array_t create_confirmation_content_byte_array(content_t);
byte_array_t build_package(package_t package);
