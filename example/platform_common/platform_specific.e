note
	description: "Features specific to the common platform (Linux, Windows, MacOSX)."
	author: "Louis Marchand"
	date: "Fri, 22 Jul 2016 19:25:50 +0000"
	revision: "1.0"

class
	PLATFORM_SPECIFIC

feature -- Access

	print_message(a_message:READABLE_STRING_GENERAL)
			-- Print an information message in the system log
		do
			io.standard_default.put_string ((a_message + "%N").as_string_8)
		end

	print_error(a_message:READABLE_STRING_GENERAL)
			-- Print an error message in the system log
		do
			io.error.put_string ((a_message + "%N").as_string_8)
		end

	assets_directory:READABLE_STRING_GENERAL
			-- The directory containing assets (images, sounds, font, etc.)
		do
			Result := "."
		end

end
