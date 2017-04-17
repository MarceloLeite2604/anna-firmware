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
#include "../../general/return_codes.h"
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
 *  SUCCESS - If the communication was closed successfully.
 *  GENERIC ERROR - Otherwise.
 */
int close_socket(int socket_fd){
    LOG_TRACE_POINT;

    int result;
    int close_result;
    close_result = close(socket_fd);

    if (close_result < 0 ) {
        LOG_ERROR("Error while closing socket.");
        LOG_ERROR("%s", strerror(errno));
        result = GENERIC_ERROR;
    }
    else {
        LOG_TRACE_POINT;
        result = SUCCESS;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Checks if there is content to be read on a socket.
 *
 * Parameters
 *  socket_fd - The socket communication file descriptor to be checked.
 *  check_time - Time to wait for a content to be avilable on socket.
 *
 * Returns
 *  NO_CONTENT_TO_READ - If there is no content to be read.
 *  CONTENT_TO_READ - If the socket has content to read.
 *  GENERIC_ERROR - If there was an error checking the socket content.
 */
int check_socket_content(int socket_fd, struct timeval check_time) {
    LOG_TRACE_POINT;

    int result;
    int select_result;
    fd_set socket_fd_set;

    FD_ZERO(&socket_fd_set);
    FD_SET(socket_fd, &socket_fd_set);
    select_result = select((socket_fd+1), &socket_fd_set, (fd_set*)NULL, (fd_set*)NULL, &check_time);
    FD_CLR(socket_fd, &socket_fd_set);

    switch (select_result) {
        case 0:
            LOG_TRACE("No content on socket.");
            result = NO_CONTENT_TO_READ;
            break;
        case -1:
            LOG_ERROR("Error while checking socket.");
            result = GENERIC_ERROR;
            break;
        default:
            LOG_TRACE("Found content on socket.");
            result = CONTENT_TO_READ;
            break;
    }

    LOG_TRACE_POINT;
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

    struct timeval read_wait_time = _read_wait_time;
    int select_result;
    uint8_t buffer[READ_CONTENT_BUFFER_SIZE];
    ssize_t content_size;
    byte_array_t result_byte_array = { .size = 0, .data = NULL };
    bool concluded = false;
    bool error = false;

    while (concluded == false) {
        LOG_TRACE("Total read: %zu.", result_byte_array.size);

        select_result = check_socket_content(socket_fd, read_wait_time);
        LOG_TRACE_POINT;

        switch (select_result) {
            case NO_CONTENT_TO_READ:
                LOG_TRACE("No content to be read on socket.");
                concluded = true;
                break;
            case GENERIC_ERROR:
                LOG_ERROR("Error while waiting for a content to read on socket.");
                concluded = true;
                error = true;
                break;
            case CONTENT_TO_READ:
                content_size = read(socket_fd, buffer, READ_CONTENT_BUFFER_SIZE);
                LOG_TRACE("Content size: %zu.", content_size);

                if ( content_size < 0 ) {
                    LOG_ERROR("Error while reading content from socket.");
                    concluded = true;
                    error = true;
                } else {
                    LOG_TRACE_POINT;
                    if ( result_byte_array.size == 0 ) {
                        LOG_TRACE_POINT;

                        result_byte_array.data = (uint8_t*)malloc(content_size);
                        if ( result_byte_array.data == NULL ) {
                            LOG_ERROR("Error while reading content from socket.");
                            LOG_ERROR("Could not allocate %zu bytes to store content read.", content_size);
                            concluded = true;
                            error = true;
                        }
                        memcpy(result_byte_array.data, buffer, content_size);
                    } else {
                        LOG_TRACE_POINT;
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
            default:
                LOG_ERROR("Unkown return code from \"check_socket_content\" function.");
                concluded = true;
                error = true;
                break;
        }
    }

    if ( error == true ) {
        LOG_TRACE_POINT;
        result_byte_array.size = 0;
        free(result_byte_array.data);
    }

    LOG_TRACE_POINT;
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
 *  SUCCESS - If content was written successfully.
 *  GENERIC ERROR - Otherwise.
 */
int write_content_on_socket(int socket_fd, byte_array_t byte_array) {
    LOG_TRACE_POINT;

    size_t write_result;
    size_t total_written = 0;
    bool concluded = false;
    int errno_value;
    int result = SUCCESS;

    while (concluded == false ) {
        LOG_TRACE_POINT;

        write_result = write(socket_fd, byte_array.data, byte_array.size);
        switch (write_result) {
            case -1:
                errno_value = errno;
                LOG_ERROR("Error while writing content on socket.");
                LOG_ERROR("%s", strerror(errno_value));
                result = GENERIC_ERROR;
                concluded = true;
                break;
            case 0:
                LOG_TRACE_POINT;
                if ( byte_array.size != 0 ) {
                    LOG_ERROR("The content was not written on socket.");
                    result = GENERIC_ERROR;
                    concluded = true;
                }
                break;
            default:
                LOG_TRACE("%zu byte(s) written on socket.", write_result);
                break;
        }

        total_written += write_result;
        LOG_TRACE("%zu of %zu byte(s) written on socket.", total_written, byte_array.size);
        if ( total_written >= byte_array.size ) {
            LOG_TRACE_POINT;
            concluded = true;
            result = SUCCESS;
        }
    }

    LOG_TRACE_POINT;
    return result;
}
