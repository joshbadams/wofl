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
		State.Tick(DeltaTime);
	}

	virtual void Invalidate(ZoneType Zone) override;
	
	virtual void OpenBoxByName(const char* Name) override;
	virtual bool CloseBoxWithObj(LuaRef BoxObj) override;
	
	virtual bool AreBoxesShowing() override;
	virtual bool IsConversationShowing() override;
	virtual bool IsMessageActive() override;
	virtual void RefreshUI() override;

	virtual void CloseBoxWithObj(LuaRef BoxObj) override;

private:
	
	NeuroConfig Config;
	friend class NeuroConfigObj;
	NeuroState State;
		
	WoflSprite* ScreenSprite;
	WoflSprite* Background;
	class Textbox* MessageBox;
	class Ninebox* DialogBox;
	vector<class Gridbox*> Boxes;
	vector<class Gridbox*> BoxCache;

	void LoadConfig();

	void OnRoomChange(Room* Room);
	void OnConversationChange(Conversation* Room);

};
