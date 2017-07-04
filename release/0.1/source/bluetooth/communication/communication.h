/*
 * This header file contains the declaration of all components required to control the bluetooh communication.
 *
 * Version: 
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

#ifndef BLUETOOTH_COMMUNICATION_H
#define BLUETOOTH_COMMUNICATION_H


/*
 * Includes.
 */

#include <time.h>

#include "../connection/connection.h"
#include "../package/package.h"

/*
 * Macros.
 */

/* Code returned when no package was received. */
#define NO_PACKAGE_RECEIVED 50


/*
 * Function headers.
 */

/* Checks if a device is connected. */
int check_connection(int);

/* Receives a package from a connection. */
int receive_package(int, package_t*);

/* Sends a disconnect signal through a connection. */
int send_disconnect_signal(int);

/* Sends a file through a connection. */
int send_file(int, char*);

/* Sends a package through a connection. */
int send_package(int, package_t);

/* Transmits a command result. */
int transmit_command_result(int, int, struct timeval);

/* Transmits an error. */
int transmit_error(int, int, const char*);

#endif
