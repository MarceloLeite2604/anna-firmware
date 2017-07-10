/*
 * This source file contains the elaboration of all components required to store retry attempts and wait before another attempt is realized.
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

#include <errno.h>
#include <math.h>
#include <stdlib.h>
#include <unistd.h>

#include "log.h"
#include "return_codes.h"
#include "wait_time.h"


/*
 * Macros.
 */

/* Minimum time to wait on a retry (in microseconds). */
#define MINIMUM_WAIT_TIME 150000

/* Wait time added for every retry realized (in microseconds). */
#define WAIT_TIME_STEP 10000


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
    LOG_TRACE_POINT;

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
 *  SUCCESS - If the number of attempts is lower or equal than maximum attempts and no errors occurred.
 *  MAXIMUM_RETRY_ATTEMPTS_REACHED - If maximum retry attempts reached.
 *  GENERIC_ERROR - If an error occurred while waiting.
 */
int wait_time(retry_informations_t* retry_informations) {
    LOG_TRACE("Attempts: %d, maximum attempts: %d", retry_informations->attempts, retry_informations->maximum);

    if ( retry_informations->attempts >= retry_informations->maximum ) {
        LOG_TRACE("Maximum retries attempt reached.");
        return MAXIMUM_RETRY_ATTEMPTS_REACHED;
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
            return GENERIC_ERROR;
        }
    }

    retry_informations->attempts++;

    LOG_TRACE_POINT;
    return SUCCESS;
}
