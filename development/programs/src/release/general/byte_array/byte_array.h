/*
 * This header file contains all components required to manipulate data arrays.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdint.h>
#include "../../log/log.h"


/* 
 * Structure definitions.
 */

/* Structure to store a byte array. */
typedef struct {
    uint8_t* data;
    size_t size;
} byte_array_t;


/* 
 * Function headers.
 */

/* Deletes a byte array. */
int delete_byte_array(byte_array_t);

