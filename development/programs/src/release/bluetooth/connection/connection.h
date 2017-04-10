/*
 * This header file contains all components required to manipulate the bluetooth connection.
 *
 * Version: 0.1
 * Author: Marcelo Leite
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
 * Function headers.
 */

/* Closes socket communication. */
int close_socket(int);

/* Checks if there is content to be read on a socket. */
int check_socket_content(int, struct timeval);

/* Disconnects from device. */
int disconnect(int);

/* Reads content from the socket. */
byte_array_t read_socket_content(int);

/* Writes content on socket. */
int write_content_on_socket(int, byte_array_t);

#endif
