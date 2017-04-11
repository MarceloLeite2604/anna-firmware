/*
 * This header file contains all functions requires to start and stop audio record.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

#ifndef AUDIO_H
#define AUDIO_H

/*
 * Checks if device is recording.
 */
bool is_recording();

/*
 * Kills the record program.
 */
int kill_record_program();

/*
 * Starts audio record.
 */
int start_audio_record();

/*
 * Stops audio record.
 */
int stop_audio_record();

#endif
