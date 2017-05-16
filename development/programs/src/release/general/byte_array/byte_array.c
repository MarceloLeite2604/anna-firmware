/*
 * This source file contains all component elaborations to manipulate data arrays.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include "../return_codes.h"
#include <stdlib.h>
#include "byte_array.h"

/*
 * Copies an array content to the byte array.
 *
 * Parameters
 *
 * byte_array - The byte array to copy the array content to.
 * array      - The array of data to be copied.
 * array_size - Size of the array to be copied.
 *
 * Returns
 *  SUCCESS - If the content was copies successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int copy_content_to_byte_array(byte_array_t* byte_array, void* array, size_t array_size) {
    LOG_TRACE_POINT;
    int result;

    byte_array->data = (uint8_t*)malloc(array_size);
    if ( byte_array->data == NULL ) {
        LOG_ERROR("Could not allocate %zu bytes to storethe array content.", array_size);
        result = GENERIC_ERROR;
    }
    else {
        LOG_TRACE_POINT;
        memcpy(byte_array->data, array, array_size);
        byte_array->size = array_size;
        result = SUCCESS;
    }

    return result;
}


/*
 * Deletes a byte array.
 * 
 * Parameters
 *  The byte array to be deleted.
 *
 * Returns
 *  SUCCESS - If the byte array was deleted correctly.
 *  GENRIC_ERROR - Otherwise.
 */
int delete_byte_array(byte_array_t byte_array){
    LOG_TRACE_POINT;

    if ( byte_array.size > 0 ) {
        LOG_TRACE("Byte array size: %zu.", byte_array.size);
        free(byte_array.data);
    }

    byte_array.size = 0;
    byte_array.data = NULL;

    LOG_TRACE_POINT;
    return SUCCESS;
}

