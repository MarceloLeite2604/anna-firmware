/*
 * This source file contains all component elaborations to manipulate bluetooth connection.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <errno.h>
#include <sys/time.h>
#include <stdlib.h>
#include <unistd.h>
#include "connection.h"

/*
 * Definitions.
 */

/* Size of the buffer to read content from the socket. */
#define READ_CONTENT_BUFFER_SIZE 1024

/*
 * Variables.
 */

/* Time to wait for a content to be read on socket. */
const struct timeval _read_wait_time = { .tv_sec = 0, .tv_usec = 0 };


/*
 * Function elaborations.
 */

/*
 * Closes a socket communication.
 *
 * Parameters
 *  socket_fd - The socket communication file descriptor to be closed.
 *
 * Returns
 *  0. If the communication was closed successfully.
 *  1. Otherwise.
 */
int close_socket(int socket_fd){
    int result;
    result = close(socket_fd);

    if (result < 0 ) {
        LOG_ERROR("Error while closing socket.");
        LOG_ERROR("%s", strerror(errno));
    }
    return result;
}

/*
 * Checks if there is content to be read on a socket.
 *
 * Parameters
 *  socket_fd - The socket communication file descriptor to be checked.
 *
 * Returns
 *  True if there is content to be read.
 *  False otherwise.
 */
int check_socket_content(int socket_fd) {
    int result;
    fd_set socket_fd_set;
    struct timeval read_wait_time = _read_wait_time;

    FD_ZERO(&socket_fd_set);
    FD_SET(socket_fd, &socket_fd_set);
    result = select((socket_fd+1), &socket_fd_set, (fd_set*)NULL, (fd_set*)NULL, &read_wait_time);
    FD_CLR(socket_fd, &socket_fd_set);

    switch (result) {
        case 0:
            LOG_TRACE("No content on socket.");
            break;
        case -1:
            LOG_ERROR("Error while checking socket.");
            break;
        default:
            LOG_TRACE("Found content on socket.");
            break;
    }

    return result;
}

/*
 * Reads content from the socket.
 *
 * Parameters
 *  socket_fd - The socket communication file descriptor to read content.
 *
 * Returns
 *  The content read from the socket.
 */
byte_array_t read_socket_content(int socket_fd) {
    LOG_TRACE("Socket file descriptor: %d", socket_fd);

    int select_result;
    uint8_t buffer[READ_CONTENT_BUFFER_SIZE];
    ssize_t content_size;
    byte_array_t result_byte_array = { .size = 0, .data = NULL };
    bool concluded = false;
    bool error = false;

    while (concluded == false) {
        LOG_TRACE("Total read: %zu.", result_byte_array.size);

        select_result = check_socket_content(socket_fd);
        LOG_TRACE_POINT;

        switch (select_result) {
            case 0:
                LOG_TRACE("No content to be read on socket.");
                concluded = true;
                break;
            case -1:
                LOG_ERROR("Error while waiting for a content to read on socket.");
                concluded = true;
                error = true;
                break;
            default:
                content_size = read(socket_fd, buffer, READ_CONTENT_BUFFER_SIZE);
                LOG_TRACE("Content size: %zu.", content_size);

                if ( content_size < 0 ) {
                    LOG_ERROR("Error while reading content from socket.");
                    concluded = true;
                    error = true;
                } else {
                    if ( result_byte_array.size == 0 ) {
                        result_byte_array.data = (uint8_t*)malloc(content_size);
                        if ( result_byte_array.data == NULL ) {
                            LOG_ERROR("Error while reading content from socket.");
                            LOG_ERROR("Could not allocate %zu bytes to store content read.", content_size);
                            concluded = true;
                            error = true;
                        }
                        memcpy(result_byte_array.data, buffer, content_size);
                    } else {
                        result_byte_array.data = (uint8_t*)realloc(result_byte_array.data, result_byte_array.size + content_size);
                        if ( result_byte_array.data == NULL ) {
                            LOG_ERROR("Error while reading content from socket.");
                            LOG_ERROR("Could not reallocate result byte array to add %zu bytes (currently using %zu bytes).", content_size, result_byte_array.size);
                            concluded = true;
                            error = true;
                        }
                        memcpy((result_byte_array.data+result_byte_array.size), buffer, content_size);
                    }
                }
                break;
        }

    }

    if ( error == true ) {
        result_byte_array.size = 0;
        free(result_byte_array.data);
    }

    return result_byte_array;
}

/*
 * Writes content on socket.
 *
 * Parameters
 *  socket_fd    - The socket communication file descritptor to write content.
 *  byte_array_t - The byte array content to be written on socket.
 *
 * Returns
 *  0. If content was written successfully.
 *  1. Otherwise.
 */
int write_content_on_socket(int socket_fd, byte_array_t byte_array) {
    /* TODO: Elaborate. */
}
