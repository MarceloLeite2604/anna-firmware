/*
 * This header file contains the declaration of all components required to manipulate data arrays.
 *
 * Version:
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef BYTE_ARRAY_H
#define BYTE_ARRAY_H


/*
 * Includes.
 */

#include <stdint.h>

#include "../../log/log.h"


/* 
 * Structures.
 */

/* Structure to store a byte array. */
typedef struct {
    uint8_t* data;
    size_t size;
} byte_array_t;


/* 
 * Function headers.
 */

/* Copies an array content to the byte array. */
int copy_content_to_byte_array(byte_array_t*, void*, size_t);

/* Deletes a byte array. */
int delete_byte_array(byte_array_t*);

#endif
