#ifndef TILEMAP_INCLUDE_H
#define TILEMAP_INCLUDE_H

typedef struct
{
    unsigned short			width;
	unsigned short			height;
    const unsigned short*	tilemap;
} TileMap;

#endif
