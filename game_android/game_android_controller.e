note
	description: "Multiple functionnality for Android"
	author: "Louis Marchand"
	date: "Fri, 22 Jul 2016 19:03:45 +0000"
	revision: "0.1"

class
	GAME_ANDROID_CONTROLLER

feature -- Access

	external_storage:READABLE_STRING_GENERAL
			-- The public storage for the Android Application
			-- Every one has access to this storage
		do
			Result := path_name_from_c_pointer(sdl_android_get_external_storage_path)
		end

	is_external_storage_readable:BOOLEAN
			-- True if the storage is readable by the android application
		do
			Result := (sdl_android_get_external_storage_state.bit_and (sdl_android_external_storage_read) /= 0)
		end

	is_external_storage_writable:BOOLEAN
			-- True if the storage is writable by the android application
		do
			Result := (sdl_android_get_external_storage_state.bit_and (sdl_android_external_storage_write) /= 0)
		end

	internal_storage:READABLE_STRING_GENERAL
			-- The private storage for the Android Application
			-- Only the current android appication has access to this storage
		do
			Result := path_name_from_c_pointer(sdl_android_get_internal_storage_path)
		end

	print_log(a_tag, a_message:READABLE_STRING_GENERAL)
			-- Print an information `a_message' to the android log system identified by `a_tag'
		do
			print_log_with_priority(android_log_info, a_tag, a_message)
		end

	print_verbose_log(a_tag, a_message:READABLE_STRING_GENERAL)
			-- Print a verbose `a_message' to the android log system identified by `a_tag'
		do
			print_log_with_priority(android_log_verbose, a_tag, a_message)
		end

	print_debug_log(a_tag, a_message:READABLE_STRING_GENERAL)
			-- Print a debug `a_message' to the android log system identified by `a_tag'
		do
			print_log_with_priority(android_log_debug, a_tag, a_message)
		end

	print_warning_log(a_tag, a_message:READABLE_STRING_GENERAL)
			-- Print a warning `a_message' to the android log system identified by `a_tag'
		do
			print_log_with_priority(android_log_warn, a_tag, a_message)
		end

	print_error_log(a_tag, a_message:READABLE_STRING_GENERAL)
			-- Print an error `a_message' to the android log system identified by `a_tag'
		do
			print_log_with_priority(android_log_error, a_tag, a_message)
		end

	print_fatal_error_log(a_tag, a_message:READABLE_STRING_GENERAL)
			-- Print a fatal error `a_message' to the android log system identified by `a_tag'
		do
			print_log_with_priority(android_log_fatal, a_tag, a_message)
		end

feature {NONE} -- Implementation

	print_log_with_priority(a_priority:INTEGER; a_tag, a_message:READABLE_STRING_GENERAL)
			-- Print `a_message' to the android log system identified by `a_tag' and prioritized using `a_priority'
		local
			l_c_tag, l_c_message:C_STRING
			l_converter:UTF_CONVERTER
			a_error:INTEGER
		do
			create l_converter
			if a_tag.is_string_8 then
				create l_c_tag.make (a_tag)
			else
				create l_c_tag.make (l_converter.string_32_to_utf_8_string_8(a_tag.as_string_32))
			end
			if a_message.is_string_8 then
				create l_c_message.make (a_message)
			else
				create l_c_message.make (l_converter.string_32_to_utf_8_string_8(a_message.as_string_32))
			end
			a_error := android_log_write(a_priority, l_c_tag.item, l_c_message.item)
		end

	path_name_from_c_pointer(a_pointer:POINTER):READABLE_STRING_GENERAL
			-- Take a UTF-8 C string `a_pointer' and convert it to a STRING_32
		local
			l_pointer:POINTER
			l_c_string:C_STRING
			l_converter:UTF_CONVERTER
		do
			if not a_pointer.is_default_pointer then
				create l_converter
				create l_c_string.make_shared_from_pointer (a_pointer)
				Result := l_converter.utf_8_string_8_to_string_32 (l_c_string.string)
			else
				Result := ""
			end
		end

feature {NONE} -- Externals

	frozen android_log_write(a_priority:INTEGER; a_tag, a_text:POINTER):INTEGER
		external
			"C inline use <android/log.h>"
		alias
			"__android_log_write($a_priority, (const char *) $a_tag, (const char *) $a_text)"
		end

	frozen android_log_verbose:INTEGER
		external
			"C inline use <android/log.h>"
		alias
			"ANDROID_LOG_VERBOSE"
		end

	frozen android_log_debug:INTEGER
		external
			"C inline use <android/log.h>"
		alias
			"ANDROID_LOG_DEBUG"
		end

	frozen android_log_info:INTEGER
		external
			"C inline use <android/log.h>"
		alias
			"ANDROID_LOG_INFO"
		end

	frozen android_log_warn:INTEGER
		external
			"C inline use <android/log.h>"
		alias
			"ANDROID_LOG_WARN"
		end

	frozen android_log_error:INTEGER
		external
			"C inline use <android/log.h>"
		alias
			"ANDROID_LOG_ERROR"
		end

	frozen android_log_fatal:INTEGER
		external
			"C inline use <android/log.h>"
		alias
			"ANDROID_LOG_FATAL"
		end

	frozen sdl_android_get_external_storage_path:POINTER
			-- See: https://wiki.libsdl.org/SDL_AndroidGetExternalStoragePath
		external
			"C inline use <SDL.h>"
		alias
			"SDL_AndroidGetExternalStoragePath()"
		end

	frozen sdl_android_get_internal_storage_path:POINTER
			-- See: https://wiki.libsdl.org/SDL_AndroidGetInternalStoragePath
		external
			"C inline use <SDL.h>"
		alias
			"SDL_AndroidGetInternalStoragePath()"
		end

	frozen sdl_android_get_external_storage_state:INTEGER
			-- See: https://wiki.libsdl.org/SDL_AndroidGetExternalStorageState
		external
			"C inline use <SDL.h>"
		alias
			"SDL_AndroidGetExternalStorageState()"
		end

	frozen sdl_android_external_storage_read:INTEGER
			-- See: https://wiki.libsdl.org/SDL_AndroidGetExternalStorageState
		external
			"C inline use <SDL.h>"
		alias
			"SDL_ANDROID_EXTERNAL_STORAGE_READ"
		end

	frozen sdl_android_external_storage_write:INTEGER
			-- See: https://wiki.libsdl.org/SDL_AndroidGetExternalStorageState
		external
			"C inline use <SDL.h>"
		alias
			"SDL_ANDROID_EXTERNAL_STORAGE_WRITE"
		end

end
