//
//  WoflApp.cpp
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "WoflApp.h"
#include "WoflRenderer.h"
#include "WoflWorld.h"

#if !IS_WOFL_LIBRARY
void WoflApplication::Initialize()
{
	Initialize(GlobalGameInitialization());
}
#endif

void WoflApplication::Initialize(WoflGame* Game)
{
	// check assumptions
	assert(Game != NULL);

	// hook everything up
	WoflWorld::Get()->SetGame(Game);
	
	assert(WoflRenderer::Renderer != NULL);
}

void WoflApplication::Tick()
{
	WoflWorld::Get()->Tick();
}

void WoflApplication::Render()
{
	WoflWorld::Get()->Render();
}
