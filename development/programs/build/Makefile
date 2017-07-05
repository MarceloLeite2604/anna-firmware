objects_directory=$(OUTPUT_DIRECTORY)objects/

muni_dependencies=audio/audio.o bluetooth/communication/communication.o bluetooth/connection/connection.o bluetooth/package/content/command_result/command_result.o bluetooth/package/content/confirmation/confirmation.o bluetooth/package/content/content.o bluetooth/package/content/error/error.o bluetooth/package/content/send_file_chunk/send_file_chunk.o bluetooth/package/content/send_file_header/send_file_header.o bluetooth/package/content/send_file_trailer/send_file_trailer.o bluetooth/package/package.o bluetooth/service/service.o directory/directory.o general/byte_array/byte_array.o general/error_messages/error_messages.o general/file/file.o general/random/random.o general/time/time.o general/wait_time/wait_time.o log/log.o muni.o script/script.o store_instant.o
muni_dependencies := $(addprefix $(objects_directory), $(muni_dependencies))

muni: $(muni_dependencies)
	@echo Creating muni program.

%.o: $(subst .o,.c,$(subst $(objects_directory),$(SOURCE_FILES_ROOT_DIRECTORY),$@))
	@mkdir -p $(shell dirname $@)
	gcc -c $(subst .o,.c,$(subst $(objects_directory),$(SOURCE_FILES_ROOT_DIRECTORY),$@)) -o $@

clean:
	@echo clean;
