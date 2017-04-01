#include <string.h>
#include "codes.h"

const package_code_t confirmation_code = { CONFIRMATION_CODE };
const package_code_t error_code = { ERROR_CODE };
const package_code_t command_result_code = { COMMAND_RESULT_CODE };
const package_code_t start_record_code = { START_RECORD_CODE };
const package_code_t stop_record_code = { STOP_RECORD_CODE };
const package_code_t check_connection_code = { CHECK_CONNECTION_CODE };
const package_code_t request_audio_file_code = { REQUEST_AUDIO_FILE_CODE };
const package_code_t disconnect_code = { DISCONNECT_CODE };
const package_code_t send_file_header_code = { SEND_FILE_HEADER_CODE };
const package_code_t send_file_chunk_code = { SEND_FILE_CHUNK_CODE };
const package_code_t send_file_trailer_code = { SEND_FILE_TRAILER_CODE };
