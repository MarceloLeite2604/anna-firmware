/*
 * This source file contains all functions required to create a bluetooth service and communicate with the connected device.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <unistd.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>
#include <bluetooth/rfcomm.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>
#include "bluetooth.h"
#include "../log/log.h"

/*
 * Private global variables.
 */

// Informations about the registered bluetooth service.
// bluetooth_service_infos_t registered_bluetooth_service_infos;

// Session indicating the connection to bluetooth service provider.
sdp_session_t* sdp_connect_session = NULL;


/*
 * Private function declarations.
 */

/*
 * Defines the information about the registered bluetooth service.
 */
// int set_registered_bluetooth_service_infos(bluetooth_service_infos_t);

/*
 * Removes the service from bluetooth service provider.
 */
// int clear_registered_bluetooth_device_infos();

/*
 * Functions elaboration.
 */

/*
 * Accepts a connection from service.
 *
 * Parameters
 *  wait_time - Time to wait for a connection.
 *
 * Returns
 *  The socket id if a connection was stablished.
 *  0. If not connection was stablished.
 *  1. If there was an error during execution.
 */
int accept_connection(struct timeval wait_time) {
    TRACE("Accepting connection.");

    struct sockaddr_rc local_address = { 0 };
    struct sockaddr_rc remote_device_address = { 0 };

    int listening_socket_file_descriptor;
    int client_socket_file_descriptor;

    socklen_t opt = sizeof(remote_device_address);

    char remote_device_address_string[19] = { 0 };
    char remote_device_name[256] = { 0 };
    fd_set listening_socket_file_descriptor_fd_set;
    int select_result;

    // struct timeval tv;
    // char content_read[1024];
    // int bytes_read;

    /*
     * Allocates a socket to listen to connections.
     */
    listening_socket_file_descriptor = socket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);
    if ( listening_socket_file_descriptor <= 0 ) {
        LOG_ERROR("Could not create socket to listen for connections.");
        return 1;
    }

    /*
     * Defines the remote address of socket connection. On a server program, "BDADDR_ANY" is used to inform that it accepts a connection from any device.
     * Observation: For listening sockets, "rc_channel" specifies the port number to listen.
     */
    local_address.rc_family = AF_BLUETOOTH;
    local_address.rc_bdaddr = *BDADDR_ANY;
    /* TODO: Isn't the channel supposed to be selectable? */
    local_address.rc_channel = (uint8_t) 27;
    bind(listening_socket_file_descriptor, (struct sockaddr *)&local_address, sizeof(local_address));

    /*
     * Listens for connections on socket, defining the listening queue to a maximum of one.
     */
    listen(listening_socket_file_descriptor, 1);


    FD_ZERO(&listening_socket_file_descriptor_fd_set);
    FD_SET(listening_socket_file_descriptor, &listening_socket_file_descriptor_fd_set);
   /*
    * Checks if there is a connection waiting to be stablished.
    */
    TRACE("Waiting for a connection.");
    select_result = select((listening_socket_file_descriptor+1), &listening_socket_file_descriptor_fd_set, (fd_set*)NULL, (fd_set*)NULL, &wait_time);
    FD_CLR(listening_socket_file_descriptor, &listening_socket_file_descriptor_fd_set);
    if ( select_result == 0 ) {
        TRACE("Connection acceptance timeout.");
        close(listening_socket_file_descriptor);
        return 0;
    }

    /* Accepts one connection from the listening socket. */
    client_socket_file_descriptor = accept(listening_socket_file_descriptor, (struct sockaddr *)&remote_device_address, &opt);

    /* Turns the remote bluetooth device address on a human-readable address. */
    ba2str( &remote_device_address.rc_bdaddr, remote_device_address_string );

    if (hci_read_remote_name(client_socket_file_descriptor, &(remote_device_address.rc_bdaddr), sizeof(remote_device_name), remote_device_name, 0) < 0 ){
        TRACE("Connected with device \"%s\".", remote_device_address_string);
    }
    else {
        TRACE("Connected with device \"%s\" (%s).", remote_device_name, remote_device_address_string); 
    }

    /* Read data from socket. */
/*    bytes_read = read(client_socket_file_descriptor, content_read, sizeof(content_read));
    if ( bytes_read < 0 ) {
        LOG_ERROR("Could not read content from remote bluetooth device.");
        return 1;
    } */

    // printf("Content received: %s\n", content_read);

    /* Close socket. */
    // close(client_socket_file_descriptor);

    close(listening_socket_file_descriptor);
    return client_socket_file_descriptor;
}

/*
 * Indicates if there is a bluetooth service registered.
 *
 * Parameters
 *  None.
 *
 * Returns
 *  true  - If the bluetooth service is registered.
 *  false - Otherwhise.
 */
bool is_bluetooth_service_registered() {
    if ( sdp_connect_session == NULL ) {
        return false;
    }
    return true; 
}

/*
 * Register a new service on bluetooth service provider.
 *
 * Parameters
 *  bluetooth_service_infos - The informations about the service to be registered such as its name, provider, description and UUID.
 *
 * Returns
 *  0. If service was registered successfully.
 *  1. Otherwise.
 */
int register_service(bluetooth_service_infos_t bluetooth_service_infos){
    TRACE("Registering service.");

    if ( is_bluetooth_service_registered() == true ) {
        LOG_ERROR("A bluetooth service is already registered.");
        return 1;
    }

    uint8_t rfcomm_channel = 27;

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
    sdp_uuid128_create( &service_uuid, &bluetooth_service_infos.uuid );

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
    session = sdp_connect( BDADDR_ANY, BDADDR_LOCAL, SDP_RETRY_IF_BUSY);
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
    TRACE("Service registered.");

    return 0;
}

/*
 * Removes the service from bluetooth service provider.
 * 
 * Parameters
 *  None
 *
 * Returns
 *  0. If service was removed successfully.
 *  1. Otherwise.
 */
int remove_service(){
    if ( is_bluetooth_service_registered() == true ) {
        sdp_close(sdp_connect_session);
        sdp_connect_session = NULL;
        // clear_registered_bluetooth_device_infos();
    }

    return 0;
}

/*
 * Sets the registered bluetooth service informations.
 *
 * Parameters
 *  bluetooth_service_infos - The informations to copy for the registered bluetooth service informations variable.
 *
 * Returns
 *  0. If values were define correctly.
 *  1. Otherwise.
 */
/* int set_registered_bluetooth_service_infos(bluetooth_service_infos_t bluetooth_service_infos) {
    int counter;

    registered_bluetooth_service_infos.name = malloc(strlen(bluetooth_service_infos.name)*sizeof(char));
    if ( registered_bluetooth_service_infos.name == NULL ) {
        return 1;
    }
    registered_bluetooth_service_infos.provider = malloc(strlen(bluetooth_service_infos.provider)*sizeof(char));
    if ( registered_bluetooth_service_infos.provider == NULL ) {
        return 1;
    }
    registered_bluetooth_service_infos.description = malloc(strlen(bluetooth_service_infos.description)*sizeof(char));
    if ( registered_bluetooth_service_infos.description == NULL ) {
        return 1;
    }

    strcpy(registered_bluetooth_service_infos.name, bluetooth_service_infos.name);
    strcpy(registered_bluetooth_service_infos.provider, bluetooth_service_infos.provider);
    strcpy(registered_bluetooth_service_infos.description, bluetooth_service_infos.description);

    for ( counter = 0; counter < 4; counter ++ ) {
        registered_bluetooth_service_infos.uuid[counter] = bluetooth_service_infos.uuid[counter];
    }

    return 0;
} */

/*
 * Clears the informations about the registered bluetooth service.
 *
 * Paramters
 *  None.
 *
 * Returns
 *  0. If information was cleared successfully.
 *  1. Otherwise.
 */
/* int clear_registered_bluetooth_device_infos() {
    int counter;

    if ( registered_bluetooth_service_infos.name != NULL ) {
        free(registered_bluetooth_service_infos.name);
        registered_bluetooth_service_infos.name = NULL;
    }

    if ( registered_bluetooth_service_infos.provider != NULL ) {
        free(registered_bluetooth_service_infos.provider);
        registered_bluetooth_service_infos.provider = NULL;
    }

    if ( registered_bluetooth_service_infos.description != NULL ) {
        free(registered_bluetooth_service_infos.description);
        registered_bluetooth_service_infos.description = NULL;
    }

    for ( counter = 0; counter < 4; counter ++ ) {
        registered_bluetooth_service_infos.uuid[counter] = 0x0000;
    }

    return 0;
} */

/*
 * Reads a content from bluetooth socket.
 *
 * Parameters
 *   socket_file_descriptor - The file descriptor of the bluetooth socket connection.
 *   buffer - Buffer where the content read will be stored.
 *   buffer_length - Length of the buffer to store the content read.
 *   wait_time - Time to wait for a content to be read through the socket.
 *
 * Returns
 *  If something was read from the socket, the function will return the content size.
 *  0. If nothing was read from the socket on the specified time.
 *  -1. If there was an error while reading the socket content.
 */
int read_bluetooth_socket(int socket_file_descriptor, char* buffer, int buffer_length, struct timeval wait_time) {

    int select_result;
    int total_read;
    fd_set socket_file_descriptor_fd_set;

    FD_ZERO(&socket_file_descriptor_fd_set);
    FD_SET(socket_file_descriptor, &socket_file_descriptor_fd_set);

    select_result = select((socket_file_descriptor+1), &socket_file_descriptor_fd_set, (fd_set*)NULL, (fd_set*)NULL, &wait_time);
    FD_CLR(socket_file_descriptor, &socket_file_descriptor_fd_set);
    if ( select_result == 0 ) {
        TRACE("No content received from socket.");
        return 0;
    } else {
        if ( select_result == -1 ) {
            TRACE("Error while waiting for a content from the socket.");
            return -1;
        }
    }

    total_read = read(socket_file_descriptor, buffer, buffer_length);
    if ( total_read < 0 ) {
        LOG_ERROR("Error while reading content from socket.");
        return -1;
    }

    return total_read;
}
