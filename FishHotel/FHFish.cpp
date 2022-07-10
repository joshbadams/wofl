//
//  FHFish.cpp
//  Wofl
//
//  Created by Josh on 6/19/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "FHFish.h"

FHFish::FHFishInfo FHFish::FishInfos[] =
{
	// Name,			Cost,	Width,	Height
	{ "Orangeroughy",	21,		30,		20 },
	{ "Fangtooth",		25,		35,		25 },
};

static_assert(ARRAY_COUNT(FHFish::FishInfos) == (int)EFishType::Max, "Mismatch between EFishType and FHFish::FishInfos");


FHFish::FHFish(EFishType Type, const Vector& InRoomSize)
	: WoflSprite(0, 0, FishInfos[(int)Type].Width, FishInfos[(int)Type].Height)
	, RoomSize(InRoomSize)
{
	WoflImage* Image = new WoflImage(FishInfos[(int)Type].ImageName);
	AddImage(Image);
	
	int XPos = rand() % (int)(RoomSize.X - Size.X);
	int YPos = rand() % (int)(RoomSize.Y - Size.Y);
	
	SetPosition(Vector(XPos, YPos));
	
}


