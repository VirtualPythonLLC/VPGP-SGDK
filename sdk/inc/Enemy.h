#ifndef ENEMY_INCLUDE_H
#define ENEMY_INCLUDE_H

#include <genesis.h>

#include "ObjectStruct.h"

u16 EnemyCreate(s16 x, s16 y);
void EnemyUpdate(ObjectStruct* enemyObject);
void EnemyDestroy(ObjectStruct* enemyObject);
void EnemyDraw(ObjectStruct* enemyObject);
void EnemyCollide(ObjectStruct* enemyObject, ObjectStruct* collidedObject);

#endif
