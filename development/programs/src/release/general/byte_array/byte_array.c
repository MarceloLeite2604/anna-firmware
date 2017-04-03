/*
 * This source file contains all component elaborations to manipulate data arrays.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdlib.h>
#include "byte_array.h"


/*
 * Deletes a byte array.
 * 
 * Parameters
 *  The byte array to be deleted.
 *
 * Returns
 *  0. If the byte array was deleted correctly.
 *  1. Otherwise.
 */
int delete_byte_array(byte_array_t byte_array){
    LOG_TRACE_POINT;
    free(byte_array.data);

    LOG_TRACE_POINT;
    return 0;
}

