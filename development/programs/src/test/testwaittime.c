/*
 * The objetive of this source file is to test all wait time functions. 
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */

#include <stdio.h>

#include "log.h"
#include "wait_time.h"

/*
 * Definitions.
 */
#define LOG_ROOT_DIRECTORY "../resources/tests/general/wait_time/"

/*
 * Function headers.
 */
void test_wait_time();
void print_retry_informations(retry_informations_t);


/*
 * Function elaborations.
 */

/*
 * Main function.
 */
int main(int argc, char** argv){

    test_wait_time();
    return 0;
}


/*
 * Tests "create_retry_informations" and "wait_time" functions.
 */
void test_wait_time(){
    printf("Testing \"create_retry_informations\" and  \"wait_time\" functions.\n");

    char log_directory[256];
    
    strcpy(log_directory, LOG_ROOT_DIRECTORY);
    /* strcat(log_directory, "test_packages/"); */
    
    set_log_directory(log_directory);
    
    open_log_file("test_wait_time");

    retry_informations_t retry_informations = create_retry_informations(1000);
    print_retry_informations(retry_informations);


    int finished = 0;
    while (finished == 0 ) {
        finished = wait_time(&retry_informations);
        printf(".");
        fflush(stdout);
    }
    printf("\nDone.\n");

    close_log_file();

    printf("Test of functions \"create_retry_informations\" and  \"wait_time\" concluded.\n\n");
}

void print_retry_informations(retry_informations_t retry_informations) {
    printf("Retry informations:\n");
    printf("\tmaximum: %d\n", retry_informations.maximum);
    printf("\tattempts: %d\n\n", retry_informations.attempts);
}
