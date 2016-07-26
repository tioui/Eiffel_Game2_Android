note
	description: "A {GAME_SOUND} loaded from a sound file."
	author: "Louis Marchand"
	date: "Wed, 08 Apr 2015 01:04:08 +0000"
	revision: "2.0"

class
	AUDIO_SOUND_FILE

inherit
	AUDIO_SOUND
	DISPOSABLE
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make(a_filename:READABLE_STRING_GENERAL)
			-- Initialization for `Current'.
			-- Will use 16 bits signed frames in the buffer.
		do
			default_create
			bits_per_sample_internal:=16
			is_signed_internal:=true
			filename:=a_filename
		end

feature {AUDIO_SOURCE}

	fill_buffer(a_buffer:POINTER;a_max_length:INTEGER)
			-- <Precursor>
		local
			l_items:INTEGER
		do
			from
				l_items:=a_max_length//2
			until
				(l_items\\byte_per_buffer_sample)=0
			loop
				l_items:=l_items-1
			end
			last_buffer_size:={AUDIO_SND_FILES_EXTERNAL}.sf_read_short(snd_file_ptr,a_buffer,l_items).to_integer*2
		end

	byte_per_buffer_sample:INTEGER
			-- <Precursor>
		do
			Result:=2
		end

feature --Access

	is_openable:BOOLEAN
			-- <Precursor>
		local
			l_file:GAME_FILE
		do
			create l_file.make_with_name (filename)
			Result:= l_file.exists and l_file.is_readable
		end

	open
			-- <Precursor>
		do
			open_from_file(filename)
			is_open:=not has_error
			has_ressource_error := has_error
		end

	channel_count:INTEGER
			-- Get the channel number of the sound (1=mono, 2=stereo, etc.).
		do
			Result:={AUDIO_SND_FILES_EXTERNAL}.get_sf_info_struct_channels(file_info)
		end

	frequency:INTEGER
			-- Get the frequency (sample rate) of the sound.
		do
			Result:={AUDIO_SND_FILES_EXTERNAL}.get_sf_info_struct_samplerate(file_info)
		end

	bits_per_sample:INTEGER
			-- Get the bit resolution of one frame of the sound.
		do
			Result:=bits_per_sample_internal
		end

	is_signed:BOOLEAN
			-- Return true if the frames in the buffer are signed.
		do
			Result:=is_signed_internal
		end

	is_seekable:BOOLEAN
			-- Return true if the sound support the seek functionnality.
		do
			Result:=({AUDIO_SND_FILES_EXTERNAL}.get_sf_info_struct_seekable(file_info)/=0)
		end

	restart
			-- Restart the sound to the beginning.
		local
			l_error:INTEGER_64
		do
			if is_seekable then
				l_error:={AUDIO_SND_FILES_EXTERNAL}.SF_seek(snd_file_ptr,0,{AUDIO_SND_FILES_EXTERNAL}.Seek_set)
				check l_error/=-1 end
			else
				dispose
				open_from_file(filename)
			end

		end

feature {NONE} -- Implementation

	open_from_file(a_filename:READABLE_STRING_GENERAL)
			-- `open' `Current' using `a_filename'
		local
			l_filename_c,l_error_c, l_mode_c:C_STRING
			l_file:GAME_FILE
			l_converter:UTF_CONVERTER
		do
			create l_file.make_with_name (a_filename)
			file_info:=file_info.memory_alloc (Sf_info_size)
			if l_file.is_asset then
				create l_filename_c.make(l_converter.string_32_to_utf_8_string_8 (a_filename.to_string_32))
				create l_mode_c.make ("rb")
				sdl_rw_ops := {GAME_FILE_EXTERNAL}.sdl_rw_from_file(l_filename_c.item, l_mode_c.item)
				virtual_rw:=virtual_rw.memory_alloc (Sf_virtual_rw_size)
				{AUDIO_SND_FILES_ANDROID_EXTERNAL}.set_snd_file_virtual_io_rw(virtual_rw)
				snd_file_ptr:={AUDIO_SND_FILES_EXTERNAL}.sf_open_virtual(virtual_rw,{AUDIO_SND_FILES_EXTERNAL}.Sfm_read, file_info, sdl_rw_ops)
			else
				create l_filename_c.make(a_filename)
				snd_file_ptr:={AUDIO_SND_FILES_EXTERNAL}.SF_open(l_filename_c.item,{AUDIO_SND_FILES_EXTERNAL}.Sfm_read,file_info)
			end
			if snd_file_ptr.is_default_pointer then
				create l_error_c.make_by_pointer ({AUDIO_SND_FILES_EXTERNAL}.sf_strerror(snd_file_ptr))
				io.error.put_string (l_error_c.string+"%N")
				has_error:=True
			end
		end

	dispose
			-- <Precursor>
		local
			l_error:INTEGER
		do
			file_info.memory_free
			l_error:={AUDIO_SND_FILES_EXTERNAL}.sf_close(snd_file_ptr)
			virtual_rw.memory_free
			l_error := {GAME_FILE_EXTERNAL}.sdl_rw_close (sdl_rw_ops)
			check l_error=0 end
		end

	Sf_virtual_rw_size:INTEGER
			-- The number of byte of a C sf_virtual_io structure
		once
			Result := {AUDIO_SND_FILES_EXTERNAL}.c_sizeof_snd_file_virtual_io
		end

	Sf_info_size:INTEGER
			-- The number of byte of a C sf_info structure
		once
			Result := {AUDIO_SND_FILES_EXTERNAL}.c_sizeof_sf_info
		end

	sdl_rw_ops:POINTER
			-- The internal pointer to the SDL_RWops using to read files

	virtual_rw:POINTER
			-- The C pointer to the internal sf_virtual_io structure

	snd_file_ptr:POINTER
			-- C pointer to the sound file handle

	file_info:POINTER
			-- C pointer to the sound file information

	bits_per_sample_internal:INTEGER
			-- The value of the `bits_per_sample' attributes

	is_signed_internal:BOOLEAN
			-- The value of the `is_signed' attributes

	filename:READABLE_STRING_GENERAL
			-- The name of the file containing the audio data


end
