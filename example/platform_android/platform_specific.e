note
	description: "Features specific to the common platform (Linux, Windows, MacOSX)."
	author: "Louis Marchand"
	date: "Fri, 22 Jul 2016 19:25:50 +0000"
	revision: "1.0"

class
	PLATFORM_SPECIFIC

inherit
	GAME_ANDROID_SHARED

feature -- Access

	print_message(a_message:READABLE_STRING_GENERAL)
			-- Print a message in the system log
		do
			game_android.print_log ("Eiffel Game2", a_message)
		end

	print_error(a_message:READABLE_STRING_GENERAL)
			-- Print an error message in the system log
		do
			game_android.print_error_log ("Eiffel Game2", a_message)
		end

end
