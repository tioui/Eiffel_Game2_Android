note
	description: "An example of sprite animation and movement using renderer and video card synchronisation"
	author: "Louis Marchand"
	date: "Wed, 16 Mar 2016 23:29:16 +0000"
	revision: "1.0"

class
	ENGINE

inherit
	GAME_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED
	PLATFORM_SPECIFIC

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization of `Current'
		local
			l_window_builder:GAME_WINDOW_RENDERED_BUILDER
		do
			create l_window_builder
			l_window_builder.enable_resizable
			l_window_builder.enable_maximized
			window := l_window_builder.generate_window
			window.renderer.set_logical_size (1024, 512)
			print_message("Creating the desert")
			create desert.make (window.renderer)
			if desert.has_error then
				print_message("Done... With Error")
				print_message("Error message: " + game_library.last_error)
			else
				print_message("Done...")
			end
			print_message("Creating the mario")
			create maryo.make (window.renderer)
			if desert.has_error then
				print_message("Done... With Error")
				print_message("Error message: " + game_library.last_error)
			else
				print_message("Done...")
			end
			has_error := desert.has_error
			print_message("Creating the font")
			create font.make ("font.ttf", 15)
			if font.is_openable then
				font.open
				if not font.is_open then
					print_message("Done... With Error")
					has_error := True
				else
					print_message("Done...")
				end
			else
				print_message("Done... With Error")
				has_error := True
			end
			make_music
		end

	make_music
		local
			l_sound:AUDIO_SOUND_FILE
		do
			audio_library.sources_add
			music_source := audio_library.last_source_added
			create l_sound.make ("intro.ogg")
			sound_sound(l_sound)
			if l_sound.is_open then
				music_source.queue_sound (l_sound)
			end
			music_intro := l_sound
			create l_sound.make ("loop.flac")
			sound_sound(l_sound)
			if l_sound.is_open then
				music_source.queue_sound_infinite_loop (l_sound)
			end
			music_loop := l_sound
		end
	
	sound_sound(a_sound:AUDIO_SOUND)
		do
			if a_sound.is_openable then
				a_sound.open
				if not a_sound.is_open then
					has_error := True
				end
			else
				has_error := True
			end
		end

feature -- Access

	run
			-- Launch the game
		require
			No_Error: not has_error
		do
			window.renderer.set_drawing_color (create {GAME_COLOR}.make_rgb (0, 0, 0))
			window.renderer.clear
			window.renderer.set_drawing_color (create {GAME_COLOR}.make_rgb (0, 128, 255))
			maryo.y := 375
			maryo.x := 400
			game_library.quit_signal_actions.extend (agent on_quit)
			window.mouse_button_pressed_actions.extend (agent on_mouse_pressed)
			window.mouse_button_released_actions.extend (agent on_mouse_released)
			game_library.iteration_actions.extend (agent on_iteration)
			music_source.play
			game_library.launch
			music_source.stop
		end

	has_error:BOOLEAN
			-- `True' if an error occured during the creation of `Current'

	window:GAME_WINDOW_RENDERED
			-- The window to draw the scene

	maryo:MARYO
			-- The main character of the game

	desert:DESERT
			-- The background

	font:TEXT_FONT
			-- {TEXT_FONT} used to draw text on the `window'

	music_source:AUDIO_SOURCE
			-- The source of the background music

	music_intro, music_loop:AUDIO_SOUND
			-- The background music

feature {NONE} -- Implementation

	on_iteration(a_timestamp:NATURAL_32)
			-- Event that is launch at each iteration.
		local
			l_text_surface:TEXT_SURFACE_BLENDED
			l_rotated_surface: GAME_SURFACE_ROTATE_ZOOM
		do
			audio_library.update
			maryo.update (a_timestamp)	-- Update Maryo animation and coordinate

			if maryo.x < 0 then		-- Be sure that Maryo does not get out of the screen
				maryo.x := 0
			elseif maryo.x + maryo.sub_image_width > desert.width then
				maryo.x := desert.width - maryo.sub_image_width
			end

			-- Draw the scene

			window.renderer.set_drawing_color (create {GAME_COLOR}.make_rgb (0, 0, 0))		-- Clearing the screen is important to
			window.renderer.clear															-- remove off-screen artefact
			window.renderer.set_drawing_color (create {GAME_COLOR}.make_rgb (0, 128, 255))	-- Redraw the blue sky
			window.renderer.draw_filled_rectangle (0, 0, desert.width, desert.height)

			window.renderer.draw_texture (desert, 0, 0)		-- Redraw the desert
			window.renderer.draw_sub_texture_with_mirror (		-- Redraw Maryo
									maryo,  maryo.sub_image_x, maryo.sub_image_y, maryo.sub_image_width, maryo.sub_image_height,
									maryo.x, maryo.y, False, maryo.facing_left
								)
			create l_text_surface.make (maryo.x.out, font, create {GAME_COLOR}.make_rgb (0, 0, 0))
			create l_rotated_surface.make_rotate (l_text_surface, 30, False)
			window.renderer.draw_texture (create {GAME_TEXTURE}.make_from_surface (window.renderer, l_rotated_surface) , 100, 10)

			window.renderer.present		-- Update modification in the screen
		end

	on_mouse_pressed(a_timestamp:NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_PRESS_EVENT; a_nb_clicks:NATURAL_8)
			-- Action when a mouse button is pressed on the `window'
		do
			if a_mouse_state.is_left_button_pressed then
				maryo.stop_left
				maryo.stop_right
				if a_mouse_state.x < (window.renderer.logical_size.width // 2) then
					maryo.go_left(a_timestamp)
				else
					maryo.go_right(a_timestamp)
				end
			end
		end

	on_mouse_released(a_timestamp:NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_RELEASE_EVENT; a_nb_clicks:NATURAL_8)
			-- Action when a mouse button is released on the `window'
		do
			if a_mouse_state.is_left_button_released then
				maryo.stop_left
				maryo.stop_right
			end
		end

	on_quit(a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

end
