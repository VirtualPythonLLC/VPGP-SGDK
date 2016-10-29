#include "genesis.h"
#include "kdebug.h"

#include "main.h"
#include "tilemap.h"


#define TILEMAP_COMPRESSION_PLAIN               0
#define TILEMAP_COMPRESSION_RLE                 1
#define TILEMAP_COMPRESSION_RLE_BINARY          2
#define TILEMAP_COMPRESSION_PLAIN_AND_PIX       3
#define TILEMAP_COMPRESSION_DERIVE              4


// tilemap buffer 1
static u16 buf1[TILEMAP_SIZE];
// tile buffer 2
static u16 buf2[TILEMAP_SIZE];

// tilemap final buffer
static u16 buff1[64 * 28];
// tilemap final buffer
static u16 buff2[64 * 28];

// current unpack read buffer
u16* tilemapUnpackRead;
// current unpack write buffer
u16* tilemapUnpackWrite;

// current read buffer
u16* tilemapRead;
// current write buffer
u16* tilemapWrite;

u16 baseTileInd;


// forward
static void unpack01(u16 *dst, u16* prev);
static void unpack_plain_and_pix(u16* buf, u8 plainColor);
static void unpack_derive(u16* buf, u16* prev, u16 extra);

//static void log_(u16* dst);


void tilemap_init()
{
    tilemapUnpackWrite = buf1;
    tilemapUnpackRead = buf2;
    tilemapWrite = buff1;
    tilemapRead = buff2;

    baseTileInd = 16;

    memset(buff1, 0, sizeof(buff1));
    memset(buff2, 0, sizeof(buff2));
}


void tilemap_unpack()
{
    unpack01(tilemapUnpackWrite, tilemapUnpackRead);
    tilemap_prepareBuffer();
}


static void unpack01(u16 *dst, u16* prev)
{
    const u8 data = *movie_src++;

    // extra & compression
    const u8 extra = data & 0xF;
    const u8 header = data >> 4;

    switch (header & 0xF)
    {
        case TILEMAP_COMPRESSION_PLAIN:
            memsetU16(dst, extra, TILEMAP_SIZE);
            break;

        case TILEMAP_COMPRESSION_PLAIN_AND_PIX:
            unpack_plain_and_pix(dst, extra);
            break;

        case TILEMAP_COMPRESSION_RLE:
            unpack_rle(dst);
            break;

        case TILEMAP_COMPRESSION_RLE_BINARY:
            unpack_rle_binary(dst);
            break;

        case TILEMAP_COMPRESSION_DERIVE:
            unpack_derive(dst, prev, extra);
            break;
    };
}


static void unpack_plain_and_pix(u16* buf, u8 plainColor)
{
    // start by filling with plain color
    memsetU16(buf, plainColor, TILEMAP_SIZE);

    u8* src = movie_src;
    u16* dst = buf;
    u16 size;
    u16 data;

    // number of not plain color tile (8 bits, > 0)
    size = *src++;

    while(size--)
    {
        data = *src++ << 8;
        data |= *src++;

        // add offset
        dst += data >> 5;

        // and set diff
        data &= 0x1F;
        if (data & 0x10) data = 0x80;
        *dst++ = data;
    }

    movie_src = src;
}

static void unpack_derive(u16* buf, u16* prev, u16 extra)
{
    // start by copying from previous tile
    memcpyU16(buf, prev, TILEMAP_SIZE);

    u8* src = movie_src;
    u16* dst = buf;
    u16 size;
    u16 data;

    // number of different tile (12 bits, >= 0)
    size = (extra << 8) | *src++;

    while(size--)
    {
        data = *src++ << 8;
        data |= *src++;

        // add offset
        dst += data >> 5;

        // and set diff
        data &= 0x1F;
        if (data & 0x10) data = 0x80;
        *dst++ = data;
    }

    movie_src = src;
}


//void unpack_rle_old(u16* buf)
//{
//    u8* src = movie_src;
//    u16 rep;
//    u8 color;
//    s16 len = TILEMAP_SIZE;
//
//    while(len > 0)
//    {
//        const u8 data = *src++;
//
//        rep = data & 7;
//
//        if (data & 0x80) color = 0x80;
//        else color = data >> 3;
//
//        if (rep)
//        {
//            len -= rep;
//            while(rep--) *buf++ = color;
//        }
//        else
//        {
//            // number of repeat (8 bits)
//            rep = *src++ + 1;
//            len -= rep;
//            while(rep--) *buf++ = color;
//        }
//    }
//
//    movie_src = src;
//}
//
//void unpack_rle_binary_old(u16* buf)
//{
//    u8* src = movie_src;
//    u16 rep;
//    u8 color;
//    s16 len = TILEMAP_SIZE;
//
//    while(len > 0)
//    {
//        const u8 data = *src++;
//
//        rep = data & 0x1F;
//
//        if (data & 0x80) color = 0x80;
//        else if (data & 0x40) color = 0x0F;
//        else color = 0;
//
//        if (rep)
//        {
//            len -= rep;
//            while(rep--) *buf++ = color;
//        }
//        else
//        {
//            // number of repeat (8 bits)
//            rep = *src++ + 1;
//            len -= rep;
//            while(rep--) *buf++ = color;
//        }
//    }
//
//    movie_src = src;
//}
//
//static void log_(u16* dst)
//{
//    u16* d = dst;
//    char str1[256];
//    char str2[32];
//    u16 i, j;
//
//    for(j = 0; j < TILEMAP_HEIGHT; j++)
//    {
//        strcpy(str1, "");
//
//        for(i = 0; i < TILEMAP_WIDTH; i++)
//        {
//            const u16 v = *d++;
//
//            intToHex(v & 0x8F, str2, 2);
//
//            strcat(str1, str2);
//            strcat(str1, " ");
//        }
//
//        KDebug_Alert(str1);
//    }
//}
