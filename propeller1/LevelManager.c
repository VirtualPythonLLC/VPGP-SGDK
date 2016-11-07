#include "LevelManager.h"

#include <genres.h>
#include <vram.h>

#include "Collisions.h"
#include "Config.h"
#include "Debug.h"
#include "Game.h"
#include "HUD.h"
#include "Explosion.h"
#include "LevelDefinitions.h"
#include "MathUtils.h"
#include "Physics.h"
#include "Player.h"
#include "SpritesAndMaps.h"
#include "VDP_Extra.h"

// game objects
#include "Coin.h"
#include "Enemy.h"
#include "Player.h"

//#define BENCHMARK_SCROLLING_UPDATE
 
// defines the size used around the player to update background tiles for scrolling.
#define TILE_UPDATE_AREA_WIDTH              (SCREEN_WIDTH_IN_TILES  + 2) 
#define TILE_UPDATE_AREA_HEIGHT             (SCREEN_HEIGHT_IN_TILES + 2)
#define TILE_UPDATE_AREA_HALF_WIDTH         (TILE_UPDATE_AREA_WIDTH >> 1)
#define TILE_UPDATE_AREA_HALF_HEIGHT        (TILE_UPDATE_AREA_HEIGHT >> 1)

u16 coinMap[MAX_COINS_IN_LEVEL];

u16 firstTime = 1;

s16 levelStartX = 0;
s16 levelStartY = 0;

s16 sectionStartX = 0;
s16 sectionStartY = 0;
u16 playerSpriteIndex = 0;

u16 levelSectionIndex = 1;

u16 insideOfDoors = 0;

ScrollDataStruct scrollData;
LevelDataStruct levelData;

sectionFunctionType setupSection;
sectionFunctionType setupSectionResources;
sectionFunctionType updateSection;
sectionFunctionType closeSection;
sectionFunctionType spawnObjects;
u16 numDoors;
const Door* doors;

u16 backgroundLineScrollValues[512];

void SetupScrollLimits()
{
    scrollData.scrollx_hires_limit = PIXEL_TO_VIRTUAL(TILE_TO_PIXEL(levelData.foreground->width) - SCREEN_WIDTH);
    scrollData.scrolly_hires_limit = PIXEL_TO_VIRTUAL(TILE_TO_PIXEL(levelData.foreground->height) - SCREEN_HEIGHT);
}

void ResetScrollData()
{
    scrollData.scrollx_hires_clamped = 0;
    scrollData.scrolly_hires_clamped = 0;
    scrollData.scrollx_hires = 0;
    scrollData.scrolly_hires = 0;
    scrollData.scrollx_vdp = 0;
    scrollData.scrolly_vdp = 0;
}


void SetupCoins()
{
	fastMemsetU16((u16*)coinMap, 1, MAX_COINS_IN_LEVEL);
}

void SetupBackgroundLayer()
{
    // setup background
    MyVDP_setTileMapRect(PLAN_B, levelData.background->tilemap, TILE_ATTR_FULL(PAL2, 0, 0, 0, backgroundLoadedTileInfo.startIndex), 0, 0, levelData.background->width, levelData.background->height);
}

inline u16 GetTile(u16 rawTileData, u16 tileBaseValue)
{
	if ((rawTileData & SPECIAL_TILE) != 0)
	{
		switch ((rawTileData & SPECIAL_TILE_TYPE_MASK) >> 8)
		{
		case COIN_TYPE:
			{
				u16 coinIndexMap = rawTileData & SPECIAL_TILE_ARRAY_INDEX_MASK;
		
				if (*(coinMap + coinIndexMap) == 1)
				{
					return ((rawTileData & SPECIAL_TILE_INDEX_MASK) >> 11) + coinLoadedTileInfo.startIndex;
				}
			}
			break;
		}

		return 0;
	}

	return tileBaseValue + rawTileData; 
}

void SetupForegroundLayer()
{
    s16 tilepositionx = PIXEL_TO_TILE(-scrollData.scrollx_vdp) - 1; // divide by 8
    s16 tilepositiony = PIXEL_TO_TILE(scrollData.scrolly_vdp) - 1; // 

    // compute start and end tiles
    s16 starttilex = tilepositionx;
    s16 endtilex = (tilepositionx + TILE_UPDATE_AREA_WIDTH);
    s16 starttiley = tilepositiony;
    s16 endtiley = (tilepositiony + TILE_UPDATE_AREA_HEIGHT);

    s16 loop = 0;
    s16 innerLoop = 0;
    u16 tileNumber = 0;
    u16 arrayStart = 0;

	const u16 tileBaseValue = TILE_ATTR_FULL(PAL3, 0, 0, 0, 0) + foregroundLoadedTileInfo.startIndex;

    for (loop = starttiley; loop <= endtiley; loop++)
    {
        arrayStart = loop * levelData.foreground->width;
        for (innerLoop = starttilex; innerLoop <= endtilex; innerLoop++)
        {
            tileNumber = ARRAY_ITEM_VALUE(levelData.foreground->tilemap, arrayStart + innerLoop);
			tileNumber = GetTile(tileNumber, tileBaseValue);
            VDP_setTileMap(PLAN_A, tileNumber, innerLoop & 63, loop & 63);
        }
    }
}

extern u16 totalActiveObjects;

void SetupSection(const SectionDefinitionStruct* sectionDefinition)
{
    setupSection = sectionDefinition->setupSection;
    setupSectionResources = sectionDefinition->setupSectionResources;
    updateSection = sectionDefinition->updateSection;
    closeSection = sectionDefinition->closeSection;
    spawnObjects = sectionDefinition->spawnObjects;
    numDoors = sectionDefinition->numDoors;
    doors = &sectionDefinition->doors[0];
}


void LevelManager_SetupLevel()
{
	InitHUD();
    SetupSection(&level001Section001Definition);
}

void LevelManager_SetupBackgroundPlanes()
{
    SetupBackgroundLayer();
    SetupForegroundLayer();
}

void LevelManager_SetupSectionResources()
{
    VDP_setPlanSize(PLANE_SIZE, PLANE_SIZE);

    setupSectionResources();
    spawnObjects();
    SetupCoins();

    SetupScrollLimits();
    
}

void LevelManager_SetupSection()
{
    LevelManager_SetScrollMode();
    setupSection();
    spawnObjects();
    ResetScrollData();
    SetupPhysics(levelData.foreground);
    insideOfDoors = 1;
}

void UpdateScrollValues()
{
    scrollData.scrollx_hires_clamped = scrollData.scrollx_hires;
    scrollData.scrolly_hires_clamped = scrollData.scrolly_hires;

    if (scrollData.scrollx_hires > 0)
    {
        scrollData.scrollx_hires_clamped = 0;
    }
        
    if (scrollData.scrollx_hires < -scrollData.scrollx_hires_limit)
    {
        scrollData.scrollx_hires_clamped = -scrollData.scrollx_hires_limit;
    }        

    if (scrollData.scrolly_hires < 0)
    {
        scrollData.scrolly_hires_clamped = 0;
    }
        
    if (scrollData.scrolly_hires > scrollData.scrolly_hires_limit)
    {
        scrollData.scrolly_hires_clamped = scrollData.scrolly_hires_limit;
    }

    scrollData.scrollx_vdp = VIRTUAL_TO_PIXEL(scrollData.scrollx_hires_clamped);
    scrollData.scrolly_vdp = VIRTUAL_TO_PIXEL(scrollData.scrolly_hires_clamped);
}

void LevelManager_UpdateScroll()
{
    scrollData.scrollx_hires -= playerObject->speedx;
    scrollData.scrolly_hires += playerObject->speedy;

	UpdateScrollValues();

	fastMemsetU16(backgroundLineScrollValues, scrollData.scrollx_vdp >> 3, 162);
	fastMemsetU16(backgroundLineScrollValues + 162, scrollData.scrollx_vdp >> 2, 328);
}


void ClearCoin(u16 tileindex, u16 tilex, u16 tiley)
{
	tilex -= tileindex >> 1;
	tiley -= tileindex & 1;

	tilex &= 63;
	tiley &= 63;

	u16 tileattr = TILE_ATTR_FULL(PAL3, 0, 0, 0, 0) + foregroundLoadedTileInfo.startIndex;

	VDP_setTileMap(PLAN_A, tileattr, tilex, tiley);
	VDP_setTileMap(PLAN_A, tileattr, (tilex + 1)& 63, tiley);
	VDP_setTileMap(PLAN_A, tileattr, tilex, (tiley + 1) & 63);
	VDP_setTileMap(PLAN_A, tileattr, (tilex + 1) & 63, (tiley + 1) & 63);
}

// This function clears the coin tile from the visible map. 
void LevelManager_UpdateCoinPickup()
{
    u16 tilex = VIRTUAL_TO_TILE(playerObject->x);
    u16 tiley = VIRTUAL_TO_TILE(playerObject->y);
    u16 tiledata = ARRAY_ITEM_VALUE(levelData.foreground->tilemap, tilex + (tiley << levelData.mapWidthAsShiftValue));

	if ((tiledata & SPECIAL_TILE) != 0 && 
		((tiledata & SPECIAL_TILE_TYPE_MASK) >> 8) == COIN_TYPE)
	{
		u16 coinIndexMap = tiledata & SPECIAL_TILE_ARRAY_INDEX_MASK;
		
		if (*(coinMap + coinIndexMap))
		{
			u16 tileindex = tiledata & SPECIAL_TILE_INDEX_MASK;
			tileindex >>= 11;	

			ClearCoin(tileindex, tilex, tiley);
			coinMap[coinIndexMap] = 0;
			playerData.numCoins++;
			UpdateHUDCoins();
		}
	}
}

u16 horizontal_segment_one[TILE_UPDATE_AREA_WIDTH + 1];
u16 horizontal_segment_two[TILE_UPDATE_AREA_WIDTH + 1];
u16 vertical_segment_one[TILE_UPDATE_AREA_HEIGHT + 1];
u16 vertical_segment_two[TILE_UPDATE_AREA_HEIGHT + 1];

u32 horizontal_segment_one_destination_address = 0;
u32 horizontal_segment_two_destination_address = 0;
u32 vertical_segment_one_destination_address = 0;
u32 vertical_segment_two_destination_address = 0;

u16 horizontal_segment_one_length = 0;
u16 horizontal_segment_two_length = 0;
u16 vertical_segment_one_length = 0;
u16 vertical_segment_two_length = 0;
	
u16* horizontal_segment_one_addr = 0;
u16* horizontal_segment_two_addr = 0;
u16* vertical_segment_one_addr = 0;
u16* vertical_segment_two_addr = 0;

s16 starttilex_mod = 0;
s16 endtilex_mod = 0;
s16 starttiley_mod = 0;
s16 endtiley_mod = 0;

void UpdateForeground()
{
    s16 tilepositionx = PIXEL_TO_TILE(-scrollData.scrollx_vdp);
    s16 tilepositiony = PIXEL_TO_TILE(scrollData.scrolly_vdp);

    // compute start and end tiles
    s16 starttilex = tilepositionx;
    s16 endtilex = (tilepositionx + TILE_UPDATE_AREA_WIDTH);
    s16 starttiley = tilepositiony;
    s16 endtiley = (tilepositiony + TILE_UPDATE_AREA_HEIGHT);

    if (starttilex < 0)
    {
        starttilex = 0;
        endtilex = TILE_UPDATE_AREA_WIDTH;
    }

    if (endtilex > levelData.foreground->width - 1)
    {
        endtilex = levelData.foreground->width - 1;
        starttilex = (levelData.foreground->width - 1) - TILE_UPDATE_AREA_WIDTH;
    }

    if (starttiley < 0)
    {
        starttiley = 0;
        endtiley = TILE_UPDATE_AREA_HEIGHT;
    }

    if (endtiley > levelData.foreground->height - 1)
    {
        endtiley = levelData.foreground->height - 1;
        starttiley = (levelData.foreground->height - 1) - TILE_UPDATE_AREA_HEIGHT;
    }

    starttilex_mod = starttilex & PLANE_SIZE_MINUS_ONE;
    endtilex_mod = endtilex & PLANE_SIZE_MINUS_ONE;
    starttiley_mod = starttiley & PLANE_SIZE_MINUS_ONE;
    endtiley_mod = endtiley & PLANE_SIZE_MINUS_ONE;

	u16 loop = 0;

	const u16 tileBaseValue = TILE_ATTR_FULL(PAL3, 0, 0, 0, 0) + foregroundLoadedTileInfo.startIndex; 

    if (playerObject->speedy < 0)
    {
        if (starttilex_mod > endtilex_mod)
        {
            // start tile x to PLANE_SIZE_MINUS_ONE
            horizontal_segment_one_length = PLANE_SIZE_MINUS_ONE - starttilex_mod + 1; 
            horizontal_segment_one_destination_address = PLAN_A + ((starttilex_mod + (starttiley_mod << 6)) << 1);
            const u16* src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, starttilex + (starttiley << levelData.mapWidthAsShiftValue)); 

			horizontal_segment_one_addr = horizontal_segment_one;
			loop = horizontal_segment_one_length; 

            while(loop--) 
            { 
				*horizontal_segment_one_addr = GetTile(*src, tileBaseValue);
				horizontal_segment_one_addr++;
                src++; 
            } 
			
            // 0 to end tile x
            horizontal_segment_two_length = endtilex_mod + 1; 
            horizontal_segment_two_destination_address = PLAN_A + (starttiley_mod << 7);
            src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, starttilex + (PLANE_SIZE_MINUS_ONE - starttilex_mod + 1) + (starttiley << levelData.mapWidthAsShiftValue));

			u16* horizontal_segment_two_addr = horizontal_segment_two;
			loop = horizontal_segment_two_length; 

            while(loop--) 
            { 
				*horizontal_segment_two_addr = GetTile(*src, tileBaseValue);
				horizontal_segment_two_addr++;
                src++; 
            } 
        }
        else
        {
            horizontal_segment_one_length = endtilex - starttilex + 1; 
            horizontal_segment_one_destination_address = PLAN_A + ((starttilex_mod + (starttiley_mod << 6)) << 1);
            const u16* src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, starttilex + (starttiley << levelData.mapWidthAsShiftValue));

			horizontal_segment_one_addr = horizontal_segment_one;
			loop = horizontal_segment_one_length; 

            while(loop--) 
            { 
				*horizontal_segment_one_addr = GetTile(*src, tileBaseValue);
				horizontal_segment_one_addr++;
                src++; 
            } 
        }
    }
    else if (playerObject->speedy > 0)
    {
        if (starttilex_mod > endtilex_mod)
        {
            // start tile x to PLANE_SIZE_MINUS_ONE
            horizontal_segment_one_length = PLANE_SIZE_MINUS_ONE - starttilex_mod + 1;
            horizontal_segment_one_destination_address = PLAN_A + ((starttilex_mod + (endtiley_mod << 6)) << 1);
            const u16* src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, starttilex + (endtiley << levelData.mapWidthAsShiftValue));

			horizontal_segment_one_addr = horizontal_segment_one;
			loop = horizontal_segment_one_length; 

            while(loop--) 
            { 
				*horizontal_segment_one_addr = GetTile(*src, tileBaseValue);
				horizontal_segment_one_addr++;
                src++; 
            } 

            // 0 to end tile x
            horizontal_segment_two_length = endtilex_mod + 1;
            horizontal_segment_two_destination_address = PLAN_A + (endtiley_mod << 7);
            src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, starttilex + (PLANE_SIZE_MINUS_ONE - starttilex_mod + 1) + (endtiley << levelData.mapWidthAsShiftValue));

			u16* horizontal_segment_two_addr = horizontal_segment_two;
			loop = horizontal_segment_two_length; 

            while(loop--) 
            { 
				*horizontal_segment_two_addr = GetTile(*src, tileBaseValue);
				horizontal_segment_two_addr++;
                src++; 
            } 
        }
        else
        {
            horizontal_segment_one_length = endtilex - starttilex + 1; 
            horizontal_segment_one_destination_address = PLAN_A + ((starttilex_mod + (endtiley_mod << 6)) << 1);
            const u16* src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, starttilex + (endtiley << levelData.mapWidthAsShiftValue));

			horizontal_segment_one_addr = horizontal_segment_one;
			loop = horizontal_segment_one_length; 

            while(loop--) 
            { 
				*horizontal_segment_one_addr = GetTile(*src, tileBaseValue);
				horizontal_segment_one_addr++;
                src++; 
            } 
        }
    }

    if (playerObject->speedx < 0)
    {
        if (starttiley_mod > endtiley_mod)
        {
            // start tile y to PLANE_SIZE_MINUS_ONE
            vertical_segment_one_length = PLANE_SIZE_MINUS_ONE - starttiley_mod + 1;
            vertical_segment_one_destination_address = PLAN_A + ((starttilex_mod + (starttiley_mod << 6)) << 1);
            const u16* src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, starttilex + (starttiley << levelData.mapWidthAsShiftValue));

			vertical_segment_one_addr = vertical_segment_one;
			loop = vertical_segment_one_length; 

            while(loop--) 
            { 
				*vertical_segment_one_addr = GetTile(*src, tileBaseValue);
				vertical_segment_one_addr++;
                src += levelData.foreground->width; 
            } 

            // 0 to end tile x
            vertical_segment_two_length = endtiley_mod + 1; 
            vertical_segment_two_destination_address = PLAN_A + (starttilex_mod << 1);
            src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, starttilex + ((starttiley + (PLANE_SIZE_MINUS_ONE - starttiley_mod + 1)) << levelData.mapWidthAsShiftValue));

			vertical_segment_two_addr = vertical_segment_two;
			loop = vertical_segment_two_length; 

            while(loop--) 
            { 
				*vertical_segment_two_addr = GetTile(*src, tileBaseValue);
				vertical_segment_two_addr++;
                src += levelData.foreground->width; 
            } 
		}
        else
        {
            vertical_segment_one_length = endtiley - starttiley + 1; 
            vertical_segment_one_destination_address = PLAN_A + ((starttilex_mod + (starttiley_mod << 6)) << 1);

            const u16* src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, starttilex + (starttiley << levelData.mapWidthAsShiftValue));

			vertical_segment_one_addr = vertical_segment_one;
			loop = vertical_segment_one_length; 

            while(loop--) 
            { 
				*vertical_segment_one_addr = GetTile(*src, tileBaseValue);
				vertical_segment_one_addr++;
                src += levelData.foreground->width; 
            } 
        }
    }
    else if (playerObject->speedx > 0)
    {
        if (starttiley_mod > endtiley_mod)
        {
            // start tile y to PLANE_SIZE_MINUS_ONE
            vertical_segment_one_length = PLANE_SIZE_MINUS_ONE - starttiley_mod + 1;
            vertical_segment_one_destination_address = PLAN_A + ((endtilex_mod + (starttiley_mod << 6)) << 1);
            const u16* src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, endtilex + (starttiley << levelData.mapWidthAsShiftValue));

			vertical_segment_one_addr = vertical_segment_one;
			loop = vertical_segment_one_length; 

            while(loop--) 
            { 
				*vertical_segment_one_addr = GetTile(*src, tileBaseValue);
				vertical_segment_one_addr++;
                src += levelData.foreground->width; 
            } 
            
            // 0 to end tile x
            vertical_segment_two_length = endtiley_mod + 1; 
            vertical_segment_two_destination_address = PLAN_A + (endtilex_mod << 1);
            src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, endtilex + ((starttiley + (PLANE_SIZE_MINUS_ONE - starttiley_mod + 1)) << levelData.mapWidthAsShiftValue));

			vertical_segment_two_addr = vertical_segment_two;
			loop = vertical_segment_two_length; 

            while(loop--) 
            { 
				*vertical_segment_two_addr = GetTile(*src, tileBaseValue);
				vertical_segment_two_addr++;
                src += levelData.foreground->width; 
            } 
        }
        else
        {
            vertical_segment_one_length = endtiley - starttiley + 1;         

            vertical_segment_one_destination_address = PLAN_A + ((endtilex_mod + (starttiley_mod << 6)) << 1);
            const u16* src = ARRAY_ITEM_ADDRESS(levelData.foreground->tilemap, endtilex + (starttiley << levelData.mapWidthAsShiftValue));

			vertical_segment_one_addr = vertical_segment_one;
			loop = vertical_segment_one_length; 

			while(loop--) 
            { 
				*vertical_segment_one_addr = GetTile(*src, tileBaseValue);
				vertical_segment_one_addr++;
                src += levelData.foreground->width; 
            } 
        }
    }
}

void DrawForeground()
{
    if (playerObject->speedy < 0)
    {
        if (starttilex_mod > endtilex_mod)
        {
			MyVDP_doDMA(VDP_DMA_VRAM, (u32)horizontal_segment_one, horizontal_segment_one_destination_address, horizontal_segment_one_length << 1, 2);
			VDP_waitDMACompletion();

			MyVDP_doDMA(VDP_DMA_VRAM, (u32)horizontal_segment_two, horizontal_segment_two_destination_address, horizontal_segment_two_length << 1, 2);
			VDP_waitDMACompletion();
        }
        else
        {
			MyVDP_doDMA(VDP_DMA_VRAM, (u32)horizontal_segment_one, horizontal_segment_one_destination_address, horizontal_segment_one_length << 1, 2);
			VDP_waitDMACompletion();
        }
    }
    else if (playerObject->speedy > 0)
    {
		if (starttilex_mod > endtilex_mod)
		{
			MyVDP_doDMA(VDP_DMA_VRAM, (u32)horizontal_segment_one, horizontal_segment_one_destination_address, horizontal_segment_one_length << 1, 2);
			VDP_waitDMACompletion();

			MyVDP_doDMA(VDP_DMA_VRAM, (u32)horizontal_segment_two, horizontal_segment_two_destination_address, horizontal_segment_two_length << 1, 2);
			VDP_waitDMACompletion();
        }
        else
        {
			MyVDP_doDMA(VDP_DMA_VRAM, (u32)horizontal_segment_one, horizontal_segment_one_destination_address, horizontal_segment_one_length << 1, 2);
			VDP_waitDMACompletion();
        }
    }

	u16 size = VDP_getPlanWidth() << 1;

    if (playerObject->speedx < 0)
    {
        if (starttiley_mod > endtiley_mod)
        {
			MyVDP_doDMA(VDP_DMA_VRAM, (u32)vertical_segment_one, vertical_segment_one_destination_address, vertical_segment_one_length << 1, size);
			VDP_waitDMACompletion();
		
			MyVDP_doDMA(VDP_DMA_VRAM, (u32)vertical_segment_two, vertical_segment_two_destination_address, vertical_segment_two_length << 1, size);
			VDP_waitDMACompletion(); 
        }
        else
        {
			MyVDP_doDMA(VDP_DMA_VRAM, (u32)vertical_segment_one, vertical_segment_one_destination_address, vertical_segment_one_length << 1, size);
			VDP_waitDMACompletion();
        }
    }
    else if (playerObject->speedx > 0)
    {
        if (starttiley_mod > endtiley_mod)
        {
			MyVDP_doDMA(VDP_DMA_VRAM, (u32)vertical_segment_one, vertical_segment_one_destination_address, vertical_segment_one_length << 1, size);
			VDP_waitDMACompletion();
		
			MyVDP_doDMA(VDP_DMA_VRAM, (u32)vertical_segment_two, vertical_segment_two_destination_address, vertical_segment_two_length << 1, size);
			VDP_waitDMACompletion();
        }
        else
        {
			MyVDP_doDMA(VDP_DMA_VRAM, (u32)vertical_segment_one, vertical_segment_one_destination_address, vertical_segment_one_length << 1, size);
			VDP_waitDMACompletion();
        }
    }
}

void UpdateDoors()
{
    if (playerObject->healthPoints == 0)
    {
        return;
    }

    s16 loop = numDoors;
    const Door* tempDoor = doors;

    // if not inside a door and touch one, then warp to the destination door.
    // if we're already inside a door, meaning we've spawned to it, then do nothing
    // until we don't touch doors anymore.

    if (insideOfDoors == 0)
    {
        while (loop--)
        {
            if (playerObject->x >= tempDoor->doorArea.left && 
                playerObject->x <= tempDoor->doorArea.right &&
                playerObject->y >= tempDoor->doorArea.top &&
                playerObject->y <= tempDoor->doorArea.bottom)
            {
                s16 doorx = playerObject->x - tempDoor->doorArea.left;
                s16 doory = playerObject->y - tempDoor->doorArea.top;
                u16 destinationDoorIndex = tempDoor->destinationSectionDoorIndex;

                SetupSection((const SectionDefinitionStruct*)tempDoor->destinationLevel);

                sectionStartX = doors[destinationDoorIndex].doorArea.left + doorx;
                sectionStartY = doors[destinationDoorIndex].doorArea.top + doory;
                playerSpriteIndex = playerObject->spriteIndex;

                insideOfDoors = 1;

                gameState = GAME_STATE_SETUP_SECTION;
                return;
            }
            tempDoor++;
        }
    }
    else
    {
        while (loop--)
        {
            if (playerObject->x >= tempDoor->doorArea.left && 
                playerObject->x <= tempDoor->doorArea.right &&
                playerObject->y >= tempDoor->doorArea.top &&
                playerObject->y <= tempDoor->doorArea.bottom)
            {
                // if we're still inside a door, just return.
                return;
            }
            tempDoor++;
        }

        insideOfDoors = 0;
   } 
}

void LevelManager_UpdateSection()
{
    updateSection();
    LevelManager_UpdateScroll();
    UpdateDoors();
}

void LevelManager_UpdateTilePlanes()
{
	UpdateForeground();
}



void LevelManager_DrawTilePlanes()
{
    VDP_setAllHorizontalScrollLines(PLAN_A, scrollData.scrollx_vdp);
    VDP_setHorizontalScrollLines(PLAN_B, backgroundLineScrollValues + (scrollData.scrolly_vdp >> 2), scrollData.scrollx_vdp >> 2);
	//VDP_setAllHorizontalScrollLines(BPLAN, scrollData.scrollx_vdp >> 2);
    VDP_setVerticalScroll(PLAN_A, scrollData.scrolly_vdp);
    VDP_setVerticalScroll(PLAN_B, scrollData.scrolly_vdp >> 2);

#ifdef BENCHMARK_SCROLLING_UPDATE
    u32 startTick = getSubTick();
    u16 loop = 0;
    for (loop = 0; loop < 100; loop++)
    {
#endif
    DrawForeground();    

#ifdef BENCHMARK_SCROLLING_UPDATE
    }
    u32 endTick = getSubTick();
    PrintNumber(endTick - startTick);
#endif


}

void LevelManager_GoToNextSection()
{
    levelSectionIndex++;
    if (levelSectionIndex >= level001Definition.numSections)
    {
        levelSectionIndex = 0;
    }

    gameState = GAME_STATE_SETUP_SECTION;
}

void LevelManager_GoToGameOver()
{
    while (1) {}
}

void LevelManager_SetupPlayerLevelStartPosition()
{
    sectionStartX = levelStartX;
    sectionStartY = levelStartY;
    playerObject->x = levelStartX;
    playerObject->y = levelStartY;
    playerObject->spriteIndex = 0;

    scrollData.scrollx_hires = -(playerObject->x - PIXEL_TO_VIRTUAL(160));
    scrollData.scrolly_hires = playerObject->y - PIXEL_TO_VIRTUAL(112);

	UpdateScrollValues();
}

void LevelManager_SetupPlayerSectionStartPosition()
{
    insideOfDoors = 1;
    playerObject->x = sectionStartX;
    playerObject->y = sectionStartY;
    playerObject->spriteIndex = playerSpriteIndex;

    scrollData.scrollx_hires = -(playerObject->x - PIXEL_TO_VIRTUAL(160));
    scrollData.scrolly_hires = playerObject->y - PIXEL_TO_VIRTUAL(112);

	UpdateScrollValues();
}

void LevelManager_SetTileMaps(const TileMap* foregroundTileMap, 
                              const TileMap* backgroundTileMap,
                              const unsigned short* foregroundTileData)
{
    levelData.foreground = foregroundTileMap;
    levelData.background = backgroundTileMap;
    levelData.foregroundTileData = foregroundTileData;

    levelData.mapWidthAsShiftValue = GetShiftValueFromValue(levelData.foreground->width);
    levelData.mapHeightAsShiftValue = GetShiftValueFromValue(levelData.foreground->height);
}

void LevelManager_SetScrollMode()
{
    // register 0x0b sets the scroll mode
    // first two bits sets the horizontal scroll mode (whole layer mode (0x00), tile row mode(0x02), or per-line mode(0x03))
    // third bit (0 or 1) sets the vertical scroll mode (whole layer mode or column mode)

    VDP_setReg(0x0b, 0x03); 
}