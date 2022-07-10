//
//  BTLevel.cpp
//  Wofl
//
//  Created by Josh on 7/26/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "BTLevel.h"
#include "BTTiles.h"

const int TilesX = 9;
const int TilesY = 4;

enum TileType
{
	N0 = 0, // narrow nothing
	NF = 0x100, // narrow ladder
	NL = 0x200, // narrow floor

	W0 = 0, // wide nothing
	WF = NF, // wide floor
	WL = NL, // wide ladder

	B1 = 1, // wide burger bun top
	B2 = 2, // wide burger lettuce
	B3 = 3, // wide burger tomato
	B4 = 4, // wide burger meat
	B5 = 5, // wide burger bun bottom
	
};

const int Layout[TilesX * TilesY] =
{
	NF,		WF+B1,		NF,		WF+B1,		NF,		WF+B1,		NF,		WF+B1,		NF,
	NL,		WL,			NL,		WF,			NL,		WL,			NL,		W0,			NL,
	NF+NL,	WL+WF,		NF+NL,	W0,			NL,		WL,			NL,		W0,			NL,
	NF+NL,	WF+B5,		NF+NL,	W0,			NF+NL,	WL+WF+B5,	NL+NF,	W0,			NL+NF,
};



BTSprite* MakeSprite(int Type, int Column, int Row)
{
	bool bIsWide, bHasLadder, bHasFloor;
	
	// parse info
	bIsWide = (Column & 1) != 0;
	bHasLadder = (Type & NL) != 0;
	bHasFloor = (Type & NF) != 0;
	
	return new BTSprite(Column / 2, Row, bIsWide, bHasFloor, bHasLadder);
};



// let's try assuming 1280x720, then scaling to fit
BTLevel::BTLevel()
	: WoflSprite(0, 0, 1280, 720)
{
	for (int Y=0; Y < TilesY; Y++)
	{
		for (int X=0; X < TilesX; X++)
		{
			// lookup the tile to add to the world
			int Type = Layout[((TilesY-1) - Y) * TilesX + X];
			if (Type == 0)
			{
				continue;
			}

			// make the tile
			BTSprite* Tile = MakeSprite(Type, X, Y);
			AddChild(Tile);
		}
	}
}

