Android port of the Eiffel Game2 library
========================================

This is a port of the Eiffel Game2 library that you can find at https://github.com/tioui/Eiffel_Game2 .

Note: The library has been compiled and has been confirmed to run on Android architecture armeabi and armeabi-v7a.

Pre-installation
----------------
Before installing, you should install the Android NDK, create toolchains for every Android architectures you want to support and generate the Eiffel compilers for the Android architectures. To do this use this link: https://github.com/tioui/Eiffel_Spec/tree/master/android-spec .

You should also get the Android .so files of the following C library:
 * SDL2 (Needed)
 * SDL2_image (Optionnal: For game_image_file library)
 * SDL2_ttf (Optionnal: For game_text library)
 * SDL2_gfx (Optionnal: For game_effects library)
 * OpenAL (Optionnal: For Audio library)
 * libsndfile (Optionnal: For audio_sound_file library)
 * libogg, libvorbis, libvorbis-stream (Optionnal: if you want to use OGG sound files with audio_sound_file library)
 * libFLAC (Optionnal: if you want to use FLAC sound files with audio_sound_file library)

Installation
------------

* Install the Eiffel Game2 library. It should be installed at $EIFFEL_LIBRARY/contrib/library/game2 .
* Clone or extract the Android port in the $EIFFEL_LIBRARY/contrib/library/game2/android (this README.md file should be at $EIFFEL_LIBRARY/contrib/library/game2/android/README.md)
* Create the $EIFFEL_LIBRARY/contrib/library/game2/android/libs/armeabi folder
* Copy the C libraries .so files that you get in the pre-installation in the $EIFFEL_LIBRARY/contrib/library/game2/android/libs/armeabi folder
* Redo the last two steps for every Android architecture you want to support (armeabi, armeabi-v7a, x86, x86_64)
* Execute the link_libs.sh script:

```bash
cd $EIFFEL_LIBRARY/contrib/library/game2/android   # The $EIFFEL_LIBRARY must be set
./link_libs
```

 * Now, there is some C files to precompile. You have to use the compile_c_additions.sh script in the Clib directory like this:

```bash
cd $EIFFEL_LIBRARY/contrib/library/game2/android/Clib   # The $EIFFEL_LIBRARY must be set
export ISE_PLATFORM=android-armeabi
export PATH=$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin:$PATH
./compile_c_additions.sh
```

 * You shoud do those last commands for every Android architecture you want to support (armeabi, armeabi-v7a, x86, x86_64)
 * Your Android Eiffel Game2 library is not installed

Compiling with the Eiffel Game2 Android library
-----------------------------------------------

 * First, you shoud used a project that is working on PC. Creating a new project entirely for Android is asking for a lots of pain and suffering.
 * Copy the .ecf file of your project (for example, copy project.ecf to project_android.ecf)
 * Edit the .ecf for android (in our example, project_android.ecf)
 * Replace every ".ecf" library from the Eiffel Game2 library to the ones in $EIFFEL_LIBRARY/contrib/library/game2/android/libraries (if it exists)
 * Add a line to indicate to the Eiffel compiler to create a .so file instead of an executable binary:
```XML
<setting name="shared_library_definition" value="$EIFFEL_LIBRARY\contrib\library\game2\android\android.def"/>
```
 * Note that, if your project root feature is not {APPLICATION}.make, you should change the android.def file accordignly. If you don't want to modify the original, you can copy it and change the path in the 'setting' XML tags of the .ecf file.
 * For an example, here is the .ecf file of a standard Eiffel Game2 project:
```XML
<?xml version="1.0" encoding="ISO-8859-1"?>
<system xmlns="http://www.eiffel.com/developers/xml/configuration-1-15-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-15-0 http://www.eiffel.com/developers/xml/configuration-1-15-0.xsd" name="project" uuid="46FD29F2-0485-4A58-BDC7-E749CED4C3EE">
	<target name="project">
		<root class="APPLICATION" feature="make"/>
		<option is_obsolete_routine_type="true" void_safety="all" syntax="standard">
			<assertions precondition="true" postcondition="true" check="true" invariant="true" loop="true" supplier_precondition="true"/>
		</option>
		<precompile name="base_pre" location="$ISE_PRECOMP\base-safe.ecf"/>
		<library name="audio_3d" location="$ISE_LIBRARY\contrib\library\game2\audio\audio-safe.ecf"/>
		<library name="base" location="$ISE_LIBRARY\library\base\base-safe.ecf"/>
		<library name="eiffel_game" location="$EIFFEL_LIBRARY\contrib\library\game2\game_core\game_core-safe.ecf"/>
		<library name="game_effects" location="$ISE_LIBRARY\contrib\library\game2\game_effects\game_effects-safe.ecf"/>
		<library name="audio_sound_file" location="$ISE_LIBRARY\contrib\library\game2\audio_sound_file\audio_sound_file-safe.ecf"/>
		<library name="game_image_file" location="$EIFFEL_LIBRARY\contrib\library\game2\game_image_file\game_image_file-safe.ecf"/>
		<library name="game_text" location="$ISE_LIBRARY\contrib\library\game2\game_text\game_text-safe.ecf"/>
		<cluster name="project" location=".\" recursive="true">
			<file_rule>
				<exclude>/EIFGENs$</exclude>
			</file_rule>
		</cluster>
	</target>
</system>
```
 * Now, here is the same project for Android:
```XML
<?xml version="1.0" encoding="ISO-8859-1"?>
<system xmlns="http://www.eiffel.com/developers/xml/configuration-1-13-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-13-0 http://www.eiffel.com/developers/xml/configuration-1-13-0.xsd" name="project_android" uuid="46FD29F2-0485-4A58-BDC7-E749CED4C3EE">
	<target name="project_android">
		<root class="APPLICATION" feature="make"/>
		<option void_safety="all" syntax="standard">
			<assertions precondition="true" postcondition="true" check="true" invariant="true" loop="true" supplier_precondition="true"/>
		</option>
		<setting name="shared_library_definition" value="$EIFFEL_LIBRARY\contrib\library\game2\android\android.def"/>
		<library name="base" location="$ISE_LIBRARY\library\base\base-safe.ecf"/>
		<library name="game_android" location="$EIFFEL_LIBRARY\contrib\library\game2\android\game_android\game_android-safe.ecf"/>
		<library name="game_core" location="$EIFFEL_LIBRARY\contrib\library\game2\android\libraries\game_core-safe.ecf"/>
		<library name="audio" location="$EIFFEL_LIBRARY\contrib\library\game2\android\libraries\audio-safe.ecf"/>
		<library name="audio_sound_file" location="$EIFFEL_LIBRARY\contrib\library\game2\android\libraries\audio_sound_file-safe.ecf"/>
		<library name="game_effects" location="$EIFFEL_LIBRARY\contrib\library\game2\android\libraries\game_effects-safe.ecf"/>
		<library name="game_image_file" location="$EIFFEL_LIBRARY\contrib\library\game2\android\libraries\game_image_file-safe.ecf"/>
		<library name="game_text" location="$EIFFEL_LIBRARY\contrib\library\game2\android\libraries\game_text-safe.ecf"/>
		<cluster name="project" location=".\" recursive="true">
			<file_rule>
				<exclude>/EIFGENs$</exclude>
			</file_rule>
		</cluster>
	</target>
</system>
```
 * Now to compile the project for Android, you can used the EiffelStudio Launchers that you create for Android. You can also used those command lines:
```bash
cd directory/of/the/project
export ISE_PLATFORM=android-armeabi
export PATH=$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin:$PATH
ec -config project_android.ecf -finalize -c_compile
```
 * It is strangely normal that the compilation failed when creating the executable. This is because even if it create a .so file of the project, EiffelStudio still try to create an executable out of it but it lack two C function to do so (init_rt and android_main). Those functions will be linked directly on the Android device at run-time.
 * The important thing is, you shoud have a .so file in EIFGENs/project_android/F_code
 * You shoud compile for every Android architecture that you want to support (armeab, armeabi-v7a, x86, x86_64). Don't forget to backup the .so file for every compilation.
