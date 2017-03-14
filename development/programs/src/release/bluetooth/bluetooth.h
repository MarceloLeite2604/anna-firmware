/*
 * This header file contains all function declarations to stabilish bluetooth services and communicate with remote devices through it.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdint.h>
#include <stdbool.h>


/*
 * Structures.
 */

/*
 *  Stores the information of a bluetooth service.
 */
typedef struct {
    uint32_t uuid[4];
    char* name;
    char* description;
    char* provider;
} bluetooth_service_infos_t;


/*
 * Functions.
 */

/*
 * Register a new service on bluetooth service provider.
 */
int register_service(bluetooth_service_infos_t bluetooth_service_infos);

/*
 * Indicates if there is a bluetooth service registered.
 */
bool is_bluetooth_service_registered();

/*
 * Removes the service from bluetooth service provider.
 */
int remove_service();

/*
 * Accepts a connection from service.
 */
int accept_connection(struct timeval timeout);
