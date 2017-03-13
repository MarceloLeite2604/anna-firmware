#!/bin/bash

source_directory="../../src/";
release_source_directory="${source_directory}release/";
test_source_directory="${source_directory}test/";
objects_directory="objects/";
binary_folder="bin/";

echo "Building debug objects.";

echo "Creating \"log\" object.";
gcc -c ${release_source_directory}log/log.c -o ${objects_directory}log.o -g;
if [ $? -ne 0 ];
then
    echo "Error creating \"log\" object.";
    exit 1;
fi;

echo "Creating \"directory\" object.";
gcc -c ${release_source_directory}directory/directory.c -o ${objects_directory}directory.o -g;
if [ $? -ne 0 ];
then
    echo "Error creating \"directory\" object.";
    exit 1;
fi;

echo "Creating \"script\" object.";
gcc -c ${release_source_directory}script/script.c -o ${objects_directory}script.o -g;
if [ $? -ne 0 ];
then
    echo "Error creating \"script\" object.";
    exit 1;
fi;

echo "Creating \"audio\" object.";
gcc -c ${release_source_directory}audio/audio.c -o ${objects_directory}audio.o -g;
if [ $? -ne 0 ];
then
    echo "Error creating \"audio\" object.";
    exit 1;
fi;

echo "Creating \"testlog\" object.";
gcc -c ${test_source_directory}testlog.c -I${release_source_directory} -o ${objects_directory}testlog.o -g;
if [ $? -ne 0 ];
then
    echo "Error creating \"testlog\" object.";
    exit 1;
fi;

echo "Creating \"testlog\" program.";
gcc -o ${binary_folder}testlog ${objects_directory}log.o ${objects_directory}testlog.o -g;

if [ $? -ne 0 ];
then
    echo "Error creating \"testlog\" object.";
    exit 1;
fi;

echo "Creating \"testdirectory\" object.";
gcc -c ${test_source_directory}testdirectory.c -I${release_source_directory} -o ${objects_directory}testdirectory.o -g;
if [ $? -ne 0 ];
then
    echo "Error creating \"testdirectory\" object.";
    exit 1;
fi;

echo "Creating \"testdirectory\" program.";
gcc -o ${binary_folder}testdirectory ${objects_directory}directory.o ${objects_directory}testdirectory.o -g;

if [ $? -ne 0 ];
then
    echo "Error creating \"testdirectory\" object.";
    exit 1;
fi;

echo "Creating \"testscript\" object.";
gcc -c ${test_source_directory}testscript.c -I${release_source_directory} -o ${objects_directory}testscript.o -g;
if [ $? -ne 0 ];
then
    echo "Error creating \"testdirectory\" object.";
    exit 1;
fi;

echo "Creating \"testscript\" program.";
gcc -o ${binary_folder}testscript ${objects_directory}script.o ${objects_directory}log.o ${objects_directory}directory.o ${objects_directory}testscript.o -g;

if [ $? -ne 0 ];
then
    echo "Error creating \"testscript\" object.";
    exit 1;
fi;

echo "Creating \"testaudio\" object.";
gcc -c ${test_source_directory}testaudio.c -I${release_source_directory} -o ${objects_directory}testaudio.o -g;
if [ $? -ne 0 ];
then
    echo "Error creating \"testaudio\" object.";
    exit 1;
fi;

echo "Creating \"testaudio\" program.";
gcc -o ${binary_folder}testaudio ${objects_directory}log.o ${objects_directory}directory.o ${objects_directory}script.o ${objects_directory}audio.o ${objects_directory}testaudio.o -g;

if [ $? -ne 0 ];
then
    echo "Error creating \"testaudio\" object.";
    exit 1;
fi;
