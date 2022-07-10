//
//  FHBuilding.hpp
//  Wofl
//
//  Created by Josh on 6/16/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#pragma once

#include "FHRoom.h"
#include "WoflSprite.h"
#include "WoflGame.h"

class FHBuilding : public WoflSprite, public IJsonObj
{
public:
	FHBuilding();
	
	// add a floor
	void AddFloor(ERoomType Type);
	
	virtual Json::Value ToJsonObject() override;
	virtual void FromJsonObject(const Json::Value& Object) override;

protected:
	
	vector<FHRoom*> Rooms;
};