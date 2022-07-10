//
//  WoflButton.hpp
//  Wofl
//
//  Created by Josh on 6/15/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#pragma once

#include "WoflSprite.h"
#include "WoflLabel.h"

class WoflButton : public WoflSprite
{
public:
	WoflButton(const char* BackgroundImage, const char* LabelText, float X, float Y, float SizeX, float SizeY, int Tag, SpriteCaptureType CaptureType);
	WoflButton(const char* BackgroundImage, const char* LabelText, float X, float Y, float SizeX, float SizeY, int Tag, const function<void(WoflButton*)>& OnClick);
	WoflButton(const char* BackgroundImage, const char* LabelText, float X, float Y, float SizeX, float SizeY, int Tag, SpriteCaptureType CaptureType, const function<void(WoflButton*, const Vector&, int)>& OnInput);

	virtual WoflButton* AsButton() override { return this; }
	virtual SpriteCaptureType GetCaptureType() override { return CaptureType; }

	virtual void OnClick() override;
	virtual void OnInput(const Vector& ScreenLocation, int RepeatCount) override;

	void SetText(string Str)
	{
		Label->SetText(Str);
	}
	
	
protected:
	WoflLabel* Label;
	
	// function to call when the button is clicked
	function<void (WoflButton*)> OnClickFunc;
	function<void (WoflButton*, const Vector&, int)> OnInputFunc;
	
	SpriteCaptureType CaptureType;
};
