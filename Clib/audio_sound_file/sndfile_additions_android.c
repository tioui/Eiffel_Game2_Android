/* Util function for Eiffel Game Lib. 	*
 * Author: Louis Marchand		*
 * Date: June 10, 2012			*
 * Version: 2.0				*/

#include "sndfile_additions_android.h"

sf_count_t fileLength_RW(void* UserData)
{
	return SDL_RWsize((SDL_RWops*)UserData);
}

sf_count_t fileSeek_RW(sf_count_t offset, int whence, void *user_data)
{
	int whence_rw;
	switch (whence)
	{
		case SEEK_SET:
			whence_rw = RW_SEEK_SET;
			break;
		case SEEK_CUR:
			whence_rw = RW_SEEK_CUR;
			break;
		case SEEK_END:
			whence_rw = RW_SEEK_END;
			break;
		default:
			whence_rw = whence;
	}
	return SDL_RWseek((SDL_RWops*) user_data, offset, whence_rw); 
}

sf_count_t fileTell_RW(void *user_data)
{
	return SDL_RWtell((struct SDL_RWops*)user_data);
}

sf_count_t fileRead_RW(void *ptr, sf_count_t count, void *user_data)
{
	return SDL_RWread((struct SDL_RWops*) user_data, ptr, 1, count);
}

sf_count_t fileWrite_RW(const void *ptr, sf_count_t count, void *user_data)
{
	return SDL_RWwrite((struct SDL_RWops*) user_data, ptr, 1, count);
}
/* Functions to add the "Android Asset" functionality	*/

void setSndFileVirtualIo_RW(SF_VIRTUAL_IO *VirtualIO)
{
	VirtualIO->get_filelen = &fileLength_RW;
	VirtualIO->read = &fileRead_RW;
	VirtualIO->seek = &fileSeek_RW;
	VirtualIO->tell = &fileTell_RW;
	VirtualIO->write = &fileWrite_RW;
}


