//
//  NeuroScene.hpp
//  Neuro
//
//  Created by Josh Adams on 4/23/23.
//

#pragma once

#include <Wofl/Wofl.h>

class NeuroScene : public WoflSprite
{
public:
	
	NeuroScene(class NeuroState* InState, float X, float Y, float SizeX, float SizeY);
	
	virtual bool OnKey(const KeyEvent& Event) override;
	virtual void OnInput(const Vector& ScreenLocation, int RepeatIndex) override;

	
protected:
	NeuroState* State;
};
