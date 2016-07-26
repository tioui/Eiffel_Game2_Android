note
	description: "[
				Represent a file in an Android System.
				With this, you can read information from a file
			]"
	author: "Louis Marchand"
	date: "Thu, 02 Apr 2015 04:11:03 +0000"
	revision: "2.0"
	todo: "can_read_16, can_read_32, can_read_64"

class
	GAME_FILE

inherit
	RAW_FILE
		redefine
			make_with_name, make_with_path, set_name, set_path, position,
			descriptor, file_info, retrieved, count, end_of_file, exists,
			access_exists, path_exists, is_symlink, file_prunable,
			prunable, same_file, open_read, open_write, open_append,
			open_read_write, create_read_write, open_read_append,
			fd_open_read, fd_open_write, fd_open_append, fd_open_read_write,
			fd_open_read_append, reopen_read, reopen_write, reopen_append,
			reopen_read_write, recreate_read_write, reopen_read_append,
			close, start, finish, forth, back, move, go, recede, next_line,
			flush, link, append, stamp, set_access, set_date, change_name,
			rename_file, rename_path, add_permission, remove_permission,
			change_mode, change_owner, change_group, touch,  wipe_out, delete,
			read_integer, read_integer_32, readint, read_integer_8,
			read_integer_16, read_integer_64, read_natural_8, read_natural_16,
			read_natural_32, read_natural, read_natural_64, read_real,
			readreal, read_double, readdouble, read_character, readchar,
			read_data, read_line, readline, read_line_thread_aware,
			read_stream, readstream, read_stream_thread_aware,
			read_to_managed_pointer, read_to_string, read_word, readword,
			read_word_thread_aware, buffered_file_info, set_buffer
		end

create
	make_with_name,
	make_with_path,
	make_open_read,
	make_open_write,
	make_open_append,
	make_open_read_write,
	make_create_read_write,
	make_open_read_append

feature {NONE} -- Implementation

	make_with_name(a_name: READABLE_STRING_GENERAL)
			-- Create file object with `a_name' as file name.
		do
			Precursor(a_name)
			create internal_mutex.make
			descriptor_available := False
			end_of_file_internal := False
		end

	make_with_path (a_path: PATH)
			-- <Precursor>
		do
			Precursor(a_path)
			create internal_mutex.make
			descriptor_available := False
			end_of_file_internal := False
		end

feature -- Access

	is_asset:BOOLEAN

	position: INTEGER
			-- Current cursor position.
		do
			if not is_closed then
				if is_asset then
					Result := {GAME_FILE_EXTERNAL}.sdl_rw_tell(file_pointer).to_integer_32
				else
					Result := Precursor
				end

			end
		end

	descriptor: INTEGER
			-- <Precursor>
		do
			if not is_asset then
				Result := file_fd (file_pointer)
				descriptor_available := True
			else
				Result := 0
				descriptor_available := False
			end
		end

	file_info: ANDROID_FILE_INFO
			-- <Precursor>
		do
			set_buffer
			Result := buffered_file_info.twin
		end

	retrieved: detachable ANY
			-- <Precursor>
		do
			if is_asset then
				-- ToDo
			else
				Result := Precursor
			end
		end

	read_natural_16_big_endian
			-- Read the next 16-bit natural in the file (Reading in Big-Endian order).
			-- Make the result available in `last_natural_16'.
		require
			File_Readable:is_readable
			Can_Read: can_read_16
		do
			lock_mutex
			internal_read_natural_16_big_endian
			unlock_mutex
		end

	read_natural_32_big_endian, read_natural_big_endian
			-- Read the next 32-bit natural in the file (Reading in Big-Endian order).
			-- Make the result available in `last_natural_32'.
		require
			File_Readable:is_readable
			Can_Read: can_read_32
		do
			lock_mutex
			internal_read_natural_32_big_endian
			unlock_mutex
		end

	read_natural_64_big_endian
			-- Read the next 64-bit natural in the file (Reading in Big-Endian order).
			-- Make the result available in `last_natural_64'.
		require
			File_Readable:is_readable
			Can_Read: can_read_64
		do
			lock_mutex
			internal_read_natural_64_big_endian
			unlock_mutex
		end

	read_natural_16_little_endian
			-- Read the next 16-bit natural in the file (Reading in Little-Endian order).
			-- Make the result available in `last_natural_16'.
		require
			File_Readable:is_readable
			Can_Read: can_read_16
		do
			lock_mutex
			internal_read_natural_16_little_endian
			unlock_mutex
		end

	read_natural_32_little_endian, read_natural_little_endian
			-- Read the next 32-bit natural in the file (Reading in Little-Endian order).
			-- Make the result available in `last_natural_32'.
		require
			File_Readable:is_readable
			Can_Read: can_read_32
		do
			lock_mutex
			internal_read_natural_32_little_endian
			unlock_mutex
		end

	read_natural_64_little_endian
			-- Read the next 64-bit natural in the file (Reading in Little-Endian order).
			-- Make the result available in `last_natural_64'.
		require
			File_Readable:is_readable
			Can_Read: can_read_64
		do
			lock_mutex
			internal_read_natural_64_little_endian
			unlock_mutex
		end

	read_real_big_endian, readreal_big_endian
			-- Read a new real (Reading in Big-Endian order).
			-- Make result available in last_real.
		require
			File_Readable:is_readable
			Can_Read: can_read_32
		local
			l_old_natural:NATURAL_32
		do
			lock_mutex
			l_old_natural := last_natural
			internal_read_natural_32_big_endian
			last_real:={SHARED_EXTERNAL}.natural_32_to_real_32(last_natural_32)
			last_natural := l_old_natural
			unlock_mutex
		end

	read_double_big_endian, readdouble_big_endian
			-- Read a new double (Reading in Big-Endian order).
			-- Make result available in last_double.
		require
			File_Readable:is_readable
			Can_Read: can_read_64
		local
			l_old_natural_64:NATURAL_64
		do
			lock_mutex
			l_old_natural_64 := last_natural_64
			internal_read_natural_64_big_endian
			last_double:={SHARED_EXTERNAL}.natural_64_to_real_64(last_natural_64)
			last_natural_64 := l_old_natural_64
			unlock_mutex
		end

	read_real_little_endian, readreal_little_endian
			-- Read a new real (Reading in Little-Endian order).
			-- Make result available in last_real.
		require
			File_Readable:is_readable
			Can_Read: can_read_32
		local
			l_old_natural:NATURAL_32
		do
			lock_mutex
			l_old_natural := last_natural
			internal_read_natural_32_little_endian
			last_real:={SHARED_EXTERNAL}.natural_32_to_real_32(last_natural_32)
			last_natural := l_old_natural
			unlock_mutex
		end

	read_double_little_endian, readdouble_little_endian
			-- Read a new double (Reading in Little-Endian order).
			-- Make result available in last_double.
		require
			File_Readable:is_readable
			Can_Read: can_read_64
		local
			l_old_natural_64:NATURAL_64
		do
			lock_mutex
			l_old_natural_64 := last_natural_64
			internal_read_natural_64_little_endian
			last_double:={SHARED_EXTERNAL}.natural_64_to_real_64(last_natural_64)
			last_natural_64 := l_old_natural_64
			unlock_mutex
		end

	read_integer_16_big_endian
			-- Read a new 16-bit integer (Reading in Big-Endian order).
			-- Make result available in last_integer_16.
		require
			File_Readable:is_readable
			Can_Read: can_read_16
		local
			l_old_natural_16:NATURAL_16
		do
			lock_mutex
			l_old_natural_16 := last_natural_16
			internal_read_natural_16_big_endian
			last_integer_16:=last_natural_16.as_integer_16
			last_natural_16 := l_old_natural_16
			unlock_mutex
		end

	read_integer_32_big_endian, read_integer_big_endian
			-- Read a new 32-bit integer (Reading in Big-Endian order).
			-- Make result available in last_integer_32.
		require
			File_Readable:is_readable
			Can_Read: can_read_32
		local
			l_old_natural:NATURAL_32
		do
			lock_mutex
			l_old_natural := last_natural
			internal_read_natural_32_big_endian
			last_integer:=last_natural_32.as_integer_32
			last_natural := l_old_natural
			unlock_mutex
		end

	read_integer_64_big_endian
			-- Read a new 64-bit integer (Reading in Big-Endian order).
			-- Make result available in last_integer_64.
		require
			File_Readable:is_readable
			Can_Read: can_read_64
		local
			l_old_natural_64:NATURAL_64
		do
			lock_mutex
			l_old_natural_64 := last_natural_64
			internal_read_natural_64_big_endian
			last_integer_64:=last_natural_64.as_integer_64
			last_natural_64 := l_old_natural_64
			unlock_mutex
		end

	read_integer_16_little_endian
			-- Read a new 16-bit integer (Reading in Little-Endian order).
			-- Make result available in last_integer_16.
		require
			File_Readable:is_readable
			Can_Read: can_read_16
		local
			l_old_natural_16:NATURAL_16
		do
			lock_mutex
			l_old_natural_16 := last_natural_16
			internal_read_natural_16_little_endian
			last_integer_16:=last_natural_16.as_integer_16
			last_natural_16 := l_old_natural_16
			unlock_mutex
		end

	read_integer_32_little_endian, read_integer_little_endian
			-- Read a new 32-bit integer (Reading in Little-Endian order).
			-- Make result available in last_integer_32.
		require
			File_Readable:is_readable
			Can_Read: can_read_32
		local
			l_old_natural:NATURAL_32
		do
			lock_mutex
			l_old_natural := last_natural
			internal_read_natural_32_little_endian
			last_integer:=last_natural_32.as_integer_32
			last_natural := l_old_natural
			unlock_mutex
		end

	read_integer_64_little_endian
			-- Read a new 64-bit integer (Reading in Little-Endian order).
			-- Make result available in last_integer_64.
		require
			File_Readable:is_readable
			Can_Read: can_read_64
		local
			l_old_natural_64:NATURAL_64
		do
			lock_mutex
			l_old_natural_64 := last_natural_64
			internal_read_natural_64_little_endian
			last_integer_64:=last_natural_64.as_integer_64
			last_natural_64 := l_old_natural_64
			unlock_mutex
		end

feature -- Measurement

	count: INTEGER
			-- <Precursor>
			-- It `is_asset' is `True', `Current' must be open to obtain the value
		do
			if is_asset then
				if not is_closed then
					Result := {GAME_FILE_EXTERNAL}.sdl_rw_size(file_pointer).to_integer_32
				end
			else
				Result := Precursor
			end
		end

feature -- Status report

	end_of_file: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := end_of_file_internal
			else
				Result := Precursor
			end

		end

	exists: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				if is_closed then
					Result := is_readable
				else
					Result := True
				end
			else
				Result := Precursor
			end
		end

	access_exists: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := exists
			else
				Result := Precursor
			end
		end

	path_exists: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := exists
			else
				Result := Precursor
			end
		end

	is_symlink: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	file_prunable: BOOLEAN
			-- <Precursor>
		obsolete
			"Use `prunable' instead."
		do
			Result := prunable
		end

	prunable: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	can_read_16:BOOLEAN
			-- There is another 16 bits in the stream to read.
		require
			File_Readable:is_readable
		do
			Result:=count-position>1
		end

	can_read_32:BOOLEAN
			-- There is another 16 bits in the stream to read.
		require
			File_Readable:is_readable
		do
			Result:=count-position>3
		end

	can_read_64:BOOLEAN
			-- There is another 16 bits in the stream to read.
		require
			File_Readable:is_readable
		do
			Result:=count-position>7
		end

feature -- Comparison

	same_file (a_filename: READABLE_STRING_GENERAL): BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := path.name ~ a_filename.as_string_32
			else
				Result := Precursor(a_filename)
			end
		end

feature -- Status setting

	open_read
			-- <Precursor>
		local
			l_mode:C_STRING
		do
			if is_asset then
				create l_mode.make ("rb")
				file_pointer := {GAME_FILE_EXTERNAL}.sdl_rw_from_file(internal_name_pointer.item, l_mode.item)
				if not file_pointer.is_default_pointer then
					mode := Read_file
				end
			else
				Precursor
			end
		end

	open_write
			-- <Precursor>
		do
			if not is_asset then
				Precursor
			end
		end

	open_append
			-- <Precursor>
		do
			if not is_asset then
				Precursor
			end
		end

	open_read_write
			-- <Precursor>
		do
			if not is_asset then
				Precursor
			end
		end

	create_read_write
			-- <Precursor>
		do
			if not is_asset then
				Precursor
			end
		end

	open_read_append
			-- <Precursor>
		do
			if not is_asset then
				Precursor
			end
		end

	fd_open_read (a_file_descriptor: INTEGER)
			-- Open file of descriptor `a_file_descriptor' in read-only mode.
		do
			if not is_asset then
				Precursor(a_file_descriptor)
			end
		end

	fd_open_write (a_file_descriptor: INTEGER)
			-- Open file of descriptor `a_file_descriptor' in write mode.
		do
			if not is_asset then
				Precursor(a_file_descriptor)
			end
		end

	fd_open_append (a_file_descriptor: INTEGER)
			-- Open file of descriptor `a_file_descriptor' in append mode.
		do
			if not is_asset then
				Precursor(a_file_descriptor)
			end
		end

	fd_open_read_write (a_file_descriptor: INTEGER)
			-- Open file of descriptor `a_file_descriptor' in read-write mode.
		do
			if not is_asset then
				Precursor(a_file_descriptor)
			end
		end

	fd_open_read_append (a_file_descriptor: INTEGER)
			-- Open file of descriptor `a_file_descriptor'
			-- in read and write-at-end mode.
		do
			if not is_asset then
				Precursor(a_file_descriptor)
			end
		end

	reopen_read (a_file_name: READABLE_STRING_GENERAL)
			-- Reopen in read-only mode with file of name `a_file_name';
			-- create file if it does not exist.
		do
			if is_asset then
				close
				set_name (a_file_name)
				open_read
			else
				Precursor(a_file_name)
			end
		end

	reopen_write (a_file_name: READABLE_STRING_GENERAL)
			-- Reopen in write-only mode with file of name `a_file_name';
			-- create file if it does not exist.
		do
			if not is_asset then
				Precursor(a_file_name)
			end
		end

	reopen_append (a_file_name: READABLE_STRING_GENERAL)
			-- Reopen in append mode with file of name `a_file_name';
			-- create file if it does not exist.
		do
			if not is_asset then
				Precursor(a_file_name)
			end
		end

	reopen_read_write (a_file_name: READABLE_STRING_GENERAL)
			-- Reopen in read-write mode with file of name `a_file_name'.
		do
			if not is_asset then
				Precursor(a_file_name)
			end
		end

	recreate_read_write (a_file_name: READABLE_STRING_GENERAL)
			-- Reopen in read-write mode with file of name `a_file_name';
			-- create file if it does not exist.
		do
			if not is_asset then
				Precursor(a_file_name)
			end
		end

	reopen_read_append (a_file_name: READABLE_STRING_GENERAL)
			-- Reopen in read and write-at-end mode with file
			-- of name `a_file_name'; create file if it does not exist.
		do
			if not is_asset then
				Precursor(a_file_name)
			end
		end

	close
			-- <Precursor>
		local
			l_error:INTEGER
		do
			if is_asset then
				l_error := {GAME_FILE_EXTERNAL}.sdl_rw_close(file_pointer)
				mode := Closed_file
				file_pointer := default_pointer
				descriptor_available := False
				end_of_file_internal := False
			else
				Precursor
			end
		end

feature -- Cursor movement

	start
			-- <Precursor>
		do
			go (0)
		end

	finish
			-- <Precursor>
		do
			recede (-1)
		end

	forth
			-- <Precursor>
		do
			if is_asset then
				move (1)
			else
				Precursor
			end

		end

	back
			-- <Precursor>
		do
			move (-1)
		end

	move (a_offset: INTEGER)
			-- Advance by `a_offset' from current location.
		local
			l_error:INTEGER_64
		do
			if is_asset then
				if position + a_offset >= count then
					end_of_file_internal := True
				else
					end_of_file_internal := False
				end
				l_error := {GAME_FILE_EXTERNAL}.sdl_rw_seek(file_pointer, a_offset, {GAME_FILE_EXTERNAL}.sdl_rw_seek_cur)
			else
				Precursor(a_offset)
			end
		end

	go (a_position: INTEGER)
			-- Go to the absolute `a_position'.
			-- (New `position' may be beyond physical length.)
		local
			l_error:INTEGER_64
		do
			if is_asset then
				l_error := {GAME_FILE_EXTERNAL}.sdl_rw_seek(file_pointer, a_position, {GAME_FILE_EXTERNAL}.sdl_rw_seek_set)
				if a_position >= count then
					end_of_file_internal := True
				else
					end_of_file_internal := False
				end
			else
				Precursor(a_position)
			end
		end

	recede (a_position: INTEGER)
			-- Go to the absolute `a_position' backwards,
			-- starting from end of file.
		local
			l_error:INTEGER_64
		do
			if is_asset then
				l_error := {GAME_FILE_EXTERNAL}.sdl_rw_seek(file_pointer, -a_position, {GAME_FILE_EXTERNAL}.sdl_rw_seek_end)
				if a_position = 0 then
					end_of_file_internal := True
				else
					end_of_file_internal := False
				end
			else
				Precursor(a_position)
			end
		end

	next_line
			-- <Precursor>
		local
			l_character:like last_character
		do
			if is_asset then
				l_character := last_character
				from
					read_character
				until
					last_character ~ '%N' or end_of_file
				loop
					read_character
				end
				last_character := l_character
			else
				Precursor
			end
		end

feature -- Element change

	flush
			-- <Precursor>
		do
			if not is_asset then
				Precursor
			end
		end

	link (a_file_name: READABLE_STRING_GENERAL)
			-- Link current file to `a_file_name'.
			-- `a_file_name' must not already exist.
			-- Not supported for Android Assets
		do
			if not is_asset then
				Precursor(a_file_name)
			end
		end

	append (a_other: like Current)
			-- Append a copy of the contents of `a_other'.
			-- Not supported for Android Assets
		do
			if not is_asset then
				Precursor(a_other)
			end
		end

	stamp (a_time: INTEGER)
			-- Stamp with `a_time' (for both access and modification).
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor(a_time)
			end
		end

	set_access (a_time: INTEGER)
			-- Stamp with `a_time' (access only).
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor(a_time)
			end
		end

	set_date (a_time: INTEGER)
			-- Stamp with `a_time' (modification time only).
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor(a_time)
			end
		end

	change_name (a_new_name: STRING)
			-- Change file name to `a_new_name'.
			-- Not supported for Android Assets
		obsolete
			"Use `rename_file' instead."
		do
			if is_asset then
				Precursor(a_new_name)
			end
		end

	rename_file (a_new_name: READABLE_STRING_GENERAL)
			-- Change file name to `a_new_name'
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor(a_new_name)
			end
		end

	rename_path (a_new_path: PATH)
			-- Change file name to `a_new_path'
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor(a_new_path)
			end
		end

	add_permission (a_who, a_what: STRING)
			-- Add read, write, execute or setuid permission
			-- for `a_who' ('u', 'g' or 'o') to `a_what'.
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor(a_who, a_what)
			end
		end

	remove_permission (a_who, a_what: STRING)
			-- Remove read, write, execute or setuid permission
			-- for `a_who' ('u', 'g' or 'o') to `a_what'.
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor(a_who, a_what)
			end
		end

	change_mode (a_mask: INTEGER)
			-- Replace mode by `a_mask'.
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor(a_mask)
			end
		end

	change_owner (a_new_owner_id: INTEGER)
			-- Change owner of file to `a_new_owner_id' found in
			-- system password file. On some systems this
			-- requires super-user privileges.
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor(a_new_owner_id)
			end
		end

	change_group (a_new_group_id: INTEGER)
			-- Change group of file to `a_new_group_id' found in
			-- system password file.
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor(a_new_group_id)
			end
		end

	touch
			-- <Precursor>
			-- Not supported for Android Assets
		do
			if is_asset then
				Precursor
			end
		end

feature -- Output

	put_natural_16_big_endian(a_value:NATURAL_16)
			-- Write `a_value' at current position (Writing in Big-Endian order).
		require
			extendible: extendible
		do
			lock_mutex
			internal_put_natural_16_big_endian(a_value)
			unlock_mutex
		end

	put_natural_16_little_endian(a_value:NATURAL_16)
			-- Write `a_value' at current position (Writing in Little-Endian order).
		require
			extendible: extendible
		do
			lock_mutex
			internal_put_natural_16_little_endian(a_value)
			unlock_mutex
		end

	put_natural_32_big_endian(a_value:NATURAL_32)
			-- Write `a_value' at current position (Writing in Big-Endian order).
		require
			extendible: extendible
		do
			lock_mutex
			internal_put_natural_32_big_endian(a_value)
			unlock_mutex
		end

	put_natural_32_little_endian(a_value:NATURAL_32)
			-- Write `a_value' at current position (Writing in Little-Endian order).
		require
			extendible: extendible
		do
			lock_mutex
			internal_put_natural_32_little_endian(a_value)
			unlock_mutex
		end

	put_natural_64_big_endian(a_value:NATURAL_64)
			-- Write `a_value' at current position (Writing in Big-Endian order).
		require
			extendible: extendible
		do
			lock_mutex
			internal_put_natural_32_big_endian(a_value.bit_shift_right (32).to_natural_32)
			internal_put_natural_32_big_endian(a_value.bit_and (0xFFFFFFFF).to_natural_32)
			unlock_mutex
		end

	put_natural_64_little_endian(a_value:NATURAL_64)
			-- Write `a_value' at current position (Writing in Little-Endian order).
		require
			extendible: extendible
		do
			lock_mutex
			internal_put_natural_32_little_endian(a_value.bit_and (0xFFFFFFFF).to_natural_32)
			internal_put_natural_32_little_endian(a_value.bit_shift_right (32).to_natural_32)
			unlock_mutex
		end

	put_integer_16_big_endian(a_value:INTEGER_16)
			-- Write `a_value' at current position (Writing in Big-Endian order).
		do
			put_natural_16_big_endian (a_value.as_natural_16)
		end

	put_integer_32_big_endian, put_integer_big_endian, putint_big_endian(a_value:INTEGER_32)
			-- Write `a_value' at current position (Writing in Big-Endian order).
		do
			put_natural_32_big_endian (a_value.as_natural_32)
		end

	put_integer_64_big_endian(a_value:INTEGER_64)
			-- Write `a_value' at current position (Writing in Big-Endian order).
		do
			put_natural_64_big_endian (a_value.as_natural_64)
		end

	put_real_big_endian, putreal_big_endian(a_value:REAL_32)
			-- Write `a_value' at current position (Writing in Big-Endian order).
		do
			put_natural_32_big_endian ({SHARED_EXTERNAL}.real_32_to_natural_32(a_value))
		end

	put_double_big_endian, putdouble_big_endian(a_value:REAL_64)
			-- Write `a_value' at current position (Writing in Big-Endian order).
		do
			put_natural_64_big_endian ({SHARED_EXTERNAL}.real_64_to_natural_64(a_value))
		end

	put_integer_16_little_endian(a_value:INTEGER_16)
			-- Write `a_value' at current position (Writing in little-Endian order).
		do
			put_natural_16_little_endian (a_value.as_natural_16)
		end

	put_integer_32_little_endian, put_integer_little_endian, putint_little_endian(a_value:INTEGER_32)
			-- Write `a_value' at current position (Writing in little-Endian order).
		do
			put_natural_32_little_endian (a_value.as_natural_32)
		end

	put_integer_64_little_endian(a_value:INTEGER_64)
			-- Write `a_value' at current position (Writing in little-Endian order).
		do
			put_natural_64_little_endian (a_value.as_natural_64)
		end

	put_real_little_endian, putreal_little_endian(a_value:REAL_32)
			-- Write `a_value' at current position (Writing in little-Endian order).
		do
			put_natural_32_little_endian ({SHARED_EXTERNAL}.real_32_to_natural_32(a_value))
		end

	put_double_little_endian, putdouble_little_endian(a_value:REAL_64)
			-- Write `a_value' at current position (Writing in Little-Endian order).
		do
			put_natural_64_little_endian ({SHARED_EXTERNAL}.real_64_to_natural_64(a_value))
		end

feature -- Removal

	wipe_out
			-- <Precursor>
			-- Not supported by Android Asset
		do
			if not is_asset then
				Precursor
			end
		end

	delete
			-- <Precursor>
			-- Not supported by Android Asset
		do
			if not is_asset then
				Precursor
			end
		end

feature -- Input

	read_integer_32
			-- <Precursor>
		local
			l_natural:NATURAL_32
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_natural, 4, 1)
				end_of_file_internal := l_eof = 0
				last_integer := l_natural.as_integer_32
			else
				Precursor
			end
		end

	readint
			-- <Precursor>
		do
			read_integer_32
		end

	read_integer
			-- <Precursor>
		do
			read_integer_32
		end



	read_integer_8
			-- <Precursor>
		local
			l_natural:NATURAL_8
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_natural, 1, 1)
				end_of_file_internal := l_eof = 0
				last_integer_8 := l_natural.as_integer_8
			else
				Precursor
			end
		end

	read_integer_16
			-- <Precursor>
		local
			l_natural:NATURAL_16
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_natural, 2, 1)
				end_of_file_internal := l_eof = 0
				last_integer_16 := l_natural.as_integer_16
			else
				Precursor
			end
		end

	read_integer_64
			-- <Precursor>
		local
			l_natural:NATURAL_64
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_natural, 8, 1)
				end_of_file_internal := l_eof = 0
				last_integer_64 := l_natural.as_integer_64
			else
				Precursor
			end
		end

	read_natural_8
			-- <Precursor>
		local
			l_natural:NATURAL_8
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_natural, 1, 1)
				end_of_file_internal := l_eof = 0
				last_natural_8 := l_natural
			else
				Precursor
			end
		end

	read_natural_16
			-- <Precursor>
		local
			l_natural:NATURAL_16
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_natural, 2, 1)
				end_of_file_internal := l_eof = 0
				last_natural_16 := l_natural
			else
				Precursor
			end
		end

	read_natural_32
			-- <Precursor>
		local
			l_natural:NATURAL_32
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_natural, 4, 1)
				end_of_file_internal := l_eof = 0
				last_natural := l_natural
			else
				Precursor
			end
		end

	read_natural
			-- <Precursor>
		do
			read_natural_32
		end

	read_natural_64
			-- <Precursor>
		local
			l_natural:NATURAL_64
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_natural, 8, 1)
				end_of_file_internal := l_eof = 0
				last_natural_64 := l_natural
			else
				Precursor
			end
		end

	read_real
			-- <Precursor>
		local
			l_natural:NATURAL_32
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_natural, 4, 1)
				end_of_file_internal := l_eof = 0
				last_real := {SHARED_EXTERNAL}.natural_32_to_real_32 (l_natural)
			else
				Precursor
			end
		end

	readreal
			-- <Precursor>
		do
			read_real
		end

	read_double
			-- <Precursor>
		local
			l_natural:NATURAL_64
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_natural, 8, 1)
				end_of_file_internal := l_eof = 0
				last_double := {SHARED_EXTERNAL}.natural_64_to_real_64 (l_natural)
			else
				Precursor
			end
		end

	readdouble
			-- <Precursor>
		do
			read_double
		end

	read_character
			-- <Precursor>
		local
			l_character:CHARACTER
			l_eof:INTEGER_64
		do
			if is_asset then
				l_eof := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$l_character, 1, 1)
				end_of_file_internal := l_eof = 0
				last_character := l_character
			else
				Precursor
			end
		end

	readchar
			-- <Precursor>
		do
			read_character
		end

	read_data (a_pointer: POINTER; a_bytes_count: INTEGER)
			-- Read a string of at most `a_bytes_count' bound bytes
			-- or until end of file.
			-- Make result available in `a_pointer'.
		local
			l_new_count:INTEGER_64
		do
			l_new_count := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,a_pointer, 1, a_bytes_count)
			end_of_file_internal := l_new_count.to_integer_32 /~ a_bytes_count
		end

	read_line
			-- <Precursor>
		local
			l_character:CHARACTER
			l_result:like last_string
		do
			if is_asset then
				l_character := last_character
				l_result := last_string
				l_result.wipe_out
				from
					last_character := '1'
				until
					last_character ~ '%N'
				loop
					read_character
					if last_character /~ '%N' then
						l_result.extend (last_character)
					end
				end
				last_character := l_character
			else
				Precursor
			end
		end

	readline
			-- <Precursor>
		do
			read_line
		end

	read_line_thread_aware
			-- <Precursor>
		do
			internal_mutex.lock
			read_line
			internal_mutex.unlock
		end

	read_stream (a_char_count: INTEGER)
			-- Read a string of at most `a_char_count' bound characters
			-- or until end of file.
			-- Make result available in last_string.
		local
			new_count: INTEGER_64
			str_area: ANY
			l: like last_string
		do
			if is_asset then
				l := last_string
				l.grow (a_char_count)
				str_area := l.area
				new_count := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,$str_area, 1, a_char_count)
				l.set_count (new_count.to_integer_32)
				end_of_file_internal := new_count /~ a_char_count
			else
				Precursor(a_char_count)
			end
		end

	readstream (a_char_count: INTEGER)
			-- Read a string of at most `a_char_count' bound characters
			-- or until end of file.
			-- Make result available in last_string.
		do
			read_stream (a_char_count)
		end

	read_stream_thread_aware (a_char_count: INTEGER)
			-- Read a string of at most `a_char_count' bound characters
			-- or until end of medium is encountered.
			-- Make result available in last_string.
			-- Functionally identical to read_stream but
			-- won't prevent garbage collection from occurring
			-- while blocked waiting for data, though data must
			-- be copied an extra time.
		do
			internal_mutex.lock
			if is_asset then
				read_stream(a_char_count)
			else
				Precursor(a_char_count)
			end
			internal_mutex.unlock
		end

	read_to_managed_pointer (a_pointer: MANAGED_POINTER; a_start_pos, a_bytes_count: INTEGER)
			-- Read at most `a_bytes_count' bound bytes and make result
			-- available in `a_pointer' at position `a_start_pos'.
		local
			l_new_count:INTEGER_64
		do
			if is_asset then
				l_new_count := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,a_pointer.item + a_start_pos, 1, a_bytes_count)
				end_of_file_internal := l_new_count /~ a_bytes_count
				bytes_read := l_new_count.to_integer_32
			else
				Precursor(a_pointer, a_start_pos, a_bytes_count)
			end
		end

	read_to_string (a_string: STRING; a_position, a_count: INTEGER): INTEGER
			-- Fill `a_string', starting at position `a_position' with at
			-- most `a_count' characters read from current file.
			-- Return the number of characters actually read.
		local
			l_new_count:INTEGER_64
		do
			if is_asset then
				l_new_count := {GAME_FILE_EXTERNAL}.sdl_rw_read(file_pointer,a_string.area.item_address (a_position - 1), 1, a_count)
				a_string.set_internal_hash_code (0)
				end_of_file_internal := l_new_count /~ a_count
			else
				Result := Precursor(a_string, a_position, a_count)
			end
		end

	read_word
			-- <Precursor>
		local
			l_character:like last_character
			l_result:like last_string
		do
			if is_asset then
				l_character := last_character
				l_result := last_string
				l_result.wipe_out
				from
					last_character := ' '
				until
					end_of_file or not {GAME_FILE_EXTERNAL}.is_space(last_character)
				loop
					read_character
				end
				if not end_of_file then
					from
						last_character := '1'
					until
						end_of_file or {GAME_FILE_EXTERNAL}.is_space(last_character)
					loop
						read_character
						if not end_of_file then
							if not {GAME_FILE_EXTERNAL}.is_space(last_character) then
								l_result.extend (last_character)
							else
								separator := last_character
								back
							end
						end
					end
				end
				last_character := l_character
			else
				Precursor
			end
		end

	readword
			-- <Precursor>
		do
			read_word
		end

	read_word_thread_aware
			-- <Precursor>
		do
			internal_mutex.lock
			if is_asset then
				read_word
			else
				Precursor
			end
			internal_mutex.unlock
		end

feature {GAME_RESSOURCE_MANAGER} -- Access

	is_thread_safe:BOOLEAN
			-- Is `Current' can be used in a multi-threaded system.

	enable_thread_safe
			-- Make `Current' usable in a multi-threaded system.
		do
			is_thread_safe:=true
		end

	disable_thread_safe
			-- Make `Current' unusable in a multi-threaded system.
		do
			is_thread_safe:=true
		end

	internal_mutex:MUTEX
			-- A mutex to sinchronize the file input/output and position

	lock_mutex
			-- Lock the internal mutex to prevent multiple access to the package file
		do
			if is_thread_safe then
				internal_mutex.lock
			end

		end

	unlock_mutex
			-- Unlock the internal mutex
		do
			if is_thread_safe then
				internal_mutex.unlock
			end
		end

feature {NONE} -- Implementation

	end_of_file_internal:BOOLEAN
			-- When `is_asset' is `True', contain the value of `end_of_file'

	set_name (a_name: READABLE_STRING_GENERAL)
			-- <Precursor>
		local
			l_path:PATH
		do
			Precursor(a_name)
			create l_path.make_from_string (a_name)
			is_asset := l_path.is_relative
		end

	set_path (a_path: PATH)
			-- <Precursor>
		do
			Precursor(a_path)
			is_asset := a_path.is_relative
		end

	buffered_file_info: ANDROID_FILE_INFO
			-- Information about the file.
		once
			create Result.make
		end

	set_buffer
			-- Resynchronizes information on file
		do
			if is_asset then
				if not is_closed then
					buffered_file_info.fast_update_asset (internal_name, internal_name_pointer, count)
				else
					buffered_file_info.fast_update_asset (internal_name, internal_name_pointer, 0)
				end
			else
				buffered_file_info.fast_update (internal_name, internal_name_pointer)
			end

		end

	internal_read_natural_16_big_endian
			-- Read the next 16-bit natural in the file (Reading in Big-Endian order).
			-- Make the result available in `last_natural_16'.
		require
			File_Readable:is_readable
		local
			l_temp:NATURAL_16
			l_old_natural_8:NATURAL_8
		do
			l_old_natural_8 := last_natural_8
			read_natural_8
			l_temp:=last_natural_8.to_natural_16.bit_shift_left (8)
			read_natural_8
			last_natural_16:=last_natural_8.to_natural_16.bit_or (l_temp)
			last_natural_8 := l_old_natural_8
		end

	internal_read_natural_32_big_endian
			-- Read the next 32-bit natural in the file (Reading in Big-Endian order).
			-- Make the result available in `last_natural_32'.
		require
			File_Readable:is_readable
		local
			l_temp:NATURAL_32
			l_old_natural_16:NATURAL_16
		do
			l_old_natural_16 := last_natural_16
			internal_read_natural_16_big_endian
			l_temp:=last_natural_16.to_natural_32.bit_shift_left (16)
			internal_read_natural_16_big_endian
			last_natural:=last_natural_16.to_natural_32.bit_or (l_temp)
			last_natural_16 := l_old_natural_16
		end

	internal_read_natural_64_big_endian
			-- Read the next 64-bit natural in the file (Reading in Big-Endian order).
			-- Make the result available in `last_natural_64'.
		require
			File_Readable:is_readable
		local
			l_temp:NATURAL_64
			l_old_natural:NATURAL_32
		do
			l_old_natural := last_natural
			internal_read_natural_32_big_endian
			l_temp:=last_natural_32.to_natural_64.bit_shift_left (16)
			internal_read_natural_32_big_endian
			last_natural_64:=last_natural_32.to_natural_64.bit_or (l_temp)
			last_natural := l_old_natural
		end

	internal_read_natural_16_little_endian
			-- Read the next 16-bit natural in the file (Reading in Little-Endian order).
			-- Make the result available in `last_natural_16'.
		require
			File_Readable:is_readable
		local
			l_temp:NATURAL_16
			l_old_natural_8:NATURAL_8
		do
			l_old_natural_8 := last_natural_8
			read_natural_8
			l_temp:=last_natural_8.to_natural_16
			read_natural_8
			last_natural_16:=l_temp.bit_or (last_natural_8.to_natural_16.bit_shift_left (8))
			last_natural_8 := l_old_natural_8
		end

	internal_read_natural_32_little_endian
			-- Read the next 32-bit natural in the file (Reading in Little-Endian order).
			-- Make the result available in `last_natural_32'.
		require
			File_Readable:is_readable
		local
			l_temp:NATURAL_32
			l_old_natural_16:NATURAL_16
		do
			l_old_natural_16 := last_natural_16
			internal_read_natural_16_little_endian
			l_temp:=last_natural_16.to_natural_32
			internal_read_natural_16_little_endian
			last_natural:=l_temp.bit_or (last_natural_16.to_natural_32.bit_shift_left (16))
			last_natural_16 := l_old_natural_16
		end

	internal_read_natural_64_little_endian
			-- Read the next 64-bit natural in the file (Reading in Little-Endian order).
			-- Make the result available in `last_natural_64'.
		require
			File_Readable:is_readable
		local
			l_temp:NATURAL_64
			l_old_natural:NATURAL_32
		do
			l_old_natural := last_natural
			internal_read_natural_32_little_endian
			l_temp:=last_natural_32.to_natural_64
			internal_read_natural_32_little_endian
			last_natural_64:=l_temp.bit_or (last_natural_32.to_natural_64.bit_shift_left (16))
			last_natural := l_old_natural
		end

	internal_put_natural_16_big_endian(a_value:NATURAL_16)
			-- Write `a_value' at current position (Writing in Big-Endian order).
		require
			extendible: extendible
		do
			put_natural_8 (a_value.bit_shift_right (8).to_natural_8)
			put_natural_8 (a_value.bit_and (0xFF).to_natural_8)
		end

	internal_put_natural_16_little_endian(a_value:NATURAL_16)
			-- Write `a_value' at current position (Writing in Little-Endian order).
		require
			extendible: extendible
		do
			put_natural_8 (a_value.bit_and (0xFF).to_natural_8)
			put_natural_8 (a_value.bit_shift_right (8).to_natural_8)
		end

	internal_put_natural_32_big_endian(a_value:NATURAL_32)
			-- Write `a_value' at current position (Writing in Big-Endian order).
		require
			extendible: extendible
		do
			internal_put_natural_16_big_endian(a_value.bit_shift_right (16).to_natural_16)
			internal_put_natural_16_big_endian(a_value.bit_and (0xFFFF).to_natural_16)
		end

	internal_put_natural_32_little_endian(a_value:NATURAL_32)
			-- Write `a_value' at current position (Writing in Little-Endian order).
		require
			extendible: extendible
		do
			internal_put_natural_16_little_endian(a_value.bit_and (0xFFFF).to_natural_16)
			internal_put_natural_16_little_endian(a_value.bit_shift_right (16).to_natural_16)
		end

invariant
	File_Ptr_Not_Null: not (is_closed xor file_pointer.is_default_pointer)

end
