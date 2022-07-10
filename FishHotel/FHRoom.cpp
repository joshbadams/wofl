//
//  FHRoom.cpp
//  Wofl
//
//  Created by Josh on 8/21/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "FHRoom.h"
#include "FHGame.h"
#include "WoflLabel.h"

#define FLOOR_HEIGHT 130
#define FLOOR_WIDTH 300

#define MAX_FLOORS 6



FHRoom::FHRoomInfo FHRoom::RoomInfos[] =
{
	// Name,			Height,		Cost,	Capacity
	{ "Disco",			1,			100,	10 },
	{ "OrcaExhibit",	1,			2000,	10 },
	{ "Fishpalace",		1,			500,	10 },
	{ "Bedroom",		1,			5000,	10 },
	{ "Kitchen",        1,          1000,   10 },
	{ "Plaza",          1,          10000,  10 },
	{ "CandyRoom",      1,          6000,   10 },
	{ "Basement",		1,			6000,	10 },
	{ "Livingroom",		1,			7000,	10 },
	{ "Attic",			1,			500,	10 },
	{ "DiningRoom",		1,			1000,	10 },
	{ "BonusRoom",		1,			4000,	10 },
	{ "CraftRoom",		1,			2500,	10 },
	{ "Closet",			1,			700,	10 },
	{ "Library",		1,			5000,	10 },
	{ "Arcade",			1,			3500,	10 },
	{ "LaundryRoom",	1,			4500,	10 },
	{ "Playground",		1,			6000,	10 },
	{ "Porch",			1,			1500,	10 },
	{ "Office",			1,			1000,	10 },
};

static_assert(sizeof(FHRoom::RoomInfos) / sizeof(FHRoom::RoomInfos[0]) == (int)ERoomType::Max, "Mismatch between ERoomType and FHRoom::RoomInfos");

ERoomType FHRoom::GetRandomRoomType()
{
	return (ERoomType)(rand() % (int)ERoomType::Max);
}

static int GetRoomX(int FloorIndex)
{
	return (FloorIndex/MAX_FLOORS)*FLOOR_WIDTH;
	//	WoflRenderer::Renderer->GetViewSize();
}

static int GetRoomY(int FloorIndex)
{
	return (FloorIndex % MAX_FLOORS)*FLOOR_HEIGHT;
}

FHRoom::FHRoom()
	: WoflSprite(0, 0, FLOOR_WIDTH, FLOOR_HEIGHT, Tag_Room)
{
	
}

FHRoom::FHRoom(int InFloorIndex, ERoomType InType)
	: WoflSprite(0, 0, FLOOR_WIDTH, FLOOR_HEIGHT, Tag_Room)
{
	FloorIndex = InFloorIndex;
	RoomType = InType;

	PostConstruct();
}

void FHRoom::PostConstruct()
{
	// position the room
	SetPosition(Vector(GetRoomX(FloorIndex), GetRoomY(FloorIndex)));
	
	WoflImage* Room = new WoflImage(RoomInfos[(int)RoomType].ImageName);
	AddImage(Room);
	
	WoflLabel* Label = new WoflLabel(RoomInfos[(int)RoomType].ImageName, true, true, 0, 0, FLOOR_WIDTH, FLOOR_HEIGHT);
	AddChild(Label);
	

	SetClickEnabled(true);
}


Json::Value FHRoom::ToJsonObject()
{
	Json::Value RoomObj(Json::objectValue);
	
	RoomObj["FloorIndex"] = FloorIndex;
	RoomObj["Type"] = (int)RoomType;
	
	return RoomObj;
}

void FHRoom::FromJsonObject(const Json::Value& Object)
{
	FloorIndex = Object["FloorIndex"].asInt();
	RoomType = (ERoomType)Object["Type"].asInt();

	PostConstruct();
}


void FHRoom::OnClick()
{
	EFishType Type = (EFishType)(rand() % (int)EFishType::Max);
	
	FHFish* NewFish = new FHFish(Type, GetSize());
	AddChild(NewFish);
	
	Fish.push_back(NewFish);
}

