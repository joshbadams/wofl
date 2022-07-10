//
//  SPlayer.h
//  Wofl
//
//  Created by Josh on 2/9/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#pragma once

#include "WoflSprite.h"

enum BTTags
{
	Tag_Player,
	Tag_Ladder,
	Tag_Food,
	Tag_Enemy,
};

class BTPlayer : public WoflSprite
{
public:
	BTPlayer();
	
	void Tick(float DeltaTime) override;
	
private:

};
