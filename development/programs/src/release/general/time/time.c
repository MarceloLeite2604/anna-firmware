/*
 * This source file contains the elaboration of all components required to retrieve informations about system time.
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
#include <string.h>

#include "general/return_codes.h"
#include "general/time/time.h"
#include "log/log.h"


/*
 * Macros.
 */

/* Length of a date formatted as a string */
#define STRING_DATE_LENGTH 19

/* Length of miliseconds formatted as a string. */
#define STRING_MILISECONDS_LENGTH 4

/* Ratio between a microsecond and a second. */
#define MILISECONDS_ON_A_SECOND 1000000.0

/* Ratio between a microseconds and a minute. */
#define MILISECONDS_ON_A_MINUTE MILISECONDS_ON_A_SECOND * 60.0

/* Ratio between a microseconds and an hour. */
#define MILISECONDS_ON_AN_HOUR MILISECONDS_ON_A_MINUTE * 60


/*
 * Function elaborations.
 */

/*
 * Converts an structure "instant" to an structure "timeval"
 *
 * Parameters
 *  instant - Instant to be converted.
 *
 * Returns
 *  An struct "timeval" with the current instant stored.
 *
 * Observations
 *  Currently this function only considers microseconds, seconds, minutes and hours on conversion.
 */
struct timeval convert_instant_to_timeval(instant_t instant) {
    LOG_TRACE_POINT;

    struct timeval result;

    result.tv_usec = instant.useconds;

    result.tv_sec  = instant.date.tm_sec;
    result.tv_sec += instant.date.tm_min*60;
    result.tv_sec += instant.date.tm_hour*60*60;

    LOG_TRACE_POINT;
    return result;
}

/*
 * Formats an instant as a human-readable string.
 *
 * Parameters
 *  instant - The instant to be formatted.
 *
 * Returns
 *  The current instant formatted as a human-readable string.
 */
char* format_instant_to_read(instant_t instant) {
    LOG_TRACE_POINT;

    char* result;
    int miliseconds;
    char* string_date;
    char* string_miliseconds;

    miliseconds = (instant.useconds/1000);

    string_date = malloc((STRING_DATE_LENGTH + 1) * sizeof(char));
    memset(string_date, 0, (STRING_DATE_LENGTH + 1) * sizeof(char));
    strftime(string_date, STRING_DATE_LENGTH + 1, "%d/%m/%Y %H:%M:%S", &instant.date);
    LOG_TRACE_POINT;

    string_miliseconds = malloc((STRING_MILISECONDS_LENGTH + 1) * sizeof(char));
    memset(string_miliseconds, 0, (STRING_MILISECONDS_LENGTH + 1) * sizeof(char));
    sprintf(string_miliseconds, ".%03d", miliseconds);
    LOG_TRACE_POINT;

    result = malloc((TIME_STRING_READ_LENGTH + 1) * sizeof(char));
    memset(result, 0, (TIME_STRING_READ_LENGTH + 1) * sizeof(char));
    LOG_TRACE_POINT;

    strcat(result, string_date);
    strcat(result, string_miliseconds);

    free(string_date);
    free(string_miliseconds);

    LOG_TRACE_POINT;
    return result;
}

/*
 * Formats the instant as a string to sort files. 
 *
 * Parameters
 *  instant - The instant to be formatted.
 *
 * Returns
 *  The current instant formatted as a string to sort files.
 */
char* format_instant_to_sort_files(instant_t instant) {
    LOG_TRACE_POINT;

    char* result;

    result = malloc((TIME_STRING_FILE_LENGTH + 1)*sizeof(char));
    strftime(result, TIME_STRING_FILE_LENGTH + 1, "%d%m%Y_%H%M%S", &instant.date);

    LOG_TRACE_POINT;
    return result;
}

/*
 * Retrieves the current instant.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  An "instant_t" structure with the current instant.
 */
instant_t get_instant() {
    LOG_TRACE_POINT;

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
 * Returns the difference between two instants.
 *
 * Parameters
 *   result - Variable where the result will be stored.
 *   instant_1 - First operator to calculate the difference.
 *   instant_2 - Second operator to calculate the differente.
 *
 * Returns
 *   SUCCESS - If the difference was calculated correctly.
 *   GENERIC_ERROR - Otherwise.
 *
 * Observations
 *  Currently this function only considers microseconds, seconds, minutes and hours to calculate the difference.
 */
int get_instant_difference(instant_t* result, instant_t instant_1, instant_t instant_2) {
    LOG_TRACE_POINT;

    if ( result == NULL ) {
        LOG_ERROR("Result variable pointer is null.");
        return GENERIC_ERROR;
    }

    float total_useconds_1;
    float total_useconds_2;
    float total_useconds_result;

    total_useconds_1 = ((float)instant_1.useconds);
    total_useconds_1 += ((float)instant_1.date.tm_sec * MILISECONDS_ON_A_SECOND);
    total_useconds_1 += ((float)instant_1.date.tm_min * MILISECONDS_ON_A_MINUTE);
    total_useconds_1 += ((float)instant_1.date.tm_hour * MILISECONDS_ON_AN_HOUR);
    LOG_TRACE("Microseconds on operator 1: %f.", total_useconds_1);

    total_useconds_2 = ((float)instant_2.useconds);
    total_useconds_2 += ((float)instant_2.date.tm_sec * MILISECONDS_ON_A_SECOND);
    total_useconds_2 += ((float)instant_2.date.tm_min * MILISECONDS_ON_A_MINUTE);
    total_useconds_2 += ((float)instant_2.date.tm_hour * MILISECONDS_ON_AN_HOUR);
    LOG_TRACE("Microseconds on operator 2: %f.", total_useconds_2);

    if ( total_useconds_2 > total_useconds_1 ) {
        LOG_ERROR("Instant registered on second operator is later than first operator.");
        return GENERIC_ERROR;
    }

    total_useconds_result = total_useconds_1 - total_useconds_2;
    memset(result, 0, sizeof(instant_t));
    LOG_TRACE_POINT;

    result->date.tm_hour = (int)floor(total_useconds_result / (MILISECONDS_ON_AN_HOUR));
    total_useconds_result -= (float)result->date.tm_hour * MILISECONDS_ON_AN_HOUR;

    result->date.tm_min = (int)floor(total_useconds_result / (MILISECONDS_ON_A_MINUTE));
    total_useconds_result -= (float)result->date.tm_min * MILISECONDS_ON_A_MINUTE;

    result->date.tm_sec = (int)floor(total_useconds_result / (MILISECONDS_ON_A_SECOND));
    total_useconds_result -= (float)result->date.tm_sec * MILISECONDS_ON_A_SECOND;

    result->useconds = total_useconds_result;

    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Retrieves the current instant formatted as a string to sort files. 
 *
 * Parameters
 *  None.
 *
 * Returns
 *  The current instant formatted as a string to sort files.
 */
char* get_instant_file_formatted() {
    LOG_TRACE_POINT;

    char* result;
    instant_t instant;

    instant = get_instant();
    LOG_TRACE_POINT;

    result = format_instant_to_sort_files(instant);

    LOG_TRACE_POINT;
    return result;
}

/*
 * Retrieves the current instant formatted as a human-readable string.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  The current instant formatted as a human-readable string.
 */
char* get_instant_read_formatted() {
    LOG_TRACE_POINT;

    char* result;
    instant_t instant;
    int miliseconds;
    char* string_date;
    char* string_miliseconds;

    instant = get_instant();
    LOG_TRACE_POINT;

    result = format_instant_to_read(instant);

    LOG_TRACE_POINT;
    return result;
}

/*
 * Retrieves an instant stored on a file.
 * 
 * Parameters
 *  instant - Pointer to the variable which the instant will be stored.
 *  file_path - Path to the file which the instant is stored.
 *
 * Returns
 *   SUCCESS - If the instant was retrieved successfully.
 *   GENERIC_ERROR - Otherwise.
 */
int retrieve_instant_from_file(instant_t* instant, char* file_path) {
    LOG_TRACE("File to retrieve the instant: %s.", file_path);

    if ( file_path == NULL ) {
        LOG_ERROR("File path informed is null.");
        return GENERIC_ERROR;
    }

    if ( instant == NULL ) {
        LOG_ERROR("Variable pointer to store the instant is null.");
        return GENERIC_ERROR;
    }

    FILE* input_file;
    char* pointer;
    int errno_value;
    size_t instant_size;
    int counter;
    int fclose_result;

    input_file = fopen(file_path, "rb");
    if ( input_file == NULL ) {
        errno_value = errno;
        LOG_ERROR("Error while opening file \"%s\".", file_path);
        LOG_ERROR("%s\n.", strerror(errno_value));
        return GENERIC_ERROR;
    }

    memset(instant, 0, sizeof(instant_t));
    pointer = (char*)instant;

    instant_size = sizeof(instant_t);
    for (counter = 0; counter < instant_size; counter++) {
        *pointer = fgetc(input_file);
        pointer += sizeof(char);
    }
    LOG_TRACE_POINT;

    fclose_result = fclose(input_file);
    if (fclose_result != 0 ) {
        errno_value = errno;
        fprintf(stderr, "Error while closing file \"%s\".\n", file_path);
        fprintf(stderr, "%s\n.", strerror(errno_value));
        return GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return SUCCESS;
}


/*
 * Stores the current instant on a file.
 *
 * Parameters
 *  file_path - Path to the file to store current instant.
 *
 * Returns
 *  SUCCESS - If current instant was stored correctly.
 *  GENERIC_ERROR - Otherwise.
 */
int store_current_instant(char* file_path) {
    LOG_TRACE("File to store current instant: \"%s\".", file_path);

    if ( file_path == NULL ) {
        LOG_ERROR("File path informed is invalid.");
        return GENERIC_ERROR;
    }

    size_t file_path_size;
    FILE* output_file;
    int errno_value;
    int fclose_result;
    char* pointer;
    instant_t instant;
    size_t instant_size;
    int counter;

    output_file = fopen(file_path, "wb");
    if ( output_file == NULL ) {
        errno_value = errno;
        fprintf(stderr, "Error while opening file \"%s\".\n", file_path);
        fprintf(stderr, "%s\n.", strerror(errno_value));
        return GENERIC_ERROR;
    }

    instant = get_instant();
    LOG_TRACE_POINT;

    pointer = (char*)&instant;
    instant_size = sizeof(instant_t);
    for (counter = 0; counter < instant_size; counter++) {
        fputc((int)*pointer, output_file);
        pointer += sizeof(char);
    }
    LOG_TRACE_POINT;

    fclose_result = fclose(output_file);
    if (fclose_result != 0 ) {
        errno_value = errno;
        fprintf(stderr, "Error while closing file \"%s\".\n", file_path);
        fprintf(stderr, "%s\n.", strerror(errno_value));
        return GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return SUCCESS;
}

