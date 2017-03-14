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
#include "../release/audio/audio.h"

/*
 * Function headers.
 */
void test_start_stop_audio_record();


/*
 * Function elaborations.
 */

/*
 * Main function.
 */
int main(int argc, char** argv){

    test_start_stop_audio_record();
    return 0;
}


/*
 * Tests "start_audio_record" and "stop_audio_record" functions.
 */
void test_start_stop_audio_record(){
    printf("Testing \"start_audio_record\" and \"stop_audio_record\" functions.\n");

    start_audio_record();
    sleep(2);
    stop_audio_record();


    printf("Test of functions \"start_audio_record\" and \"stop_audio_record\" concluded.\n\n");
}
