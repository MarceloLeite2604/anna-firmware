/*
 * The objetive of this source file is to test all audio functions. 
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "../release/audio/audio.h"

/*
 * Function headers.
 */
void test_start_stop_audio_record();
void test_get_latest_audio_record();


/*
 * Function elaborations.
 */

/*
 * Main function.
 */
int main(int argc, char** argv){

    test_get_latest_audio_record();
    test_start_stop_audio_record();
    return 0;
}


/*
 * Tests "start_audio_record" and "stop_audio_record" functions.
 */
void test_start_stop_audio_record(){
    printf("Testing \"start_audio_record\" and \"stop_audio_record\" functions.\n");

    start_audio_record();
    sleep(1);
    stop_audio_record();


    printf("Test of functions \"start_audio_record\" and \"stop_audio_record\" concluded.\n\n");
}

/*
 * Tests "get_latest_audio_record" function.
 */
void test_get_latest_audio_record(){
    printf("Testing \"get_latest_audio_record\" function.\n");

    char* latest_audio_record_file_path;

    latest_audio_record_file_path = get_latest_audio_record();

    printf("Latest audio record file path: \"%s\".\n", latest_audio_record_file_path);

    free(latest_audio_record_file_path);

    printf("Test of function \"get_latest_audio_record\" concluded.\n\n");
}
