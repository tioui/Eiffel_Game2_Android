note
	description: "Summary description for {GAME_FILE_EXTERNAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_FILE_EXTERNAL

feature -- Externals

	frozen sdl_rw_size(a_context:POINTER):INTEGER_64
		external
			"C inline use <SDL.h>"
		alias
			"SDL_RWsize((SDL_RWops*) $a_context)"
		end

	frozen sdl_rw_from_file(a_file, a_mode:POINTER):POINTER
		external
			"C inline use <SDL.h>"
		alias
			"SDL_RWFromFile((const char*) $a_file, (const char*) $a_mode)"
		end

	frozen sdl_rw_close(a_context:POINTER):INTEGER
		external
			"C inline use <SDL.h>"
		alias
			"SDL_RWclose((struct SDL_RWops*) $a_context)"
		end

	frozen sdl_rw_tell(a_context:POINTER):INTEGER_64
		external
			"C inline use <SDL.h>"
		alias
			"SDL_RWtell((SDL_RWops*) $a_context)"
		end

	frozen sdl_rw_read(a_context, a_buffer:POINTER; a_size, a_maxnum:INTEGER_64):INTEGER_64
		external
			"C inline use <SDL.h>"
		alias
			"SDL_RWread((struct SDL_RWops*) $a_context, $a_buffer, $a_size, $a_maxnum)"
		end

	frozen sdl_rw_seek(a_context:POINTER; a_offset:INTEGER_64; a_whence:INTEGER):INTEGER_64
		external
			"C inline use <SDL.h>"
		alias
			"SDL_RWseek((SDL_RWops*) $a_context, $a_offset, $a_whence)"
		end

	frozen sdl_rw_seek_set:INTEGER
		external
			"C inline use <SDL.h>"
		alias
			"RW_SEEK_SET"
		end

	frozen sdl_rw_seek_cur:INTEGER
		external
			"C inline use <SDL.h>"
		alias
			"RW_SEEK_CUR"
		end

	frozen sdl_rw_seek_end:INTEGER
		external
			"C inline use <SDL.h>"
		alias
			"RW_SEEK_END"
		end

	frozen end_of_file_char:NATURAL_8
		external
			"C inline use <stdio.h>"
		alias
			"EOF"
		end

	frozen is_space(a_char:CHARACTER_8):BOOLEAN
		external
			"C inline use <ctype.h>"
		alias
			"isspace($a_char)"
		end

end
