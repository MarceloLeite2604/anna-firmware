/*
 * This source file contains the elaboration of all components requires to create and manage a bluetooth service.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */

#include <stdint.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>
#include <bluetooth/rfcomm.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>
#include "service.h"
#include "../connection/connection.h"
#include "../../log/log.h"

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
 * Definitions.
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
#define SERVICE_DESCRIPTION "A service to create a communication between the project's hardware and a smard device."

/* Wait time to check a connection attempt. */
#define CHECK_CONNECTION_WAIT_TIME_SECONDS 5
#define CHECK_CONNECTION_WAIT_TIME_MICROSECONDS 0

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
 *  None 
 *
 * Returns
 *  If a connection was stablished, it returns the connection file descriptor.
 *  If no connection attempt was received, it returns 0.
 *  If there was an error, it returns -1.
 */
int check_connection_attempt() {
    LOG_TRACE_POINT;

    if ( is_bluetooth_service_registered() == false ) {
        LOG_ERROR("Bluetooth service is not registered.");
        return -1;
    }

    int listening_socket_file_descriptor;
    int client_socket_file_descriptor;
    int result;

    struct sockaddr_rc remote_device_address = { 0 };
    socklen_t address_length = sizeof(struct sockaddr_rc);

    char remote_device_address_string[19] = { 0 };
    char remote_device_name[256] = { 0 };

    struct timeval check_connection_wait_time = _check_connection_wait_time;
    int check_socket_content_result;

    /* Allocates a socket to listen to connections. */
    listening_socket_file_descriptor = socket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);
    if ( listening_socket_file_descriptor <= 0 ) {
        LOG_ERROR("Could not create socket to listen for connections.");
        return 1;
    }

    bind(listening_socket_file_descriptor, (struct sockaddr *)&local_address, sizeof(local_address));

    /*
     * Listens for connections on socket, defining the listening queue to a maximum of one.
     */
    listen(listening_socket_file_descriptor, 1);

    LOG_TRACE("Checking connection.");
    check_socket_content_result = check_socket_content(listening_socket_file_descriptor, check_connection_wait_time); 

    switch (check_socket_content_result) {
        case 0:
            LOG_TRACE("No connections.");
            result = 0;
            break;
        case -1:
            LOG_TRACE("Error while checking bluetooth service socket.");
            result = -1;
            break;
        default:
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
            result = client_socket_file_descriptor;
            break;
    }

    close_socket(listening_socket_file_descriptor);
    return result;
}

/*
 * Checks is bluetooth service is registered.
 * 
 * Parameters
 *  None
 *
 * Return
 *  True if bluetooth service is available.
 *  False otherwise.
 */
bool is_bluetooth_service_registered(){
    if ( sdp_connect_session == NULL ) {
        return false;
    }
    return true; 
}

/*
 * Registers the bluetooth service.
 *
 * Parameters
 *  None
 *
 * Return
 *  0. If bluetooth service started successfully.
 *  1. If there was an error while starting bluetooth service.
 */
int register_bluetooth_service(){
    LOG_TRACE_POINT;

    if ( is_bluetooth_service_registered() == true ) {
        LOG_ERROR("The bluetooth service is already registered.");
        return 1;
    }

    uint8_t rfcomm_channel = _rfcomm_channel;

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

    // Creates the service ID.
    sdp_uuid128_create(&service_uuid, &bluetooth_service_infos.uuid );

    // Sets the services classes ID.
    service_class_id_list = sdp_list_append(0, &service_uuid);
    sdp_set_service_classes(&record, service_class_id_list);

    // Makes the service record publicly browsable.
    sdp_uuid16_create(&public_browse_group_uuid, PUBLIC_BROWSE_GROUP);
    public_browse_group_list = sdp_list_append(0, &public_browse_group_uuid);
    sdp_set_browse_groups( &record, public_browse_group_list );

    // Elaborates L2CAP protocol informations.
    sdp_uuid16_create(&l2cap_uuid, L2CAP_UUID);
    l2cap_list = sdp_list_append( 0, &l2cap_uuid );
    protocol_list = sdp_list_append( 0, l2cap_list );

    // Elaborates RFCOMM protocol informations.
    sdp_uuid16_create(&rfcomm_uuid, RFCOMM_UUID);
    rfcomm_list = sdp_list_append( 0, &rfcomm_uuid );
    channel_data = sdp_data_alloc(SDP_UINT8, &rfcomm_channel);

    // Defines the procol accepted by the service.
    sdp_list_append( rfcomm_list, channel_data );
    sdp_list_append( protocol_list, rfcomm_list );
    access_protocol_list = sdp_list_append( 0, protocol_list );
    sdp_set_access_protos( &record, access_protocol_list );

    // Set the service name, description and provider.
    // sdp_set_info_attr(&record, service_name, service_dsc, service_prov);
    sdp_set_info_attr(&record, bluetooth_service_infos.name, bluetooth_service_infos.description, bluetooth_service_infos.provider);

    /*
     * Connects the service to the local SDP server.
     * Observation: There is a bug on Ubuntu related to BlueZ version used. To correct it, follow the instructions listed on "https://bbs.archlinux.org/viewtopic.php?id=201672".
     */
    session = sdp_connect(BDADDR_ANY, BDADDR_LOCAL, SDP_RETRY_IF_BUSY);
    if ( session <= 0 ) {
        LOG_ERROR("Could not register the bluetooth service.");
        return 1;
    }

    // Register the service on SDP server.
    sdp_record_register(session, &record, 0);

    // Clean variables previously alocated. 
    sdp_data_free( channel_data );
    sdp_list_free( l2cap_list, 0 );
    sdp_list_free( rfcomm_list, 0 );
    sdp_list_free( public_browse_group_list, 0 );
    sdp_list_free( access_protocol_list, 0 );

    // set_registered_bluetooth_service_infos(bluetooth_service_infos);
    sdp_connect_session = session;

    LOG_TRACE("Service registered.");
    return 0;
}

/*
 * Unregisters the bluetooth service.
 *
 * Parameters
 *  None
 *
 * Returns
 *  0. If bluetooth service was unregistered successfully.
 *  1. If there was an error while unregistering bluetooth service.
 */
int unregister_bluetooth_service() {
    if ( is_bluetooth_service_registered() == true ) {
        sdp_close(sdp_connect_session);
        sdp_connect_session = NULL;
    }

    return 0;
}
