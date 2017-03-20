#include <string.h>

void copy_command(char* buffer, int command) {

    char* pointer = (char*)&command;

    memcpy(buffer, pointer, 4);
}
