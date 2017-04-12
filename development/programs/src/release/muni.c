/*
 * This is the source file of the bluetooth communication program (a. k. a. Muni).
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include "bluetooth/service/service.h"
#include "bluetooth/package/package.h"
#include "bluetooth/package/codes/codes.h"
#include "log/log.h"


/*
 * Definitions.
 */
/* Preffix to identify the program log file. */
#define PROGRAM_LOG_FILE_PREFFIX "muni_program"

/* Preffix to identofy shell scripts log file. */
#define SCRIPT_LOG_FILE_PREFFIX "muni_script"

/*
 * Function headers.
 */

/* Checks the bluetooth command received. */
int check_command_received(package_t);

/* Executes the device disconnection processes. */
int command_disconnect();

/* Starts audio record. */
int command_start_audio_record();

/* Stops audio record. */
int command_stop_audio_record();

/* Transmit latest audio recorded. */
int command_transmit_lastest_audio_record();

/* Finish both program and script logs. */
int finish_logs();

/* Processes to be done before finish the program. */
int finish_processes();

/* Program's main function. */
int main(int argc, char** argv);

/* Resets the device. */
int reset_device();

/* Shuts down the device. */
int shut_down_device();

/* Start both program and script logs. */
int start_logs();

/* Processes to be done before the program starts. */
int start_processes();

/* Stops the bluetooth service. */
/* TODO: Shouldn't this be on "bluetooth service" section? */
int stop_bluetooth_service();

/* Waits for a device to connect. */
int wait_connection();


/*
 * Function elaborations.
 */

/*
 * Checks the bluetooth command received.
 *
 * Parameters
 *  package - The package with the command received.
 *
 * Returns
 *  0. If command was checked successfully.
 *  1. Otherwise.
 */
int check_command_received(package_t package) {
    int result;
    int command_execution_result;

    switch (package.type_code) {
        case CHECK_CONNECTION_CODE:
            LOG_TRACE("Connection checked by device.");
            command_execution_result = 0;
            break;
        case CONFIRMATION_CODE:
        case COMMAND_RESULT_CODE:
        case ERROR_CODE:
        case SEND_FILE_CHUNK_CODE:
        case SEND_FILE_HEADER_CODE:
        case SEND_FILE_TRAILER_CODE:
            LOG_ERROR("Pacakage type recognized, but no action defined to be done: 0x%08x.", package.type_code);
            command_execution_result = 1;
            break;
        case DISCONNECT_CODE:
            command_execution_result = command_disconnect();
            break;
        case REQUEST_AUDIO_FILE_CODE:
            command_execution_result = command_transmit_last_record();
            break;
        case START_RECORD_CODE:
            command_execution_result = command_start_record();
            break;
        case STOP_RECORD_CODE:
            command_execution_result = command_stop_record();
            break;
        default:
            LOG_ERROR("Unrecognized package type: 0x%08x.", package.type_code);
            break;
    }

    if ( command_execution_result == 0 ) {
        result = 0;
    }
    else {
        result = 1;
    }

    return result;
}


/*
 * Finish both program and script logs.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  0. If logs were finished successfully.
 *  1. Otherwise.
 */
int finish_logs() {
    int close_log_file_result;
    int finish_shell_script_log_result;
    int result;

    close_log_file_result = close_log_file();
    if ( close_log_file_result == 0 ) {
        finish_shell_script_log_result = finish_shell_script_log();
        if ( finish_shell_script_log_result == 0 ) {
            result = 0;
        }
        else {
            result = 1;
        }
    }
    return result;
}

/*
 * Processes to be done before finish the program.
 *
 * Parameters
 *  None
 *
 * Returns
 *  0. If processes were done successfully.
 *  1. Otherwise.
 */
int finish_processes(){
    int result;
    int finish_logs_result;

    finish_logs_result = finish_logs();

    if ( finish_logs_result == 0 ) {
        result = 0;
    } else {
        result = 1;
    }

    return result;
}

/*
 * Starts both program and script logs.
 *
 * Parameters
 *  None
 *
 * Returns
 *  0. If logs started successfully.
 *  1. Otherwise.
 */
int start_logs() {
    int open_log_file_result;
    int start_shell_script_log_result;
    int result;

    open_log_file_result = open_log_file(PROGRAM_LOG_FILE_PREFFIX);
    if ( open_log_file_result == 0 ) {
        start_shell_script_log_result = start_shell_script_log(SCRIPT_LOG_FILE_PREFFIX, LOG_MESSAGE_TYPE_TRACE);
        if ( start_shell_script_log_result == 0 ) {
            result = 0;
        }
        else {
            result = 1;
        }
    }
    else {
        result = 1;
    }

    return result;
}

/*
 * Processes to be done before the program starts.
 *
 * Parameters
 *  None
 *
 * Returns
 *  0. If processes were done successfully.
 *  1. Otherwise.
 */
int start_processes(){
    int result;
    int start_logs_result;
    int register_bluetooth_service_result;

    start_logs_result = start_logs();

    if ( start_logs_result == 0 ) {

        register_bluetooth_service_result = register_bluetooth_service();
        if ( register_bluetooth_service_result == 0 ) {
            result = 0;
        } 
        else {
            result = 1;
        }
       
    } 
    else {
        result = 1;
    }

    return result;
}

/*
 * Main function.
 *
 * Parameters
 *  None applicable.
 *
 * Returns
 *  0. If the program finished successfully.
 *  1. If the program aborted it's execution due to an error.
 */
int main(int argc, char** argv){
    int start_processes_result;
    int finish_processes_result;

    start_processes_result = start_processes();
    if ( start_processes_result == 1 ) {
        return 1;
    }


    finish_processes_result = finish_processes();
    if ( finish_processes_result == 1 ) {
        return 1;
    }

    return 0;
}

/*
 * Waits for a device to connect.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  The socket connection file descriptor.
 */
int wait_connection() {
    /* TODO: Elaborate. */
}

