//
//  Textbox.cpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#include "Textbox.h"
#include "NeuroState.h" // replace with InterfaceDelegate.h or similar
#include "NeuroGame.h"


Textbox::Textbox(const char* BackgroundImage, float X, float Y, float SizeX, float SizeY, int Tag, bool bClickToAdvance, bool bClickToEnd, WColor Color, int InLineHeight)
	: WoflSprite(X, Y, SizeX, SizeY)
	, InterfaceDelegate(nullptr)
	, FirstLine(0)
	, LineHeight(InLineHeight)
	, bPauseOnLastPage(bClickToEnd)
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

void Textbox::SetText(const std::string& InText)
{
	if (InText == "")
	{
		return;
	}
		
	if (InText[0] == '@')
	{
		NeuroConfig& Config = ((NeuroGame*)WoflGame::TheGame)->GetConfig();
		FullText = Config.Strings[InText.substr(1)];
	}
	else
	{
		FullText = InText;
	}

	UpdateLines();
	if (this->bPauseOnLastPage)
	{
		Lines.push_back("[END]");
	}
	FirstLine = 0;
	NumLinesToRender = GetSize().Y / LineHeight;
	
	if (FullText != "" && InterfaceDelegate != nullptr && !NeedsMore() && !bPauseOnLastPage)
	{
		InterfaceDelegate->MessageComplete();
	}
}

bool Textbox::NeedsMore()
{
	return FirstLine + NumLinesToRender < Lines.size();
}

void Textbox::UpdateLines()
{
	int Travel = 0;
	int LineStart = 0;
	Lines.clear();
	
	while (true)
	{
		int NewlineIndex = (int)FullText.find('\n', Travel);
		if (NewlineIndex != std::string::npos)
		{
			Vector StrSize = WoflRenderer::Renderer->GetStringSize(FullText.substr(LineStart, NewlineIndex - LineStart).c_str());
			if (StrSize.X <= GetSize().X)
			{
				Lines.push_back(FullText.substr(LineStart, NewlineIndex - LineStart));
				Travel = LineStart = NewlineIndex + 1;
				continue;
			}
		}
				
		int SpaceIndex = (int)FullText.find(' ', Travel);
		bool bIsLastWord = false;
		if (SpaceIndex == std::string::npos)
		{
			SpaceIndex = (int)FullText.length() + 1;
			bIsLastWord = true;
		}
		else
		{
			while (FullText[SpaceIndex + 1] == ' ')
			{
				SpaceIndex++;
			}
		}
		
		// check if we are going over the
		Vector StrSize = WoflRenderer::Renderer->GetStringSize(FullText.substr(LineStart, SpaceIndex - LineStart).c_str());
		if (StrSize.X > GetSize().X)
		{
			Lines.push_back(FullText.substr(LineStart, Travel - LineStart));
			if (LineStart == Travel)
			{
				Travel = SpaceIndex + 1;
			}
			else
			{
				LineStart = Travel;
			}
		}
		else
		{
			Travel = SpaceIndex + 1;
		}
		
		if (bIsLastWord)
		{
			Lines.push_back(FullText.substr(LineStart));
			break;
		}
	}
}

void Textbox::CustomRender()
{
	if (FullText == "")
	{
		return;
	}
		
	int MessageLines = NumLinesToRender;
	if (NeedsMore())
	{
		MessageLines -= 1;
	}
	
	Vector RenderPos = GetPosition();
	for (int Line = FirstLine; Line < FirstLine + NumLinesToRender && Line < Lines.size(); Line++)
	{
		if (Lines[Line] != "")
		{
			WoflRenderer::Renderer->DrawString(Lines[Line].c_str(), RenderPos, 1.0f, TextColor);
		}
		RenderPos.Y += LineHeight;
	}
	if (NeedsMore())
	{
		WoflRenderer::Renderer->DrawString("[MORE]", RenderPos, 1.0f, TextColor);
	}
}

void Textbox::OnClick()
{
	if (bPauseOnLastPage && !NeedsMore())
	{
		InterfaceDelegate->MessageComplete();
		return;
	}
	
	if (NeedsMore())
	{
		FirstLine = std::min(FirstLine + NumLinesToRender - 1, (int)Lines.size() - NumLinesToRender);
		if (!NeedsMore() && InterfaceDelegate != nullptr && !bPauseOnLastPage)
		{
			InterfaceDelegate->MessageComplete();
		}
	}
}
