CC = gcc
LIBS = -lbluetooth -lm

toptargets := all clean muni store_instant

subdirs := $(wildcard */.)

objects_directory=$(OUTPUT_FILES_DIRECTORY)objects/

_muni_dependencies=audio.o communication.o connection.o command_result.o confirmation.o content.o error.o send_file_chunk.o send_file_header.o send_file_trailer.o package.o service.o directory.o byte_array.o error_messages.o file.o random.o time.o wait_time.o log.o muni.o script.o 
muni_dependencies = $(patsubst %,$(objects_directory)%,$(_muni_dependencies))
muni_program_path = $(OUTPUT_FILES_DIRECTORY)bin/muni

_store_instant_dependencies=directory.o script.o time.o log.o store_instant.o
store_instant_dependencies = $(patsubst %,$(objects_directory)%,$(_store_instant_dependencies))
store_instant_program_path = $(OUTPUT_FILES_DIRECTORY)bin/store_instant

$(toptargets): $(subdirs)

all: $(subdirs) muni store_instant

$(subdirs):
	@$(MAKE) -C $@ $(MAKECMDGOALS) OUTPUT_FILES_DIRECTORY=../$(OUTPUT_FILES_DIRECTORY)


$(objects_directory)%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

muni: $(muni_program_path)

$(muni_program_path): $(muni_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

store_instant: $(store_instant_program_path)

$(store_instant_program_path): $(store_instant_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

clean:
	rm -f $(muni_program_path)
	rm -f $(store_instant_program_path)

.PHONY: $(toptargets) $(subdirs) $(objects_directory)
