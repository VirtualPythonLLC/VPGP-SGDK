#include "Debug.h"

#include <kdebug.h>
#include <tab_vram.h>

void PrintNumber(u32 value)
{
	KDebug_AlertNumber(value);
}

void PrintText(char* message)
{
    KDebug_Alert(message);
}

void PrintSprite(const Sprite* sprite)
{
    PrintNumber(sprite->x);
    PrintNumber(sprite->y);
    PrintNumber(sprite->attribut);
    PrintNumber(sprite->lastVDPSprite->size);
    PrintNumber(sprite->index);
}

void PrintObjectStruct(ObjectStruct* objectStruct)
{
    PrintText("****** OBJECT *******");
    PrintSprite(&objectStruct->sprite);
    PrintNumber(objectStruct->x);
    PrintNumber(objectStruct->y);
    PrintNumber((u32)objectStruct->updateFunction);
    PrintNumber((u32)objectStruct->destroyFunction);
    PrintNumber((u32)objectStruct->drawFunction);
    PrintNumber((u32)objectStruct->collisionFunction);
    PrintNumber(objectStruct->objectState);
    PrintNumber(objectStruct->aiState);
    PrintNumber(objectStruct->spriteIndex);
    PrintNumber(objectStruct->speedx);
    PrintNumber(objectStruct->speedy);
    PrintNumber(objectStruct->lifetime);
    PrintNumber(objectStruct->objectType);
    PrintNumber(objectStruct->rectLeft);
    PrintNumber(objectStruct->rectRight);
    PrintNumber(objectStruct->rectTop);
    PrintNumber(objectStruct->rectBottom);
    PrintNumber(objectStruct->healthPoints);
    PrintNumber(objectStruct->damage);
    PrintText("*********************");
}

void PrintAPLAN(u32 value, u16 x, u16 y)
{
    char tempString[16];
    intToStr(value, tempString, 16);
    VDP_drawText(tempString, x, y);
}
extern u16 textBasetile;


void PrintWPLAN(u32 value, u16 x, u16 y)
{
    char tempString[16];
    intToStr(value, tempString, 16);
    //VDP_drawText(tempString, x, y);
    VDP_drawTextBG(PLAN_WINDOW, tempString, textBasetile, x, y);
}

