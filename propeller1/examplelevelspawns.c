#include "examplelevelspawns.h"

// Spawn points are in tile space. No real reason why.
const ObjectSpawnPoint examplelevelspawns_objectspawnpoints[10] = 
{
{14, 14, 0},
{61, 7, 1},
{190, 8, 1},
{126, 7, 1},
{63, 114, 1},
{191, 116, 1},
{100, 91, 1},
{152, 90, 1},
{19, 87, 1},
{234, 89, 1},
};


const ObjectSpawnPoints examplelevelspawns = 
{
	10,
	examplelevelspawns_objectspawnpoints
};
