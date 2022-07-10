//
//  FHGame.h
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

#include "WoflGame.h"
#include "WoflLabel.h"

const int Tag_Button_Gold = 1;
const int Tag_Room = 2;


class FHGame : public WoflGame
{
public:
	FHGame();
	
	virtual void Tick(float DeltaTime) override;
	
	virtual void PostRender() override;

	virtual class WoflHud* GetHud() override
	{
		return CurrentHud;
	}

	// serialization of the game
	virtual Json::Value ToJsonObject() override;
	virtual void FromJsonObject(const Json::Value& Object) override;

protected:
	
	// button callbacks
	void OnGoldButtonClicked();
	void OnBuildRoomClicked();
	

protected:
	class FHBuilding* CurrentBuilding;
	vector<class FHBuilding*> Buildings;
	
	uint64_t CurrentCoins;
	uint64_t CurrentBait;
	uint64_t CurrentFood;
	uint64_t CurrentGems;

	class FHMainHud* MainHud;
	WoflHud* CurrentHud;

	// let the Hud get our properties
	friend class FHMainHud;
};

