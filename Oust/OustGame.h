//
//  FHGame.h
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once
#include "WoflGame.h"

enum OustTags
{
	Tag_Board,
	Tag_Cell,
};

class OustGame : public WoflGame
{
public:
	OustGame();
	
	virtual void Tick(float DeltaTime) override;
	
	virtual void PostRender() override;

protected:
	
	class WoflSprite* BoardSprite;
	
	int NextTurn;
	int EdgeSize;
};
