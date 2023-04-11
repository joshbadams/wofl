//
//  Textbox.cpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#include "Textbox.h"


Textbox::Textbox(const char* BackgroundImage, float X, float Y, float SizeX, float SizeY, int Tag, bool bClickToAdvance, WColor Color, int InLineHeight)
	: WoflSprite(X, Y, SizeX, SizeY)
	, FirstLine(0)
	, LineHeight(InLineHeight)
	, TextColor(Color)
{
	if (BackgroundImage != nullptr)
	{
		AddImage(new WoflImage(BackgroundImage, 0, 0, 1, 1));
	}
	
	if (bClickToAdvance)
	{
		SetClickEnabled(true);
	}
	
	TextColor = Color;
}

void Textbox::SetText(const string& InText)
{
	FullText = InText;
	UpdateLines();
	FirstLine = 0;
	NumLinesToRender = GetSize().Y / LineHeight;
}

void Textbox::UpdateLines()
{
	int Travel = 0;
	int LineStart = 0;
	Lines.clear();
	
	while (true)
	{
		int SpaceIndex = (int)FullText.find(' ', Travel);
		if (SpaceIndex == string::npos)
		{
			// push remainder into vector
			Lines.push_back(FullText.substr(LineStart));
			break;
		}
		
		// check if we are going over the
		Vector StrSize = WoflRenderer::Renderer->GetStringSize(FullText.substr(LineStart, SpaceIndex - LineStart).c_str());
		if (StrSize.X > GetSize().X)
		{
			Lines.push_back(FullText.substr(LineStart, Travel - LineStart));
			LineStart = Travel;
		}
		else
		{
			Travel = SpaceIndex + 1;
		}
	}
}

bool Textbox::CustomRender()
{
	Vector RenderPos = GetPosition();
	for (int Line = FirstLine; Line < FirstLine + NumLinesToRender && Line < Lines.size(); Line++)
	{
		
		WoflRenderer::Renderer->DrawString(Lines[Line].c_str(), RenderPos, 1.0f, TextColor);
		RenderPos.Y += LineHeight;
	}

	return true;
}

void Textbox::OnClick()
{
	FirstLine = std::min(FirstLine + NumLinesToRender, (int)Lines.size() - NumLinesToRender);
}
