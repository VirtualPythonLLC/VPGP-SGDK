#ifndef SPRITES_AND_MAPS_INCLUDE_H
#define SPRITES_AND_MAPS_INCLUDE_H

// Refers to all the level-related and sprite-related data.

#include <genesis.h>

#include "ObjectSpawnPoints.h"

// Tile maps.
#include "examplebackground.h"
#include "exampleforground.h"

// Object spawn points.
#include "examplelevelspawns.h"

// Sections
#include "Level001Section001.h"
//#include "Level001Section002.h"
//#include "Level001Section003.h"
// ...

// Tileset data.
// Tileset data describes a tile's attribute. Solid, non-solid, etc.
#include "ExampleTileSetData.h"

// Genres Resources
#define IMPORT_SPRITE(spritename) extern struct genresSprites spritename

// This is where we import extern'd sprite data from resource.rc
IMPORT_SPRITE(foregroundSprite);
IMPORT_SPRITE(backgroundSprite);
IMPORT_SPRITE(playerSprite);
IMPORT_SPRITE(bulletSprite);
IMPORT_SPRITE(explosionSprite);
IMPORT_SPRITE(ExplosionSprite);
IMPORT_SPRITE(coinSprite);
IMPORT_SPRITE(enemySprite);
IMPORT_SPRITE(radarArrowSprite);
IMPORT_SPRITE(heartSprite);

// data type that maps sprites or map tiles into a location in the VDP's tile memory.
typedef struct
{
    u16 startIndex;
    u16 numTiles;
} LoadedTileInfo;

// sprite to VDP tile mappings.
// An object needs to know where it's sprite data is located in VDP memory.
// A LoadedTileInfo contains this information.
#define IMPORT_LTI(lti) extern LoadedTileInfo lti
IMPORT_LTI(backgroundLoadedTileInfo);
IMPORT_LTI(foregroundLoadedTileInfo);
IMPORT_LTI(playerLoadedTileInfo);
IMPORT_LTI(bulletLoadedTileInfo);
IMPORT_LTI(explosionLoadedTileInfo);
IMPORT_LTI(coinLoadedTileInfo);
IMPORT_LTI(enemyLoadedTileInfo);
IMPORT_LTI(radarArrowLoadedTileInfo);
IMPORT_LTI(heartLoadedTileInfo);



// functions to loads tiles and sprites into VDP. call reset first, then loadmapdata and
// loadspritedata will fill VDP tile memory sequentially.
void ResetTileStartIndex();
void StoreSectionTileStartIndex();
void SetTileStartIndexToSectionTileStartIndex();
void LoadSpriteDataToVDP(struct genresSprites* sprite, LoadedTileInfo* loadedTileInfo);

// Spawns objects from Object Spawn Point objects.
void SpawnObjects(const ObjectSpawnPoints* objectSpawnPoints);

#endif
