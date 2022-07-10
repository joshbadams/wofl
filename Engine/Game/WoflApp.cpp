//
//  WoflApp.cpp
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "WoflPch.h"
#include "WoflApp.h"
#include "WoflRenderer.h"
#include "WoflWorld.h"

void WoflApplication::Initialize()
{
	// always make a world object (singleton which registers itself)
	WoflWorld* World = new WoflWorld();
	
	// now let the game start itself
	WoflGame* Game = GlobalGameInitialization();
	World->SetGame(Game);
	
	// check assumptions
	assert(Game != NULL);
	assert(WoflRenderer::Renderer != NULL);
}

void WoflApplication::Tick()
{
	WoflWorld::World->Tick();
}

void WoflApplication::Render()
{
	WoflWorld::World->Render();
}
