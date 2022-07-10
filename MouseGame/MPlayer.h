//
//  Player.h
//  Wofl
//
//  Created by Josh on 2/16/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef __Wofl__Player__
#define __Wofl__Player__

#include "WoflSprite.h"


class MPlayer : public WoflSprite
{
public:
	MPlayer();
	
	virtual void Tick(float DeltaTime) override;
	
protected:
	Vector Velocity;
};

#endif /* defined(__Wofl__Player__) */
