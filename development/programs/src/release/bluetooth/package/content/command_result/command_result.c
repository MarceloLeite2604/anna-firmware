/*
 * This source file contains all the components required to create "command result" packages.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */

#include <stdlib.h>

#include "../../../../general/return_codes.h"
#include "command_result.h"


/*
 * Function elaborations.
 */

/*
 * Converts a byte array to a "command result" package content.
 *
 * Parameters
 *  command_result_content - The content variable where the byte array informations will be stored.
 *  byte_array - The byte array with the content information.
 *
 * Returns
 *  SUCCESS - If the byte array was converted successfully.
 *  GENERIC ERROR - Otherwise.
 */
int convert_byte_array_to_command_result_content(command_result_content_t* command_result_content, byte_array_t byte_array) {
    LOG_TRACE_POINT;
    size_t content_size;

    content_size = sizeof(uint32_t);

    if ( byte_array.size != content_size ) {
        LOG_ERROR("The byte array size does not match a command result content.");
        return GENERIC_ERROR;
    }

    command_result_content = (command_result_content_t*)malloc(sizeof(command_result_content_t));
    memcpy(&command_result_content->result_code, byte_array.data, sizeof(uint32_t));
    return SUCCESS;
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
command_result_content_t* create_command_result_content(uint32_t result_code, struct timeval execution_delay) {
    LOG_TRACE("Result code: 0x%x, Execution delay: %ld.%06ld.", result_code, execution_delay.tv_sec, execution_delay.tv_usec);

    command_result_content_t* command_result_content;
    command_result_content = (command_result_content_t*)malloc(sizeof(command_result_content_t));

    command_result_content->result_code = result_code;
    command_result_content->execution_delay = execution_delay;
    LOG_TRACE_POINT;
    return command_result_content;
}

/*
 * Creates a byte array containing a command result package content.
 *
 * Parameters
 *  command_result_content - The command result package content with the informations to build the byte array.
 *
 * Returns
 *  A byte array structure with the command result package content informations.
 */
byte_array_t create_command_result_content_byte_array(command_result_content_t command_result_content) {
    LOG_TRACE_POINT;

    byte_array_t byte_array;

    byte_array.size = sizeof(uint32_t) + sizeof(struct timeval);

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));
    uint8_t* array_pointer = byte_array.data;

    memcpy(array_pointer, &command_result_content.result_code, sizeof(uint32_t));
    array_pointer += sizeof(uint32_t);

    memcpy(array_pointer, &command_result_content.execution_delay, sizeof(struct timeval));

    LOG_TRACE_POINT;
    return byte_array;
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
int delete_command_result_content(command_result_content_t* command_result_content) {
    free(command_result_content);
    LOG_TRACE_POINT;
    return SUCCESS;
}
