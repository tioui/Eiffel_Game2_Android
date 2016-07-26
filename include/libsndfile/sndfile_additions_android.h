#ifndef AUDIO_ADDITIONS_ANDROID_H
#define AUDIO_ADDITIONS_ANDROID_H
#include <sndfile.h>
#include <SDL.h>

void setSndFileVirtualIo_RW(SF_VIRTUAL_IO *VirtualIO);

#endif
