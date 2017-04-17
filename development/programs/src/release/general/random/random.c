/*
 * This source file contains all components used to generate random values.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include "random.h"

/*
 * Private variables.
 */

bool initialized = false;

/*
 * Private functions.
 */
void initialize_random_byte_generator();

/*
 * Function elborations.
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
    uint8_t* byte_array = (uint8_t*)malloc(array_size*sizeof(uint8_t));
    size_t count;

    if ( initialized == false ) {
        initialize_random_byte_generator();
    }

    for ( count = 0; count < array_size; count++ ) {
        byte_array[count] = rand();
    }

    return byte_array;
}

/*
 * Initialized the random byte generator.
 *
 * Parameters
 *  None
 *
 * Returns
 *  Nothing
 */
void initialize_random_byte_generator() {
    srand((unsigned int)time(NULL));
    initialized = true;
}
