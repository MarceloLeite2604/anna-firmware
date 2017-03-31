/*
 * This header file contains all commands comprehended by the program.
 */

/* Raspbian in little-ended, so the byte commands are inverted. */
#define CONFIRMATION_VALUE 0x4b1ee9ed
#define ERROR_VALUE 0x89c09f5a
#define COMMAND_RESULT_VALUE 0x984761f1
#define START_RECORD_VALUE 0x11d2bb74
#define STOP_RECORD_VALUE 0xa1f6d1e5
#define CHECK_CONNECTION_VALUE 0xd12f48d4
#define REQUEST_AUDIO_FILE_VALUE 0x42a27b9b
#define DISCONNECT_VALUE 0xb704fb8c
#define SEND_FILE_HEADER_VALUE 0x34f966d4
#define SEND_FILE_CHUNK_VALUE 0x0f0f769f
#define SEND_FILE_TRAILER_VALUE 0x8c61e11c

#define PACKAGE_HEADER 0xf0037142
#define PACKAGE_TRAILER 0x9228c204

/* Structure to store a code value */
typedef union {
    int value;
    unsigned char data[4];
} package_code_t;

extern const package_code_t confirmation_code;
extern const package_code_t error_code;
extern const package_code_t command_result_code;
extern const package_code_t start_record_code;
extern const package_code_t stop_record_code;
extern const package_code_t check_connection_code;
extern const package_code_t request_audio_file_code;
extern const package_code_t disconnect_code;
extern const package_code_t send_file_header_code;
extern const package_code_t send_file_chunk_code;
extern const package_code_t send_file_trailer_code;
