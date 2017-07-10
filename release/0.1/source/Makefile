# This Makefile creates an object for each "C" source file found on current directory.
#
# Parameters:
#   TARGET - The target which is being built.
#   ADDITIONAL_C_FLAGS_OBJECTS - Addicional flags to inform on compilator execution to create the objects. (Optional)
#   OUTPUT_FILES_DIRECTORY - Path to the directory which the output files will be created.
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
ifeq ($(TARGET),)
$(error Parameter "TARGET" not informed)
endif

# Defines the compilator to use.
CC = gcc

# Default flags used to compile.
CFLAGS = -Wall

# Top targets of this Makefile.
toptargets := all clean

# Subdirectories of this directory.
subdirs := $(wildcard */.)
subdirs := $(filter-out include/., $(subdirs))

# Path to the target directory where files will be created.
ifeq ($(OUTPUT_FILES_DIRECTORY),)
output_files_directory=../../build/$(TARGET)/
else
output_files_directory=$(OUTPUT_FILES_DIRECTORY)
endif

# Path to the root directory where the header files are stored.
include_files_directory=include/

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
parameters_make_subdirectories = OUTPUT_FILES_DIRECTORY=../$(output_files_directory)
parameters_make_subdirectories += INCLUDE_FILES_DIRECTORY=../$(include_files_directory)
parameters_make_subdirectories += ADDITIONAL_C_FLAGS_OBJECTS=$(ADDITIONAL_C_FLAGS_OBJECTS)

_muni_dependencies=audio.o communication.o connection.o command_result.o confirmation.o content.o error.o send_file_chunk.o send_file_header.o send_file_trailer.o package.o service.o directory.o byte_array.o error_messages.o file.o random.o instant.o wait_time.o log.o muni.o script.o 
muni_dependencies = $(patsubst %,$(objects_directory)%,$(_muni_dependencies))

muni_libs= -lbluetooth -lm

muni_program_path = $(binaries_directory)muni

_store_instant_dependencies=directory.o script.o instant.o log.o store_instant.o

store_instant_dependencies = $(patsubst %,$(objects_directory)%,$(_store_instant_dependencies))

store_instant_libs=-lm

store_instant_program_path = $(binaries_directory)store_instant

# Programs built by this Makefile.
programs=muni store_instant

$(toptargets): $(subdirs)

all: $(subdirs) $(programs)

$(subdirs):
	@$(MAKE) -C $@ $(MAKECMDGOALS) $(parameters_make_subdirectories)

$(objects_directory)%.o: %.c
	$(CC) -c -o $@ $< $(cflags_objects) -I$(include_files_directory)

muni: $(muni_program_path)

$(muni_program_path): $(muni_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) -I$(include_files_directory) $(muni_libs)

store_instant: $(store_instant_program_path)

$(store_instant_program_path): $(store_instant_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) -I$(include_files_directory) $(store_instant_libs)

clean:
	rm -f $(muni_program_path)
	rm -f $(store_instant_program_path)
	rm -f $(objects)

.PHONY: $(toptargets) $(subdirs) $(objects_directory) $(programs)

