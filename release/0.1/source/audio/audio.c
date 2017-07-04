/*
 * This source file contains the elaboration of all components required to start and stop audio record.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

/*
 * Includes.
 */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "../directory/directory.h"
#include "../general/file/file.h"
#include "../general/return_codes.h"
#include "../log/log.h"
#include "../script/script.h"


/*
 * Macros.
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

/* File name which the start audio record instant is stored. */
#define START_AUDIO_RECORD_INSTANT_FILE_NAME "temporary/start_audio_instant"

/* File name which the stop audio record instant is stored. */
#define STOP_AUDIO_RECORD_INSTANT_FILE_NAME "temporary/stop_audio_instant"


/*
 * Function elaborations.
 */

/*
 * Returns the latest audio record file path.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  The path to the latest audio record file or NULL if there was an error.
 */
char* get_latest_audio_record(){
    LOG_TRACE_POINT;

    char* output_directory;
    char* result = NULL;
    size_t result_size;
    int script_result;
    char* larfn_file_path;
    int errno_value;
    int fclose_result;
    /* Observation: larfn - Latest audio record file name */
    size_t larfn_file_path_length;
    FILE* larfn_file;
    size_t larfn_content_size;
    char* larfn_content;
    size_t bytes_read;

    script_result = execute_script(FIND_LATEST_AUDIO_RECORD_SCRIPT_NAME);
    LOG_TRACE_POINT;

    if ( script_result == SUCCESS ) {
        LOG_TRACE_POINT;

        output_directory = get_output_directory();
        LOG_TRACE_POINT;

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
            LOG_TRACE_POINT;

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
                LOG_TRACE_POINT;

                larfn_content[bytes_read] = 0;
                result_size = strlen(output_directory);
                result_size += strlen(AUDIO_DIRECTORY);
                result_size += bytes_read;
                result_size += 1;

                result = (char*)malloc(result_size*sizeof(char));
                memset(result, 0, result_size);
                strcpy(result, output_directory);
                strcat(result, AUDIO_DIRECTORY);
                strcat(result, larfn_content);
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

    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Returns the path of the file which the start audio record instant is stored.
 * 
 * Parameters
 *  None.
 *
 * Result
 *  The path of the file which the start audio record instant is stored.
 */
char* get_start_audio_record_instant_file_path() {
    LOG_TRACE_POINT;

    char* result;
    size_t result_size;
    char* output_directory;

    output_directory = get_output_directory();
    LOG_TRACE_POINT;

    result_size = strlen(START_AUDIO_RECORD_INSTANT_FILE_NAME);
    result_size += strlen(output_directory);
    result_size += 1;

    result = malloc(result_size*sizeof(char));

    memset(result, 0, result_size*sizeof(char));
    strcpy(result, output_directory);
    strcat(result, START_AUDIO_RECORD_INSTANT_FILE_NAME);

    free(output_directory);

    LOG_TRACE_POINT;
    return result;
}

/*
 * Returns the path of the file which the stop audio record instant is stored.
 * 
 * Parameters
 *  None.
 *
 * Result
 *  The path of the file which the stop audio record instant is stored.
 */
char* get_stop_audio_record_instant_file_path() {
    LOG_TRACE_POINT;

    char* result;
    size_t result_size;
    char* output_directory;

    output_directory = get_output_directory();
    LOG_TRACE_POINT;

    result_size = strlen(STOP_AUDIO_RECORD_INSTANT_FILE_NAME);
    result_size += strlen(output_directory);
    result_size += 1;

    result = malloc(result_size*sizeof(char));

    memset(result, 0, result_size*sizeof(char));
    strcpy(result, output_directory);
    strcat(result, STOP_AUDIO_RECORD_INSTANT_FILE_NAME);

    free(output_directory);

    LOG_TRACE_POINT;
    return result;
}

/*
 * Checks if device is recording.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  True - If device is recording.
 *  False - If device is not recording.
 */
bool is_recording() {
    LOG_TRACE_POINT;

    int result;
    int script_result = execute_script(CHECK_DEVICE_IS_RECORDING_SCRIPT_NAME);

    LOG_TRACE_POINT;   
    return ( script_result == SUCCESS );
}

/*
 * Starts audio record.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  SUCCESS - If audio record was started successfully.
 *  GENERIC ERROR - Otherwise.
 */
int start_audio_record(){
    LOG_TRACE_POINT;

    int script_result;

    script_result = execute_script(START_AUDIO_RECORD_SCRIPT_NAME);
    LOG_TRACE_POINT;

    if ( script_result != SUCCESS ){
        LOG_ERROR("Error executing start record script. Execution returned: %d.", script_result);
        return GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return script_result;
}

/*
 * Stops audio record.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  SUCCESS - If audio record was started successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int stop_audio_record(){
    LOG_TRACE_POINT;

    int script_result;

    script_result = execute_script(STOP_AUDIO_RECORD_SCRIPT_NAME);
    LOG_TRACE_POINT;

    if ( script_result != SUCCESS ){
        LOG_ERROR("Error executing stop record script. Execution returned: %d.", script_result);
        return GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return script_result;
}
