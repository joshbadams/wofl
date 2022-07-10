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
#include "SPlayer.h"

enum LayerNames
{
	Background,
	Game,
	Foreground,
	
	NumLayers,
};


enum ScrollyTags
{
	Tag_Level,
	Tag_Player,
};

// Layer structure (it's a Sprite just so it can be added into the world easily)
struct Layer : public WoflSprite
{
	Layer(float InScrollSpeed, Vector Size)
		: WoflSprite(0, 0, Size.X, Size.Y, Tag_Level)
		, ScrollSpeed(InScrollSpeed)
	{
		
	}
	
	
	float ScrollSpeed;
};


class ScrollyGame : public WoflGame
{
public:
	ScrollyGame();
	
	virtual void Tick(float DeltaTime) override;
	
	virtual void PostRender() override;

protected:
	
	Layer* Layers[NumLayers];
	
	class SPlayer* Player;
	
};
