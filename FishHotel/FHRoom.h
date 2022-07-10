//
//  FHRoom.h
//  Wofl
//
//  Created by Josh on 8/21/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

#include "WoflSprite.h"
#include "WoflGame.h"
#include "FHFish.h"

enum class ERoomType : int
{
	Disco,
	OrcaExhibit,
	FishPalace,
	Bedroom,
	Kitchen,
	Plaza,
	CandyRoom,
	Basement,
	LivingRoom,
	Attic,
	DiningRoom,
	BonusRoom,
	CraftRoom,
	Closett,
	Library,
	Arcade,
	LaundryRoom,
	Playground,
	Porch,
	Office,

	Max
};


class FHRoom : public WoflSprite, public IJsonObj
{
public:
	struct FHRoomInfo
	{
		// the name of the graphic
		const char* ImageName;
		// height of the room in floors
		int Height;
		// how much does it cost to buy
		int Cost;
		// capacity of the room
		int Capacity;
	};
	static FHRoomInfo RoomInfos[];

	static ERoomType GetRandomRoomType();
	

	FHRoom();
	FHRoom(int InFloorIndex, ERoomType InType);
	
	virtual Json::Value ToJsonObject() override;
	virtual void FromJsonObject(const Json::Value& Object) override;

	virtual void OnClick() override;
	
protected:
	
	void PostConstruct();
	
	ERoomType RoomType;
	int FloorIndex;
	
	vector<FHFish*> Fish;
};

