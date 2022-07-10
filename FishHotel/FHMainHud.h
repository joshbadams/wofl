//
//  FHMainHud.hpp
//  Wofl
//
//  Created by Josh on 6/17/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "WoflHud.h"


class FHMainHud : public WoflHud
{
public:
	
	FHMainHud(class FHGame* InGame);
	
	virtual void Tick(float DeltaTime) override;
	
protected:
	class FHGame* Game;

	// cached controls
	WoflLabel* CoinsLabel;
	WoflLabel* GemsLabel;
	WoflLabel* FoodLabel;
	WoflLabel* BaitLabel;
};
