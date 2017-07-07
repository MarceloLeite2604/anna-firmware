/*
 * This header file contains the declaration of all package content codes comprehended by the program.
 *
 * Version:
 *  0.1
 *
 * Author:
 *  Marcelo Leite
 */

#ifndef PACKAGE_CONTENT_CODES_H
#define PACKAGE_CONTENT_CODES_H


/*
 * Macros.
 */

/* Code used on package contents to indicates it has a chunk o file. */
#define SEND_FILE_CHUNK_CONTENT_CODE 0x90e3ec43

/* Code used on package contents to indicates it has a file header. */
#define SEND_FILE_HEADER_CONTENT_CODE 0x674eb247

/* Code used on package contents to indicates it has a file trailer. */
#define SEND_FILE_TRAILER_CONTENT_CODE 0xfa618007

#endif
