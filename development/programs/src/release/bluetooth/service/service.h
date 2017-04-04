/*
 * This header file contains all components required to create a bluetooth service.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdbool.h>


/*
 * Function headers.
 */

/* Checks if there is a bluetooth connection attempt. */
int check_connection_attempt();

/* Checks is bluetooth service is registered. */
bool is_bluetooth_service_registered();

/* Registers the bluetooth service. */
int register_bluetooth_service();

/* Unregisters the bluetooth service. */
int unregister_bluetooth_service();
