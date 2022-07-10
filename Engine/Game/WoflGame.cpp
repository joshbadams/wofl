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
	string JsonString = ToJsonObject().toStyledString();
	
	return Utils::File->SaveStringToFile(JsonString, Utils::File->GetSavePath("game.sav").c_str());
}

bool WoflGame::Load()
{
	string JsonString = Utils::File->LoadFileToString(Utils::File->GetSavePath("game.sav").c_str());;

	if (JsonString.length() == 0)
	{
		return false;
	}
	
	Json::Reader Reader;
	Json::Value Root(Json::objectValue);
	
	// convert into an object hierarchy
	Reader.parse(JsonString, Root, false);

	// let the game load itself from the Json string
	FromJsonObject(Root);
	
	return true;
}