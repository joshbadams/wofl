//
//  FHGame.h
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once
#include "WoflGame.h"
#include "WoflSprite.h"


class BTGame : public WoflGame
{
public:
	BTGame();
	
	virtual void Tick(float DeltaTime) override;
	
	virtual void PostRender() override;

protected:
	
	class BTPlayer* Player;
};
