#!/bin/bash

test_source_directory="../src/";
source_directory="../../src/";
objects_directory="objects/";
binary_folder="bin/";

echo "Creating \"log\" object.";
gcc -c ${source_directory}log/log.c -o ${objects_directory}log.o -g;
if [ $? -ne 0 ];
then
    echo "Error creating \"log\" object.";
    exit 1;
fi;

echo "Creating \"testlog\" object.";
gcc -c ${test_source_directory}testlog.c -I${source_directory} -o ${objects_directory}testlog.o -g;
if [ $? -ne 0 ];
then
    echo "Error creating \"testlog\" object.";
    exit 1;
fi;

echo "Creating \"testlog\" program.";
gcc -o ${binary_folder}testlog ${objects_directory}log.o ${objects_directory}testlog.o -g;

if [ $? -ne 0 ];
then
    echo "Error creating \"test\" object.";
    exit 1;
fi;

