/*
 * This header contains all constants and function declarations required to 
 * elaborate log files.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */

#include <stdbool.h>
#include <stdio.h>


/*
 * Definitions.
 */

// Codes used to identify a message level.
#define LOG_MESSAGE_TYPE_TRACE 5
#define LOG_MESSAGE_TYPE_WARNING 10
#define LOG_MESSAGE_TYPE_ERROR 15

#define LOG_MESSAGE_BUFFER_SIZE 256

// Macro to register a log message.
#define LOG(x, y) write_log_message((x), __func__, __LINE__, (y))

// Macro to register an error message
#define LOG_ERROR(x) write_log_message(LOG_MESSAGE_TYPE_ERROR, __func__, __LINE__, (x)) 

// Macro to print a trace point.
#define TRACE_POINT write_log_message(LOG_MESSAGE_TYPE_TRACE, __func__, __LINE__, _log_message_buffer);\
    memset(_log_message_buffer, 0, LOG_MESSAGE_BUFFER_SIZE);

// Macro to register a trace message.
#define TRACE(...) sprintf(_log_message_buffer, __VA_ARGS__);\
    TRACE_POINT;



/*
 * Variables.
 */
extern char _log_message_buffer[LOG_MESSAGE_BUFFER_SIZE];


/*
 * Function headers.
 */

/*
 * Closes a log file.
 */
int close_log_file();

/*
 * Returns the current log directory.
 */
char* get_log_directory();

/*
 * Returns the current log file name.
 */
char* get_log_file_name();

/*
 * Returns the current log file path.
 */
char* get_log_file_path();

/*
 * Returns the current log level.
 */
int get_log_level();

/*
 * Indicates if a log file is open.
 */
bool is_log_open();

/*
 * Opens a log file.
 */
int open_log_file(char* log_file_preffix);

/*
 * Defines the directory to store log files.
 */
int set_log_directory(const char* new_log_directory);

/*
 * Defines the current level of log file.
 */ 
int set_log_level(int new_log_level);

/*
 * Writes a log message.
 */
int write_log_message(const int message_type, const char* tag, const int index, const char* message);
