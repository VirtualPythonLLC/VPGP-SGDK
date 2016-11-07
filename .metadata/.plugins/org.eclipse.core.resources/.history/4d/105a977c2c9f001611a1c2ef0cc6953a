#include "Player.h"

#include <genesis.h>
#include <kdebug.h>
#include <maths.h>

#include "Bullet.h"
#include "Collisions.h"
#include "Config.h"
#include "Debug.h"
#include "Explosion.h"
#include "Game.h"
#include "Explosion.h"
#include "LevelManager.h"
#include "MathUtils.h"
#include "Objects.h"
#include "Physics.h"
#include "SpritesAndMaps.h"

#define WALLS_HURT

#define MAX_HEALTH_POINTS 8

ObjectStruct player;
ObjectStruct* playerObject;
PlayerDataStruct playerData;



#define WEAPON_BULLET_COOLDOWN_TIME     15


#define MOVEMENT_SPEED        10

extern const u16 movement_direction[32];

u16 useLevelStartPosition = 1;

u16 rotateDirection = 0;
u16 deathWaitTime = 0;
u16 hitTimer = 0;
u16 weaponCooldownTimer = 0;
u16 startButtonDown = 0;

void FireWeapon()
{
    switch (playerData.currentWeapon)
    {
    case WEAPON_BULLET:
        if (BulletCreate(playerObject->x, 
                         playerObject->y, 
                         playerObject->speedx * 1.5,
                         playerObject->speedy * 1.5))
        {
            weaponCooldownTimer = WEAPON_BULLET_COOLDOWN_TIME;
        }
        break;
	}
}

void UpdateControls()
{
    if (joystate & BUTTON_LEFT)
    {
        playerObject->speedx = -MOVEMENT_SPEED;
    }
    else if (joystate & BUTTON_RIGHT)
    {
        playerObject->speedx = MOVEMENT_SPEED;
    }
    else
    {
        playerObject->speedx = 0;
    }

    if (joystate & BUTTON_UP)
    {
        playerObject->speedy = -MOVEMENT_SPEED;
    }
    else if (joystate & BUTTON_DOWN)
    {
        playerObject->speedy = MOVEMENT_SPEED;
    }
    else
    {
        playerObject->speedy = 0;
    }


    if ((joystate & BUTTON_A) && weaponCooldownTimer == 0)
    {
        u16 value = (s16)(1.35 * 128) >> 4;

        BulletCreate(playerObject->x, playerObject->y, value, 0.0);
        BulletCreate(playerObject->x, playerObject->y, 0.0, value);
        BulletCreate(playerObject->x, playerObject->y, 0.0, -value);
        BulletCreate(playerObject->x, playerObject->y, -value, 0.0);
		weaponCooldownTimer = WEAPON_BULLET_COOLDOWN_TIME;
    }
}

void UpdateCommon()
{

    //You could update your player physics here...


    if (hitTimer > 0)
    {
        hitTimer--;
    }

    if (playerObject->healthPoints == 1)
    {
        if ((playerObject->lifetime & 31) == 0)
        {
            ExplosionCreate(playerObject->x, playerObject->y);
        }
    }
}

void PlayerUpdate(ObjectStruct* playerObject)
{
    UpdateControls();

    if (weaponCooldownTimer > 0)
    {
        weaponCooldownTimer--;
    }

    playerObject->x += playerObject->speedx;
    playerObject->y += playerObject->speedy;
    playerObject->sprite.posx = (s16)VIRTUAL_TO_PIXEL(playerObject->x + scrollData.scrollx_hires_clamped) - 12;
    playerObject->sprite.posy = (s16)VIRTUAL_TO_PIXEL(playerObject->y - scrollData.scrolly_hires_clamped) - 12;
}

void PlayerDestroy(ObjectStruct* playerObject)
{
}

void PlayerCollide(ObjectStruct* playerObject, ObjectStruct* collidedObject)
{
  // doesn't collide with anything, but could.    
}

void PlayerDraw(ObjectStruct* playerObject)
{
    playerObject->sprite.tile_attr = TILE_ATTR_FULL(PAL0,0,0,0,0) + playerLoadedTileInfo.startIndex;

    playerObject->sprite.link  = spriteDrawIndex + 1;
    VDP_setSpriteP(spriteDrawIndex, &playerObject->sprite);
    spriteDrawIndex++;
}

void PlayerCreate()
{
    playerObject = &player;
    playerObject->updateFunction    = (ObjectFunctionTypePrototype)PlayerUpdate;
    playerObject->destroyFunction   = (ObjectFunctionTypePrototype)PlayerDestroy;
    playerObject->drawFunction      = (ObjectFunctionTypePrototype)PlayerDraw;
    playerObject->collisionFunction = (ObjectCollisionFunctionPrototype)PlayerCollide;
    playerObject->objectState       = OBJECTSTATE_ACTIVE;

    playerObject->objectType        = TYPE_PLAYER;
    playerObject->sprite.size       = SPRITE_SIZE(3,3);
    playerObject->damage            = 1;
    playerObject->healthPoints      = MAX_HEALTH_POINTS;

    playerObject->rectLeft          = PIXEL_TO_VIRTUAL(-12);
    playerObject->rectRight         = PIXEL_TO_VIRTUAL(12);
    playerObject->rectTop           = PIXEL_TO_VIRTUAL(-12);
    playerObject->rectBottom        = PIXEL_TO_VIRTUAL(12);
     
    playerData.numCoins             = 0;
    playerData.lives                = 3;
    playerData.currentWeapon        = WEAPON_BULLET;

}

void Player_SetupForGame()
{
    PlayerCreate();
}

void Player_SetupForLevel()
{
    useLevelStartPosition = 1;
}

void Player_SetupForSection()
{
    if (useLevelStartPosition == 1)
    {
        LevelManager_SetupPlayerLevelStartPosition();
        useLevelStartPosition = 0;
    }
    else
    {
        LevelManager_SetupPlayerSectionStartPosition();
    }
}

void Player_SetupForSectionAfterDeath()
{
    playerObject->healthPoints      = MAX_HEALTH_POINTS;
    playerData.playerColliding      = 0;
    playerData.currentWeapon        = WEAPON_BULLET;
    rotateDirection                 = 0;
    deathWaitTime                   = 0;
    hitTimer                        = 0;
    weaponCooldownTimer             = 0;
    startButtonDown                 = 0;    
}
