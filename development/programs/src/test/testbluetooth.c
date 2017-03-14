#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <bluetooth/bluetooth.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <inttypes.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>
#include <bluetooth/rfcomm.h>
#include "../release/bluetooth/bluetooth.h"
#include "../release/log/log.h"

#define ERROR_MESSAGE_SIZE 512

#define MAX_DISCOVERED_DEVICES 10

// Observation: On "hci_inquiry" function, the "len" is used to define inquiry time as "1.28 * len".
#define INQUIRY_TIME 3

/*typedef struct {
    uint32_t uuid[4];
    char* name;
    char* description;
    char* provider;
} bluetooth_service_infos_t;*/

/* int inquiry_devices(){
    char* error_message;

    inquiry_info* inquiry_infos = NULL;
    inquiry_info* var_inquiry_info = NULL;
    int total_discovered_devices;
    int bluetooth_device_id;
    int bluetooth_device_socket;
    int inquiry_flags;
    int counter;

    char bluetooth_device_address[19] = {0};
    char bluetooth_device_name[248] = {0};

    
    // Returns the resource number of the first available bluetooth adapter.
    // Observation: Bluetooth must be enable/activated on system.
    bluetooth_device_id = hci_get_route(NULL);
    if ( bluetooth_device_id < 0 ) {
        LOG_ERROR("Could not find bluetooth device.");
        return 1;
    }

    //  Opens a socket communication with the bluetooth device.
    bluetooth_device_socket = hci_open_dev(bluetooth_device_id);
    if ( bluetooth_device_socket < 0 ) {
        LOG_ERROR("Could not open socket with bluetooh device.");
        return 1;
    }

    // Observation: IRQ_CACHE_FLUSH ignores results from previous inquires.
    inquiry_flags = IREQ_CACHE_FLUSH;

    inquiry_infos = malloc(MAX_DISCOVERED_DEVICES * sizeof(inquiry_info));

    printf("Searching nearby devices.\n");

    // Inquires nearby bluetooth devices available.
    total_discovered_devices = hci_inquiry(bluetooth_device_id, INQUIRY_TIME, MAX_DISCOVERED_DEVICES, NULL, &inquiry_infos, inquiry_flags);
    if ( total_discovered_devices < 0 ) {
        error_message=malloc(ERROR_MESSAGE_SIZE*sizeof(char));
        sprintf(error_message, "Error discovering bluetooth devices (%d): %s", total_discovered_devices, strerror(errno));
        LOG_ERROR(error_message);
        perror("Enrror hci_inquiry!");
        return 1;
    }
    printf("Search completed. %d device(s) found.\n", total_discovered_devices);

    for ( counter=0; counter < total_discovered_devices; counter++) {
        var_inquiry_info=(inquiry_infos+counter);

        ba2str(&(var_inquiry_info->bdaddr), bluetooth_device_address);
        memset(bluetooth_device_name, 0, sizeof(bluetooth_device_name));

        // Gets the remote bluetooth device friendly name.
        if (hci_read_remote_name(bluetooth_device_socket, &(var_inquiry_info->bdaddr), sizeof(bluetooth_device_name), bluetooth_device_name, 0) < 0 ){
            strcpy(bluetooth_device_name, "[unknown]");
        }
        printf("%s  %s\n", bluetooth_device_address, bluetooth_device_name);
    }

    free(inquiry_infos);
    close(bluetooth_device_socket);

    return 0;
}
*/

int rfcomm_server(){
    struct sockaddr_rc local_address = { 0 };
    struct sockaddr_rc remote_device_address = { 0 };
    int listening_socket_file_descriptor;
    int client_socket_file_descriptor;
    char content_read[1024];
    int bytes_read;
    socklen_t opt = sizeof(remote_device_address);
    char remote_device_address_string[19] = { 0 };
    char remote_device_name[256] = { 0 };
    char log_message[1024];

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
    local_address.rc_channel = (uint8_t) 27;
    bind(listening_socket_file_descriptor, (struct sockaddr *)&local_address, sizeof(local_address));

    /*
     * Listens for connections on socket, defining the listening queue to a maximum of one.
     */
    listen(listening_socket_file_descriptor, 1);

    fd_set listening_socket_file_descriptor_fd_set;
    struct timeval tv;
    tv.tv_sec=(long)5;
    tv.tv_usec=0;
    int select_result;

    FD_ZERO(&listening_socket_file_descriptor_fd_set);
    FD_SET(listening_socket_file_descriptor, &listening_socket_file_descriptor_fd_set);

    select_result = select((listening_socket_file_descriptor+1), &listening_socket_file_descriptor_fd_set, (fd_set*)NULL, (fd_set*)NULL, &tv);
    if ( select_result = 0 ) {
        TRACE("Connection acceptance timeout.");
        return 1;
    }

    /*
     * Accepts one connection from the listening socket.
     */
    client_socket_file_descriptor = accept(listening_socket_file_descriptor, (struct sockaddr *)&remote_device_address, &opt);
    ba2str( &remote_device_address.rc_bdaddr, remote_device_address_string );

    if (hci_read_remote_name(client_socket_file_descriptor, &(remote_device_address.rc_bdaddr), sizeof(remote_device_name), remote_device_name, 0) < 0 ){
        sprintf(log_message, "Connected with device \"%s\".", remote_device_address_string);
    }
    else {
        sprintf(log_message, "Connected with device \"%s\" (%s).", remote_device_name, remote_device_address_string); 
    }
    TRACE(log_message);

    /*
     * Turns the remote bluetooth device address on a human-readable address.
     */


    /*
     * Read data from socket.
     */
    bytes_read = read(client_socket_file_descriptor, content_read, sizeof(content_read));
    if ( bytes_read < 0 ) {
        LOG_ERROR("Could not read content from remote bluetooth device.");
        return 1;
    }

    printf("Content received: %s\n", content_read);

    /*
     * Close sockets.
     */
    close(client_socket_file_descriptor);
    close(listening_socket_file_descriptor);
    return 0;
}
/*
int register_service(bluetooth_service_infos_t bluetooth_service_infos)
{
    
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
    // sdp_uuid128_create( &service_uuid, &service_uuid_int );
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

    
     // Connects the service to the local SDP server.
     // Observation: There is a bug on Ubuntu related to BlueZ version used. To correct it, follow the instructions listed on "https://bbs.archlinux.org/viewtopic.php?id=201672".
    session = sdp_connect( BDADDR_ANY, BDADDR_LOCAL, SDP_RETRY_IF_BUSY);

    // Register the service on SDP server.
    sdp_record_register(session, &record, 0);

    // Clean variables previously alocated. 
    sdp_data_free( channel_data );
    sdp_list_free( l2cap_list, 0 );
    sdp_list_free( rfcomm_list, 0 );
    sdp_list_free( public_browse_group_list, 0 );
    sdp_list_free( access_protocol_list, 0 );

    return 0;
}
*/

int main( int argc, char** argv){

    bluetooth_service_infos_t bluetooth_service_infos;

    /*
     *  Defines the bluetooth service UUID.
     *  Observation: Be careful when informing UUID. When it is passed to 
     *  service descriptor, its bytes order will be rearranged from big-endian
     *  to little-endian.
     */
    bluetooth_service_infos.uuid[0] = 0x964b93f5;
    bluetooth_service_infos.uuid[1] = 0xe6111001;
    bluetooth_service_infos.uuid[2] = 0x555e228d;
    bluetooth_service_infos.uuid[3] = 0x667c5017;

    const char* service_name = "Projeto Anna";
    const char* service_provider = "Marcelo de Moraes Leite";
    const char* service_description = "A service to communicate between the project's hardware and the smart device.";

    bluetooth_service_infos.name = malloc(strlen(service_name)*sizeof(char));
    bluetooth_service_infos.description = malloc(strlen(service_description)*sizeof(char));
    bluetooth_service_infos.provider = malloc(strlen(service_provider)*sizeof(char));

    strcpy(bluetooth_service_infos.name, service_name);
    strcpy(bluetooth_service_infos.provider, service_provider);
    strcpy(bluetooth_service_infos.description, service_description);

    //inquiry_devices();
    if ( register_service(bluetooth_service_infos) == 0 ) {
        rfcomm_server();
    }

    return 0;
}
