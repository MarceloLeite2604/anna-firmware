#include <string.h>
#include "codes.h"

const package_code_t confirmation_code = { CONFIRMATION_VALUE };
const package_code_t error_code = { ERROR_VALUE };
const package_code_t command_result_code = { COMMAND_RESULT_VALUE };
const package_code_t start_record_code = { START_RECORD_VALUE };
const package_code_t stop_record_code = { STOP_RECORD_VALUE };
const package_code_t check_connection_code = { CHECK_CONNECTION_VALUE };
const package_code_t request_audio_file_code = { REQUEST_AUDIO_FILE_VALUE };
const package_code_t disconnect_code = { DISCONNECT_VALUE };
const package_code_t send_file_header_code = { SEND_FILE_HEADER_VALUE };
const package_code_t send_file_chunk_code = { SEND_FILE_CHUNK_VALUE };
const package_code_t send_file_trailer_code = { SEND_FILE_TRAILER_VALUE };

void copy_command(char* buffer, int command) {

    char* pointer = (char*)&command;

    memcpy(buffer, pointer, 4);
}
