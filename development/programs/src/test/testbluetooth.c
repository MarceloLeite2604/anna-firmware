#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>
#include <bluetooth/rfcomm.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include "log/log.h"
#include <inttypes.h>

#define ERROR_MESSAGE_SIZE 512

#define MAX_DISCOVERED_DEVICES 10

// Observation: On "hci_inquiry" function, the "len" is used to define inquiry time as "1.28 * len".
#define INQUIRY_TIME 3

int inquiry_devices(){
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

    /*
     * Returns the resource number of the first available bluetooth adapter.
     * Observation: Bluetooth must be enable/activated on system.
     */
    bluetooth_device_id = hci_get_route(NULL);
    if ( bluetooth_device_id < 0 ) {
        LOG_ERROR("Could not find bluetooth device.");
        return 1;
    }

    /*
     * Opens a socket communication with the bluetooth device.
     */
    bluetooth_device_socket = hci_open_dev(bluetooth_device_id);
    if ( bluetooth_device_socket < 0 ) {
        LOG_ERROR("Could not open socket with bluetooh device.");
        return 1;
    }

    /*
     * Observation: IRQ_CACHE_FLUSH ignores results from previous inquires.
     */
    inquiry_flags = IREQ_CACHE_FLUSH;

    inquiry_infos = malloc(MAX_DISCOVERED_DEVICES * sizeof(inquiry_info));

    printf("Searching nearby devices.\n");

    /*
     * Inquires nearby bluetooth devices available.
     */
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

        /*
         * Gets the remote bluetooth device friendly name.
         */
        if (hci_read_remote_name(bluetooth_device_socket, &(var_inquiry_info->bdaddr), sizeof(bluetooth_device_name), bluetooth_device_name, 0) < 0 ){
            strcpy(bluetooth_device_name, "[unknown]");
        }
        printf("%s  %s\n", bluetooth_device_address, bluetooth_device_name);
    }

    free(inquiry_infos);
    close(bluetooth_device_socket);

    return 0;
}

int rfcomm_server(){
    struct sockaddr_rc local_address = { 0 };
    struct sockaddr_rc remote_device_address = { 0 };
    char remote_device_address_string[19] = { 0 };
    int listening_socket_file_descriptor;
    int client_socket_file_descriptor;
    char content_read[1024];
    int bytes_read;
    socklen_t opt = sizeof(remote_device_address);

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
    local_address.rc_channel = (uint8_t) 1;
    bind(listening_socket_file_descriptor, (struct sockaddr *)&local_address, sizeof(local_address));

    /*
     * Listens for connections on socket, defining the listening queue to a maximum of one.
     */
    listen(listening_socket_file_descriptor, 1);

    /*
     * Accepts one connection from the listening socket.
     */
    printf("Waiting for bluetooth connections.\n");
    client_socket_file_descriptor = accept(listening_socket_file_descriptor, (struct sockaddr *)&remote_device_address, &opt);

    printf("Connection created.\n");

    /*
     * Turns the remote bluetooth device address on a human-readable address.
     */
    ba2str( &remote_device_address.rc_bdaddr, remote_device_address_string );
    printf("Remote device address: %s\n", remote_device_address_string);
    memset(remote_device_address_string, 0, sizeof(remote_device_address_string));

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

int register_service()
{
    // uint32_t svc_uuid_int[] = { 0x7b6b1238, 0x52d34516, 0x9e1ec8c1, 0xaa1bdd49 };
    // uint32_t svc_uuid_int[] = { 0xf5934b96, 0x011011e6, 0x8d225e55, 0x17507c66 };
    uint32_t svc_uuid_int[] = { 0x964b93f5, 0xe6111001, 0x555e228d, 0x667c5017 };
    printf("Service UUID: %" PRIu32 ".\n", svc_uuid_int[3]);
    // uint8_t rfcomm_port = 11;
    uint8_t rfcomm_channel = 3;
    const char *service_name = "Projeto Anna";
    const char *service_dsc = "This is my project description";
    const char *service_prov = "Marcelo";

    uuid_t root_uuid;
    uuid_t l2cap_uuid;
    uuid_t rfcomm_uuid;
    uuid_t svc_uuid;
    uuid_t svc_class_uuid;
    sdp_list_t *l2cap_list = 0;
    sdp_list_t *rfcomm_list = 0;
    sdp_list_t *root_list = 0;
    sdp_list_t *proto_list = 0;
    sdp_list_t *access_proto_list = 0;
    sdp_list_t *svc_class_list = 0;
    sdp_list_t *profile_list = 0;
    sdp_data_t *channel = 0;
    sdp_profile_desc_t profile;
    sdp_record_t record = { 0 };
    sdp_session_t *session = 0;
    int service_availability_time = 20;

    // PART ONE
    // set the general service ID
    sdp_uuid128_create( &svc_uuid, &svc_uuid_int );
    //printf("%x %x.\n", svc_uuid, svc_uuid_int);
    sdp_set_service_id( &record, svc_uuid );

    // set the service class
    sdp_uuid16_create(&svc_class_uuid, SERIAL_PORT_SVCLASS_ID);
    // printf("%x", SERIAL_PORT_SVCLASS_ID);
    // svc_class_list = sdp_list_append(0, &svc_class_uuid);
    svc_class_list = sdp_list_append(0, &svc_uuid);
    sdp_set_service_classes(&record, svc_class_list);

    // set the Bluetooth profile information
    sdp_uuid16_create(&profile.uuid, SERIAL_PORT_PROFILE_ID);
    profile.version = 0x0100;
    profile_list = sdp_list_append(0, &profile);
    sdp_set_profile_descs(&record, profile_list);

    // make the service record publicly browsable
    sdp_uuid16_create(&root_uuid, PUBLIC_BROWSE_GROUP);
    root_list = sdp_list_append(0, &root_uuid);
    sdp_set_browse_groups( &record, root_list );

    // set l2cap information
    sdp_uuid16_create(&l2cap_uuid, L2CAP_UUID);
    l2cap_list = sdp_list_append( 0, &l2cap_uuid );
    proto_list = sdp_list_append( 0, l2cap_list );

    // register the RFCOMM channel for RFCOMM sockets
    sdp_uuid16_create(&rfcomm_uuid, RFCOMM_UUID);
    channel = sdp_data_alloc(SDP_UINT8, &rfcomm_channel);
    rfcomm_list = sdp_list_append( 0, &rfcomm_uuid );
    sdp_list_append( rfcomm_list, channel );
    sdp_list_append( proto_list, rfcomm_list );
    access_proto_list = sdp_list_append( 0, proto_list );
    sdp_set_access_protos( &record, access_proto_list );

    // set the name, provider, and description
    sdp_set_info_attr(&record, service_name, service_prov, service_dsc);

    // PART TWO
    // connect to the local SDP server, register the service record, and
    // disconnect
    /*
     * Observation: There is a bug on Ubuntu related to BlueZ version used. To correct it, follow the instructions listed on "https://bbs.archlinux.org/viewtopic.php?id=201672".
     */
    session = sdp_connect( BDADDR_ANY, BDADDR_LOCAL, SDP_RETRY_IF_BUSY);
    printf("session: %p.\n", session);
    sdp_record_register(session, &record, 0);

    // cleanup
    sdp_data_free( channel );
    sdp_list_free( l2cap_list, 0 );
    sdp_list_free( rfcomm_list, 0 );
    sdp_list_free( root_list, 0 );
    sdp_list_free( access_proto_list, 0 );

    printf("Service will be available for %d seconds.\n", service_availability_time);
    sleep(service_availability_time);
    sdp_close(session);
    return 0;
}

int main( int argc, char** argv){
    //inquiry_devices();
    //rfcomm_server();
    register_service();

    return 0;
}
