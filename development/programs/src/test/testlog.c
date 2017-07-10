/*
 * The objetive of this source file is to test all log functions. 
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

#include "log.h"

/*
 * Definitions.
 */
#define LOG_ROOT_DIRECTORY "../resources/tests/log/"

/*
 * Function headers.
 */
void test_log_directory();
void test_set_log_level();
void test_open_log_file();
void test_write_log_message();


/*
 * Function elaborations.
 */

/*
 * Main function.
 */
int main(int argc, char** argv){

    test_log_directory();
    test_set_log_level();
    test_open_log_file();
    test_write_log_message();
    return 0;
}


/*
 * Tests "get_log_directory" and "set_log_directory" functions.
 */
void test_log_directory(){
    printf("Testing \"get_log_directory\" and \"set_log_directory\" functions.\n");

    char invalid_log_directory[256];

    strcpy(invalid_log_directory, LOG_ROOT_DIRECTORY);
    strcat(invalid_log_directory, "test_log_directory/invalid_directory/");
    printf("Default log directory is \"%s\".\n", get_log_directory());

    set_log_directory(LOG_ROOT_DIRECTORY);

    printf("New log directory is \"%s\".\n", get_log_directory());

    set_log_directory(invalid_log_directory);
    printf("Current log directory is \"%s\".\n", get_log_directory());

    printf("Test of functions \"get_log_directory\" and \"set_log_directory\" concluded.\n\n");
}

/*
 * Tests "get_log_level" and "set_log_level" functions.
 */
void test_set_log_level(){
    printf("Testing \"get_log_level\" and \"set_log_level\" functions.\n");
    int invalid_log_level = -1;

    printf("Default log level is %d.\n", get_log_level());

    set_log_level(LOG_MESSAGE_TYPE_ERROR);
    printf("New log level is %d.\n", get_log_level());

    set_log_level(LOG_MESSAGE_TYPE_WARNING);
    printf("New log level is %d.\n", get_log_level());

    set_log_level(LOG_MESSAGE_TYPE_TRACE);
    printf("New log level is %d.\n", get_log_level());

    set_log_level(invalid_log_level);
    printf("Current log level is %d.\n", get_log_level());

    printf("Test of functions \"get_log_level\" and \"set_log_level\" concluded.\n\n");
}

/*
 * Tests "open_log_file", "is_log_open" and "close_log_file" functions.
 */
void test_open_log_file(){
    printf("Testing \"open_log_file\", \"is_log_open\" and \"close_log_file\" functions.\n");

    char log_directory[256];

    strcpy(log_directory, LOG_ROOT_DIRECTORY);
    strcat(log_directory, "test_open_log_file/");

    struct stat stat_struct = {0};

    if ( stat(log_directory, &stat_struct) == -1 ) {
        printf("Directory \"%s\" does not exist.\n", log_directory);
        if ( mkdir(log_directory, 0700) == 0 ) {
            printf("Directory \"%s\" created.\n", log_directory);
        } else {
            printf("Could not create directory \"%s\".\n", log_directory);
            return;
        }
    }

    printf("Log directory is \"%s\".\n", get_log_directory());
    printf("Log file name: \"%s\".\n", get_log_file_name());
    printf("Log file path: \"%s\".\n", get_log_file_path());

    set_log_directory(log_directory);
    if ( is_log_open() == true ) {
        printf("Log file is open.\n");
    }
    else {
        printf("Log file is closed.\n");
    }

    if ( open_log_file("test_open_log_file") == 0 ) {
        printf("Opened a new log file.\n");
    }
    else {
        printf("Could not create log file.\n");
    }

    if ( is_log_open() == true ) {
        printf("Log file is open.\n");
    } else {
        printf("Log file is closed.\n");
    }

    printf("Log directory is \"%s\".\n", get_log_directory());
    printf("Log file name: \"%s\".\n", get_log_file_name());
    printf("Log file path: \"%s\".\n", get_log_file_path());

    if ( open_log_file("invalid_test_open_log_file") == 0 ) {
        printf("New log file opened.\n");
    }
    else {
        printf("Could not create a new log file.\n");
    }

    if ( close_log_file() == 0 ) {
        printf("Log file closed.\n");
    }
    else {
        printf("Error closing log file.\n");
    }

    if ( is_log_open() == true ) {
        printf("Log file is open.\n");
    } else {
        printf("Log file is closed.\n");
    }

    printf("Test of functions \"open_log_file\", \"is_log_open\" and \"close_log_file\" concluded.\n\n");
}

/*
 * Tests "write_log_message" function.
 */
void test_write_log_message() {
    printf("Testing \"write_log_message\" function and \"LOG\" and \"TRACE\" macros.\n");

    char log_directory[256];
    char* function_name = "test_write_log_message";

    strcpy(log_directory, LOG_ROOT_DIRECTORY);
    strcat(log_directory, function_name);
    strcat(log_directory, "/");
    struct stat stat_struct = {0};

    if ( stat(log_directory, &stat_struct) == -1 ) {
        printf("Directory \"%s\" does not exist.\n", log_directory);
        if ( mkdir(log_directory, 0700) == 0 ) {
            printf("Directory \"%s\" created.\n", log_directory);
        } else {
            printf("Could not create directory \"%s\".\n", log_directory);
            return;
        }
    }

    write_log_message(LOG_MESSAGE_TYPE_TRACE, function_name, 1, "This trace message should be written on console."); 
    write_log_message(LOG_MESSAGE_TYPE_WARNING, function_name, 2, "This warning message should be written on console."); 
    write_log_message(LOG_MESSAGE_TYPE_ERROR, function_name, 3, "This error message should be written on console."); 
    LOG_TRACE("This trace message was written through \"TRACE\" macro.");
    LOG_TRACE_POINT;

    set_log_directory(log_directory);

    if (open_log_file(function_name) == 0 ) {
        printf("Log file opened.\n");
        }
    else {
        printf("Error opening log file.\n");
    }

    printf("Log directory is \"%s\".\n", get_log_directory());
    printf("Log file name: \"%s\".\n", get_log_file_name());
    printf("Log file path: \"%s\".\n", get_log_file_path());

    write_log_message(LOG_MESSAGE_TYPE_TRACE, function_name, 4, "This trace message should be written on log file."); 
    write_log_message(LOG_MESSAGE_TYPE_WARNING, function_name, 5, "This warning message should be written on log file."); 
    write_log_message(LOG_MESSAGE_TYPE_ERROR, function_name, 6, "This error message should be written on log file.");

    LOG_TRACE("This message was written through \"TRACE\" macro.");
    LOG_TRACE_POINT;

    if ( close_log_file() == 0 ) {
        printf("Log file closed.\n");
    }
    else {
        printf("Error closing log file.\n");
    }

    if ( is_log_open() == true ) {
        printf("Log file is open.\n");
    } else {
        printf("Log file is closed.\n");
    }

    printf("Test of function \"write_log_message\" and \"LOG\" and \"TRACE\" macros concluded.\n\n");
}
