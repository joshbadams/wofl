//
//  FHBuilding.cpp
//  Wofl
//
//  Created by Josh on 6/16/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "FHBuilding.h"
#include "WoflWorld.h"


FHBuilding::FHBuilding()
	: WoflSprite(0, 0, 0, 0)
{
	
}

Json::Value FHBuilding::ToJsonObject()
{
	Json::Value BuildingObj(Json::objectValue);
	
	AddArrayToObject(Rooms, BuildingObj, "Rooms");
	
	return BuildingObj;
}

void FHBuilding::FromJsonObject(const Json::Value& Object)
{
	GetArrayFromObject<FHRoom>(Rooms, Object, "Rooms",
								   [this](FHRoom* Room)
								   {
									   AddChild(Room);
								   });
}


void FHBuilding::AddFloor(ERoomType Type)
{
	int Floor = (int)Rooms.size();
	
	FHRoom* Room = new FHRoom(Floor, Type);
	Rooms.push_back(Room);

//	printf("Before\n");
//	WoflWorld::Get()->DumpWorld();
	AddChild(Room);
//	printf("\nAfter\n");
//	WoflWorld::Get()->DumpWorld();
}

