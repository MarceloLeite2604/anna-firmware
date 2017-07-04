/*
 * This header file contains the declaration of all components required to create and manipulate the "confirmation" package content.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef CONTENT_CONFIRMATION_H
#define CONTENT_CONFIRMATION_H


/*
 * Includes.
 */

#include <stdint.h>

#include "../../../../general/byte_array/byte_array.h"

/*
 * Structure definitions.
 */

/* The content of a "confirmation" package. */
typedef struct {
    uint32_t package_id;
} confirmation_content_t;


/*
 * Function headers.
 */

/* Converts a byte array to a "confirmation" package content. */
int convert_byte_array_to_confirmation_content(confirmation_content_t*, byte_array_t);

/* Creates a "confirmation" package content. */
confirmation_content_t* create_confirmation_content(uint32_t);

/* Creates a byte array containing a "confirmation" package content. */
byte_array_t create_confirmation_content_byte_array(confirmation_content_t);

/* Deletes the information of a "confirmation" package content. */
int delete_confirmation_content(confirmation_content_t*);

#endif
