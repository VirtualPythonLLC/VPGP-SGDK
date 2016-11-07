#include "Level001Section001.h"

#include <genesis.h>
#include <genres.h>
#include <tab_vram.h>

#include "Config.h"
#include "Debug.h"
#include "GameFont.h"
#include "LevelManager.h"
#include "MathUtils.h"
#include "SpritesAndMaps.h"
#include "VDP_Extra.h"
#include "Enemy.h"

void Level001Section001_PrecacheTileAssetsToVDP()
{
    SetTileStartIndexToSectionTileStartIndex();
    LoadSpriteDataToVDP(&backgroundSprite, &backgroundLoadedTileInfo);
    LoadSpriteDataToVDP(&foregroundSprite, &foregroundLoadedTileInfo);
    LoadSpriteDataToVDP(&enemySprite, &enemyLoadedTileInfo);

    VDP_loadFont((const u32 *)gameFont, 1);
}

void Level001Section001_SetupPalettes()
{
    VDP_setPalette(PAL0, playerSprite);
    VDP_setPalette(PAL1, enemySprite);
    VDP_setPalette(PAL2, backgroundSprite);
    VDP_setPalette(PAL3, foregroundSprite);
}

void Level001Section001_SpawnObjects()
{
    SpawnObjects(&examplelevelspawns);
}

void Level001Section001_SetupSection()
{

}

void Level001Section001_SetupSectionResources()
{
    LevelManager_SetTileMaps(&exampleforground, &examplebackground, example_tiledata);
    Level001Section001_PrecacheTileAssetsToVDP();
    Level001Section001_SetupPalettes();
}

void Level001Section001_UpdateSection()
{

}

void Level001Section001_CloseSection()
{

}


const SectionDefinitionStruct level001Section001Definition =
{
    Level001Section001_SetupSection,
    Level001Section001_SetupSectionResources,
    Level001Section001_UpdateSection,
    Level001Section001_CloseSection,        
    Level001Section001_SpawnObjects,
	// Example door setup, to go from one section to another:
    0, // 1
    {
        {{TILE_TO_VIRTUAL(62), TILE_TO_VIRTUAL(63), TILE_TO_VIRTUAL(0), TILE_TO_VIRTUAL(63)}, 0/*&level001Section002Definition*/, 0},
        {{0, 0, 0, 0}, 0, 0},
        {{0, 0, 0, 0}, 0, 0},
        {{0, 0, 0, 0}, 0, 0}
    }
};

