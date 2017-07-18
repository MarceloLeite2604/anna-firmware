/*
 * Source file of bluetooth communication program (a. k. a. Muni).
 *
 * Arguments:
 *  -l - Inform the log level which the program must be executed with. Current valid values are "TRACE", "WARNING" and "ERROR".
 *
 * Version:
 *  0.1
 *
 * Author: 
 *  Marcelo Leite
 */

/*
 * Includes.
 */

#include <stdlib.h>

#include "audio.h"
#include "bluetooth/service.h"
#include "bluetooth/communication.h"
#include "bluetooth/connection.h"
#include "bluetooth/package/codes.h"
#include "bluetooth/package/package.h"
#include "instant.h"
#include "log.h"
#include "parameters.h"
#include "return_codes.h"


/*
 * Macros.
 */

/* Code used to indicate the remote device was/has disconnected. */
#define DEVICE_DISCONNECTED 93

/* Maximum errors tolerated by the program while receiving packages from a remote device. */
#define MAX_RECEIVE_PACKAGE_ERRORS_TOLERATED 5

/* Preffix to identify the program log file. */
#define PROGRAM_LOG_FILE_PREFFIX "muni_program"

/* Preffix to identofy shell scripts log file. */
#define SCRIPT_LOG_FILE_PREFFIX "muni_script"

/*
 * Function headers.
 */

/* Checks a single program argument. */
int check_argument(char*, char*);

/* Checks the program argument "log". */
int check_argument_log(char*);

/* Checks the program arguments. */
int check_arguments(int, char**);

/* Checks the bluetooth command received. */
int check_command_received(int, package_t);

/* Executes the device disconnection processes. */
int command_disconnect(int);

/* Starts audio recording. */
int command_start_audio_record(int);

/* Stops audio recording. */
int command_stop_audio_record(int);

/* Transmits the latest audio recorded. */
int command_transmit_latest_audio_record(int);

/* Finish both program and script logs. */
int finish_logs();

/* Processes to be done before finishing the program. */
int finish_processes();

/* Program's main function. */
int main(int argc, char** argv);

/* Loop to control the program execution. */
int program_execution_loop();

/* Loop to control the remote device communication. */
int remote_device_communication_loop(int);

/* Start both program and script logs. */
int start_logs();

/* Processes to be done before the program starts. */
int start_processes();

/* Waits for a device to connect. */
int wait_connection(int*);


/*
 * Function elaborations.
 */

/*
 * Checks a single program argument.
 *
 * Parameters
 *  argument - The program argument to be checked.
 *  value - The argument value.
 *
 * Returns
 *  SUCCESS - If program argument was checked successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int check_argument(char* argument, char* value) {
    LOG_TRACE("Argument: \"%s\", value pointer: %p.", argument, value);

    int result;
    int check_argument_log_result;
    
    if ( strcmp(argument, PARAMETER_LOG) == 0 ) {
        LOG_TRACE_POINT;

        check_argument_log_result = check_argument_log(value);
        LOG_TRACE_POINT;

        if ( check_argument_log_result == SUCCESS ) {
            LOG_TRACE_POINT;
            result = SUCCESS;
        }
        else {
            LOG_TRACE_POINT;
            result = GENERIC_ERROR;
        }
    }
    else {
        LOG_ERROR("Unknown argument \"%s\".", argument);
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Checks the program argument for log level.
 *
 * Parameters
 *  value - Value informed for log level argument.
 *
 * Returns
 *  SUCCESS - If log argument was checked successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int check_argument_log(char* value) {
    LOG_TRACE_POINT;

    int result;
    int value_integer;
    int log_level;
    bool start_log_level_defined;
    int define_start_log_level_result;

    if ( value == NULL ) {
        LOG_ERROR("No value defined to \"log\" argument.");
        result = GENERIC_ERROR;
    }
    else {
        LOG_TRACE("Value for argument log: \"%s\".", value);
        value_integer = atoi(value);

        if ( ( strcmp(value, PARAMETER_LOG_VALUE_TRACE) == 0 ) || ( value_integer == LOG_MESSAGE_TYPE_WARNING ) ) {
            LOG_TRACE_POINT;

            log_level = LOG_MESSAGE_TYPE_TRACE;
            start_log_level_defined = true;
        }
        else {
            LOG_TRACE_POINT;

            if ( ( strcmp(value, PARAMETER_LOG_VALUE_WARNING) == 0 ) || ( value_integer == LOG_MESSAGE_TYPE_WARNING ) ) {
                LOG_TRACE_POINT;

                log_level = LOG_MESSAGE_TYPE_WARNING;
                start_log_level_defined = true;
            }
            else {
                LOG_TRACE_POINT;

                if ( ( strcmp(value, PARAMETER_LOG_VALUE_ERROR) == 0 ) || ( value_integer == LOG_MESSAGE_TYPE_ERROR ) ) {
                    LOG_TRACE_POINT;

                    log_level = LOG_MESSAGE_TYPE_ERROR;
                    start_log_level_defined = true;
                }
                else {
                    LOG_TRACE_POINT;

                    LOG_ERROR("Unknown value for parameter \"log\".");
                    result = GENERIC_ERROR;
                }
            }
        }

        if ( start_log_level_defined == true ) {
            LOG_TRACE_POINT;

            define_start_log_level_result = define_start_log_level(log_level); 
            LOG_TRACE_POINT;

            if ( define_start_log_level_result == SUCCESS ) {
                LOG_TRACE_POINT;
                set_log_level(log_level);
                LOG_TRACE_POINT;
                result = SUCCESS;
            }
            else {
                LOG_TRACE_POINT;
                result = GENERIC_ERROR;
            }
        }
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Checks the program arguments.
 *
 * Parameters
 *  argc - Total of arguments informed to the program.
 *  argv - The array of arguments informed to the program.
 *
 * Returns
 *  SUCCESS - If the arguments were checked successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int check_arguments(int argc, char** argv) {
    LOG_TRACE("Total of arguments: %d.", argc);

    int result;
    int check_argument_result;
    int counter;
    char* argument;
    char* value;

    /* If no argument was informed for the program execution. */
    if ( argc == 1 ) {
        LOG_TRACE_POINT;
        result = SUCCESS;
    }
    else {
        LOG_TRACE_POINT;

        for (counter = 1; counter < argc; counter++ ) {
            LOG_TRACE_POINT;

            argument = argv[counter];

            /* Checks if the argument informed has a value. */
            if ( (counter+1) < argc ) {
                LOG_TRACE_POINT;

                if ( argv[counter+1][0] != '-' ) {
                    LOG_TRACE_POINT;
                    value = argv[counter+1];
                }
                else {
                    LOG_TRACE_POINT;
                    value = NULL;
                }
            }
            else {
                LOG_TRACE_POINT;
                value = NULL;
            }

            /* Checks the argument informed. */
            check_argument_result = check_argument(argument, value);
            LOG_TRACE_POINT;

            if ( check_argument_result != SUCCESS ) {
                LOG_TRACE_POINT;
                result = GENERIC_ERROR;
                break;
            }
            else {
                LOG_TRACE_POINT;
                if ( value != NULL ) {
                    LOG_TRACE_POINT;
                    counter++;
                }
            }
        }
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Checks the bluetooth command received.
 *
 * Parameters
 *  btc_socket_fd - The bluetooth communication's socket file descriptor to the remote device.
 *  package - The package with the command received.
 *
 * Returns
 *  SUCCESS - If the command was checked and executed successfully.
 *  GENERIC_ERROR - If there was an error checking the command received.
 *  DEVICE_DISCONNECTED - If the remote device was disconnected.
 *  RESTART_PROGRAM_CODE - If the program requested to restart.
 *  RESTART_AUDIO_RECORDER_CODE - If the program requested the audio recorder to restart.
 *  SHUT_DOWN_AUDIO_RECORDER_CODE - If the program requested the audio recorder to shut down.
 *
 * Observation
 *  The return codes are defined on "return_codes" header file.
 */
int check_command_received(int btc_socket_fd, package_t package) {
    LOG_TRACE_POINT;

    int result;
    int command_execution_result;

    switch (package.type_code) {
        case CHECK_CONNECTION_CODE:
            LOG_TRACE("Connection checked by device.");
            result = SUCCESS;
            break;

        case CONFIRMATION_CODE:
        case COMMAND_RESULT_CODE:
        case ERROR_CODE:
        case SEND_FILE_CHUNK_CODE:
        case SEND_FILE_HEADER_CODE:
        case SEND_FILE_TRAILER_CODE:
            LOG_ERROR("Package type recognized, but no action defined to be done. Package type: 0x%08x.", package.type_code);
            result = GENERIC_ERROR;
            break;

        case DISCONNECT_CODE:
            LOG_TRACE_POINT;

            command_execution_result = command_disconnect(btc_socket_fd);
            LOG_TRACE_POINT;

            if ( command_execution_result != SUCCESS ) {
                LOG_ERROR("Error while disconnecting from remote device.");
            }
            result = DEVICE_DISCONNECTED;
            break;

        case REQUEST_AUDIO_FILE_CODE:
            LOG_TRACE_POINT;

            command_execution_result = command_transmit_latest_audio_record(btc_socket_fd);
            LOG_TRACE_POINT;

            if ( command_execution_result == SUCCESS ) {
                LOG_TRACE_POINT;
                result = SUCCESS;
            }
            else {
                LOG_TRACE_POINT;
                result = GENERIC_ERROR;
            }

            break;

        case START_RECORD_CODE:
            LOG_TRACE_POINT;

            command_execution_result = command_start_audio_record(btc_socket_fd);
            LOG_TRACE_POINT;

            if ( command_execution_result == SUCCESS ) {
                LOG_TRACE_POINT;
                result = SUCCESS;
            }
            else {
                LOG_TRACE_POINT;
                result = GENERIC_ERROR;
            }

            break;

        case STOP_RECORD_CODE:
            LOG_TRACE_POINT;

            command_execution_result = command_stop_audio_record(btc_socket_fd);
            LOG_TRACE_POINT;

            if ( command_execution_result == SUCCESS ) {
                LOG_TRACE_POINT;
                result = SUCCESS;
            }
            else {
                LOG_TRACE_POINT;
                result = GENERIC_ERROR;
            }

            break;

        default:
            LOG_ERROR("Unrecognized package type: 0x%08x.", package.type_code);
            result = GENERIC_ERROR;
            break;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Executes the device disconnection processes.
 *
 * Parameters
 *  btc_socket_fd - The bluetooth communication's socket file descriptor to the remote device.
 *
 * Return
 *  SUCCESS - If remote device was disconnected successfully.
 *  GENERIC_ERROR - Otherwise.
 */

int command_disconnect(int btc_socket_fd) {
    LOG_TRACE_POINT;

    int result;
    int close_socket_result;

    close_socket_result = close_socket(btc_socket_fd);
    LOG_TRACE_POINT;

    if ( close_socket_result != SUCCESS ) {
        LOG_ERROR("Error while disconnecting remote device.");
        return GENERIC_ERROR;
    }
    else {
        LOG_TRACE_POINT;
        result = SUCCESS;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Starts audio recording.
 *
 * Parameters
 *  socket_fd - The bluetooth connection socket file descriptor to send the result of the "start audio record" command.
 *
 * Result
 *  SUCCESS - If audio recording started successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int command_start_audio_record(int socket_fd){
    LOG_TRACE_POINT;

    int result;
    int start_audio_record_result;
    int send_package_result;
    struct timeval execution_delay;
    char* start_audio_instant_file_path;
    instant_t start_audio_record_instant;
    int retrieve_instant_from_file_result;
    instant_t current_instant;
    instant_t difference;
    int get_instant_difference_result;
    package_t command_result_package;

    start_audio_record_result = start_audio_record();
    LOG_TRACE_POINT;

    start_audio_instant_file_path = get_start_audio_record_instant_file_path();
    LOG_TRACE_POINT;

    retrieve_instant_from_file_result  = retrieve_instant_from_file(&start_audio_record_instant, start_audio_instant_file_path);
    LOG_TRACE_POINT;

    if ( retrieve_instant_from_file_result != SUCCESS ) {
        LOG_ERROR("Error while retrieving start record instant.");
        return GENERIC_ERROR;
    }

    current_instant = get_instant();
    LOG_TRACE_POINT;

    get_instant_difference_result = get_instant_difference(&difference, current_instant, start_audio_record_instant);
    LOG_TRACE_POINT;

    if ( get_instant_difference_result != SUCCESS ) {
        LOG_ERROR("Error while calculating difference between the start audio record time and current instant.");
        return GENERIC_ERROR;
    }

    execution_delay = convert_instant_to_timeval(difference);
    LOG_TRACE_POINT;

    command_result_package = create_command_result_package(start_audio_record_result, execution_delay);
    LOG_TRACE_POINT;

    send_package_result = send_package(socket_fd, command_result_package);
    LOG_TRACE_POINT;

    if ( send_package_result == SUCCESS ) {
        LOG_TRACE_POINT;
        result = SUCCESS;
    }
    else {
        LOG_TRACE_POINT;
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
}


/*
 * Stops audio recording.
 *
 * Parameters
 *  socket_fd - The bluetooth connection socket file descriptor to send the result of the "stop audio record" command.
 *
 * Result
 *  SUCCESS - If audio record stopped successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int command_stop_audio_record(int socket_fd){
    LOG_TRACE_POINT;

    int result;
    int stop_audio_record_result;
    int send_package_result;
    package_t command_result_package;
    struct timeval execution_delay;
    char* stop_audio_instant_file_path;
    instant_t stop_audio_record_instant;
    int retrieve_instant_from_file_result;
    instant_t current_instant;
    int get_instant_difference_result;
    instant_t difference;

    stop_audio_record_result = stop_audio_record();
    LOG_TRACE_POINT;

    stop_audio_instant_file_path = get_stop_audio_record_instant_file_path();
    LOG_TRACE_POINT;

    retrieve_instant_from_file_result  = retrieve_instant_from_file(&stop_audio_record_instant, stop_audio_instant_file_path);
    LOG_TRACE_POINT;

    if ( retrieve_instant_from_file_result != SUCCESS ) {
        LOG_ERROR("Error while retrieving stop record instant.");
        return GENERIC_ERROR;
    }

    current_instant = get_instant();
    LOG_TRACE_POINT;

    get_instant_difference_result = get_instant_difference(&difference, current_instant, stop_audio_record_instant);
    LOG_TRACE_POINT;

    if ( get_instant_difference_result != SUCCESS ) {
        LOG_ERROR("Error while calculating difference between the stop audio record time and current instant.");
        return GENERIC_ERROR;
    }

    execution_delay = convert_instant_to_timeval(difference);
    LOG_TRACE_POINT;

    command_result_package = create_command_result_package(stop_audio_record_result, execution_delay);
    LOG_TRACE_POINT;

    send_package_result = send_package(socket_fd, command_result_package);
    LOG_TRACE_POINT;

    if ( send_package_result == SUCCESS ) {
        LOG_TRACE_POINT;
        result = SUCCESS;
    }
    else {
        LOG_TRACE_POINT;
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Transmits the latest audio recorded.
 *
 * Parameters
 *  btc_socket_fd - The bluetooth communication's socket file descriptor to the remote device.
 *
 * Returns
 *  SUCCESS - If the latest audio record file was sent successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int command_transmit_latest_audio_record(int btc_socket_fd){
    LOG_TRACE_POINT;

    int result;
    int send_file_result;
    char* latest_audio_record_file_path;

    latest_audio_record_file_path = get_latest_audio_record();
    LOG_TRACE_POINT;

    if ( latest_audio_record_file_path == NULL ) {
        LOG_ERROR("Could not obtain the latest audio record file path.");
        result = GENERIC_ERROR;
    }
    else {
        if ( strlen(latest_audio_record_file_path) <= 0 ) {
            LOG_ERROR("Could not obtain the latest audio record file path.");
            result = GENERIC_ERROR;
        }
        else {
            LOG_TRACE_POINT;

            send_file_result = send_file(btc_socket_fd, latest_audio_record_file_path);
            LOG_TRACE_POINT;

            if ( send_file_result != SUCCESS ) {
                LOG_ERROR("Error sending latest audio record file.");
                result = GENERIC_ERROR;
            }
            else {
                LOG_TRACE_POINT;
                result = SUCCESS;
            }
        }
        free(latest_audio_record_file_path);
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Finish both program and script logs.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  SUCCESS - If logs were finished successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int finish_logs() {
    LOG_TRACE_POINT;

    int close_log_file_result;
    int finish_shell_script_log_result;
    int result;

    close_log_file_result = close_log_file();
    LOG_TRACE_POINT;

    if ( close_log_file_result == SUCCESS ) {
        LOG_TRACE_POINT;

        finish_shell_script_log_result = finish_shell_script_log();
        LOG_TRACE_POINT;

        if ( finish_shell_script_log_result == SUCCESS ) {
            LOG_TRACE_POINT;
            result = SUCCESS;
        }
        else {
            LOG_TRACE_POINT;
            result = GENERIC_ERROR;
        }
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Processes to be done before finishing the program.
 *
 * Parameters
 *  None
 *
 * Returns
 *  SUCCESS - If processes were done successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int finish_processes(){
    LOG_TRACE_POINT;

    int result;
    int finish_logs_result;
    int unregister_bluetooth_service_result;

    unregister_bluetooth_service_result = unregister_bluetooth_service();
    LOG_TRACE_POINT;

    if ( unregister_bluetooth_service_result != SUCCESS ) {
        LOG_ERROR("Error unregistering bluetooth service.");
    }

    finish_logs_result = finish_logs();
    LOG_TRACE_POINT;

    if ( finish_logs_result != SUCCESS ) {
        LOG_ERROR("Error finishing log.");
    }

    if ( unregister_bluetooth_service_result != SUCCESS || finish_logs_result != SUCCESS ) {
        LOG_TRACE_POINT;
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
 * Program's main function.
 *
 * Parameters
 *  Check the program arguments on this file source header.
 *
 * Returns
 *  RESTART_PROGRAM_CODE - If the program requested to restart.
 *  RESTART_RASPBERRY_CODE - If the program requested the Raspberry to restart.
 *  SHUT_DOWN_RASPBERRY_CODE - If the program requested the Raspberry to shut down.
 *
 * Observation
 *  The return codes are defined on "return_codes" header file.  
 */
int main(int argc, char** argv){
    LOG_TRACE_POINT;

    int check_arguments_result;
    int start_processes_result;
    int program_execution_loop_result;
    int finish_processes_result;

    check_arguments_result = check_arguments(argc, argv);
    LOG_TRACE_POINT;

    if ( check_arguments_result == GENERIC_ERROR ) {
        LOG_TRACE_POINT;
        return GENERIC_ERROR;
    }

    start_processes_result = start_processes();
    LOG_TRACE_POINT;

    if ( start_processes_result == GENERIC_ERROR ) {
        LOG_TRACE_POINT;
        return GENERIC_ERROR;
    }

    program_execution_loop_result = program_execution_loop();
    LOG_TRACE_POINT;

    finish_processes_result = finish_processes();
    LOG_TRACE_POINT;

    if ( program_execution_loop_result == GENERIC_ERROR || finish_processes_result == GENERIC_ERROR ) {
        LOG_TRACE_POINT;
        return GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return program_execution_loop_result;
}

/*
 * Loop to control the program execution.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  RESTART_PROGRAM_CODE - If the program requested to restart.
 *  RESTART_RASPBERRY_CODE - If the program requested the audio recorder to restart.
 *  SHUT_DOWN_RASPBERRY_CODE - If the program requested the audio recorder to shut down.
 *
 * Observation
 *  The return codes are defined on "return_codes" header file.
 */
int program_execution_loop(){
    LOG_TRACE_POINT;

    int result;
    bool program_finished = false;
    int wait_connection_result;
    int remote_device_communication_loop_result;
    /* Bluetooth connection socket file descriptor. */
    int btc_socket_fd;

    while ( program_finished == false ) {
        LOG_TRACE_POINT;

        wait_connection_result = wait_connection(&btc_socket_fd);
        LOG_TRACE_POINT;

        if ( wait_connection_result == GENERIC_ERROR ) {
            LOG_ERROR("Error while waiting for a bluetooth connection.");
            program_finished = true;
            result = RESTART_PROGRAM_CODE;
        } else {
            LOG_TRACE_POINT;
            remote_device_communication_loop_result = remote_device_communication_loop(btc_socket_fd);
            LOG_TRACE_POINT;

            switch ( remote_device_communication_loop_result ) {
                case SUCCESS:
                    LOG_TRACE_POINT;
                    break;
                case DEVICE_DISCONNECTED:
                    LOG_TRACE_POINT;
                    break;
                case RESTART_PROGRAM_CODE:
                case RESTART_AUDIO_RECORDER_CODE:
                case SHUT_DOWN_AUDIO_RECORDER_CODE:
                    LOG_TRACE_POINT;
                    program_finished = true;
                    result = remote_device_communication_loop_result;
                    break;
                default:
                    LOG_ERROR("Unknown return code received from function \"remote_device_communication_loop\".");
                    program_finished = true;
                    result = RESTART_PROGRAM_CODE;
                    break;
            }
        }
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Loop to control the remote device communication.
 *
 * Parameters
 *  btc_socket_fd - The bluetooth communication's socket file descriptor to the remote device.
 *
 * Returns
 *  DEVICE_DISCONNECTED - If remote device has disconnected.
 *  RESTART_PROGRAM_CODE - If the program requested to restart.
 *  RESTART_RASPBERRY_CODE - If the program requested the audio recorder to restart.
 *  SHUT_DOWN_RASPBERRY_CODE - If the program requested the audio recorder to shut down.
 *
 * Observation
 *  The return codes are defined on "return_codes" header file.
 */
int remote_device_communication_loop(int btc_socket_fd) {
    LOG_TRACE_POINT;

    int result;
    int receive_package_result;
    int check_command_received_result;
    int close_socket_result;
    package_t package;
    bool device_connected = true;
    int error_counter = 0;

    while ( device_connected == true ) {
        LOG_TRACE_POINT;

        receive_package_result = receive_package(btc_socket_fd, &package);
        LOG_TRACE_POINT;

        switch (receive_package_result) {
            case SUCCESS:
                LOG_TRACE("Package received.");
                check_command_received_result = check_command_received(btc_socket_fd, package);
                LOG_TRACE_POINT;

                switch (check_command_received_result) {
                    case SUCCESS:
                        LOG_TRACE_POINT;
                        error_counter = 0;
                        break;

                    case GENERIC_ERROR:
                        LOG_ERROR("Error while checking bluetooth command.");
                        error_counter++;
                        if ( error_counter >= MAX_RECEIVE_PACKAGE_ERRORS_TOLERATED ) {
                            device_connected = false;
                            result = RESTART_PROGRAM_CODE;
                        }
                        break;

                    case DEVICE_DISCONNECTED:
                        LOG_TRACE("Device disconnected.");

                        error_counter = 0;
                        device_connected = false;
                        result = receive_package_result;
                        /* close_socket_result = close_socket(btc_socket_fd);
                        LOG_TRACE_POINT;

                        if ( close_socket_result == SUCCESS ) {
                            LOG_TRACE_POINT;
                            result = receive_package_result;
                        }
                        else {
                            LOG_ERROR("Error while closing bluetooth communication socket with remote device.");
                        } */
                        break;

                    case RESTART_PROGRAM_CODE:
                        LOG_TRACE("Device requested the program to be restarted.");

                        error_counter = 0;
                        close_socket_result = close_socket(btc_socket_fd);
                        LOG_TRACE_POINT;
                        device_connected = false;

                        if ( close_socket_result == SUCCESS ) {
                            LOG_TRACE_POINT;
                            result = receive_package_result;
                        }
                        else {
                            LOG_ERROR("Error while closing bluetooth communication socket with remote device.");
                        }
                        break; 

                    case RESTART_AUDIO_RECORDER_CODE:
                        LOG_TRACE("Device requested to restart the audio recorder.");

                        error_counter = 0;
                        close_socket_result = close_socket(btc_socket_fd);
                        LOG_TRACE_POINT;
                        device_connected = false;

                        if ( close_socket_result == SUCCESS ) {
                            LOG_TRACE_POINT;
                            result = receive_package_result;
                        }
                        else {
                            LOG_ERROR("Error while closing bluetooth communication socket with remote device.");
                        }
                        break;

                    case SHUT_DOWN_AUDIO_RECORDER_CODE:
                        LOG_TRACE("Device requested the audio recorder to shut down.");

                        error_counter = 0;
                        close_socket_result = close_socket(btc_socket_fd);
                        LOG_TRACE_POINT;
                        device_connected = false;

                        if ( close_socket_result == SUCCESS ) {
                            LOG_TRACE_POINT;
                            result = receive_package_result;
                        }
                        else {
                            LOG_ERROR("Error while closing bluetooth communication socket with remote device.");
                        }
                        break;

                    default:
                        LOG_ERROR("Unknown code returned from \"check_command_received\" function: %d", check_command_received_result);

                        close_socket_result = close_socket(btc_socket_fd);
                        LOG_TRACE_POINT;
                        device_connected = false;

                        if ( close_socket_result != SUCCESS ) {
                            LOG_ERROR("Error while closing bluetooth communication socket with remote device.");
                        }
                        result = RESTART_PROGRAM_CODE;
                        break;
                }
                break;

            case GENERIC_ERROR:
                LOG_ERROR("Error while receiving package from bluetooth connection.");
                error_counter++;
                if ( error_counter >= MAX_RECEIVE_PACKAGE_ERRORS_TOLERATED ) {
                    device_connected = false;
                    result = RESTART_PROGRAM_CODE;
                }
                break;

            case NO_PACKAGE_RECEIVED:
                LOG_TRACE_POINT;
                device_connected = false;
                result = DEVICE_DISCONNECTED;
                break;

            default:
                LOG_ERROR("Unknown code returned from \"receive_package\" function.");

                close_socket_result = close_socket(btc_socket_fd);
                LOG_TRACE_POINT;
                if ( close_socket_result != SUCCESS ) {
                    LOG_ERROR("Error while closing bluetooth communication socket with remote device.");
                }

                device_connected = false;
                result = RESTART_PROGRAM_CODE;
                break;
        }
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Starts both program and script logs.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  SUCCESS - If logs started successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int start_logs() {
    LOG_TRACE_POINT;

    int open_log_file_result;
    int start_shell_script_log_result;
    int result;

    open_log_file_result = open_log_file(PROGRAM_LOG_FILE_PREFFIX);
    LOG_TRACE_POINT;

    if ( open_log_file_result == SUCCESS ) {
        LOG_TRACE_POINT;

        start_shell_script_log_result = start_shell_script_log(SCRIPT_LOG_FILE_PREFFIX, LOG_MESSAGE_TYPE_TRACE);
        LOG_TRACE_POINT;

        if ( start_shell_script_log_result == SUCCESS ) {
            LOG_TRACE_POINT;
            result = SUCCESS;
        }
        else {
            LOG_TRACE_POINT;
            result = GENERIC_ERROR;
        }
    }
    else {
        LOG_TRACE_POINT;
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Processes to be done before the program starts.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  SUCCESS - If processes were done successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int start_processes(){
    LOG_TRACE_POINT;

    int result;
    int start_logs_result;
    int register_bluetooth_service_result;

    start_logs_result = start_logs();
    LOG_TRACE_POINT;

    if ( start_logs_result == SUCCESS ) {
        LOG_TRACE_POINT;

        register_bluetooth_service_result = register_bluetooth_service();
        LOG_TRACE_POINT;

        if ( register_bluetooth_service_result == SUCCESS ) {
            LOG_TRACE_POINT;
            result = SUCCESS;
        } 
        else {
            LOG_TRACE_POINT;
            result = GENERIC_ERROR;
        }

    } 
    else {
        LOG_TRACE_POINT;
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Waits for a remote device to connect.
 *
 * Parameters
 *  btc_socket_fd - The variable where the bluetooth connection's socket file descriptor will be returned. 
 *
 * Returns
 *  SUCCESS - If a device connected successfully.
 *  GENERIC_ERROR - Otherwise.
 */
int wait_connection(int* btc_socket_fd) {
    LOG_TRACE_POINT;

    int result;
    bool wait_connection_concluded = false;
    int check_connection_attempt_result;
    int temporary_btc_socket_fd;

    while ( wait_connection_concluded == false ) {
        LOG_TRACE_POINT;

        check_connection_attempt_result = check_connection_attempt(&temporary_btc_socket_fd);
        LOG_TRACE_POINT;

        switch (check_connection_attempt_result) {
            case CONNECTION_STABLISHED:
                LOG_TRACE_POINT;

                *btc_socket_fd = temporary_btc_socket_fd;
                wait_connection_concluded = true;
                result = SUCCESS;
                break;

            case NO_CONNECTION:
                LOG_TRACE_POINT;
                break;

            case GENERIC_ERROR:
                LOG_ERROR("Error while checking for a bluetooth connection attempt.");

                wait_connection_concluded = true;
                result = GENERIC_ERROR;
                break;

            default:
                LOG_ERROR("Unknown \"check_connection_attempt\" result: %d.", check_connection_attempt_result);

                wait_connection_concluded = true;
                result = GENERIC_ERROR;
                break;
        }
    }

    LOG_TRACE_POINT;
    return result;
}
