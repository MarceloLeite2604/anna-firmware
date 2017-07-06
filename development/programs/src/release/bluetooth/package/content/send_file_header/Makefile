CC = gcc
objects_directory=$(OUTPUT_FILES_DIRECTORY)objects/

_objects = $(subst .c,.o,$(wildcard *.c))
ifneq ($(_objects),)
objects = $(patsubst %,$(objects_directory)%,$(_objects));
endif

subdirs := $(wildcard */.)

all: $(objects) $(subdirs) 

$(subdirs):
	@$(MAKE) -C $@ OUTPUT_FILES_DIRECTORY=../$(OUTPUT_FILES_DIRECTORY)

$(objects_directory)%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

clean:
	rm $(objects)

.PHONY: clean $(subdirs) $(objects_directory)
