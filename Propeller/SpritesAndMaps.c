#include "SpritesAndMaps.h"

#include <genres.h>
#include <tab_vram.h>

#include "MathUtils.h"
#include "VDP_Extra.h"

#include "LevelManager.h"

// Objects to spawn.
#include "Enemy.h"

LoadedTileInfo backgroundLoadedTileInfo;
LoadedTileInfo foregroundLoadedTileInfo;
LoadedTileInfo playerLoadedTileInfo;
LoadedTileInfo bulletLoadedTileInfo;
LoadedTileInfo explosionLoadedTileInfo;
LoadedTileInfo coinLoadedTileInfo;
LoadedTileInfo enemyLoadedTileInfo;
LoadedTileInfo radarArrowLoadedTileInfo;
LoadedTileInfo heartLoadedTileInfo;


u16 commonTileStartIndex;   // stores the current index of common assets stored in the VDP.
u16 sectionTileStartIndex;  // stores the start index of the section-specifc assets store in the VDP.

void ResetTileStartIndex()
{
    commonTileStartIndex = 1;
}

void StoreSectionTileStartIndex()
{
    sectionTileStartIndex = commonTileStartIndex;
}

void SetTileStartIndexToSectionTileStartIndex()
{
    commonTileStartIndex = sectionTileStartIndex;
}

void LoadSpriteDataToVDP(struct genresSprites* sprite, LoadedTileInfo* loadedTileInfo)
{
    u16 numTiles = (sprite->width >> 3) * (sprite->height >> 3) * sprite->count;

    loadedTileInfo->startIndex = commonTileStartIndex;
    loadedTileInfo->numTiles = numTiles;
    commonTileStartIndex += numTiles;

    VDP_loadTileData( sprite->sprites[0], loadedTileInfo->startIndex, loadedTileInfo->numTiles, 1);
    VDP_waitDMACompletion();

	PrintNumber(commonTileStartIndex);
}

void SpawnObjects(const ObjectSpawnPoints* objectSpawnPoints)
{
    u16 loop = objectSpawnPoints->numObjectSpawnPoints;
    const ObjectSpawnPoint* objectSpawnPoint = objectSpawnPoints->objectSpawnPoints;

    while (loop--)
    {
        switch (objectSpawnPoint->objectType)
        {
        case 0:
            levelStartX = TILE_TO_VIRTUAL(objectSpawnPoint->x);
            levelStartY = TILE_TO_VIRTUAL(objectSpawnPoint->y);
            break;
        case 1:
            EnemyCreate(TILE_TO_VIRTUAL(objectSpawnPoint->x), TILE_TO_VIRTUAL(objectSpawnPoint->y));
            break;
        }

        objectSpawnPoint++;
    }
}
