/*
 * This header file contains all commands comprehended by the program.
 */

/* Raspbian in little-ended, so the byte commands are inverted. */
#define START_RECORD 0x06735705
#define STOP_RECORD  0x7404fb27 
#define SEND_AUDIO_DATA 0xb67b13d7
#define AUDIO_DATA_RECEIVED 0x31a2a82f
#define SEND_AUDIO_INFO 0xeeb83562
#define AUDIO_INFO_RECEIVED 0xb21fefdd
#define STATUS_RECORDING 0xb73a0172
#define STATUS_IDLE 0x977b3cce
#define SEND_STATUS 0x4154dfbd
#define EXECUTION_SUCCESS 0xff729929
#define EXECUTION_FAILURE 0xc9bcf130
#define RESET_DEVICE 0x34952bbf
#define SHUTDOWN_DEVICE 0xd45008e6

void copy_command(char* buffer, int command);
