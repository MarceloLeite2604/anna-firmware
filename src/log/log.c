/*
 * This source contains the elaboration of all functions required to 
 * elaborate log files.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <time.h>
#include "log.h"

// Default directory to log files.
#define DEFAULT_LOG_DIRECTORY "."

// Preffixes used to identify message levels.
#define LOG_TRACE_PREFFIX "TRACE"
#define LOG_WARNING_PREFFIX "WARNING"
#define LOG_ERROR_PREFFIX "ERROR"

// Length of a string containing the formatted time.
#define TIME_STRING_LENGTH 20

// Current directory to store log files.
char* log_directory = NULL;

// Current log file.
FILE* log_file = NULL;

// Current log level.
int log_level = LOG_MESSAGE_TYPE_TRACE;

/*
 * Returns the current time formatted as a string.
 *
 * Parameters:
 *  None.
 * 
 * Returns:
 *  The current time formatted as a string.
 */
char* get_current_time(){
    char* result;
    time_t rawtime;
    struct tm* timeinfo;

    time(&rawtime);
    timeinfo = localtime(&rawtime);

    result = (char*)malloc((TIME_STRING_LENGTH+1)*sizeof(char)); 
    strftime(result, TIME_STRING_LENGTH, "%d/%m/%Y %H:%M:%S", timeinfo);

    return result;
}

/*
 * Indicates if a log file is open.
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  0 - If there is a log file specified.
 *  1 - Otherwise.
 */
int is_log_open() {
    if ( log_file == NULL ) {
        return 1;
    }
    else {
        return 0;
    }
}

/*
 * Returns the current directory where log files are stored.
 *
 * Parameters:
 *  None.
 * 
 * Returns:
 *  The current directory where log files are stored.
 */
char* get_log_directory() {
    if ( log_directory == NULL ) {
        return DEFAULT_LOG_DIRECTORY;
    }

    return log_directory;
}

/*
 * Defines the directory to store log files.
 *
 * Parameters:
 *  new_log_directory - The directory that should be defined to store the log files.
 *
 * Returns:
 *  0 - If the directory to store log files was defined correctly.
 *  1 - Otherwise.
 */
int set_log_directory(char* new_log_directory){

    int new_log_directory_length;

    // Check "new_log_directory" parameter.
    if ( new_log_directory == NULL ) {
        fprintf(stderr, "[%s] %s: Log directory cannot be null.\n", get_current_time(), LOG_ERROR_PREFFIX);
        return 1;
    }

    DIR* dir = opendir(new_log_directory);
    if ( dir == 0 ) {
        fprintf(stderr, "[%s] %s: Directory \"%s\" does not exist.\n", get_current_time(), LOG_ERROR_PREFFIX, new_log_directory);
        return 1;

    }

    closedir(dir);

    new_log_directory_length=strlen(new_log_directory);

    if ( log_directory != NULL ) {
        free(log_directory);
    }
    log_directory=(char*)malloc(new_log_directory_length*sizeof(char));
    strncpy(log_directory, new_log_directory, new_log_directory_length);
    return 0;
}

/*
 * Format a message to be logged.
 *
 * Parameters:
 *  buffer - Buffer where the message will be returned.
 *  buffer_size - Size of "buffer" parameter.
 *  message_type - Type of message to be formatted.
 *  tag - Tag to identify the message location.
 *  index - Index to identify the message location.
 *  message - The message to be written (optional).
 *
 * Returns:
 *  0 - If the message was formatted successfully.
 *  1 - Otherwise.
 *  The formatted message is returned through "buffer" parameter.
 */
int format_log_message(char* buffer, int buffer_size, int message_type, char* tag, int index, char* message) {

    char* preffix;
    int preffix_length;

    int tag_length;

    char string_index[20];
    int string_index_length;

    char* temporary_buffer;
    int temporary_buffer_length;

    int message_length;

    int characters_to_copy;

    // Check "buffer" parameter.
    if ( buffer == NULL ) {
        fprintf(stderr, "[%s] %s: Buffer pointer is null.\n", get_current_time(), LOG_ERROR_PREFFIX);
        return 1;
    }

    // Check "buffer_size" parameter.
    if ( buffer_size <= 0 ) {
        fprintf(stderr, "[%s] %s: Buffer size must be greater than zero.\n", get_current_time(), LOG_ERROR_PREFFIX);
        return 1;
    }

    // Check "message_type" parameter.
    switch (message_type){
        case LOG_MESSAGE_TYPE_TRACE:
            preffix = LOG_TRACE_PREFFIX;
            break;
        case LOG_MESSAGE_TYPE_WARNING:
            preffix = LOG_WARNING_PREFFIX;
            break;
        case LOG_MESSAGE_TYPE_ERROR:
            preffix = LOG_ERROR_PREFFIX;
            break;
        default:
            fprintf(stderr, "[%s] %s: Unknown log message type.\n", get_current_time(), LOG_ERROR_PREFFIX);
            return 1;
            break;
    }

    preffix_length=strlen(preffix);

    // Check "tag" parameter.
    if ( tag == NULL ) {
        fprintf(stderr, "[%s] %s: Function name is null.\n", get_current_time(), LOG_ERROR_PREFFIX);
        return 1;
    }

    tag_length=strlen(tag);

    // Check "index" parameter.
    sprintf(string_index, "%d", index);
    string_index_length = strlen(string_index);


    if ( message != NULL ) {
        message_length = strlen(message) + 2;
    }
    else {
        message_length = 0;
    }

    temporary_buffer_length=TIME_STRING_LENGTH+preffix_length+tag_length+message_length+9;

    temporary_buffer = (char*)malloc(temporary_buffer_length*sizeof(char));

    if ( message != NULL ) {
        sprintf(temporary_buffer, "[%s] %s: %s (%s): %s", get_current_time(), preffix, tag, string_index, message);
    }
    else {
        sprintf(temporary_buffer, "[%s] %s: %s (%s)", get_current_time(), preffix, tag, string_index);
    }

    if ( temporary_buffer_length > buffer_size ) {
        characters_to_copy=buffer_size-1;
    }
    else {
        characters_to_copy=temporary_buffer_length-1;
    }

    strncpy(buffer, temporary_buffer, characters_to_copy);

    buffer[characters_to_copy] = '\0';

    free(temporary_buffer);

    return 0;

}

/*
 * Defines the current level of log file.
 *
 * Parameters:
 *  new_log_level - The new log level.
 *
 * Returns:
 *  0 - If the log level was defined correctly.
 *  1 - Otherwise.
 *
 * Observation:
 *  The log level indicates wich messages will be stored on log file. Messages with a level lower than current log level will be ignored.
 *  Use the message level constants defined on header file to indicate the log level.
 */ 
int set_log_level(int new_log_level) {

    // Check "new_log_level" parameter.
    if ( new_log_level != LOG_MESSAGE_TYPE_TRACE && new_log_level != LOG_MESSAGE_TYPE_WARNING && new_log_level != LOG_MESSAGE_TYPE_ERROR ) {
        fprintf(stderr, "[%s] %s: Unknown log level.\n", get_current_time(), LOG_ERROR_PREFFIX);
        return 1;
    }

    log_level = new_log_level;

    return 0;
}

/*
 * Returns the current log level.
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  The current log level.
 */
int get_log_level() {
    return log_level;
}

/*
   void print_error_message(char* function, int index, char* message) {
   char* error_message = format_log_message(LOG_MESSAGE_TYPE_ERROR, function, index, message);
   fprintf(stderr, "%s", error_message);
   }
   */

/*
   void trace(char* function, int index){

   }
   */
