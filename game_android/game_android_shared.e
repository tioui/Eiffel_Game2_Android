note
	description: "Inherit from this class to use the {GAME_LIBRARY_CONTROLLER} singleton named game_library"
	author: "Louis Marchand"
	date: "Fri, 22 Jul 2016 19:34:30 +0000"
	revision: "1.0"

deferred class
	GAME_ANDROID_SHARED

feature -- Access

	game_android:GAME_ANDROID_CONTROLLER
			-- The android controller of the game library
		once ("PROCESS")
			if attached internal_game_android as la_game_android then
				Result := la_game_android
			else
				create Result
			end
		end

feature {NONE} -- Implementation

	internal_game_android:detachable GAME_ANDROID_CONTROLLER
			-- Assign to this attribute prior to use `game_android' to inject a specific {GAME_ANDROID_CONTROLLER} singleton.

end
