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
#include <byteswap.h>
#include "../release/bluetooth/bluetooth.h"
#include "../release/log/log.h"
#include "../release/bluetooth/package/package.h"
#include "../release/bluetooth/package/codes/codes.h"
#include "../release/general/error_messages/error_messages.h"

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
    struct timeval wait_connection_time;
    int client_socket_id;
    struct timeval read_content_time;
    char* buffer;
    int buffer_size = 1024;
    int read_result;
    int counter;

    /*
    package_code_t package_code = confirmation_code;
    printf("Package code length: %d.\n", (int)sizeof(package_code_t));
    printf("%x %x %x %x\n", package_code.data[0], package_code.data[1], package_code.data[2], package_code.data[3]);

    printf("Error message 1: \"%s\"\n", error_messages[1]);
    */

    content_t content;

    byte_array_t file_chunk;

    file_chunk.size = 256;

    file_chunk.data = (uint8_t*)malloc(file_chunk.size*sizeof(uint8_t));
    memset(file_chunk.data, 0x22, file_chunk.size);

    package_t package;
    /* package = create_package(ERROR_CODE); */



    /* content = create_confirmation_content(0xabcdef10); */
    /* content = create_result_content(1); */
    /* content = create_error_content(2, ERROR_MESSAGE_002); */
    /* content = create_send_file_header_content(4*1024*1024, "20170331_180432.mp3"); */
    /* content = create_send_file_chunk_content(file_chunk.size, file_chunk.data); */
    /* content = create_send_file_trailer_content(); */
    package.content = content;

    byte_array_t byte_array;
    /* byte_array = create_confirmation_content_byte_array(content); */
    /* byte_array = create_result_content_byte_array(content); */
    /* byte_array = create_error_content_byte_array(content); */
    /* byte_array = create_send_file_header_content_byte_array(content); */
    /* byte_array = create_send_file_chunk_content_byte_array(content);  */
    /* byte_array = create_send_file_trailer_content_byte_array(content); */
    byte_array = create_package_byte_array(package);

    
    for (counter = 0; counter < byte_array.size; counter++ ) {
        printf("%02x ", byte_array.data[counter]);
    }
    printf("\n");
    

    /*
    for (counter = 0; counter < error_content_byte_array.size; counter++ ) {
        printf("%c", (unsigned char)error_content_byte_array.data[counter]);
    }
    printf("\n");
    */



    /*
    char command[4];

    copy_command(command, START_RECORD);
    printf("%02x %02x %02x %02x\n", command[0], command[1], command[2], command[3]);
    */

   /* Defines the time to wait for a connection as 30 seconds. */
    /* wait_connection_time.tv_sec = 30; 
    wait_connection_time.tv_usec = 0; */

    /* Defines the time to wait for a content to read as 1 second. */
    /* read_content_time.tv_sec = 1;
    read_content_time.tv_usec = 0; */
    

    /*
     *  Defines the bluetooth service UUID.
     *  Observation: Be careful when informing UUID. When it is passed to 
     *  service descriptor, its bytes order will be rearranged from big-endian
     *  to little-endian.
     */
    /* bluetooth_service_infos.uuid[0] = 0x964b93f5;
    bluetooth_service_infos.uuid[1] = 0xe6111001;
    bluetooth_service_infos.uuid[2] = 0x555e228d;
    bluetooth_service_infos.uuid[3] = 0x667c5017;

    const char* service_name = "Projeto Anna";
    const char* service_provider = "Marcelo de Moraes Leite";
    const char* service_description = "A service to create a communication channel between the project's hardware and the smart device.";

    bluetooth_service_infos.name = malloc(strlen(service_name)*sizeof(char));
    bluetooth_service_infos.description = malloc(strlen(service_description)*sizeof(char));
    bluetooth_service_infos.provider = malloc(strlen(service_provider)*sizeof(char));

    strcpy(bluetooth_service_infos.name, service_name);
    strcpy(bluetooth_service_infos.provider, service_provider);
    strcpy(bluetooth_service_infos.description, service_description);

    //inquiry_devices();
    TRACE("Registering bluetooth service.");
    if ( register_service(bluetooth_service_infos) != 0 ) {
        LOG_ERROR("Error registering bluetooth service.");
        return 1;
    }

    TRACE("Waiting for a connection.");
    client_socket_id = accept_connection(wait_connection_time);
    if ( client_socket_id < 0 ) {
        LOG_ERROR("Error while waiting for a client connection.");
        return 1;
    }
    else {
        if ( client_socket_id == 0 ) {
            TRACE("No client to stablish a connection.");

            if ( remove_service() != 0 ) {
                LOG_ERROR("Error while removing bluetooth service.");
                return 1;
            } 
            TRACE("Bluetooth service removed.");

            return 1;
        } 
    }

    TRACE("Connection stablished with a client.");

    buffer = malloc(buffer_size*sizeof(char));

    while (1) {
        read_result = read_bluetooth_socket(client_socket_id, buffer, buffer_size, read_content_time);
        if ( read_result > 0 ) {
            printf("%d bytes read from socket.\n", read_result);
            for (counter = 0; counter < read_result; counter++) {
                printf("%02x ", buffer[counter]);
            }
            printf("\n");
        }
        else {
            if ( read_result < 0 ) {
                printf("Error while reading content from socket.\n");
                break;
            }
        }
    }

    free(buffer);

    close(client_socket_id);

    if ( remove_service() != 0 ) {
        LOG_ERROR("Error while removing bluetooth service.");
        return 1;
    } 

    TRACE("Bluetooth service removed.");
    */

    return 0;
}
#include <stdio.h>
