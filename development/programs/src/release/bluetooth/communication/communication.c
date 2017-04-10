/*
 * This source file contains all component elaborations required to control the bluetooth communication.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include "../../general/wait_time/wait_time.h"
#include "../package/codes/codes.h"
#include "communication.h"


/*
 * Definitions.
 */
#define MAXIMUM_WRITE_ATTEMPTS 30
#define MAXIMUM_READ_ATTEMPTS 30

/*
 * Function elaborations.
 */

/*
 * Checks if a device is connected.
 *
 * Parameters
 *  socket_fd - The device's connection socket file descriptor.
 *
 * Returns
 *  0. If the device responded the connection check.
 *  1. If the device did not respond the connection check or there was an error while chekcing connection.
 */
int check_connection(int socket_fd) {
    LOG_TRACE_POINT;

    package_t check_connection_package;
    byte_array_t check_connection_package_byte_array;

    check_connection_package = create_check_connection_package();

    send_package(socket_fd, check_connection_package);

}

/*
 * Receives a confirmation pacakge.
 *
 * Parameters
 *  socket_fd - The connection socket file descriptor to receive the confirmation.
 *  package   - The package awaiting to be confirmed.
 *
 * Returns
 *  0. If the confirmation package was received successfully.
 *  1. Otherwise.
 */
int receive_confirmation(int socket_fd, package_t package) {
    LOG_TRACE_POINT;

    bool read_concluded = false;
    byte_array_t byte_array_readed;
    retry_informations_t retry_informations;
    package_t package_received;
    int wait_result;
    int result;

    retry_informations = create_retry_informations(MAXIMUM_READ_ATTEMPTS);

    while ( read_concluded == false ) {
        byte_array_readed = read_socket_content(socket_fd);

        if ( byte_array_readed.size > 0 ) {
            /* package_received = create_package_from_byte_array(byte_array); */
            if ( package_received.type_code == CONFIRMATION_CODE ) {
                if ( package_received.content.confirmation_content->package_id == package.id ) {
                    read_concluded = true;
                    result = 0;
                }
            }
        }

        if ( read_concluded == false ) {
            wait_result = wait_time(&retry_informations);
            switch (wait_result) {
                case -1:
                    LOG_ERROR("Error while waiting to read the package confirmation from connection.");
                    read_concluded = true;
                    result = 1;
                    break;
                case 1:
                    LOG_ERROR("Maximum read attempts reached.");
                    read_concluded = true;
                    result = 1;
                    break;
                default:
                    break;
            }
        }
    }

    return result;
}

/*
 * Sends a package through a connection.
 *
 * Parameters
 *  socket_fd - The connection socket file descriptor to send the package.
 *  package   - The package to be sent.
 *
 *  Returns
 *   0. If the package was sent successfuly.
 *   1. Otherwise.
 */
int send_package(int socket_fd, package_t package) {
    int result = 1;
    int write_result;
    int wait_result;
    int receive_confirmation_result;
    int convertion_result;
    bool write_concluded = false;
    retry_informations_t retry_informations;
    byte_array_t package_byte_array;

    retry_informations = create_retry_informations(MAXIMUM_WRITE_ATTEMPTS);
    convertion_result = convert_package_to_byte_array(&package_byte_array, package);

    if ( convertion_result == -1 ) {
        /* TODO: Elaborate. */
    }

    while (write_concluded == false ) {

        write_result = write_content_on_socket(socket_fd, package_byte_array);

        if ( write_result == 0 ) {
            
            receive_confirmation_result = receive_confirmation(socket_fd, package);
            if ( receive_confirmation_result == 0 ) {
                LOG_TRACE_POINT;
                write_concluded = true;
                result = 0;
            }
            else {
                LOG_ERROR("Did not receive confirmation o package id 0x%x.", package.id);
                write_concluded = true;
                result = 1;
            }
        } else {
            wait_result = wait_time(&retry_informations);
            switch (wait_result) {
                case -1:
                    LOG_ERROR("Error while waiting to retry writing package.");
                    write_concluded = true;
                    result = 1;
                    break;
                case 1:
                    LOG_ERROR("Maximum write attempts reached.");
                    write_concluded = true;
                    result = 1;
                    break;
                default:
                    break;

            }
        }
    }

    return result;
}

