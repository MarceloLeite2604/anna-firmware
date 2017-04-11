/*
 * This source file contains all functions required to start and stop audio record.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdio.h>
#include <stdlib.h>
#include "../log/log.h"
#include "../script/script.h"


/*
 * Definitions.
 */

/* Script name to start audio record. */
#define START_AUDIO_RECORD_SCRIPT_NAME "start_record.sh"

/* Script name to stop audio record. */
#define STOP_AUDIO_RECORD_SCRIPT_NAME "stop_record.sh"

/* Script name to check if device is recording. */
#define CHECK_DEVICE_IS_RECORDING_SCRIPT_NAME "is_recording.sh"

/* Script name to kill record processes. */
#define KILL_AUDIO_RECORD_PROCESSES_SCRIPT_NAME "kill_record_processes.sh"


/*
 * Function elaborations.
 */

/*
 * Checks if device is recording.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  0. If device is recording.
 *  1. Otherwise.
 */
int is_recording() {
    LOG_TRACE_POINT;
    int script_result = execute_script(CHECK_DEVICE_IS_RECORDING_SCRIPT_NAME);

    return script_result;
}

/*
 * Starts audio record.
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  0. If audio record was started successfully.
 *  1. Otherwise.
 */
int start_audio_record(){
    int script_result = execute_script(START_AUDIO_RECORD_SCRIPT_NAME);

    if ( script_result != 0 ){
        LOG_ERROR("Error executing start record script. Execution returned: %d.", script_result);
        return 1;
    }

    return script_result;
}

/*
 * Stops audio record.
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  0. If audio record was started successfully.
 *  1. Otherwise.
 */
int stop_audio_record(){
    int script_result = execute_script(STOP_AUDIO_RECORD_SCRIPT_NAME);

    if ( script_result != 0 ){
        LOG_ERROR("Error executing stop record script. Execution returned: %d.", script_result);
        return 1;
    }

    return script_result;
}
