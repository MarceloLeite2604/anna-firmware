/*
 * This header file contains all components required to manipulate the bluetooth communication data packages.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

typedef struct {
    int error_code;
    char* error_message;
} error_content_t;

typedef struct {
    int result_code;
} result_content_t;

typedef struct {
    int file_header;
    int file_size;
    char* file_name;
} send_file_header_content_t;

typedef struct {
    int file_content;
    int chunk_size;
    char* chunk_data;
} send_file_chunk_content_t;

typedef struct {
    int file_trailer;
} send_file_trailer_content_t;

typedef union {
    error_content_t* error_content;
    result_content_t* result_content;
    send_file_header_content_t* send_file_header_content;
    send_file_chunk_content_t* send_file_chunk_content;
    send_file_trailer_content_t* send_file_trailer_content;
} content_t;

typedef struct {
    int header;
    int command;
    content_t content;
    int trailer;
} package_t;
