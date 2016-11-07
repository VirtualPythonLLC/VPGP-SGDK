#include "genesis.h"
#include "kdebug.h"

#include "main.h"
#include "tile.h"
#include "tilemap.h"
#include "tools.h"


#define TILE_COMPRESSION_DICO_0             0
#define TILE_COMPRESSION_DICO_1             1
#define TILE_COMPRESSION_PLAIN_AND_PIX      2
#define TILE_COMPRESSION_DERIVE_SAME        3
#define TILE_COMPRESSION_DERIVE_OTHER       4
#define TILE_COMPRESSION_COPY               5
#define TILE_COMPRESSION_RAW                6
#define TILE_COMPRESSION_PLAIN              7


// tile buffer 0
u8 buf1[512 * 32];
// tile buffer 1
u8 buf2[512 * 32];

// current read buffer
u8* tileRead;
// current write buffer
u8* tileWrite;


void tile_init()
{
    tileWrite = buf1;
    tileRead = buf2;
}
