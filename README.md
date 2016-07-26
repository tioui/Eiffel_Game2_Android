The library has been compiled and has been confirmed to run on Android architecture armeabi, armeabi-v7a and x86.

Download the source code of:
	SDL2
	SDL2_image
	SDL2_ttf

Configuring Android compilation
	# sudo apt-get install openjdk-8-jdk ant libncurses5:i386 libbz2-1.0:i386 libstdc++6:i386 libz1:i386
	# export PATH=/opt/android-ndk:$PATH
	# export PATH=/home/louis/Android/Sdk/tools:$PATH
		-> Use the commande `android` to install API 12
	# export PATH=/home/louis/Android/Sdk/platform-tools:$PATH

Extract the SDL2 source
	# tar xvfz SDL2-2.0.4.tar.gz
	# tar xvfz SDL2_image-2.0.1.tar.gz
	# tar xvfz SDL2_ttf-2.0.14.tar.gz

Preparing the SDL2 wrapper:
	# tar xvfz SDL2-2.0.4.tar.gz
	# cd SDL2-2.0.4/build-scripts
	# vim androidbuild.sh
	 	-> Find the line "$ANDROID update project --path $BUILDPATH" (118) and append:
	 		--target android-12
	# ./androidbuild.sh org.eiffelgame2 /dev/null
	 	-> Change the "org.eiffelgame2" for your companie
	 	-> Does not matter if it fail, it is just for the setup.
	# cd ../build/org.eiffelgame2
	# rm -rf jni/src/	# Dummy files

Linking SDL2_image and SDL2_ttf to the SDL2 wrapper:
	# ln -s /directory/to/SDL2_image jni/
	# ln -s /directory/to/SDL2_image/external/libwebp-0.3.0 jni/webp
	# ln -s /directory/to/SDL2_ttf jni/
	
Building .so files:
	# ndk-build -j$(nproc)

The .so files are in the libs sub-directories.
	-> Copie the libs directory in the Eiffel Game2 android directory:
		# cp -rp libs $EIFFEL_LIBRARY/contrib/library/game2/android/
	-> Create the links to match EiffelStudio Spec (for each spec):
		# cd $EIFFEL_LIBRARY/contrib/library/game2/android/
		# ./link_libs.sh

Compiling the Additions C files:
	-> For each platform (ex: android-14-arm, android-14-x86, etc.)
		-> Be sure to have set the environment variables $ISE_EIFFEL and $EIFFEL_LIBRARY (generally the same value than $ISE_EIFFEL)
		# export ISE_PLATFORM=android-14-arm
		# export PATH=$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin:$PATH
		# ./compile_c_additions.sh

To compile a project:
	-> Create a new .ecf file for your Android version of the program (or create another target)
	-> Change the Game2 library .ecf files whith those in the android/configs directory
	-> Add the Android definition files to the Android target of your application .ecf file:
		<setting name="shared_library_definition" value="$EIFFEL_LIBRARY\contrib\library\game2\android\android.def"/>
	-> If your application root feature is different than {APPLICATION}.`make', change the definition file.
	-> Compile the Android target with your Android spec
		-> The C compilation of the application will fail with:
				SDL_android_main.c:61: error: undefined reference to 'init_rt'
				SDL_android_main.c:62: error: undefined reference to 'android_main'
			-> It is ok because we don't need the application, we only need the shared library of the project.
			-> If your EIFGENs/**/F_code contain a .so file, the compilation succeeded.
	-> Copie the generated .so file in the Android project libs sub-directory and name it libmain.so .
	-> To generate an apk file and put it on an android device, you can use "ant":
		# ant debug install
	
