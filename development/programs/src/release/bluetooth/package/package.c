/*
 * This source file contains all the components required to create and manipulate bluetooth communication data.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "package.h"
#include "codes/codes.h"
#include "../../log/log.h"

/*
 * Creates a new package.
 */
package_t create_new_package(uint32_t package_code) {
    package_t package;

    package.header = PACKAGE_HEADER;
    package.trailer = PACKAGE_TRAILER;
    package.code = package_code;

    return package;
}

/*
 * Creates a confirmation content for a package.
 */
content_t create_confirmation_content(uint32_t package_id){

    content_t content;

    content.confirmation_content = (confirmation_content_t*)malloc(sizeof(confirmation_content_t));

    content.confirmation_content->package_id = package_id;
    return content;
}

byte_array_t create_confirmation_content_byte_array(content_t content) {

    byte_array_t byte_array;

    byte_array.size = sizeof(uint32_t);

    byte_array.data = (uint8_t*)malloc(byte_array.size*sizeof(uint8_t));

    memcpy(byte_array.data, &content.confirmation_content->package_id, sizeof(uint32_t));

    return byte_array;
}

/*
 * Creates an error content for a package.
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
 * Builds a byte array containing the package content.
 */
byte_array_t build_package(package_t package) {
    byte_array_t byte_array;
    // TODO: Fixed value! Use "sizeof".
    uint32_t array_size = 16; // 16 bytes is the minimum package size.
    switch (package.code) {
        case CONFIRMATION_VALUE:
            array_size+=4;
            break;
        default:
            // TODO: Elaborate other package codes.
            break;
    }
   
    // array = (uint8_t*)malloc(array_size*sizeof(uint8_t));

    // TODO: Copy package content.
    
    return byte_array;

}
