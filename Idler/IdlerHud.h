//
//  IdlerHud.hpp
//  Idler
//
//  Created by Josh on 4/18/22.
//  Copyright © 2022 Josh. All rights reserved.
//


#pragma once

#include "WoflHud.h"

class IdlerHud : public WoflHud
{
public:
	
	IdlerHud(class IdlerGame* InGame);
	
	virtual void Tick(float DeltaTime) override;
	
protected:
	class IdlerGame* Game;

	// cached controls
	WoflLabel* MoneyLabel;
	WoflLabel* LevelLabel;
	WoflLabel* XPLabel;
	WoflLabel* InfoLabel;

	WoflButton* BuyLevelButton;
};
