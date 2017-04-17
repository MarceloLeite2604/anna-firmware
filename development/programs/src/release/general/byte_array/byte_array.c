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
        LOG_TRACE_POINT;
        free(byte_array.data);
    }

    LOG_TRACE_POINT;
    return SUCCESS;
}

