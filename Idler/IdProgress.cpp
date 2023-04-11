//
//  IdProgress.cpp
//  Idler
//
//  Created by Josh on 4/19/22.
//  Copyright © 2022 Josh. All rights reserved.
//

#include "IdProgress.h"
#include "WoflLabel.h"

IdProgress::IdProgress(int X, int Y, int Width, int Height, const char* LabelText, int BorderWidth, int Tag)
	: WoflSprite(X, Y, Width, Height, Tag)
	, ValueReference(nullptr)
{
	WoflImage* WhiteImage = new WoflImage("White", 0, 0, 1, 1);
	AddImage(WhiteImage);
	
	Background = new WoflSprite(BorderWidth, BorderWidth, Width - BorderWidth * 2, Height - BorderWidth * 2);
	Background->AddImage(WhiteImage);
	Background->SetColor(WColor(1, 0, 0, 1));

	Foreground = new WoflSprite(0, 0, Background->GetSize().X, Background->GetSize().Y);
	Foreground->AddImage(WhiteImage);
	Foreground->SetColor(WColor(0, 1, 0, 1));

	AddChild(Background);
	Background->AddChild(Foreground);
	
	Label = new WoflLabel(LabelText, false, true, BorderWidth, 0, Background->GetSize().X, Background->GetSize().Y);
	Background->AddChild(Label);
}

void IdProgress::SetValue(float Value)
{
	Foreground->SetSize(Vector(Background->GetSize().X * Value, Background->GetSize().Y));
}

void IdProgress::SetLabel(const char* LabelText)
{
	Label->SetText(LabelText);
}

bool IdProgress::CustomPreRender()
{
	// use this function to update value if a value ref is set
	if (ValueReference != nullptr)
	{
		SetValue(*ValueReference);
	}

	return false;
}

