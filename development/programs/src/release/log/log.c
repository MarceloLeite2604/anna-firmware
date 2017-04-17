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
#include "../directory/directory.h"
#include "../general/return_codes.h"
#include "../script/script.h"
#include "log.h"


/*
 * Definitions.
 */


/* Default directory to log files. */
#define DEFAULT_LOG_DIRECTORY "./logs/"

/* Preffixes used to identify message levels. */
#define LOG_TRACE_PREFFIX "TRACE"
#define LOG_WARNING_PREFFIX "WARNING"
#define LOG_ERROR_PREFFIX "ERROR"

/* Script to start shell script log. */
#define SHELL_SCRIPT_START_LOG "start_log.sh"

/* Script to finish shell script log. */
#define SHELL_SCRIPT_FINISH_LOG "finish_log.sh"

/* Script to check is shell script log is activated. */
#define SHELL_SCRIPT_IS_LOG_ACTIVATED "is_log_activated.sh"

/* Script to change current shell script log level. */
#define SHELL_SCRIPT_CHANGE_LOG_LEVEL "change_log_level.sh"

/* Script to define start log level. */
#define SHELL_SCRIPT_DEFINE_START_LOG_LEVEL "define_start_log_level.sh"

/* Script to undefine start log level. */
#define SHELL_SCRIPT_UNDEFINE_START_LOG_LEVEL "undefine_start_log_level.sh"

/* Length of time string formatted to read. */
#define TIME_STRING_READ_LENGTH 19

/* Length of time string formatted to identify files. */
#define TIME_STRING_FILE_LENGTH 15

/* Suffix to identify log files. */
#define LOG_FILE_SUFFIX ".log"

/* Length of error messsage buffer. */
#define ERROR_MESSAGE_BUFFER_LENGTH 1024

/* Size of variable that stored the log directory. */
#define LOG_DIRECTORY_SIZE 512

/* Macro to print an error message. */
#define _LOG_PRINT_ERROR(x) fprintf(stderr, "[%s] %s: (%s, %d): %s\n", get_current_time_read_formatted(), LOG_ERROR_PREFFIX, __func__, __LINE__, (x))

/*
 * Global variables.
 */

/* Log message buffer. */
char _log_message_buffer[LOG_MESSAGE_BUFFER_SIZE];

/* Current directory to store log files. */
char log_directory[LOG_DIRECTORY_SIZE];

/* Indicates that log directory was initialized. */
bool log_directory_initialized = false;

/* Current log file name. */
char* log_file_name = NULL;

/* Current log file path. */
char* log_file_path = NULL;

/* Current log file. */
FILE* log_file = NULL;

/* Error message. */
char error_message[ERROR_MESSAGE_BUFFER_LENGTH];

/* Current log level. */
int log_level = LOG_MESSAGE_TYPE_TRACE;

/* Indicates if start log level is defined. */
bool start_log_level_defined = false;

/* Indicates that a message is being written. */
bool _log_writing_message = false;


/*
 * Private function headers.
 */

/* Format a message to be logged. */
int format_log_message(char*, int, const int, const char*, const int, const char*);

/* Returns the current time formatted to sort file names. */
char* get_current_time_file_formatted();

/* Returns the current time in a readable format. */
char* get_current_time_read_formatted();

/* Initializes log directory. */
int initialize_log_directory();

/* Creates a log file name. */
char* create_log_file_name(char*);

/* Undefines the start log level for shell scripts. */
int undefine_shell_start_log_level();


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
 *  SUCCESS - If log file was closed successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int close_log_file() {
    LOG_TRACE_POINT;

    if ( is_log_open() == false ) {
        LOG_ERROR("There is not a log file opened.\n");
        return GENERIC_ERROR;
    }

    char* current_time_read_formatted = get_current_time_read_formatted();
    LOG_TRACE_POINT;

    fprintf(log_file, "[%s] Log finished.\n", current_time_read_formatted);
    free(current_time_read_formatted);

    if ( fclose(log_file) != 0 ) {
        LOG_ERROR("Error while closing log file.\n");
        return GENERIC_ERROR; 
    }
    log_file=NULL;

    free(log_file_name);
    log_file_name=NULL;
    free(log_file_path);
    log_file_path=NULL;

    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Defines the start log level.
 *
 * Parameters
 *  start_log_level - The start log level to be defined.
 *
 * Returns
 *  SUCCESS - If start log level was defined successfully.
 *  GENERAL_ERROR - Otherwise.
 */
int define_start_log_level(int start_log_level) {
    LOG_TRACE_POINT;

    int result;
    char command[256];
    int script_result;
    int start_log_level_result;

    sprintf(command, "%s %d", SHELL_SCRIPT_DEFINE_START_LOG_LEVEL, start_log_level);

    script_result = execute_script(command);
    LOG_TRACE_POINT;

    if ( script_result == SUCCESS ) {
        LOG_TRACE_POINT;
        start_log_level_defined = true;

        start_log_level_result = set_log_level(start_log_level);
        LOG_TRACE_POINT;

        if ( start_log_level_result == SUCCESS ) {
            LOG_TRACE_POINT;
            result = SUCCESS;
        }
        else {
            LOG_TRACE_POINT;
            result = GENERIC_ERROR;
        }
    }
    else {
        LOG_TRACE_POINT;
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Finishes a shell script log file.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  SUCCESS - If shell script log was finished successfully.
 *  GENERIC ERROR - Otherwise.
 */
int finish_shell_script_log(){
    LOG_TRACE_POINT;

    int result;
    int script_result;
    int undefine_shell_start_log_level_result;

    script_result = execute_script(SHELL_SCRIPT_FINISH_LOG);
    LOG_TRACE_POINT;

    if ( script_result == SUCCESS ) {
        LOG_TRACE_POINT;

        if ( start_log_level_defined == true ) {
            LOG_TRACE_POINT;

            undefine_shell_start_log_level_result = undefine_shell_start_log_level();
            LOG_TRACE_POINT;

            if ( undefine_shell_start_log_level_result == SUCCESS ) {
                LOG_TRACE_POINT;
                result = SUCCESS;
            }
        }
        else {
            LOG_TRACE_POINT;
            result = SUCCESS;
        }
    } else {
        LOG_TRACE_POINT;
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
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
    LOG_TRACE_POINT;

    char* result;

    int log_file_preffix_length;

    if ( log_file_preffix == NULL ) {
        LOG_ERROR("Log file preffix is null.\n");
        return NULL;
    }

    log_file_preffix_length = strlen(log_file_preffix);

    result = malloc((log_file_preffix_length+TIME_STRING_FILE_LENGTH+strlen(LOG_FILE_SUFFIX)+2)*sizeof(char));

    strcpy(result, log_file_preffix);
    strcat(result, "_");
    char* current_time_file_formatted = get_current_time_file_formatted();
    strcat(result, current_time_file_formatted);
    free(current_time_file_formatted);
    strcat(result, LOG_FILE_SUFFIX);

    LOG_TRACE_POINT;
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
 *  SUCCESS - If the message was formatted successfully.
 *  GENERIC ERROR - Otherwise.
 *  The formatted message is returned through "buffer" parameter.
 */
int format_log_message(char* buffer, int buffer_size, const int message_type, const char* tag, const int index, const char* message) {
    LOG_TRACE_POINT;

    char* preffix;
    int preffix_length;

    int tag_length;

    char string_index[20];
    int string_index_length;

    char* temporary_buffer;
    int temporary_buffer_length;

    int message_length;
    int additional_characters;

    int characters_to_copy;

    // Check "buffer" parameter.
    if ( buffer == NULL ) {
        LOG_ERROR("Buffer pointer is null.\n");
        return GENERIC_ERROR;
    }

    // Check "buffer_size" parameter.
    if ( buffer_size <= 0 ) {
        LOG_ERROR("Buffer size must be greater than zero.\n");
        return GENERIC_ERROR;
    }

    // Check "message_type" parameter.
    switch (message_type){
        case LOG_MESSAGE_TYPE_TRACE:
            LOG_TRACE_POINT;
            preffix = LOG_TRACE_PREFFIX;
            break;
        case LOG_MESSAGE_TYPE_WARNING:
            LOG_TRACE_POINT;
            preffix = LOG_WARNING_PREFFIX;
            break;
        case LOG_MESSAGE_TYPE_ERROR:
            LOG_TRACE_POINT;
            preffix = LOG_ERROR_PREFFIX;
            break;
        default:
            LOG_TRACE_POINT;
            _LOG_PRINT_ERROR("Unknown log message type.\n");
            return GENERIC_ERROR;
            break;
    }

    preffix_length=strlen(preffix);

    // Check "tag" parameter.
    if ( tag == NULL ) {
        LOG_ERROR("Message tag is null.\n");
        return GENERIC_ERROR;
    }

    tag_length=strlen(tag);

    // Check "index" parameter.
    sprintf(string_index, "%d", index);
    string_index_length = strlen(string_index);

    if ( message != NULL ) {
        LOG_TRACE_POINT;
        message_length = strlen(message) + 2;
        additional_characters=10;
    }
    else {
        LOG_TRACE_POINT;
        message_length = 0;
        additional_characters=8;
    }

    temporary_buffer_length=TIME_STRING_READ_LENGTH+preffix_length+tag_length+string_index_length+message_length+additional_characters+1;
    temporary_buffer = malloc(temporary_buffer_length*sizeof(char));

    char* current_time_read_formatted = get_current_time_read_formatted();
    if ( message != NULL && strlen(message) > 0 ) {
        LOG_TRACE_POINT;
        sprintf(temporary_buffer, "[%s] %s: %s (%s): %s", current_time_read_formatted, preffix, tag, string_index, message);
    }
    else {
        LOG_TRACE_POINT;
        sprintf(temporary_buffer, "[%s] %s: %s (%s)", current_time_read_formatted, preffix, tag, string_index);
    }
    free(current_time_read_formatted);

    if ( temporary_buffer_length > buffer_size ) {
        LOG_TRACE_POINT;
        characters_to_copy=buffer_size-1;
    }
    else {
        LOG_TRACE_POINT;
        characters_to_copy=temporary_buffer_length-1;
    }

    strcpy(buffer, temporary_buffer);
    //strncpy(buffer, temporary_buffer, characters_to_copy);
    //buffer[characters_to_copy] = '\0';

    free(temporary_buffer);
    temporary_buffer=NULL;

    LOG_TRACE_POINT;
    return SUCCESS;
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
    LOG_TRACE_POINT;

    char* result;
    time_t rawtime;
    struct tm* timeinfo;

    time(&rawtime);
    timeinfo = localtime(&rawtime);

    result = malloc((TIME_STRING_FILE_LENGTH+1)*sizeof(char)); 
    strftime(result, TIME_STRING_FILE_LENGTH+1, "%d%m%Y_%H%M%S", timeinfo);

    LOG_TRACE_POINT;
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
    LOG_TRACE_POINT;

    char* result;
    time_t rawtime;
    struct tm* timeinfo;

    time(&rawtime);
    timeinfo = localtime(&rawtime);

    result = malloc((TIME_STRING_READ_LENGTH+1)*sizeof(char)); 
    strftime(result, TIME_STRING_READ_LENGTH+1, "%d/%m/%Y %H:%M:%S", timeinfo);

    LOG_TRACE_POINT;
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
    LOG_TRACE_POINT;

    if ( log_directory_initialized == false ) {
        LOG_TRACE_POINT;

        initialize_log_directory();
        LOG_TRACE_POINT;
    }

    LOG_TRACE_POINT;
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
    LOG_TRACE_POINT;

    if ( is_log_open() == false ) {
        LOG_TRACE_POINT;
        return NULL;
    } 

    LOG_TRACE_POINT;
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
    LOG_TRACE_POINT;

    /*char* result;
    int log_directory_length;
    int log_file_name_length;*/

    if ( is_log_open() == false ) {
        LOG_TRACE_POINT;
        return NULL;
    } 

    LOG_TRACE_POINT;
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
 * Parameters
 *  None.
 *
 * Returns
 *  The current log level.
 */
int get_log_level() {
    LOG_TRACE_POINT;
    return log_level;
}

/*
 * Initializes log directory.
 *
 * Parameters
 *  None
 *
 * Returns
 *  SUCCESS - If log directory was initialized successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int initialize_log_directory() {
    LOG_TRACE_POINT;
    
    char* output_directory;

    output_directory = get_output_directory();
    LOG_TRACE_POINT;

    memset(log_directory, 0, LOG_DIRECTORY_SIZE);

    if ( output_directory != NULL ) {
        LOG_TRACE_POINT;
        strcpy(log_directory, output_directory);
    }

    strcat(log_directory, DEFAULT_LOG_DIRECTORY); 

    free(output_directory);

    log_directory_initialized = true;

    return SUCCESS;
}

/*
 * Indicates if a log file is open.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  True if there is a log file specified. False otherwise.
 */
bool is_log_open() {
    LOG_TRACE_POINT;

    if ( log_file == NULL ) {
        LOG_TRACE_POINT;
        return false;
    }
    else {
        LOG_TRACE_POINT;
        return true;
    }
}

/*
 * Checks if shell log is activated.
 *
 * Parameters
 *  None
 *
 * Returns
 *  True if shell script log is activated. False otherwise.
 */
bool is_shell_log_activated(){
    LOG_TRACE_POINT;

    bool result;
    int script_result;

    script_result = execute_script(SHELL_SCRIPT_IS_LOG_ACTIVATED);
    LOG_TRACE_POINT;

    if ( script_result == SUCCESS ) {
        LOG_TRACE_POINT;
        result = true;
    } else {
        LOG_TRACE_POINT;
        result = false;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Opens a log file.
 *
 * Parameters:
 *  log_file_preffix - Preffix to identify log file.
 *
 * Returns:
 *  SUCCESS - If log file was created successfully.
 *  GENERIC ERROR - Otherwise.
 */
int open_log_file(char* log_file_preffix){
    LOG_TRACE_POINT;

    int log_file_name_length;
    int log_directory_length;

    if ( log_file_preffix == NULL ) {
        LOG_ERROR("Log file preffix is null.");
        return GENERIC_ERROR;
    }

    if ( is_log_open() == true ) {
        LOG_ERROR("A log file is already open.");
        return GENERIC_ERROR;
    }

    log_file_name = create_log_file_name(log_file_preffix);
    if ( log_file_name == NULL ) {
        LOG_ERROR("Could not create log file name.");
        return GENERIC_ERROR;
    }

    log_file_name_length=strlen(log_file_name);
    log_directory_length=strlen(get_log_directory());
    LOG_TRACE_POINT;

    log_file_path=(char*)malloc((log_directory_length+log_file_name_length+1)*sizeof(char));

    strcpy(log_file_path, get_log_directory());
    LOG_TRACE_POINT;
    strcat(log_file_path, log_file_name);

    errno = 0;
    log_file = fopen(log_file_path, "a");

    if ( log_file == NULL || errno != 0 ) {
        LOG_ERROR("Could not open log file \"%s\".\n", log_file_path);
        return GENERIC_ERROR;
    }

    char* current_time_read_formatted = get_current_time_read_formatted();
    fprintf(log_file, "[%s] Log started.\n", current_time_read_formatted);
    free(current_time_read_formatted);

    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Defines the directory to store log files.
 *
 * Parameters:
 *  new_log_directory - The directory that should be defined to store the log files.
 *
 * Returns:
 *  SUCCESS - If the directory to store log files was defined correctly.
 *  GENERIC ERROR - Otherwise.
 */
int set_log_directory(const char* new_log_directory){
    LOG_TRACE_POINT;

    int new_log_directory_length;

    // Check "new_log_directory" parameter.
    if ( new_log_directory == NULL ) {
        LOG_ERROR("Log directory cannot be null.");
        return GENERIC_ERROR;
    }

    if ( is_log_open() == true ) {
        LOG_ERROR("Cannot change log directory while log file is open.\n");
        return GENERIC_ERROR;
    }

    DIR* dir = opendir(new_log_directory);
    if ( dir == 0 ) {
        LOG_ERROR("Directory \"%s\" does not exist.\n", new_log_directory);
        return GENERIC_ERROR;
    }

    closedir(dir);

    /*
    new_log_directory_length=strlen(new_log_directory);

    if ( log_directory != NULL ) {
        free(log_directory);
    }
    log_directory=malloc((new_log_directory_length+1)*sizeof(char));
    */

    strcpy(log_directory, new_log_directory);

    log_directory_initialized = true;

    LOG_TRACE_POINT;
    return SUCCESS;
}

/*
 * Defines the current level of log file.
 *
 * Parameters:
 *  new_log_level - The new log level.
 *
 * Returns:
 *  SUCCESS - If the log level was defined correctly.
 *  GENERIC ERROR - Otherwise.
 *
 * Observation:
 *  The log level indicates wich messages will be stored on log file. Messages with a level lower than current log level will be ignored.
 *  Use the message level constants defined on header file to indicate the log level.
 */ 
int set_log_level(int new_log_level) {
    LOG_TRACE_POINT;

    char command[256];
    int script_result;
    int result;

    /* Check "new_log_level" parameter. */
    if ( new_log_level != LOG_MESSAGE_TYPE_TRACE && new_log_level != LOG_MESSAGE_TYPE_WARNING && new_log_level != LOG_MESSAGE_TYPE_ERROR ) {
        LOG_ERROR("Unknown log level: %d.", new_log_level);
        return GENERIC_ERROR;
    }

    sprintf(command, "%s %d", SHELL_SCRIPT_CHANGE_LOG_LEVEL, new_log_level);

    script_result = execute_script(command);
    LOG_TRACE_POINT;

    if ( script_result == SUCCESS ) {
        LOG_TRACE_POINT;
        log_level = new_log_level;
        result = SUCCESS;
    }
    else {
        LOG_TRACE_POINT;
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Starts shell script log.
 *
 * Parameters
 *  log_preffix - The preffix to use on log file name.
 *  log_level   - The log level to define.
 *
 * Returns
 *  SUCCESS - If shell script log was activated successfully.
 *  GENERIC ERROR - Otherwise.
 */
int start_shell_script_log(char* log_preffix, int log_level){
    LOG_TRACE_POINT;

    int result;
    int script_result;
    char command[256];

    sprintf(command, "%s \"%s\" %d", SHELL_SCRIPT_START_LOG, log_preffix, log_level);

    script_result = execute_script(command);
    LOG_TRACE_POINT;

    if ( script_result == SUCCESS ) {
        LOG_TRACE_POINT;
        result = SUCCESS;
    }
    else {
        LOG_TRACE_POINT;
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Undefines the start log level for shell scripts.
 *
 * Parameters
 *  None
 *
 * Returns
 *  SUCCESS - If start log level was undefined successfully.
 *  GENERAL_ERROR - Otherwise.
 */
int undefine_shell_start_log_level() {
    LOG_TRACE_POINT;

    int result;
    int script_result;

    script_result = execute_script(SHELL_SCRIPT_UNDEFINE_START_LOG_LEVEL);
    LOG_TRACE_POINT;

    if ( script_result == SUCCESS ) {
        LOG_TRACE_POINT;
        result = SUCCESS;
    }
    else {
        LOG_TRACE_POINT;
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
}

/* 
 * Writes a log message.
 *
 * Parameters:
 *  message_type - Type of log message.
 *  tag          - Tag to identify log message origin.
 *  index        - Index to identify log message origin.
 *  message      - Message to be written.
 *
 * Returns:
 *  SUCCESS - If message was written successfully.
 *  GENERIC ERROR - Otherwise.
 *
 * Observations:
 *  Use constants defined on header file to fill "message_type" parameter.
 *  Parameter "message" is optional if message is a trace information.
 */
int write_log_message(const int message_type, const char* tag, const int index, const char* message){
    LOG_TRACE_POINT;

    const int formatted_message_length = 1024;
    char* formatted_message;
    FILE* output_file;

    // Check "message_type" parameter.
    if ( message_type != LOG_MESSAGE_TYPE_TRACE && message_type != LOG_MESSAGE_TYPE_WARNING && message_type != LOG_MESSAGE_TYPE_ERROR ) {
        LOG_ERROR("Unknown message type: %d.", message_type);
        return GENERIC_ERROR;
    }

    // Check "tag" parameter.
    if ( tag == NULL ) {
        LOG_ERROR("Message tag is null.");
        return GENERIC_ERROR;
    }

    // Check "message" parameter.
    if ( message == NULL && message_type != LOG_MESSAGE_TYPE_TRACE ) {
        LOG_ERROR("Message content is mandatory if its type is not \"trace\".");
        return GENERIC_ERROR;
    }

    formatted_message = malloc(formatted_message_length*sizeof(char));

    format_log_message(formatted_message, formatted_message_length, message_type, tag, index, message);
    LOG_TRACE_POINT;

    if ( is_log_open() == true ) {
        LOG_TRACE_POINT;
        output_file = log_file;
    }
    else {
        LOG_TRACE_POINT;
        output_file = stdout;
    }

    if ( fprintf(output_file, "%s\n", formatted_message) < 0 ) {
        LOG_ERROR("Error printing log message.\n");
        return GENERIC_ERROR;
    }

    fflush(output_file);

    free(formatted_message);

    LOG_TRACE_POINT;
    return SUCCESS;
}
