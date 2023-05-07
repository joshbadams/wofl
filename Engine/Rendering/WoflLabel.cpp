//
//  WoflLabel.cpp
//  Wofl
//
//  Created by Josh on 6/14/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "WoflLabel.h"
#include "WoflRenderer.h"
#include <string>

WoflLabel::WoflLabel(const char* InText, bool bInCenteredHorizontal, bool bInCenteredVertical, float X, float Y, float SizeX, float SizeY)
	: WoflSprite(X, Y, SizeX, SizeY)
	, Text(InText)
	, bCenteredHorizontal(bInCenteredHorizontal)
	, bCenteredVertical(bInCenteredVertical)
	, TextColor(WColor::White)
{
}

void WoflLabel::CustomRender()
{
	if (Text == "")
	{
		return;
	}
	
	Vector RenderPos = GetPosition();
	
	// handle centering
	if (bCenteredHorizontal || bCenteredVertical)
	{
		Vector StrSize = WoflRenderer::Renderer->GetStringSize(Text.c_str());
		
		if (bCenteredHorizontal)
		{
			// start is half length left of center
			float HalfLength = StrSize.X / 2.0f;
			float Center = RenderPos.X + GetSize().X / 2.0f;
			
			RenderPos.X = Center - HalfLength;
		}

		if (bCenteredVertical)
		{
			float HalfHeight = StrSize.Y / 2.0f;
			float Center = RenderPos.Y + GetSize().Y / 2.0f;
			
			RenderPos.Y = Center - HalfHeight;
		}
	}
	
	WoflRenderer::Renderer->DrawString(Text.c_str(), RenderPos, 1.0f, TextColor);
}
