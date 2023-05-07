//
//  WoflLabel.hpp
//  Wofl
//
//  Created by Josh on 6/14/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#pragma once

#include WOFL_INC(Sprite)


class WoflLabel : public WoflSprite
{
public:
	WoflLabel(const char* InText, bool bCenteredHorizontal, bool bCenteredVertical, float X, float Y, float SizeX=0.0, float SizeY=0.0);

	virtual void CustomRender() override;

	void SetText(const char* InText)
	{
		Text = InText;
	}
	void SetText(const string& InText)
	{
		Text = InText;
	}
	void SetInt(int Int)
	{
		Text = std::to_string(Int);
	}
	void SetInt(uint64_t Int)
	{
		Text = std::to_string(Int);
	}
	
	void SetTextColor(const WColor& InColor)
	{
		TextColor = InColor;
	}
	
	virtual WoflLabel* AsLabel() override { return this; }

	
protected:
	string Text;
	bool bCenteredHorizontal;
	bool bCenteredVertical;
	WColor TextColor;
	
};
