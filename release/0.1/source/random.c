/*
 * This source file contains the elaboration of all components required to generate random values.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

/*
 * Includes.
 */

#include <stdbool.h>
#include <stdlib.h>
#include <time.h>

#include "log.h"
#include "random.h"


/*
 * Variables.
 */

/* Indicates if random byte generator was initialized. */
bool initialized = false;


/*
 * Function headers.
 */

void initialize_random_byte_generator();


/*
 * Function elaborations.
 */

/*
 * Generates an array of random bytes.
 *
 * Parameters
 *  array_size - The size of the random bytes array.
 *
 * Returns
 *  An array with random byte values.
 */
uint8_t* generate_random_bytes(size_t array_size) {
    LOG_TRACE_POINT;

    uint8_t* byte_array;
    size_t count;

    byte_array = (uint8_t*)malloc(array_size*sizeof(uint8_t));

    if ( initialized == false ) {
        LOG_TRACE_POINT;

        initialize_random_byte_generator();
        LOG_TRACE_POINT;
    }

    for ( count = 0; count < array_size; count++ ) {
        byte_array[count] = rand();
    }

    LOG_TRACE_POINT;
    return byte_array;
}

/*
 * Initialized the random byte generator.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  Nothing.
 */
void initialize_random_byte_generator() {
    LOG_TRACE_POINT;

    srand((unsigned int)time(NULL));
    initialized = true;

    LOG_TRACE_POINT;
}
