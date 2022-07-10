//
//  MGame.h
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef __Wofl__MGame__
#define __Wofl__MGame__

#include "WoflGame.h"

class MGame : public WoflGame
{
public:
	MGame();
	
	virtual void Tick(float DeltaTime) override;
	virtual void PostRender() override;
		
	void IncScore()
	{
		Score++;
	}
protected:
	class MPlayer* Player;
	
	int Score;
};

#endif /* defined(__Wofl__MGame__) */
