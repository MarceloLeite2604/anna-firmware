/*
 * The objetive of this source file is to test all log functions. 
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */
#include <stdio.h>
#include <stdlib.h>
#include "log/log.h"

int main(int argc, char** argv){

    /*
    char* log_directory = get_log_directory();

    printf ("Current log directory is \"%s\".\n", log_directory);

    if ( is_log_open() == 1 ) {
        printf("Log file is open.\n");
    }
    else {
        printf("Log file is closed.\n");
    }
    */

    printf("Current log directory is \"%s\".\n", get_log_directory());

    set_log_directory("/home/marcello");

    printf("New log directory is \"%s\".\n", get_log_directory());

    printf("Current time is: %s.\n", get_current_time());

    char log_message[128];

    sprintf(log_message, "teste");

    format_log_message(log_message, 128, LOG_MESSAGE_TYPE_TRACE, "main", 1, "test");

    printf("%s\n", log_message);

    return 0;
}
