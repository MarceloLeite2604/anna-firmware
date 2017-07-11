# This Makefile creates an object for each "C" source file found on current directory.
#
# Parameters:
#   OUTPUT_FILES_DIRECTORY - Path to the directory which the output files will be created.
#   ADDITIONAL_C_FLAGS_OBJECTS - Addicional flags to inform on compilator execution to create the objects. (Optional)
#
# Observations: 
#    When using the "OUTPUT_FILES_DIRECTORY" parameter, the path must be relative to this Makefile, otherwise the fila creation will fail.
#
# Version:
#   0.1
#
# Author:
#   Marcelo Leite.

# Check Makefile parameters.
ifeq ($(OUTPUT_FILES_DIRECTORY),)
$(error Parameter "OUTPUT_FILES_DIRECTORY" not informed)
endif

# Defines the compilator to use.
CC = gcc

# Default flags used to compile.
CFLAGS = -Wall

# Top targets of this Makefile.
toptargets := all clean

# Subdirectories of this directory.
subdirs := $(wildcard */.)

# Path to the target directory where files will be created.
ifeq ($(OUTPUT_FILES_DIRECTORY),)
output_files_directory=../../build/$(TARGET)/
else
output_files_directory=$(OUTPUT_FILES_DIRECTORY)
endif
output_files_directory := $(realpath $(output_files_directory))/

# Path to the root directory where the header files are stored.
include_files_directory=../release/include/

# Path to the directory where the objects will be created.
objects_directory=$(output_files_directory)objects/

# Objects this Makefile should create.
_objects = $(subst .c,.o,$(wildcard *.c))

# If there are objects to create for this Makefile.
ifneq ($(_objects),)
# Define the path of the objects to be created. 
objects = $(patsubst %,$(objects_directory)%,$(_objects))
endif

# Path to the directory where the binaries will be created.
binaries_directory=$(output_files_directory)bin/

# Flags informed to the compilator to create the objects.
cflags_objects=$(CFLAGS) $(ADDITIONAL_C_FLAGS_OBJECTS)

# Parameter to inform when executing makefiles on subdirectories.
# parameters_make_subdirectories = OUTPUT_FILES_DIRECTORY=../$(output_files_directory)
parameters_make_subdirectories = OUTPUT_FILES_DIRECTORY=$(output_files_directory)
parameters_make_subdirectories += INCLUDE_FILES_DIRECTORY=../$(include_files_directory)
parameters_make_subdirectories += ADDITIONAL_C_FLAGS_OBJECTS=$(ADDITIONAL_C_FLAGS_OBJECTS)

# Informations about "testaudio" program.
_testaudio_dependencies= audio.o directory.o file.o instant.o log.o script.o testaudio.o
testaudio_dependencies = $(patsubst %,$(objects_directory)%,$(_testaudio_dependencies))
testaudio_libs= -lm
testaudio_program_path = $(binaries_directory)testaudio

# Informations about "testbluetooth" program.
_testbluetooth_dependencies= byte_array.o confirmation.o content.o command_result.o directory.o error.o instant.o log.o package.o random.o script.o send_file_chunk.o send_file_header.o send_file_trailer.o testbluetooth.o
testbluetooth_dependencies = $(patsubst %,$(objects_directory)%,$(_testbluetooth_dependencies))
testbluetooth_libs= -lm
testbluetooth_program_path = $(binaries_directory)testbluetooth

# Informations about "testdirectory" program.
_testdirectory_dependencies= directory.o instant.o log.o script.o testdirectory.o
testdirectory_dependencies = $(patsubst %,$(objects_directory)%,$(_testdirectory_dependencies))
testdirectory_libs= -lm
testdirectory_program_path = $(binaries_directory)testdirectory

# Informations about "testlog" program.
_testlog_dependencies= directory.o instant.o log.o script.o testlog.o
testlog_dependencies = $(patsubst %,$(objects_directory)%,$(_testlog_dependencies))
testlog_libs= -lm
testlog_program_path = $(binaries_directory)testlog

# Informations about "testpackage" program.
_testpackage_dependencies= byte_array.o confirmation.o content.o command_result.o directory.o error.o error_messages.o instant.o log.o package.o random.o script.o send_file_chunk.o send_file_header.o send_file_trailer.o testpackage.o
testpackage_dependencies = $(patsubst %,$(objects_directory)%,$(_testpackage_dependencies))
testpackage_libs= -lm
testpackage_program_path = $(binaries_directory)testpackage

# Informations about "testscript" program.
_testscript_dependencies= testscript.o
testscript_dependencies = $(patsubst %,$(objects_directory)%,$(_testscript_dependencies))
testscript_libs= -lm
testscript_program_path = $(binaries_directory)testscript

# Informations about "testswaittime" program.
_testwaittime_dependencies= directory.o instant.o log.o script.o testwaittime.o wait_time.o
testwaittime_dependencies = $(patsubst %,$(objects_directory)%,$(_testwaittime_dependencies))
testwaittime_libs= -lm
testwaittime_program_path = $(binaries_directory)testwaittime

# Programs built by this Makefile.
programs=testaudio testbluetooth testdirectory testlog testpackage testscript testwaittime

$(toptargets): $(subdirs)

all: $(subdirs) $(programs)
$(subdirs):
	@$(MAKE) -C $@ $(MAKECMDGOALS) $(parameters_make_subdirectories)

$(objects_directory)%.o: %.c
	$(CC) -c -o $@ $< $(cflags_objects) -I$(include_files_directory)

testaudio: $(testaudio_program_path)

$(testaudio_program_path): $(testaudio_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) -I$(include_files_directory) $(testaudio_libs)

testbluetooth: $(testbluetooth_program_path)

$(testbluetooth_program_path): $(testbluetooth_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) -I$(include_files_directory) $(testbluetooth_libs)

testdirectory: $(testdirectory_program_path)

$(testdirectory_program_path): $(testdirectory_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) -I$(include_files_directory) $(testdirectory_libs)

testlog: $(testlog_program_path)

$(testlog_program_path): $(testlog_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) -I$(include_files_directory) $(testlog_libs)

testpackage: $(testpackage_program_path)

$(testpackage_program_path): $(testpackage_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) -I$(include_files_directory) $(testpackage_libs)

testscript: $(testscript_program_path)

$(testscript_program_path): $(testscript_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) -I$(include_files_directory) $(testscript_libs)

testwaittime: $(testwaittime_program_path)

$(testwaittime_program_path): $(testwaittime_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) -I$(include_files_directory) $(testwaittime_libs)

clean:
	rm -f $(testaudio_program_path)
	rm -f $(testbluetooth_program_path)
	rm -f $(testdirectory_program_path)
	rm -f $(testlog_program_path)
	rm -f $(testpackage_program_path)
	rm -f $(testscript_program_path)
	rm -f $(testwaittime_program_path)
	rm -f $(objects)

.PHONY: $(toptargets) $(subdirs) $(objects_directory) $(programs)

