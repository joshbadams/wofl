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
	return SaveToFile(Utils::File->GetSavePath("game.sav").c_str());
}

bool WoflGame::Load()
{
	return LoadFromFile(Utils::File->GetSavePath("game.sav").c_str());
}
