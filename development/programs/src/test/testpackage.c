/*
 * The objetive of this source file is to test all bluetooth package functions. 
 *
 * Version: 0.1
 * Author: Marcelo Leite
 */

/*
 * Includes.
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include "../release/log/log.h"
#include "../release/general/error_messages/error_messages.h"
#include "../release/bluetooth/package/codes/codes.h"
#include "../release/bluetooth/package/package.h"

/*
 * Definitions.
 */
#define LOG_ROOT_DIRECTORY "../resources/tests/bluetooth/package/"

/*
 * Function headers.
 */
void print_byte_array(byte_array_t);
void test_packages();
void print_package(package_t);
void print_package_content(uint32_t, content_t);
void print_uint8_t_array(uint8_t*, size_t);


/*
 * Function elaborations.
 */

/*
 * Main function.
 */
int main(int argc, char** argv){

    test_packages();
    return 0;
}


/*
 * Tests "create_check_connection_package", "create_command_result_package", "create_confirmation_package", "create_disconnect_package", "create_error_package", "create_package_byte_array", "create_send_file_chunk_package", "create_send_file_header_package", "create_send_file_trailer_package" and "delete_package" functions.
 */
void test_packages(){
    printf("Testing \"create_check_connection_package\", \"create_command_result_package\", \"create_confirmation_package\", \"create_disconnect_package\", \"create_error_package\", \"create_package_byte_array\", \"create_send_file_chunk_package\", \"create_send_file_header_package\", \"create_send_file_trailer_package\" and \"delete_package\" functions.\n");

    char log_directory[256];
    
    strcpy(log_directory, LOG_ROOT_DIRECTORY);
    /* strcat(log_directory, "test_packages/"); */
    
    set_log_directory(log_directory);
    
    open_log_file("test_packages");

    package_t check_connection_package = create_check_connection_package();
    print_package(check_connection_package);
    byte_array_t check_connection_byte_array = create_package_byte_array(check_connection_package);
    printf("Check connection byte array:\n");
    print_byte_array(check_connection_byte_array);
    printf("\n");
    delete_byte_array(check_connection_byte_array);
    delete_package(check_connection_package);
    
    package_t command_result_package  = create_command_result_package(0x2236);
    print_package(command_result_package);
    byte_array_t command_result_byte_array = create_package_byte_array(command_result_package);
    printf("Command result byte array:\n");
    print_byte_array(command_result_byte_array);
    printf("\n");
    delete_byte_array(command_result_byte_array);
    delete_package(command_result_package);

    package_t confirmation_package = create_confirmation_package(0xaabbccdd);
    print_package(confirmation_package);
    byte_array_t confirmation_byte_array = create_package_byte_array(confirmation_package);
    printf("Confirmation byte array:\n");
    print_byte_array(confirmation_byte_array);
    printf("\n");
    delete_byte_array(confirmation_byte_array);
    delete_package(confirmation_package);

    package_t disconnect_package = create_disconnect_package();
    print_package(disconnect_package);
    byte_array_t disconnect_byte_array = create_package_byte_array(disconnect_package);
    printf("Disconnect byte array:\n");
    print_byte_array(disconnect_byte_array);
    printf("\n");
    delete_byte_array(disconnect_byte_array);
    delete_package(disconnect_package);

    uint32_t error_code = 0xc;
    package_t error_package = create_error_package(error_code, error_messages[error_code]);
    print_package(error_package);
    byte_array_t error_byte_array = create_package_byte_array(error_package);
    printf("Error byte array:\n");
    print_byte_array(error_byte_array);
    printf("\n");
    delete_byte_array(error_byte_array);
    delete_package(error_package);

    size_t chunk_size = 256;
    uint8_t chunk_data[chunk_size];
    memset(chunk_data, 0x22, chunk_size);
    package_t send_file_chunk_package = create_send_file_chunk_package(chunk_size, chunk_data);
    print_package(send_file_chunk_package);
    byte_array_t send_file_chunk_byte_array = create_package_byte_array(send_file_chunk_package);
    printf("Send file chunk byte array:\n");
    print_byte_array(send_file_chunk_byte_array);
    printf("\n");
    delete_byte_array(send_file_chunk_byte_array);
    delete_package(send_file_chunk_package);

    char* file_name = "20170309_141802.mp3";
    int file_size = (int)(3.128*1024*1024);
    package_t send_file_header_package = create_send_file_header_package(file_size, file_name);
    print_package(send_file_header_package);
    byte_array_t send_file_header_byte_array = create_package_byte_array(send_file_header_package);
    printf("Send file header byte array:\n");
    print_byte_array(send_file_header_byte_array);
    printf("\n");
    delete_byte_array(send_file_header_byte_array);
    delete_package(send_file_header_package);

    package_t send_file_trailer_package = create_send_file_trailer_package();
    print_package(send_file_trailer_package);
    byte_array_t send_file_trailer_byte_array = create_package_byte_array(send_file_trailer_package);
    printf("Send file trailer byte array:\n");
    print_byte_array(send_file_trailer_byte_array);
    printf("\n");
    delete_byte_array(send_file_trailer_byte_array);
    delete_package(send_file_trailer_package);

    close_log_file();
}

void print_package(package_t package) {
    printf("Package header...: 0x%x\n", package.header);
    printf("Package id.......: 0x%x\n", package.id);
    printf("Package type code: 0x%x\n", package.type_code);
    print_package_content(package.type_code, package.content);
    printf("Package trailer..: 0x%x\n\n", package.trailer);
}

void print_package_content(uint32_t package_type, content_t content){
    printf("Package content..:\n");

    switch (package_type) {
        case CHECK_CONNECTION_CODE:
        case DISCONNECT_CODE:
            printf("\tThis type of package does not have a content.\n");
            break;
        case CONFIRMATION_CODE:
            printf("\tConfirmation code: 0x%x\n", content.confirmation_content->package_id);
            break;
        case ERROR_CODE:
            printf("\tError code........: 0x%x\n", content.error_content->error_code);
            printf("\tError message size: 0x%x\n", content.error_content->error_message_size);
            printf("\tError message.....: \"");
            print_uint8_t_array(content.error_content->error_message, content.error_content->error_message_size);
            printf("\"\n");
            break;
        case COMMAND_RESULT_CODE:
            printf("\tCommand result: 0x%x\n", content.command_result_content->result_code);
            break;
        case SEND_FILE_HEADER_CODE:
            printf("\tFile header code: 0x%x\n", content.send_file_header_content->file_header);
            printf("\tFile size.......: 0x%x\n", content.send_file_header_content->file_size);
            printf("\tFile name size..: 0x%x\n", content.send_file_header_content->file_name_size);
            printf("\tFile name.......: \"");
            print_uint8_t_array(content.send_file_header_content->file_name, content.send_file_header_content->file_name_size);
            printf("\"\n");
            break;
        case SEND_FILE_CHUNK_CODE:
            printf("\tFile content code: 0x%x\n", content.send_file_chunk_content->file_content);
            printf("\tChunk size: 0x%x\n", content.send_file_chunk_content->chunk_size);
            byte_array_t chunk_data;
            chunk_data.size = content.send_file_chunk_content->chunk_size;
            chunk_data.data = (uint8_t*)malloc(chunk_data.size*sizeof(uint8_t));
            memcpy(chunk_data.data, content.send_file_chunk_content->chunk_data, chunk_data.size);
            printf("\tChunk_data:\n");
            print_byte_array(chunk_data);
            delete_byte_array(chunk_data);
            break;
        case SEND_FILE_TRAILER_CODE:
            printf("\tFile trailer code: 0x%x\n", content.send_file_trailer_content->file_trailer);
            break;
        default:
            printf("Unknown package type!\n");
            break;
    }
}

void print_byte_array(byte_array_t byte_array) {
    size_t counter;

    for (counter = 0; counter < byte_array.size; counter++){
        if (counter != 0 ) {
            if (counter%16 == 0 ) {
                printf("\n");
            }
            else {
                if ( counter%4 == 0 ) {
                    printf("  ");
                }
            }
        }
        printf("0x%02x ", byte_array.data[counter]);
    }
    if ( counter != 0 && counter%16 == 0 ) {
        printf("\n");
    }
}

void print_uint8_t_array(uint8_t* array, size_t array_size) {
    size_t counter;
    for (counter = 0; counter < array_size; counter++) {
        printf("%c", (unsigned char)array[counter]);
    }
}
