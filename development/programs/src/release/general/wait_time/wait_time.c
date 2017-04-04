/*
 * This source file contains all component elaborations to control retry attempts and wait time.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <math.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include "../../log/log.h"
#include "wait_time.h"

/*
 * Definitions.
 */

/* Minimum time to wait on a retry (in miliseconds). */
#define MINIMUM_WAIT_TIME 100
/* Wait time added for every retry realized (in miliseconds). */
#define WAIT_TIME_STEP 700

/*
 * Function elaborations.
 */

/*
 * Creates a retry informations structure.
 *
 * Parameters
 *  max_retries - Maximum attempt retries.
 *
 * Returns
 *  A retry informations structure with the maximum attempt retries informed and zero attempts realized.
 */
retry_informations_t create_retry_informations(int maximum_attempts) {
    retry_informations_t retry_informations = { .maximum = maximum_attempts, .attempts = 0 };
    return retry_informations;
}

/*
 * Waits an amount of time based on retry informations.
 *
 * Parameters
 *  retry_informations - The retry informations.
 *
 * Return
 *  0. If the number of attempts is lower or equal than maximum attempts and no errors occurred.
 *  1. If maximum attempts reached.
 *  -1. If an error occurred while waiting.
 */
int wait_time(retry_informations_t* retry_informations) {
    LOG_TRACE("Attempts: %d, maximum attempts: %d", retry_informations->attempts, retry_informations->maximum);
    if ( retry_informations->attempts >= retry_informations->maximum ) {
        LOG_TRACE("Maximum retries attempt reached.");
        return 1;
    }

    int error_code;
    int usleep_result;

    unsigned long microseconds;
    unsigned long seconds;
   
    microseconds = MINIMUM_WAIT_TIME;
    microseconds += retry_informations->attempts * WAIT_TIME_STEP;

    seconds = trunc(((double)microseconds)/1000000.0);
    microseconds = (microseconds%1000000);
    LOG_TRACE("Wait time: %lu seconds, %lu microseconds.", seconds, microseconds);

    if ( seconds > 0 ) {
        sleep(seconds);
    }

    if ( microseconds > 0 ) {
        usleep_result = usleep(microseconds);
        if ( usleep_result == -1 ) {
            error_code = errno;
            LOG_ERROR("Error while sleeping %lu microseconds.", microseconds);
            char* error_message = strerror(error_code);
            LOG_ERROR("%s", error_message);
            free(error_message);
            return -1;
        }
    }

    retry_informations->attempts++;
    return 0;
}
