/*
 * This source contains the elaboration of all functions required to 
 * elaborate log files.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 *  Inclusions.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>
#include <time.h>
#include "log.h"


/*
 * Definitions.
 */


// Default directory to log files.
#define DEFAULT_LOG_DIRECTORY "."

// Preffixes used to identify message levels.
#define LOG_TRACE_PREFFIX "TRACE"
#define LOG_WARNING_PREFFIX "WARNING"
#define LOG_ERROR_PREFFIX "ERROR"

// Length of time string formatted to read.
#define TIME_STRING_READ_LENGTH 20

// Length of time string formatted to identify files.
#define TIME_STRING_FILE_LENGTH 15

// Suffix to identify log files.
#define LOG_FILE_SUFFIX ".log"

// Macro to print an error message.
#define PRINT_ERROR(x) fprintf(stderr, "[%s] %s: (%s, %d): %s\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX, __func__, __LINE__, (x))

/*
 * Global variables.
 */
// Current directory to store log files.
char* log_directory = NULL;

// Current log file name.
char* log_file_name = NULL;

// Current log file path.
char* log_file_path = NULL;

// Current log file.
FILE* log_file = NULL;


// Current log level.
int log_level = LOG_MESSAGE_TYPE_TRACE;


/*
 * Private function headers.
 */

/*
 * Format a message to be logged.
 */
int format_log_message(char* buffer, int buffer_size, int message_type, char* tag, int index, char* message);

/*
 * Returns the current time formatted to sort file names.
 */
char* get_current_time_file_formatted();

/*
 * Returns the current time in a readable format.
 */
char* get_current_time_read_formatted();

/*
 * Creates a log file name.
 */
char* create_log_file_name(char* log_file_preffix);

/*
 * Function elaborations.
 */

/*
 * Closes a log file.
 *
 * Parameters:
 *  None.
 *
 * Return:
 *  0 - If log file was closed successfully.
 *  1 - Otherwise.
 */
int close_log_file() {

    if ( is_log_open() == false ) {
        fprintf(stderr, "[%s] %s: There is not a log file opened.\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX);
        return 1;
    }

    if ( fclose(log_file) != 0 ) {
        fprintf(stderr, "[%s] %s: Error while closing log file.\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX);
        return 1;
    }
    log_file=NULL;

    free(log_file_name);
    log_file_name=NULL;
    free(log_file_path);
    log_file_path=NULL;

    return 0;
}

/*
 * Creates a log file name.
 *
 * Parameters:
 *  log_file_preffix - The preffix to identify the log file.
 *
 * Returns:
 *  The log file name based on the preffix informed and current time or NULL if there was any error.
 */
char* create_log_file_name(char* log_file_preffix){

    char* result;

    int log_file_preffix_length;

    if ( log_file_preffix == NULL ) {
        fprintf(stderr, "[%s] %s: Log file preffix is null.\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX);
        return NULL;
    }

    log_file_preffix_length = strlen(log_file_preffix);

    result = (char*)malloc(log_file_preffix_length+TIME_STRING_FILE_LENGTH+strlen(LOG_FILE_SUFFIX+2)*sizeof(char));

    strncpy(result, log_file_preffix, log_file_preffix_length);
    strcat(result, "_");
    strcat(result, get_current_time_file_formatted());
    strcat(result, LOG_FILE_SUFFIX);

    return result;
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
        fprintf(stderr, "[%s] %s: Buffer pointer is null.\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX);
        return 1;
    }

    // Check "buffer_size" parameter.
    if ( buffer_size <= 0 ) {
        fprintf(stderr, "[%s] %s: Buffer size must be greater than zero.\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX);
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
            fprintf(stderr, "[%s] %s: Unknown log message type.\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX);
            return 1;
            break;
    }

    preffix_length=strlen(preffix);

    // Check "tag" parameter.
    if ( tag == NULL ) {
        fprintf(stderr, "[%s] %s: Function name is null.\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX);
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

    temporary_buffer_length=TIME_STRING_READ_LENGTH+preffix_length+tag_length+message_length+9;

    temporary_buffer = (char*)malloc(temporary_buffer_length*sizeof(char));

    if ( message != NULL ) {
        sprintf(temporary_buffer, "[%s] %s: %s (%s): %s", get_current_time_read_formatted(), preffix, tag, string_index, message);
    }
    else {
        sprintf(temporary_buffer, "[%s] %s: %s (%s)", get_current_time_read_formatted(), preffix, tag, string_index);
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
 * Returns the current time formatted to sort file names.
 *
 * Parameters:
 *  None.
 * 
 * Returns:
 *  The current time formatted as a string.
 *
 *  Observation:
 *   Time will be formatted as <YEAR><MONTHS><DAYS>_<HOURS><MINUTES><SECONDS>. 
 *   This format is used mostly on log file names.
 */
char* get_current_time_file_formatted(){
    char* result;
    time_t rawtime;
    struct tm* timeinfo;

    time(&rawtime);
    timeinfo = localtime(&rawtime);

    result = (char*)malloc((TIME_STRING_READ_LENGTH+1)*sizeof(char)); 
    strftime(result, TIME_STRING_READ_LENGTH, "%d%m%Y_%H%M%S", timeinfo);

    return result;
}

/*
 * Returns the current time in a readable format.
 *
 * Parameters:
 *  None.
 * 
 * Returns:
 *  The current time formatted as a string.
 *
 * Observation:
 *  This function will format time as "<DAYS>/<MONTHS>/<YEAR> <HOURS>:<MINUTES>:<SECONDS>".
 */
char* get_current_time_read_formatted(){
    char* result;
    time_t rawtime;
    struct tm* timeinfo;

    time(&rawtime);
    timeinfo = localtime(&rawtime);

    result = (char*)malloc((TIME_STRING_READ_LENGTH+1)*sizeof(char)); 
    strftime(result, TIME_STRING_READ_LENGTH, "%d/%m/%Y %H:%M:%S", timeinfo);

    return result;
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
 * Returns the current log file name.
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  The current log file name. If log file is not opened then it will return NULL.
 */
char* get_log_file_name() {
    if ( is_log_open() == false ) {
        return NULL;
    } 

    return log_file_name;
}

/*
 * Returns the current log file path.
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  The current log file path.
 *
 * Observations:
 *  If there is not a log file opened, then it will return NULL.
 */
char* get_log_file_path() {
    /*char* result;
    int log_directory_length;
    int log_file_name_length;*/

    if ( is_log_open() == false ) {
        return NULL;
    } 

    return log_file_path;

    /*log_directory_length=strlen(log_directory);
    log_file_name_length=strlen(log_file_name);

    char* result=malloc((log_directory+log_file_name+1)*sizeof(char));

    strcpy(result, log_directory);
    strcat(result, log_file_name);

    return result;*/
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
 * Indicates if a log file is open.
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  1 (true)  - If there is a log file specified.
 *  0 (false) - Otherwise.
 */
bool is_log_open() {
    if ( log_file == NULL ) {
        return false;
    }
    else {
        return true;
    }
}

/*
 * Opens a log file.
 *
 * Parameters:
 *  log_file_preffix - Preffix to identify log file.
 *
 * Returns:
 *  0 - If log file was created successfully.
 *  1 - Otherwise.
 */
int open_log_file(char* log_file_preffix){

    int log_file_name_length;
    int log_directory_length;

    if ( log_file_preffix == NULL ) {
        PRINT_ERROR("Log file preffix is null.");
        return 1;
    }

    if ( is_log_open() == true ) {
        //fprintf(stderr, "[%s] %s: A log file is already open.\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX);
        PRINT_ERROR("A log file is already open.");
        return 1;
    }

    log_file_name = create_log_file_name(log_file_preffix);
    if ( log_file_name == NULL ) {
        PRINT_ERROR("Could not create log file name.");
        return 1;
    }

    log_file_name_length=strlen(log_file_name);
    log_directory_length=strlen(get_log_directory());

    log_file_path=(char*)malloc((log_directory_length+log_file_name_length+1)*sizeof(char));

    strcpy(log_file_path, get_log_directory());
    strcat(log_file_path, log_file_name);

    errno = 0;
    log_file = fopen(log_file_path, "a");

    if ( log_file == NULL || errno != 0 ) {
        /* TODO: How to print error messages through macro when the error message has an argument? */
        fprintf(stderr, "[%s] %s: Could not open log file \"%s\".\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX, log_file_path);
        return 1;
    }

    return 0;
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
        PRINT_ERROR("Log directory cannot be null.");
        return 1;
    }

    DIR* dir = opendir(new_log_directory);
    if ( dir == 0 ) {
        fprintf(stderr, "[%s] %s: Directory \"%s\" does not exist.\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX, new_log_directory);
        return 1;

    }

    closedir(dir);

    new_log_directory_length=strlen(new_log_directory);

    if ( log_directory != NULL ) {
        free(log_directory);
    }
    log_directory=(char*)malloc((new_log_directory_length+1)*sizeof(char));
    strcpy(log_directory, new_log_directory);
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
        PRINT_ERROR("Unknown log level.");
        return 1;
    }

    log_level = new_log_level;

    return 0;
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
