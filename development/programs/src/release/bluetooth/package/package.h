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
#include "content/content.h"


/*
 * Structure definitions.
 */

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
