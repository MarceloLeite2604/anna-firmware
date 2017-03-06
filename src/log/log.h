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


/*
 * Definitions.
 */

// Codes used to identify a message level.
#define LOG_MESSAGE_TYPE_TRACE 5
#define LOG_MESSAGE_TYPE_WARNING 10
#define LOG_MESSAGE_TYPE_ERROR 15

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
int set_log_directory(char* new_log_directory);

/*
 * Defines the current level of log file.
 */ 
int set_log_level(int new_log_level);
