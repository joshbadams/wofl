//
//  IdProgress.hpp
//  Idler
//
//  Created by Josh on 4/19/22.
//  Copyright © 2022 Josh. All rights reserved.
//

#pragma once

#include "WoflSprite.h"

#define DEFAULT_BORDER_WIDTH 2

class IdProgress : public WoflSprite
{
public:
	IdProgress(int X, int Y, int Width, int Height, const char* LabelText=nullptr, int BorderWidth=DEFAULT_BORDER_WIDTH, int Tag=0);
	
	void SetValueRef(float* ValueRef)
	{
		ValueReference = ValueRef;
	}
	
	void SetValue(float Value);
	void SetLabel(const char* LabelText);

	virtual bool CustomRender() override;

protected:
	WoflSprite* Background;
	WoflSprite* Foreground;
	class WoflLabel* Label;
	
	float* ValueReference;
};
