/*
 * This source file contains the elaboration of all components required to create and manage a bluetooth service.
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

#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>
#include <bluetooth/rfcomm.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>
#include <stdint.h>

#include "bluetooth/connection.h"
#include "bluetooth/service.h"
#include "log.h"
#include "return_codes.h"


/*
 * Macros.
 */

/* The RFCOMM channel used to provide the service. */
#define RFCOMM_CHANNEL 27

/* The bluetooth service UUID. */
#define SERVICE_UUID 0x964b93f5, 0xe6111001, 0x555e228d, 0x667c5017

/* The bluetooth service name. */
#define SERVICE_NAME "Projeto Anna"

/* The bluetooth service provider. */
#define SERVICE_PROVIDER "Marcelo Leite"

/* The bluetooth service description. */
#define SERVICE_DESCRIPTION "A service to create a communication between the audio recorder and a remote device."

/* Wait time to check a connection attempt. */
#define CHECK_CONNECTION_WAIT_TIME_SECONDS 5
#define CHECK_CONNECTION_WAIT_TIME_MICROSECONDS 0


/*
 * Structures.
 */

/* Stores informations about the bluetooth service provided. */
typedef struct {
    uint32_t uuid[4];
    char* name;
    char* description;
    char* provider;
} bluetooth_service_infos_t;


/*
 * Constants.
 */

/* The RFCOMM channel used to provide the service. */
const uint8_t _rfcomm_channel = RFCOMM_CHANNEL;

/* The bluetooth service informations. */
const bluetooth_service_infos_t bluetooth_service_infos = { .uuid = { SERVICE_UUID}, .name = SERVICE_NAME, .provider = SERVICE_PROVIDER, .description = SERVICE_DESCRIPTION};

/* Wait time to check a connection attempt. */
const struct timeval _check_connection_wait_time = { .tv_sec = CHECK_CONNECTION_WAIT_TIME_SECONDS, .tv_usec = CHECK_CONNECTION_WAIT_TIME_MICROSECONDS };

/* Local address to check connection attempt. */
const struct sockaddr_rc local_address = { .rc_family = AF_BLUETOOTH, .rc_bdaddr = *BDADDR_ANY, .rc_channel = RFCOMM_CHANNEL };


/*
 * Variables.
 */

/* Session indicating the connection to bluetooth service provider. */
sdp_session_t* sdp_connect_session = NULL;


/*
 * Function elaborations.
 */

/*
 * Checks if there is a bluetooth connection attempt.
 *
 * Parameters
 *  socket_fd - If a connection was stablished, the bluetooth connection's socket file descriptor will be returned through this parameter.
 *
 * Returns
 *  CONNECTION_STABLISHED - If a connection was stablished.
 *  NO_CONNECTION - If no connection was stablished.
 *  GENERIC_ERROR - If there was an error while checking a connection attempt.
 */
int check_connection_attempt(int* socket_fd) {
    LOG_TRACE_POINT;

    int listening_socket_file_descriptor;
    int client_socket_file_descriptor;
    int close_socket_result;
    int result;
    struct sockaddr_rc remote_device_address = { 0 };
    char remote_device_address_string[19] = { 0 };
    char remote_device_name[256] = { 0 };
    socklen_t address_length;
    struct timeval check_connection_wait_time;
    int check_socket_content_result;

    if ( is_bluetooth_service_registered() == false ) {
        LOG_ERROR("Bluetooth service is not registered.");
        return GENERIC_ERROR;
    }

    address_length = sizeof(struct sockaddr_rc);
    check_connection_wait_time = _check_connection_wait_time;

    /* Allocates a socket to listen to connections. */
    listening_socket_file_descriptor = socket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);
    if ( listening_socket_file_descriptor <= 0 ) {
        LOG_ERROR("Could not create socket to listen for connections.");
        return GENERIC_ERROR;
    }

    bind(listening_socket_file_descriptor, (struct sockaddr *)&local_address, sizeof(local_address));
    LOG_TRACE_POINT;

    /* Listens for connections on socket, defining the listening queue to a maximum of one. */
    listen(listening_socket_file_descriptor, 1);
    LOG_TRACE("Checking connection.");

    check_socket_content_result = check_socket_content(listening_socket_file_descriptor, check_connection_wait_time); 
    LOG_TRACE_POINT;

    switch (check_socket_content_result) {
        case NO_CONTENT_TO_READ:
            LOG_TRACE("No connections.");

            result = NO_CONNECTION;
            break;

        case GENERIC_ERROR:
            LOG_TRACE("Error while checking bluetooth service socket.");

            result = GENERIC_ERROR;
            break;

        case CONTENT_TO_READ:
            LOG_TRACE("Connection attempt initialized.");

            /* Accepts one connection from the listening socket. */
            client_socket_file_descriptor = accept(listening_socket_file_descriptor, (struct sockaddr *)&remote_device_address, &address_length);

            /* Converts the device address on a human-readable address. */
            ba2str( &remote_device_address.rc_bdaddr, remote_device_address_string );

            /* Requests remote device name. */
            if (hci_read_remote_name(client_socket_file_descriptor, &(remote_device_address.rc_bdaddr), sizeof(remote_device_name), remote_device_name, 0) < 0 ){
                LOG_TRACE("Connected with device \"%s\".", remote_device_address_string);
            }
            else {
                LOG_TRACE("Connected with device \"%s\" (%s).", remote_device_name, remote_device_address_string); 
            }
            *socket_fd = client_socket_file_descriptor;
            result = CONNECTION_STABLISHED;
            break;

        default:
            LOG_ERROR("Unknown result received from \"check_socket_content\" function.");
            result = GENERIC_ERROR;
            break;
    }

    close_socket_result = close_socket(listening_socket_file_descriptor);
    LOG_TRACE_POINT;

    if ( close_socket_result != SUCCESS ) {
        LOG_ERROR("Error while closing socket connection.");
        result = GENERIC_ERROR;
    }

    LOG_TRACE_POINT;
    return result;
}

/*
 * Checks is bluetooth service is registered.
 * 
 * Parameters
 *  None.
 *
 * Returns
 *  True - If bluetooth service is available.
 *  False - Otherwise.
 */
bool is_bluetooth_service_registered(){
    LOG_TRACE_POINT;

    return ( sdp_connect_session == NULL );
}

/*
 * Registers the bluetooth service.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  SUCCESS - If bluetooth service started successfully.
 *  GENERIC_ERROR - If there was an error while starting bluetooth service.
 */
int register_bluetooth_service(){
    LOG_TRACE_POINT;

    uint8_t rfcomm_channel;

    uuid_t public_browse_group_uuid;
    uuid_t l2cap_uuid;
    uuid_t rfcomm_uuid;
    uuid_t service_uuid;

    sdp_list_t *service_class_id_list = 0;
    sdp_list_t *public_browse_group_list = 0;

    sdp_list_t *l2cap_list = 0;
    sdp_list_t *rfcomm_list = 0;
    sdp_list_t *protocol_list = 0;
    sdp_list_t *access_protocol_list = 0;
    sdp_data_t *channel_data = 0;
    sdp_record_t record = { 0 };
    sdp_session_t *session = 0;

    if ( is_bluetooth_service_registered() == true ) {
        LOG_ERROR("The bluetooth service is already registered.");
        return GENERIC_ERROR;
    }

    rfcomm_channel = _rfcomm_channel;

    /* Creates the service ID. */
    sdp_uuid128_create(&service_uuid, &bluetooth_service_infos.uuid );
    LOG_TRACE_POINT;

    /* Sets the services classes ID. */
    service_class_id_list = sdp_list_append(0, &service_uuid);
    sdp_set_service_classes(&record, service_class_id_list);
    LOG_TRACE_POINT;

    /* Makes the service record publicly browsable. */
    sdp_uuid16_create(&public_browse_group_uuid, PUBLIC_BROWSE_GROUP);
    public_browse_group_list = sdp_list_append(0, &public_browse_group_uuid);
    sdp_set_browse_groups( &record, public_browse_group_list );
    LOG_TRACE_POINT;

    /* Elaborates L2CAP protocol informations. */
    sdp_uuid16_create(&l2cap_uuid, L2CAP_UUID);
    l2cap_list = sdp_list_append( 0, &l2cap_uuid );
    protocol_list = sdp_list_append( 0, l2cap_list );
    LOG_TRACE_POINT;

    /* Elaborates RFCOMM protocol informations. */
    sdp_uuid16_create(&rfcomm_uuid, RFCOMM_UUID);
    rfcomm_list = sdp_list_append( 0, &rfcomm_uuid );
    channel_data = sdp_data_alloc(SDP_UINT8, &rfcomm_channel);
    LOG_TRACE_POINT;

    /* Defines the procol accepted by the service. */
    sdp_list_append( rfcomm_list, channel_data );
    sdp_list_append( protocol_list, rfcomm_list );
    access_protocol_list = sdp_list_append( 0, protocol_list );
    sdp_set_access_protos( &record, access_protocol_list );
    LOG_TRACE_POINT;

    /* Set the service name, description and provider. */
    sdp_set_info_attr(&record, bluetooth_service_infos.name, bluetooth_service_infos.description, bluetooth_service_infos.provider);
    LOG_TRACE_POINT;
    
    /* Connects the service to the local SDP server.
     Observation: There is a bug on Ubuntu related to BlueZ version used. To correct it, follow the instructions listed on "https://bbs.archlinux.org/viewtopic.php?id=201672". */
    session = sdp_connect(BDADDR_ANY, BDADDR_LOCAL, SDP_RETRY_IF_BUSY);
    if ( session <= 0 ) {
        LOG_ERROR("Could not register the bluetooth service.");
        return GENERIC_ERROR;
    }

    /* Register the service on SDP server. */
    sdp_record_register(session, &record, 0);
    LOG_TRACE_POINT;

    /* Clean variables previously alocated. */
    sdp_data_free( channel_data );
    sdp_list_free( l2cap_list, 0 );
    sdp_list_free( rfcomm_list, 0 );
    sdp_list_free( public_browse_group_list, 0 );
    sdp_list_free( access_protocol_list, 0 );
    LOG_TRACE_POINT;

    sdp_connect_session = session;

    LOG_TRACE("Service registered.");
    return SUCCESS;
}

/*
 * Unregisters the bluetooth service.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  SUCCESS - If bluetooth service was unregistered successfully.
 *  GENERIC_ERROR - If there was an error while unregistering bluetooth service.
 */
int unregister_bluetooth_service() {
    LOG_TRACE_POINT;

    if ( is_bluetooth_service_registered() == true ) {
        sdp_close(sdp_connect_session);
        sdp_connect_session = NULL;
    }

    LOG_TRACE_POINT;
    return SUCCESS;
}
