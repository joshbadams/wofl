//
//  NeuroScene.cpp
//  Neuro
//
//  Created by Josh Adams on 4/23/23.
//

#include "NeuroScene.h"
#include "NeuroState.h"
#include "NeuroGame.h"

NeuroScene::NeuroScene(class NeuroState* InState, float X, float Y, float SizeX, float SizeY)
	: WoflSprite(X, Y, SizeX, SizeY)
	, State(InState)
{
	SetClickEnabled(true);
}


bool NeuroScene::OnKey(const KeyEvent& Event)
{
	return State->HandleSceneKey(Event);
}

// RepeatIndex: 0 is first, > 0 is repeat, < 0 is end)
void NeuroScene::OnInput(const Vector& ScreenLocation, int RepeatIndex)
{
	if (RepeatIndex == 0)
	{
		ZoneType Zone = ZoneType::Room;

		WoflSprite* Dialog = WoflWorld::FindSpriteWithTag(Tag_Dialog);
		if (Dialog && Dialog->HitTest(ScreenLocation - GetPosition()))
		{
			Zone = ZoneType::Dialog;
		}
		State->HandleSceneClick(Zone);
	}
}
