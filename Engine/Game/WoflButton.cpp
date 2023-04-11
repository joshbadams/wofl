//
//  WoflButton.cpp
//  Wofl
//
//  Created by Josh on 6/15/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "WoflButton.h"
#include "WoflImage.h"

WoflButton::WoflButton(const char* BackgroundImage, const char* LabelText, float X, float Y, float SizeX, float SizeY, int Tag,  SpriteCaptureType InCaptureType)
	: WoflSprite(X, Y, SizeX, SizeY)
	, OnClickFunc(nullptr)
	, CaptureType(InCaptureType)
{
	if (BackgroundImage != nullptr)
	{
		AddImage(new WoflImage(BackgroundImage));
	}
	
	if (LabelText != nullptr)
	{
		Label = new WoflLabel(LabelText, true, true, 0, 0, SizeX, SizeY);
		AddChild(Label);
	}
	
	SetClickEnabled(true);
}

WoflButton::WoflButton(const char* BackgroundImage, const char* LabelText, float X, float Y, float SizeX, float SizeY, int Tag, const function<void(WoflButton*)>& OnClick)
	: WoflButton(BackgroundImage, LabelText, X, Y, SizeX, SizeY, Tag, SpriteCaptureType::SingleClick)
{
	OnClickFunc = OnClick;
}

WoflButton::WoflButton(const char* BackgroundImage, const char* LabelText, float X, float Y, float SizeX, float SizeY, int Tag, SpriteCaptureType CaptureType, const function<void(WoflButton*, const Vector&, int)>& OnInput)
	: WoflButton(BackgroundImage, LabelText, X, Y, SizeX, SizeY, Tag, CaptureType)
{
	OnInputFunc = OnInput;
}

void WoflButton::OnClick()
{
	if (OnClickFunc)
	{
		OnClickFunc(this);
	}
}

void WoflButton::OnInput(const Vector& ScreenLocation, int RepeatCount)
{
	if (OnInputFunc)
	{
		OnInputFunc(this, ScreenLocation, RepeatCount);
	}
}
