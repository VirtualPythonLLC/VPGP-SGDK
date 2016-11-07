#ifndef PLAYER_INCLUDE_H
#define PLAYER_INCLUDE_H

#include "ObjectStruct.h"

#define WEAPON_BULLET       0

void Player_SetupForGame();
void Player_SetupForLevel();
void Player_SetupForSection();
void Player_SetupForSectionAfterDeath();

void Player_StartDebugMovement();
void Player_EndDebugMovement();

extern ObjectStruct* playerObject;

typedef struct
{
    u16 numCoins;
    u16 lives;
    u16 playerColliding;
    u16 currentWeapon;
} PlayerDataStruct;


extern PlayerDataStruct playerData;

#endif
