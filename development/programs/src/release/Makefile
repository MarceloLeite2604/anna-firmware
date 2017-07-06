CC = gcc
LIBS = -lbluetooth -lm

subdirs := $(wildcard */.)

objects_directory=$(OUTPUT_FILES_DIRECTORY)objects/

_muni_dependencies=audio.o communication.o connection.o command_result.o confirmation.o content.o error.o send_file_chunk.o send_file_header.o send_file_trailer.o package.o service.o directory.o byte_array.o error_messages.o file.o random.o time.o wait_time.o log.o muni.o script.o 
muni_dependencies = $(patsubst %,$(objects_directory)%,$(_muni_dependencies))
muni_program_path = $(OUTPUT_FILES_DIRECTORY)bin/muni

all: $(subdirs) muni

$(subdirs):
	@$(MAKE) -C $@ OUTPUT_FILES_DIRECTORY=../$(OUTPUT_FILES_DIRECTORY)


$(objects_directory)%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

muni: $(muni_program_path)

$(muni_program_path): $(muni_dependencies)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

clean:
	rm -r $(objects_directory)*.o
	rm $(muni_program_path)

.PHONY: clean muni $(subdirs)
