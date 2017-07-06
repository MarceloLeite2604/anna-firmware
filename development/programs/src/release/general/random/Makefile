CC = gcc

toptargets := all clean

subdirs := $(wildcard */.)

objects_directory=$(OUTPUT_FILES_DIRECTORY)objects/
_objects = $(subst .c,.o,$(wildcard *.c))
ifneq ($(_objects),)
objects = $(patsubst %,$(objects_directory)%,$(_objects))
endif


$(toptargets): $(subdirs)

all: $(objects) $(subdirs) 

$(subdirs):
	@$(MAKE) -C $@ $(MAKECMDGOALS) OUTPUT_FILES_DIRECTORY=../$(OUTPUT_FILES_DIRECTORY)

$(objects_directory)%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

clean:
	rm -f $(objects)

.PHONY: $(toptargets) $(subdirs) $(objects_directory)
