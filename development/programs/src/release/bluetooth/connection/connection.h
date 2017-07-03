/*
 * This header file contains the declaration of all components required to manipulate the bluetooth connection.
 *
 * Version:
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef BLUETOOTH_CONNECTION_H
#define BLUETOOTH_CONNECTION_H


/*
 * Includes.
 */
#include <stdbool.h>
#include <sys/time.h>

#include "../../general/byte_array/byte_array.h"


/*
 * Macros.
 */

/* Code returned when there is not content to be read on socket. */
#define NO_CONTENT_TO_READ 50

/* Code returned when the socket has content to read. */
#define CONTENT_TO_READ 51


/*
 * Function headers.
 */

/* Closes socket communication. */
int close_socket(int);

/* Checks if there is content to be read on a socket. */
int check_socket_content(int, struct timeval);

/* Reads content from the socket. */
int read_socket_content(int, byte_array_t*);

/* Writes content on socket. */
int write_content_on_socket(int, byte_array_t);

#endif
