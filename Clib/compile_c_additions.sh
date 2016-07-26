#!/bin/bash
pushd android_main
finish_freezing -library
popd 
pushd cpf
finish_freezing -library
popd 
pushd game_core
finish_freezing -library
popd 
pushd audio_sound_file
finish_freezing -library
popd 
