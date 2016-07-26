note
	description: "Summary description for {ANDROID_FILE_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANDROID_FILE_INFO

inherit
	FILE_INFO
		redefine
			protection, type, inode, size, user_id, group_id, date,
			access_date, change_date, device, device_type, links,
			owner_name, group_name, is_plain, is_device, is_directory,
			is_symlink, is_fifo, is_socket, is_block, is_character,
			is_readable, is_writable, is_executable, is_setuid,
			is_setgid, is_sticky, is_owner, is_access_owner,
			is_access_readable, is_access_writable, is_access_executable,
			fast_update, copy
		end

create
	make

feature -- Access

	protection: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 0c444
			else
				Result := Precursor
			end

		end

	type: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 0c100000
			else
				Result := Precursor
			end
		end

	inode: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 0
			else
				Result := Precursor
			end
		end

	size: INTEGER
			-- <Precursor>
		do
			if is_asset then
				Result := internal_size
			else
				Result := Precursor
			end
		end

	user_id: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 0
			else
				Result := Precursor
			end
		end

	group_id: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 0
			else
				Result := Precursor
			end
		end

	date: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 0
			else
				Result := Precursor
			end
		end

	access_date: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 0
			else
				Result := Precursor
			end
		end

	change_date: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 0
			else
				Result := Precursor
			end
		end

	device: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 0
			else
				Result := Precursor
			end
		end

	device_type: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 0
			else
				Result := Precursor
			end
		end

	links: INTEGER
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := 1
			else
				Result := Precursor
			end
		end

	owner_name: STRING
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := "Android"
			else
				Result := Precursor
			end
		end

	group_name: STRING
			-- <Precursor>
			-- Not supported for Android assets
		do
			if is_asset then
				Result := "Android"
			else
				Result := Precursor
			end
		end

feature -- Status report

	is_plain: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := True
			else
				Result := Precursor
			end
		end

	is_device: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_directory: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
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

	is_fifo: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_socket: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_block: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_character: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_readable: BOOLEAN
			-- <Precursor>
		local
			l_file:POINTER
			l_c_mode:C_STRING
			l_error:INTEGER
		do
			if is_asset then
				if attached internal_name_pointer as la_pointer then
					create l_c_mode.make ("rb")
					l_file := {GAME_FILE_EXTERNAL}.sdl_rw_from_file(la_pointer.item, l_c_mode.item)
					Result := not l_file.is_default_pointer
					if not l_file.is_default_pointer then
						Result := True
						l_error := {GAME_FILE_EXTERNAL}.sdl_rw_close(l_file)
					else
						Result := False
					end
				else
					Result := False
				end
			else
				Result := Precursor
			end
		end

	is_writable: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_executable: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_setuid: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_setgid: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_sticky: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_owner: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := True
			else
				Result := Precursor
			end
		end

	is_access_owner: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := True
			else
				Result := Precursor
			end
		end

	is_access_readable: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := is_readable
			else
				Result := Precursor
			end
		end

	is_access_writable: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

	is_access_executable: BOOLEAN
			-- <Precursor>
		do
			if is_asset then
				Result := False
			else
				Result := Precursor
			end
		end

feature -- Duplication

	copy (a_other: like Current)
			-- <Precursor>
		do
			if a_other /= Current then
				standard_copy (a_other)
				set_area (a_other.buffered_file_info.twin)
				if attached a_other.internal_name_pointer as l_pointer then
					internal_name_pointer := l_pointer.twin
				end
				if attached a_other.internal_file_name as l_file_name then
					internal_file_name := l_file_name.twin
				end
				is_asset := a_other.is_asset
				internal_size := a_other.internal_size
				exists := a_other.exists
			end
		ensure then
			not_shared_if_different: a_other /= Current implies buffered_file_info /= a_other.buffered_file_info
			equal_buffered_file_infos: buffered_file_info ~ a_other.buffered_file_info
		end

feature {FILE, DIRECTORY} -- Element change

	fast_update_asset (f_name: READABLE_STRING_GENERAL; a_ptr: MANAGED_POINTER; a_size:INTEGER)
			-- Update information buffer: fill it in with information
			-- from the inode of `f_name'.
		require
			f_name_not_empty: not f_name.is_empty
			a_ptr_not_empty: a_ptr.count > 0
		do
				-- Do not duplicate the file name. That way, if the file is
				-- renamed, the name here will change accordingly and access()
				-- based calls will continue to work properly.	
			internal_file_name := f_name
			internal_name_pointer := a_ptr
			is_asset := True
			internal_size := a_size
			exists := is_readable
		ensure
			file_name_set: internal_file_name = f_name
		end

	fast_update (f_name: READABLE_STRING_GENERAL; a_ptr: MANAGED_POINTER)
			-- <Precursor>
		do
			is_asset := False
			Precursor(f_name, a_ptr)
		end

feature {ANDROID_FILE_INFO} -- Implementation

	internal_size:INTEGER
			-- Is `is_asset' is set, represent the size of the Android asset

	is_asset:BOOLEAN
			-- The file represented by `Current' is an Android asset

end
