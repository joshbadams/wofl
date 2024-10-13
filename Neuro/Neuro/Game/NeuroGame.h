//
//  NeuroGame.hpp
//  Neuro
//
//  Created by Josh Adams on 4/9/23.
//

#pragma once

#include <Wofl/Wofl.h>
#include "NeuroState.h"

const int Tag_Dialog = 1;

class NeuroGame : public WoflGame, public IStateChangedDelegate
{
public:
	NeuroGame();

	NeuroConfig& GetConfig()
	{
		return Config;
	}
	
	virtual void Tick(float DeltaTime) override
	{
		State.Tick();
	}

	virtual void Invalidate(ZoneType Zone) override;

	virtual void CloseBoxWithObj(LuaRef BoxObj) override;

private:
	
	NeuroConfig Config;
	friend class NeuroConfigObj;
	NeuroState State;
		
	WoflSprite* ScreenSprite;
	WoflSprite* Background;
	class Textbox* MessageBox;
	class Ninebox* DialogBox;
	class Gridbox* Inventory;
	class Gridbox* WebSite;

	void LoadConfig();

	void OnRoomChange(Room* Room);
	void OnConversationChange(Conversation* Room);

};
