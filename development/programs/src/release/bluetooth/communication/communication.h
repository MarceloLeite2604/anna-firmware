/*
 * This header file contains all components required to control the bluetooh communication.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */
#ifndef BLUETOOTH_COMMUNICATION_H
#define BLUETOOTH_COMMUNICATION_H

/*
 * Includes.
 */
#include "../package/package.h"
#include "../connection/connection.h"

/*
 * Function headers.
 */

/* Checks if a device is connected. */
int check_connection(int);

/* Receives a confirmation package. */
int receive_confirmation(int, package_t);

/* Sends a confirmation package. */
int send_confirmation(int, package_t);

/* Sends a file chunk. */
int send_file_chunk(int, size_t, uint8_t*);

/* Sends a file header. */
int send_file_header(int, const char*, size_t);

/* Sends a file trailer. */
int send_file_trailer(int);

/* Sends a package through a connection. */
int send_package(int, package_t);

/* Transmits a command result. */
int transmit_command_result(int, int);

/* Transmits an error. */
int transmit_error(int, int, const char*);

/* Checks if a device os connected. */
/* int is_connected(int); */

#endif
