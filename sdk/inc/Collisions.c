#include "Collisions.h"

//#include "LevelManager.h"
#include "MathUtils.h"
#include "Objects.h"
#include "Physics.h"
#include "Player.h"

u16 CollidesWithTile(u16 x, u16 y)
{
    u16 tile = ARRAY_ITEM_VALUE(levelData.foreground->tilemap, 
                                VIRTUAL_TO_TILE(x) + (VIRTUAL_TO_TILE(y) << levelData.mapWidthAsShiftValue));

	if ((tile & SPECIAL_TILE) == 0)
	{
		return ARRAY_ITEM_VALUE(levelData.foregroundTileData, (tile & NORMAL_TILE_INDEX_MASK)) == TILE_SOLID;
	}

	return 0;
}

u16 OutOfBounds(s16 x, s16 y)
{
    return (x < 0 ||
            y < 0 ||
            x > TILE_TO_VIRTUAL(levelData.foreground->width) ||
            y > TILE_TO_VIRTUAL(levelData.foreground->height));
}

u16 ObjectIsOffScreen(s16 x, s16 y)
{
    return (x < -scrollData.scrollx_hires_clamped ||
            y < scrollData.scrolly_hires_clamped ||
            x > -(scrollData.scrollx_hires_clamped - PIXEL_TO_VIRTUAL(320))||
            y > (scrollData.scrolly_hires_clamped + PIXEL_TO_VIRTUAL(224)));    

}

u16 ObjectIsOnScreen(s16 x, s16 y)
{
    return (x >= -scrollData.scrollx_hires_clamped &&
            y >= scrollData.scrolly_hires_clamped &&
            x <= -(scrollData.scrollx_hires_clamped - PIXEL_TO_VIRTUAL(320)) &&
            y <= (scrollData.scrolly_hires_clamped + PIXEL_TO_VIRTUAL(224)));

}

u16 SpriteIsOnScreen(s16 x, s16 y, s16 padding)
{
    return (x >= 0 - padding &&
            y >= 0 - padding &&
            x <= 320 + padding &&
            y <= 224 + padding);

}

u16 PointSquareCollision(ObjectStruct* firstObject, ObjectStruct* secondObject)
{
    return ((firstObject->x >= secondObject->x + secondObject->rectLeft) && 
            (firstObject->x <= secondObject->x + secondObject->rectRight) &&
            (firstObject->y >= secondObject->y + secondObject->rectTop) &&
            (firstObject->y <= secondObject->y + secondObject->rectBottom));
}


u16 SquareSquareCollision(ObjectStruct* firstObject, ObjectStruct* secondObject)
{
    return !(firstObject->x + firstObject->rectLeft   > secondObject->x + secondObject->rectRight ||
             firstObject->x + firstObject->rectRight  < secondObject->x + secondObject->rectLeft ||
             firstObject->y + firstObject->rectTop    > secondObject->y + secondObject->rectBottom ||
             firstObject->y + firstObject->rectBottom < secondObject->y + secondObject->rectTop);
}

