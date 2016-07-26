#!/bin/bash
pushd Clib/android_main
finish_freezing -library
popd 
pushd Clib/cpf
finish_freezing -library
popd 
pushd Clib/game_core
finish_freezing -library
popd 
