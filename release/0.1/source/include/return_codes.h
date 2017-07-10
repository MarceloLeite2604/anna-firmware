/*
 * This header file contains all general return codes used by functions.
 * 
 * Version:
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef RETURN_CODES_H
#define RETURN_CODES_H


/*
 * Macros.
 */

/* Code used when a function was executed successfully. */
#define SUCCESS 0

/* Code used when an generic error occurred. */
#define GENERIC_ERROR 1

/* Request the program to restart. */
#define RESTART_PROGRAM_CODE 90

/* Request the audio recorder to restart. */
#define RESTART_AUDIO_RECORDER_CODE 91

/* Request to shut down the audio recorder. */
#define SHUT_DOWN_AUDIO_RECORDER_CODE 92


#endif
