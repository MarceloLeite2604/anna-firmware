/*
 * This source file contains all component elaborations retrieve informations about system time.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include "time.h"
#include "../../log/log.h"
#include <string.h>
#include <errno.h>
#include <stdlib.h>

/*
 * Constants.
 */

/* Length of a date formatted as a string */
#define STRING_DATE_LENGTH 19

/* Length of miliseconds formatted as a string. */
#define STRING_MILISECONDS_LENGTH 4

/*
 * Retrieves the current instant.
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  A "instant_t" structure with the current instant.
 */
instant_t get_instant() {

    instant_t instant;

    int gettimeofday_result;
    struct timeval timeofday;
    struct tm* tm;
    int errno_value;

    gettimeofday_result = gettimeofday(&timeofday, NULL);
    LOG_TRACE_POINT;

    if ( gettimeofday_result == -1 ) {
        errno_value = errno;
        LOG_ERROR("Error while getting current time.");
        LOG_ERROR("%s", strerror(errno_value));
        memset(&instant, 0, sizeof(instant_t));
    }

    tm = localtime(&timeofday.tv_sec);
    instant.date = *tm;
    LOG_TRACE_POINT;

    instant.useconds = timeofday.tv_usec;

    LOG_TRACE_POINT;
    return instant;
}

/*
 * Retrieves the current instant formatted as a string to sort files. 
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  The current instant formatted as a string to sort files.
 */
char* get_instant_file_formatted() {

    char* result;
    instant_t instant;

    instant = get_instant();

    result = malloc((TIME_STRING_FILE_LENGTH + 1)*sizeof(char));
    strftime(result, TIME_STRING_FILE_LENGTH + 1, "%d%m%Y_%H%M%S", &instant.date);

    return result;
}

/*
 * Retrieves the current instant formatted as a human-readable string.
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  The current instant formatted as a human-readable string.
 */
char* get_instant_read_formatted() {

    char* result;
    instant_t instant;
    int miliseconds;
    char* string_date;
    char* string_miliseconds;

    instant = get_instant();

    miliseconds = (instant.useconds/1000);

    string_date = malloc((STRING_DATE_LENGTH + 1) * sizeof(char));
    memset(string_date, 0, (STRING_DATE_LENGTH + 1) * sizeof(char));
    strftime(string_date, STRING_DATE_LENGTH + 1, "%d/%m/%Y %H:%M:%S", &instant.date);

    string_miliseconds = malloc((STRING_MILISECONDS_LENGTH + 1) * sizeof(char));
    memset(string_miliseconds, 0, (STRING_MILISECONDS_LENGTH + 1) * sizeof(char));
    sprintf(string_miliseconds, ".%03d", miliseconds);

    result = malloc((TIME_STRING_READ_LENGTH + 1) * sizeof(char));
    memset(result, 0, (TIME_STRING_READ_LENGTH + 1) * sizeof(char));

    strcat(result, string_date);
    strcat(result, string_miliseconds);
   
    free(string_date);
    free(string_miliseconds);

    return result;
}

