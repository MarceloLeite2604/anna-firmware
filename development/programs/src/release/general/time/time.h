/*
 * This header file contains all componentes required to retrieve informations about system time.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

#ifndef TIME_H
#define TIME_H

/*
 * Includes.
 */
#include <sys/time.h>
#include <time.h>

/*
 * Constants.
 */

/* Length of time string formatted to read. */
#define TIME_STRING_READ_LENGTH 23

/* Length of time string formatted to identify files. */
#define TIME_STRING_FILE_LENGTH 15


/*
 * Structures.
 */

/* Stores informations about an instant. It's maximum precision is microseconds. */
typedef struct instant_t {
    struct tm date;
    suseconds_t useconds;
} instant_t;


/*
 * Function headers.
 */

/* Converts an structure "instant" to an structure "timeval" */
struct timeval convert_instant_to_timeval(instant_t);

/* Formats an instant as a human-readable string. */
char* format_instant_to_read(instant_t); 

/* Formats the instant as a string to sort files. */
char* format_instant_to_sort_files(instant_t);

/* Retrieves the current instant */
instant_t get_instant();

/* Calculates the difference between two instants. */
int get_instant_difference (instant_t*, instant_t,  instant_t);

/* Retrieves the current instant formatted as a string to sort files. */
char* get_instant_file_formatted();

/* Retrieves the current instant formatted as a human-readable string. */
char* get_instant_read_formatted();

/* Retrieves an instant stored on a file. */
int retrieve_instant_from_file(instant_t*, char*);

/* Stores the current instant on a file. */
int store_current_instant(char*);

#endif

