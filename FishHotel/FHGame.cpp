//
//  FHGame.cpp
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "FHGame.h"
#include "WoflWorld.h"
#include "WoflRenderer.h"
#include "WoflAtlases.h"
#include "WoflButton.h"
#include "FHRoom.h"
#include "FHBuilding.h"
#include "FHMainHud.h"


WoflGame* GlobalGameInitialization()
{
	return new FHGame();
}

// construt the world
FHGame::FHGame()
	: WoflGame("Fish Hotel")
	, CurrentCoins(0)
	, CurrentBait(0)
	, CurrentFood(0)
	, CurrentGems(0)
{
	//load up the atlas for the sprites
	WoflAtlases::LoadAtlas("FishAtlas");
	
	Vector ViewSize = WoflRenderer::Renderer->GetViewSize();
	
	WoflSprite* Background = new WoflSprite(0, 0, ViewSize.X, ViewSize.Y);
	WoflImage* BackgroundImage = new WoflImage("Background");
	Background->AddImage(BackgroundImage);
	WoflWorld::World->SetRootSprite(Background);
	
	if (Load() == false)
	{
		// create a building and add to world
		CurrentBuilding = new FHBuilding();
		Background->AddChild(CurrentBuilding);

		Buildings.push_back(CurrentBuilding);
	}
	
	MainHud = new FHMainHud(this);
	CurrentHud = MainHud;

}

Json::Value FHGame::ToJsonObject()
{
	// root object for the game
	Json::Value GameObj(Json::objectValue);
	
	// add buildings
	AddArrayToObject(Buildings, GameObj, "Buildings");
	
	GameObj["Coins"] = CurrentCoins;
	GameObj["Gems"] = CurrentGems;
	GameObj["Food"] = CurrentFood;
	GameObj["Bait"] = CurrentBait;
	
	return GameObj;
}

void FHGame::FromJsonObject(const Json::Value& GameObj)
{
	GetArrayFromObject<FHBuilding>(Buildings, GameObj, "Buildings",
					   [](FHBuilding* Building)
					   {
						   WoflWorld::World->GetRootSprite()->AddChild(Building);
					   });
	CurrentBuilding = Buildings[0];
	
	CurrentCoins = GameObj["Coins"].asInt64();
	CurrentGems = GameObj["Gems"].asInt64();
	CurrentFood = GameObj["Food"].asInt64();
	CurrentBait = GameObj["Bait"].asInt64();
}

void FHGame::Tick(float DeltaTime)
{
	WoflGame::Tick(DeltaTime);
}

void FHGame::PostRender()
{

}



