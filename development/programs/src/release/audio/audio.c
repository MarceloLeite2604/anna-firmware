/*
 * This source file contains all functions required to start and stop audio record.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include "../general/return_codes.h"
#include "../log/log.h"
#include "../script/script.h"
#include "../directory/directory.h"
#include "../general/file/file.h"


/*
 * Definitions.
 */

/* Script name to start audio record. */
#define START_AUDIO_RECORD_SCRIPT_NAME "start_record.sh"

/* Script name to stop audio record. */
#define STOP_AUDIO_RECORD_SCRIPT_NAME "stop_record.sh"

/* Script name to check if device is recording. */
#define CHECK_DEVICE_IS_RECORDING_SCRIPT_NAME "is_recording.sh"

/* Script name to find the latest audio record file name. */
#define FIND_LATEST_AUDIO_RECORD_SCRIPT_NAME "find_latest_audio_record.sh"

/* Path to the audio directory */
#define AUDIO_DIRECTORY "audio/"

/* Name of the file where is stored the latest audio record file name. */
#define LATEST_AUDIO_RECORD_FILE_NAME_FILE "latest_audio_record"

/*
 * Function elaborations.
 */

/*
 * Returns the latest audio record file path.
 *
 * Parameters
 *  None
 *
 * Returns
 *  The path to the latest audio record file or NULL if there was an error.
 */
char* get_latest_audio_record(){
    char* output_directory;
    char* result = NULL;
    int script_result;
    char* larfn_file_path;
    int errno_value;
    int fclose_result;

    /* larfn: Latest audio record file name */
    size_t larfn_file_path_length;
    FILE* larfn_file;
    size_t larfn_content_size;
    char* larfn_content;
    size_t bytes_read;

    script_result = execute_script(FIND_LATEST_AUDIO_RECORD_SCRIPT_NAME);

    if ( script_result == SUCCESS ) {
        output_directory = get_output_directory();
        larfn_file_path_length = strlen(output_directory);
        larfn_file_path_length += strlen(AUDIO_DIRECTORY);
        larfn_file_path_length += strlen(LATEST_AUDIO_RECORD_FILE_NAME_FILE);
        larfn_file_path_length += 1;

        larfn_file_path = (char*)malloc(larfn_file_path_length*sizeof(char));
        strcpy(larfn_file_path, output_directory);
        strcat(larfn_file_path, AUDIO_DIRECTORY);
        strcat(larfn_file_path, LATEST_AUDIO_RECORD_FILE_NAME_FILE);
        LOG_TRACE("Latest audio record file name file path: \"%s\"", larfn_file_path);

        larfn_file = fopen(larfn_file_path, "r");

        if ( larfn_file == NULL ) {
            errno_value = errno;
            LOG_ERROR("Could not open file \"%s\".", larfn_file_path);
            LOG_ERROR("%s", strerror(errno_value));
            result = NULL;
        }
        else {
            larfn_content_size = get_file_size(larfn_file_path);
            larfn_content = (char*)malloc((larfn_content_size+1)*sizeof(char));


            bytes_read = fread(larfn_content, sizeof(char), larfn_content_size, larfn_file);

            if ( ferror(larfn_file) != 0 ) {
                LOG_ERROR("Error while reading \"latest record audio file name\" file: \"%s\".", larfn_file_path);
                LOG_ERROR("%s", strerror(errno_value));
                free(larfn_content);
                result = NULL;
            }
            else {
                larfn_content[larfn_content_size] = 0;
                result = larfn_content;
            }
        }

        fclose_result = fclose(larfn_file);

        if ( fclose_result != 0 ) {
            errno_value = errno;
            LOG_ERROR("Error while closing file \"%s\".", larfn_file_path);
            LOG_ERROR("%s", strerror(errno_value));
            return NULL;
        }

        free(larfn_file_path);
        free(output_directory);
        /* TODO: Check if "fclose" finished successfully. */

    }

    return result;
}

/*
 * Checks if device is recording.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  SUCCESS - If device is recording.
 *  GENERIC ERROR - Otherwise.
 */
int is_recording() {
    LOG_TRACE_POINT;
    int result;
    int script_result = execute_script(CHECK_DEVICE_IS_RECORDING_SCRIPT_NAME);

    if (script_result == SUCCESS ) {
        result = SUCCESS;
    } else {
        result = GENERIC_ERROR;
    }

    return result;
}

/*
 * Starts audio record.
 *
 * Parameters:
 *  None.
 *
 * Returns:
 *  SUCCESS - If audio record was started successfully.
 *  GENERIC ERROR - Otherwise.
 */
int start_audio_record(){
    int script_result = execute_script(START_AUDIO_RECORD_SCRIPT_NAME);

    if ( script_result != SUCCESS ){
        LOG_ERROR("Error executing start record script. Execution returned: %d.", script_result);
        return GENERIC_ERROR;
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
 *  SUCCESS - If audio record was started successfully.
 *  GENERIC ERROR - Otherwise.
 */
int stop_audio_record(){
    int script_result = execute_script(STOP_AUDIO_RECORD_SCRIPT_NAME);

    if ( script_result != SUCCESS ){
        LOG_ERROR("Error executing stop record script. Execution returned: %d.", script_result);
        return GENERIC_ERROR;
    }

    return script_result;
}
