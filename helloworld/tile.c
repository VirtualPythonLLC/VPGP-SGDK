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
#define APLAN
#define BPLAN


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


//u16 tile_unpack_old()
//{
//    u8* dst = tileWrite;
//    u16 remain;
//    u16 ind;
//
//    remain = *movie_src++ << 8;
//    remain |= *movie_src++;
//
//    while(remain--)
//    {
//        const u8 data = *movie_src++;
//
//        // header & extra
//        const u8 header = data >> 5;
//        const u8 extra = data & 0x1F;
//
//        switch (header)
//        {
//            case TILE_COMPRESSION_DICO_0:
//                unpack_dico0(dst);
//                break;
//
//            case TILE_COMPRESSION_DICO_1:
//                unpack_dico1(dst);
//                break;
//
//            case TILE_COMPRESSION_PLAIN_AND_PIX:
//                unpack_plain_and_pix(dst);
//                break;
//
//            case TILE_COMPRESSION_COPY:
//                unpack_copy(dst, tileRead + (dst - tileWrite));
//                break;
//
//            case TILE_COMPRESSION_DERIVE_SAME:
//                unpack_derive(dst, tileRead + (dst - tileWrite), extra);
//                break;
//
//            case TILE_COMPRESSION_DERIVE_OTHER:
//                ind = *movie_src++;
//                ind |= (extra & 1) << 8;
//
//                unpack_derive(dst, tileRead + (ind << 5), extra);
//                break;
//
//            case TILE_COMPRESSION_RAW:
//                unpack_raw(dst);
//                break;
//        }
//
//        dst += 32;
//    }
//
//    return (dst - tileWrite) >> 5;
//}
//
//
//void unpack_plain_and_pix_old(u8* buf)
//{
//    u8* src = movie_src;
//
//    u16 data = *src++;
//
//    u32* dst32 = (u32*) buf;
//    const u32 fill = cnv_4to32_tab[data & 0xF];
//
//    *dst32++ = fill;
//    *dst32++ = fill;
//    *dst32++ = fill;
//    *dst32++ = fill;
//    *dst32++ = fill;
//    *dst32++ = fill;
//    *dst32++ = fill;
//    *dst32++ = fill;
//
//    u8* dst = buf;
//
//    u16 remain = data >> 4;
//
//    while(remain--)
//    {
//        dst += *src++;
//        *dst = *src++;
//    }
//
//    movie_src = src;
//}
//
//void unpack_derive_old(u8* buf, u8* prev, u16 extra)
//{
//    // source tile
//    u32* src32 = (u32*) prev;
//    u32* dst32 = (u32*) buf;
//
//    *dst32++ = *src32++;
//    *dst32++ = *src32++;
//    *dst32++ = *src32++;
//    *dst32++ = *src32++;
//    *dst32++ = *src32++;
//    *dst32++ = *src32++;
//    *dst32++ = *src32++;
//    *dst32++ = *src32++;
//
//    u8* src = movie_src;
//    u8* dst = buf;
//
//    u16 remain = extra >> 1;
//
//    while(remain--)
//    {
//        dst += *src++;
//        *dst = *src++;
//    }
//
//    movie_src = src;
//}
//
//void unpack_copy_old(u8* buf, u8* prev)
//{
//    // get source tile
//    u32* src = (u32*) prev;
//    u32* dst = (u32*) buf;
//
//    // copy
//    *dst++ = *src++;
//    *dst++ = *src++;
//    *dst++ = *src++;
//    *dst++ = *src++;
//    *dst++ = *src++;
//    *dst++ = *src++;
//    *dst++ = *src++;
//    *dst++ = *src++;
//}
//
//void unpack_raw_old(u8* buf)
//{
//    u8* src = movie_src;
//    u8* dst = (u8*) buf;
//
//    // 32 bytes to unpack
//    s16 remain = 32;
//
//    while(remain--)
//        *dst++ = *src++;
//
//    movie_src = src;
//}
//
//
//void log_(u8* dst)
//{
//    u8* d = dst;
//    char str1[128];
//    char str2[32];
//    u16 i, j;
//
//    for(j = 0; j < 8; j++)
//    {
//        u8 b;
//
//        strcpy(str1, "");
//
//        b = *d++;
//
//        intToHex((b >> 4) & 0xF, str2, 1);
//        strcat(str1, str2);
//        strcat(str1, " ");
//
//        intToHex((b >> 0) & 0xF, str2, 1);
//        strcat(str1, str2);
//        strcat(str1, " ");
//
//        b = *d++;
//
//        intToHex((b >> 4) & 0xF, str2, 1);
//        strcat(str1, str2);
//        strcat(str1, " ");
//
//        intToHex((b >> 0) & 0xF, str2, 1);
//        strcat(str1, str2);
//        strcat(str1, " ");
//
//        b = *d++;
//
//        intToHex((b >> 4) & 0xF, str2, 1);
//        strcat(str1, str2);
//        strcat(str1, " ");
//
//        intToHex((b >> 0) & 0xF, str2, 1);
//        strcat(str1, str2);
//        strcat(str1, " ");
//
//        b = *d++;
//
//        intToHex((b >> 4) & 0xF, str2, 1);
//        strcat(str1, str2);
//        strcat(str1, " ");
//
//        intToHex((b >> 0) & 0xF, str2, 1);
//        strcat(str1, str2);
//        strcat(str1, " ");
//
//        KDebug_Alert(str1);
//    }
//}
//
