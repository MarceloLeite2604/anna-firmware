/*
 * This header contains all constants and function declarations required to 
 * elaborate log files.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

// Default directory to log files.
#define DEFAULT_LOG_DIRECTORY "."

// Preffixes used to identify message levels.
#define LOG_TRACE_PREFFIX "TRACE"
#define LOG_WARNING_PREFFIX "WARNING"
#define LOG_ERROR_PREFFIX "ERROR"

// Codes used to identify a message level.
#define LOG_MESSAGE_TYPE_TRACE 5
#define LOG_MESSAGE_TYPE_WARNING 10
#define LOG_MESSAGE_TYPE_ERROR 15

/*
 * Indicates if a log file is open.
 */
int is_log_open();

/*
 * Returns the current log directory.
 */
char* get_log_directory();

/*
 * Format a log message.
 * TODO: Once this function has a stable version, remove it from this header file.
 */
int format_log_message(char* buffer, int buffer_size, int message_type, char* function, int index, char* message);

/*
 * Return the current time formatted as a string.
 * TODO: Once this function has a stable version, remove it from this header file.
 */
char* get_current_time();

/*
 * Defines the directory to store log files.
 */
int set_log_directory(char* new_log_directory);
