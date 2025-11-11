//
//  WoflGame.cpp
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "WoflGame.h"

WoflGame* WoflGame::TheGame = NULL;

bool WoflGame::Save()
{
	return SaveToFile("game.sav", FileDomain::Save);
}

bool WoflGame::Load()
{
	return LoadFromFile("game.sav", FileDomain::Save);
}
