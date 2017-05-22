/*
 * This header file contains all components required to create a bluetooth service.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */
#ifndef BLUETOOTH_SERVICE_H
#define BLUETOOTH_SERVICE_H

/*
 * Includes.
 */
#include <stdbool.h>

/*
 * Definitions.
 */

/* Code used to indicate that a connection to a remote device was stablished. */
#define CONNECTION_STABLISHED 50

/* Code used to indicate that no connection attempt was realized. */
#define NO_CONNECTION 51


/*
 * Function headers.
 */

/* Checks if there is a bluetooth connection attempt. */
int check_connection_attempt(int*);

/* Checks is bluetooth service is registered. */
bool is_bluetooth_service_registered();

/* Registers the bluetooth service. */
int register_bluetooth_service();

/* Unregisters the bluetooth service. */
int unregister_bluetooth_service();

#endif
