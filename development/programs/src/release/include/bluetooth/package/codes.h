/*
 * This header file contains the declaration of all package codes comprehended by the program.
 *
 * Version:
 *  0.1
 *
 * Author:
 *  Marcelo Leite
 */

#ifndef BLUETOOTH_PACKAGE_CODES_H
#define BLUETOOTH_PACKAGE_CODES_H


/*
 * Macros.
 */

/* Code to specify that a package is to check the connection. */
#define CHECK_CONNECTION_CODE 0xd12f48d4

/* Code to specify that a package is a confirmation of a previous package delivery. */
#define CONFIRMATION_CODE 0x4b1ee9ed

/* Code to specify that a package is returning a the result of a command. */
#define COMMAND_RESULT_CODE 0x984761f1

/* Code used on a package when a device is requesting to disconnect. */
#define DISCONNECT_CODE 0xb704fb8c

/* Code used on packages which stores error messages. */
#define ERROR_CODE 0x89c09f5a

/* Code used on packages when a remote device is requesting the latest audio recorded. */
#define REQUEST_AUDIO_FILE_CODE 0x42a27b9b

/* Code used on packages to inform it has a chunk of file. */
#define SEND_FILE_CHUNK_CODE 0x0f0f769f

/* Code used on packages to inform that a package header is being send. */
#define SEND_FILE_HEADER_CODE 0x34f966d4

/* Code used on packages to inform that a file transmission is over. */
#define SEND_FILE_TRAILER_CODE 0x8c61e11c

/* Code used on packages to request the device to start audio record. */
#define START_RECORD_CODE 0x11d2bb74

/* Code used on packages to request the device to stop audio record. */
#define STOP_RECORD_CODE 0xa1f6d1e5

/* Code used to specify the start position of a package. */
#define PACKAGE_HEADER 0xf0037142

/* Code used to specify the end position of a package. */
#define PACKAGE_TRAILER 0x9228c204

/*
 * Structures.
 */

/* Stores a package code value */
typedef union {
    int value;
    unsigned char data[4];
} package_code_t;

#endif
