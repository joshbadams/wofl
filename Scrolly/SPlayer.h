//
//  SPlayer.h
//  Wofl
//
//  Created by Josh on 2/9/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#pragma once

#include "WoflSprite.h"

class SPlayer : public WoflSprite
{
public:
	SPlayer(float X, float Y);
	
	void Tick(float DeltaTime) override;
	
private:
	float Velocity;
	float Acceleration;
	float GroundLevel;
};
