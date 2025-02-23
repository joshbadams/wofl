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

	virtual void Tick(float DeltaTime) override
	{
		State.Tick(DeltaTime);
	}

	virtual void Invalidate(ZoneType Zone) override;
	
	virtual LuaRef OpenBoxByName(const char* Name) override;
	virtual bool CloseBoxWithObj(LuaRef BoxObj) override;
	virtual bool ReorderBoxWithObj(LuaRef BoxObj, int Mode) override;

	virtual bool AreBoxesShowing() override;
	virtual bool IsConversationShowing() override;
	virtual bool IsMessageActive() override;
	virtual void RefreshUI() override;

	virtual bool OnGlobalKey(const KeyEvent& Event) override;

private:
	
	NeuroState State;
		
	WoflSprite* ScreenSprite;
	WoflSprite* Background;
	class WoflButton* InvButton;
	class WoflSprite* ButtonContainer;
	class Textbox* MessageBox;
	class Textbox* InfoBox;
	class WoflSprite* DialogInputSorter;
	class WoflSprite* SiteInputSorter;
	class Ninebox* DialogBox;
	class Ninebox* ThoughtBox;
	vector<class Gridbox*> Boxes;
	vector<class Gridbox*> BoxCache;

	void LoadConfig();

	void OnRoomChange(Room* Room);
	void OnConversationChange(Conversation* Room);

};
