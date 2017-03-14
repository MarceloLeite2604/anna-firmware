/*
 * This source file contains all functions required to create a bluetooth service and communicate with the connected device.
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdlib.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>
#include "bluetooth.h"
#include "../log/log.h"

/*
 * Private global variables.
 */

// Informations about the registered bluetooth service.
bluetooth_service_infos_t registered_bluetooth_service_infos;

// Session indicating the connection to bluetooth service provider.
sdp_session_t* sdp_connect_session;


/*
 * Private function declarations.
 */

/*
 * Defines the information about the registered bluetooth service.
 */
int set_registered_bluetooth_service_infos(bluetooth_service_infos_t);

/*
 * Removes the service from bluetooth service provider.
 */
int clear_registered_bluetooth_device_infos();

/*
 * Functions elaboration.
 */

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

    set_registered_bluetooth_service_infos(bluetooth_service_infos);
    sdp_connect_session = session;

    return 0;
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
        clear_registered_bluetooth_device_infos();
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
int set_registered_bluetooth_service_infos(bluetooth_service_infos_t bluetooth_service_infos) {
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
}

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
int clear_registered_bluetooth_device_infos() {
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
}

