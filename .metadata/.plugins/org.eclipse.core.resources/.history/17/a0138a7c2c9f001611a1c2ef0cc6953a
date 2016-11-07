#include "Enemy.h"

#include <KDebug.h>
#include <vdp_spr.h>
#include <vdp_tile.h>

#include "Coin.h"
#include "Collisions.h"
#include "Debug.h"
#include "EnemyBullet.h"
#include "Explosion.h"
#include "Explosion.h"
#include "LevelManager.h"
#include "MathUtils.h"
#include "Objects.h"
#include "Physics.h"
#include "Player.h"
#include "SpritesAndMaps.h"

#define ENEMY_AI_STATE_ACTIVE 0
#define ENEMY_AI_STATE_DEAD   1

const u16 enemyAnimationFrames[32] =
{
    TILE_ATTR_FULL(PAL1,0,0,0,0),
    TILE_ATTR_FULL(PAL1,0,0,0,(1 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(2 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(3 * 9)),

    TILE_ATTR_FULL(PAL1,0,0,0,(4 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(5 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(6 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(7 * 9)),

    TILE_ATTR_FULL(PAL1,0,0,0,(8 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(9 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(10 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(11 * 9)),

    TILE_ATTR_FULL(PAL1,0,0,0,(12 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(13 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(14 * 9)),
    TILE_ATTR_FULL(PAL1,0,0,0,(15 * 9)),

    TILE_ATTR_FULL(PAL1,0,1,1,0),
    TILE_ATTR_FULL(PAL1,0,1,1,(1 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(2 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(3 * 9)),

    TILE_ATTR_FULL(PAL1,0,1,1,(4 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(5 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(6 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(7 * 9)),

    TILE_ATTR_FULL(PAL1,0,1,1,(8 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(9 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(10 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(11 * 9)),

    TILE_ATTR_FULL(PAL1,0,1,1,(12 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(13 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(14 * 9)),
    TILE_ATTR_FULL(PAL1,0,1,1,(15 * 9))
};

u16 EnemyCreate(s16 x, s16 y)
{
    ObjectStruct* enemyObject = CreateObject(TYPE_ENEMY,
                                             EnemyUpdate, 
                                             EnemyDestroy, 
                                             EnemyDraw,
                                             EnemyCollide);

    if (!enemyObject)
    {
#ifdef DEBUG_OBJECTS
        KDebug_Alert("enemy could not be created!");
#endif
        return 0;
    }

    enemyObject->x                 = x;
    enemyObject->y                 = y;
    enemyObject->speedx            = 0;
    enemyObject->speedy            = 0;
    enemyObject->sprite.size       = SPRITE_SIZE(3,3);
    enemyObject->spriteIndex       = random() & 31;
    enemyObject->sprite.tile_attr  = enemyAnimationFrames[enemyObject->spriteIndex] + enemyLoadedTileInfo.startIndex;
    enemyObject->aiState           = ENEMY_AI_STATE_ACTIVE;
    enemyObject->rectLeft          = PIXEL_TO_VIRTUAL(-12);
    enemyObject->rectRight         = PIXEL_TO_VIRTUAL(12);
    enemyObject->rectTop           = PIXEL_TO_VIRTUAL(-12);
    enemyObject->rectBottom        = PIXEL_TO_VIRTUAL(12);
    enemyObject->healthPoints      = 1;
    enemyObject->damage            = 1;
    enemyObject->visible           = 1;

#ifdef DEBUG_OBJECTS
    KDebug_Alert("enemyCreate");
#endif
    
    return 1;
}

void RotateObject(ObjectStruct* enemyObject)
{
    s16 tile_distance_x = VIRTUAL_TO_TILE(enemyObject->x - playerObject->x);
    s16 tile_distance_y = VIRTUAL_TO_TILE(enemyObject->y - playerObject->y);

    u16 x_is_negative = mathutils_isnegative(tile_distance_x);
    u16 y_is_negative = mathutils_isnegative(tile_distance_y);

    tile_distance_x = mathutils_abs(tile_distance_x);
    tile_distance_y = mathutils_abs(tile_distance_y);

    if (tile_distance_x > DISTANCE_ANGLE_TABLE_WIDTH - 1 || tile_distance_y > DISTANCE_ANGLE_TABLE_HEIGHT - 1)
    {
        return;
    }

    u16 angleValue = GET_ANGLE_VALUE(tile_distance_x, tile_distance_y); 

    angleValue >>= 3; // map from 0 to 63 angles to 0 to 7 animationFrames;

    // if x and y are negative, do nothing.
    // if x is negative and y is positive,  angleValue = 31 - angleValue;
    // if x is positive and y is negative, angleValue = 15 - angleValue;
    // if x and y are positive, angleValue = angleValue + 16? 

    if (x_is_negative)
    {
        if (!y_is_negative)
        {
            angleValue = 31 - angleValue;
        }
    }
    else
    {
        if (y_is_negative)
        {
            angleValue = 15 - angleValue;
        }
        else
        {
            angleValue = angleValue + 16;
        }
    }

    enemyObject->spriteIndex       = angleValue;
    enemyObject->sprite.tile_attr  = enemyAnimationFrames[enemyObject->spriteIndex] +  + enemyLoadedTileInfo.startIndex;
}


void EnemyUpdate(ObjectStruct* enemyObject)
{
    //KDebug_Alert("enemy Update");

    enemyObject->sprite.posx = VIRTUAL_TO_PIXEL(enemyObject->x) + scrollData.scrollx_vdp - 12;
    enemyObject->sprite.posy = VIRTUAL_TO_PIXEL(enemyObject->y) - scrollData.scrolly_vdp - 12;

    RotateObject(enemyObject);


    
    if (enemyObject->aiState == ENEMY_AI_STATE_ACTIVE)
    {
        enemyObject->x += enemyObject->speedx;
        enemyObject->y += enemyObject->speedy;

        if (ObjectIsOnScreen(enemyObject->x, enemyObject->y))
        {
            if ((enemyObject->lifetime % 64) == 0)
            {
                EnemyBulletCreate(enemyObject->x, 
                                    enemyObject->y, 
                                    costable32[enemyObject->spriteIndex],
                                    sintable32[enemyObject->spriteIndex]);
            }
        }
    }
    else if (enemyObject->aiState == ENEMY_AI_STATE_DEAD)
    {
        enemyObject->x += enemyObject->speedx;
        enemyObject->y += enemyObject->speedy >> 2;

        enemyObject->speedy++;

        if (enemyObject->visible)
        {
            if ((enemyObject->lifetime % 20) == 0)
            {
                ExplosionCreate(enemyObject->x, enemyObject->y);
            }
        }
        else
        {
            enemyObject->objectState = OBJECTSTATE_INACTIVE;
        }

        if (collidesWithTile(enemyObject->x, enemyObject->y))
        {
            enemyObject->objectState = OBJECTSTATE_INACTIVE;
            ExplosionCreate(enemyObject->x, enemyObject->y);
        }
    }
}

void EnemyDestroy(ObjectStruct* enemyObject)
{
#ifdef DEBUG_OBJECTS
    KDebug_Alert("enemyDestroy");
#endif
}

void EnemyDraw(ObjectStruct* enemyObject)
{
    enemyObject->sprite.link  = spriteDrawIndex + 1;
    VDP_setSpriteP(spriteDrawIndex, &enemyObject->sprite);
    spriteDrawIndex++;
}

void EnemyCollide(ObjectStruct* enemyObject, ObjectStruct* collidedObject)
{
    if (enemyObject->aiState == ENEMY_AI_STATE_ACTIVE)
    {
        enemyObject->healthPoints -= collidedObject->damage;

        if (enemyObject->healthPoints <= 0)
        {
            ExplosionCreate(enemyObject->x, enemyObject->y);
            enemyObject->aiState   = ENEMY_AI_STATE_DEAD;
            enemyObject->speedy    = 8;
            CoinCreate(enemyObject->x, enemyObject->y);
        }
    }
}

