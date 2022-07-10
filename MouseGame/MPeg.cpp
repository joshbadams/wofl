//
//  MPeg.cpp
//  Wofl
//
//  Created by Josh on 6/30/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "MPeg.h"
#include "WoflWorld.h"
#include "MGame.h"

#define PEG_RADIUS 10.0f

MPeg::MPeg(float CenterX, float CenterY)
	: WoflSprite(CenterX - PEG_RADIUS, CenterY - PEG_RADIUS, PEG_RADIUS * 2, PEG_RADIUS * 2)
	, Radius(PEG_RADIUS)
 {
	 WoflImage* BasicPeg = new WoflImage(rand() < (INT32_MAX/2) ? "Walnut" : "Cheese", 0.0, 0.0, 1.0, 1.0);
	 AddImage(BasicPeg);
	 
	 // enable collision
	 SetCollisionRadius(PEG_RADIUS);

 }

void MPeg::OnCollision(WoflSprite* Collider)
{
	WoflWorld::World->DeleteSprite(this);
	
	MGame* Game = (MGame*)WoflWorld::World->GetGame();
	Game->IncScore();
}
