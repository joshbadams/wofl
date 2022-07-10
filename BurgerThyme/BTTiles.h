//
//  BTTiles.hpp
//  Wofl
//
//  Created by Josh on 7/9/17.
//  Copyright © 2017 Josh. All rights reserved.
//

#pragma once

#include "WoflSprite.h"
#include "BTUtils.h"

class BTSprite : public WoflSprite
{
public:
	
	BTSprite(int Column, int Row, bool bIsWide, bool bInHasFloor, bool bHasLadder)
		: WoflSprite(0, 0, bIsWide ? WideWidth : NarrowWidth, TileHeight)
		, bHasFloor(bInHasFloor)
	{
		if (bIsWide)
		{
			SetRelativePosition(Vector((NarrowWidth + WideWidth) * Column + NarrowWidth, TileHeight * Row));
		}
		else
		{
			SetRelativePosition(Vector((NarrowWidth + WideWidth) * Column, TileHeight * Row));
		}
		
		if (bHasLadder)
		{
			AddImage(new WoflImage(bIsWide ? "WideLadder" : "Ladder"));
		}
		
		if (bHasFloor)
		{
			WoflSprite* FloorSprite = new WoflSprite(0, 0, Size.X, Size.Y);
			FloorSprite->AddImage(new WoflImage("Floor"));
			AddChild(FloorSprite);
		}		
	}
	
	bool HasFloor()
	{ return bHasFloor; }
	
protected:
	bool bHasFloor;
};

