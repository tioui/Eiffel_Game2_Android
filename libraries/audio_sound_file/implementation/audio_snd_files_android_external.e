note
	description: "Summary description for {AUDIO_SND_FILES_ANDROID_EXTERNAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUDIO_SND_FILES_ANDROID_EXTERNAL

feature -- External

	frozen set_snd_file_virtual_io_rw(virtual_io:POINTER)
		external
			"C (SF_VIRTUAL_IO *) | <sndfile_additions.h>"
		alias
			"setSndFileVirtualIo_RW"
		end

end
