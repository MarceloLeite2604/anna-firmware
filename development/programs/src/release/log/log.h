/*
 * This header contains all constants and function declarations required to 
 * elaborate log files.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */
#ifndef LOG_H
#define LOG_H

/*
 * Includes.
 */

#include <stdbool.h>
#include <stdio.h>
#include <string.h>


/*
 * Definitions.
 */

// Codes used to identify a message level.
#define LOG_MESSAGE_TYPE_TRACE 105
#define LOG_MESSAGE_TYPE_WARNING 110
#define LOG_MESSAGE_TYPE_ERROR 115

#define LOG_MESSAGE_BUFFER_SIZE 256

// Macro to register a warning message
#define LOG_WARNING(...) if (_log_writing_message == false){\
    _log_writing_message = true;\
    sprintf(_log_message_buffer, __VA_ARGS__);\
    write_log_message(LOG_MESSAGE_TYPE_WARNING, __func__, __LINE__, _log_message_buffer);\
    memset(_log_message_buffer, 0, LOG_MESSAGE_BUFFER_SIZE);\
    _log_writing_message = false;\
}
#define LOG(x, y) if (_log_writing_message == false){\
    _log_writing_message=true;\
    write_log_message((x), __func__, __LINE__, (y));\
    _log_writing_message=false;\
}

// Macro to register an error message
#define LOG_ERROR(...) if (_log_writing_message == false){\
    _log_writing_message=true;\
    sprintf(_log_message_buffer, __VA_ARGS__);\
    write_log_message(LOG_MESSAGE_TYPE_ERROR, __func__, __LINE__, _log_message_buffer);\
    memset(_log_message_buffer, 0, LOG_MESSAGE_BUFFER_SIZE);\
    _log_writing_message=false;\
}

// Macro to register a trace message.
#define LOG_TRACE(...) if (_log_writing_message == false){\
    _log_writing_message=true;\
    sprintf(_log_message_buffer, __VA_ARGS__);\
    LOG_TRACE_POINT;\
    _log_writing_message=false;\
}

// Macro to register a trace point.
#define LOG_TRACE_POINT if (_log_writing_message == false){\
    _log_writing_message=true;\
write_log_message(LOG_MESSAGE_TYPE_TRACE, __func__, __LINE__, _log_message_buffer);\
    memset(_log_message_buffer, 0, LOG_MESSAGE_BUFFER_SIZE);\
    _log_writing_message=false;\
}



/*
 * Variables.
 */
extern char _log_message_buffer[LOG_MESSAGE_BUFFER_SIZE];
extern bool _log_writing_message;


/*
 * Function headers.
 */

/*
 * Closes a log file.
 */
int close_log_file();

/*
 * Defines the start log level.
 */
int define_start_log_level(int);

/*
 * Finishes a shell script log file.
 */
int finish_shell_script_log();

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
 * Checks if shell log is activated.
 */
bool is_shell_log_activated();

/*
 * Opens a log file.
 */
int open_log_file(char*);

/*
 * Defines the directory to store log files.
 */
int set_log_directory(const char*);

/*
 * Defines the current level of log file.
 */ 
int set_log_level(int);

/*
 * Starts shell script log.
 */
int start_shell_script_log(char*, int);

/*
 * Writes a log message.
 */
int write_log_message(const int, const char*, const int, const char*);

#endif
