# This Makefile creates an object for each "C" source file found on current directory.
#
# Parameters:
#   INCLUDE_FILES_DIRECTORY - Path to the root directory where the header files are stored.
# 	OUTPUT_FILES_DIRECTORY - Path to the root directory where the "objects" directory is. This directory will be the output directory to the objects created.
#	ADDITIONAL_C_FLAGS_OBJECTS - Addicional flags to inform on compilator execution to create the objects. (Optional)
#
# Version:
# 	0.1
#
# Author:
# 	Marcelo Leite.

# Check Makefile parameters.
ifeq ($(INCLUDE_FILES_DIRECTORY),)
$(error Parameter "INCLUDE_FILES_DIRECTORY" not informed)
endif

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

# Directory where the objects created will be deployed.
objects_directory=$(OUTPUT_FILES_DIRECTORY)objects/

# Objects this Makefile should create.
_objects = $(subst .c,.o,$(wildcard *.c))

# If there are objects to create for this Makefile.
ifneq ($(_objects),)
# Define the path of the objects to be created.	
objects = $(patsubst %,$(objects_directory)%,$(_objects))
endif

# Flags informed to the compilator to create the objects.
cflags_objects=$(CFLAGS) $(ADDITIONAL_C_FLAGS_OBJECTS)

# Parameter to inform when executing makefiles on subdirectories.
parameters_make_subdirectories = OUTPUT_FILES_DIRECTORY=../$(OUTPUT_FILES_DIRECTORY)
parameters_make_subdirectories += INCLUDE_FILES_DIRECTORY=../$(INCLUDE_FILES_DIRECTORY)
parameters_make_subdirectories += ADDITIONAL_C_FLAGS_OBJECTS=$(ADDITIONAL_C_FLAGS_OBJECTS)

$(toptargets): $(subdirs)

all: $(objects) $(subdirs) 

$(subdirs):
	@$(MAKE) -C $@ $(MAKECMDGOALS) $(parameters_make_subdirectories)

$(objects_directory)%.o: %.c
	$(CC) -c -o $@ $< $(cflags_objects) -I$(INCLUDE_FILES_DIRECTORY)

clean:
	rm -f $(objects)

.PHONY: $(toptargets) $(subdirs) $(objects_directory)
