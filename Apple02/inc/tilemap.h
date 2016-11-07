#define TILEMAP_WIDTH       40
#define TILEMAP_HEIGHT      28
#define TILEMAP_SIZE        (TILEMAP_WIDTH * TILEMAP_HEIGHT)

#define MAXTILE_PER_FRAME   512


// current unpack read buffer
extern u16* tilemapUnpackRead;
// current unpack write buffer
extern u16* tilemapUnpackWrite;

// current read buffer
extern u16* tilemapRead;
// current write buffer
extern u16* tilemapWrite;

extern u16 baseTileInd;


void tilemap_init();

void tilemap_unpack();

void unpack_rle(u16* buf);
void unpack_rle_binary(u16* buf);

void tilemap_prepareBuffer();

