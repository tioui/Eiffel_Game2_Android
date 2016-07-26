#!/bin/sh
cd libs
for f in * ; do ln -s $f android-${f} ; done
