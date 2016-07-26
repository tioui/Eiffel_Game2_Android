note
	description : "Root class for the animation using renderer example"
	author		: "Louis Marchand"
	date        : "Wed, 16 Mar 2016 23:29:16 +0000"
	revision    : "2.1"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'
	IMG_LIBRARY_SHARED		-- To use `image_file_library'
	TEXT_LIBRARY_SHARED		-- To use `text_library'
	AUDIO_LIBRARY_SHARED
	PLATFORM_SPECIFIC
	EXCEPTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_engine:detachable ENGINE
		do
			audio_library.enable_sound
			game_library.enable_video -- Enable the video functionalities
			image_file_library.enable_image (true, false, false)  -- Enable PNG image (but not TIF or JPG).
			text_library.enable_text
			create l_engine.make
			if not l_engine.has_error then
				l_engine.run
			else
				print_error ("An error occured.%N")
			end
			l_engine := Void				-- To be sure that the garbage collector can collect everything before quitting the libraries
			game_library.clear_all_events	-- To be sure that an object is not stocked inside an event agent
			image_file_library.quit_library  -- Correctly unlink image files library
			game_library.quit_library  -- Clear the library before quitting
			text_library.quit_library
			audio_library.quit_library
		rescue
			if attached exception_trace as la_trace then
				print_error (la_trace)
			end
		end


end
