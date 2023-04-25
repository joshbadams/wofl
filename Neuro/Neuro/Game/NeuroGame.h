//
//  NeuroGame.hpp
//  Neuro
//
//  Created by Josh Adams on 4/9/23.
//

#pragma once

#include <Wofl/Wofl.h>
#include "NeuroState.h"

class NeuroGame : public WoflGame, public IStateDelegate, IInterfaceDelegate
{
public:
	NeuroGame();
	
	virtual void Tick(float DeltaTime) override
	{
		State.Tick();
	}

	virtual void Invalidate(ZoneType Zone) override;
	virtual void MessageComplete() override
	{
		State.MessageComplete();
	}
	
private:
	
	NeuroConfig Config;
	NeuroState State;
		
	WoflSprite* ScreenSprite;
	class Textbox* MessageBox;
	class Ninebox* DialogBox;
	
	void LoadConfig();

	void OnRoomChange(Room* Room);
	void OnConversationChange(Conversation* Room);

};
