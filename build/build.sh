#!/bin/bash

test_source_folder="../test/src";
source_folder="../src/";
objects_folder="objects/";

echo "Creating \"log\" object.";
gcc -c ${source_folder}log/log.c -o ${objects_folder}log.o;
if [ $? -ne 0 ];
then
    echo "Error creating \"log\" object.";
    exit 1;
fi;
