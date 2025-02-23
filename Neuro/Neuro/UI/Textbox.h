//
//  Textbox.hpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#pragma once

#include <Wofl/Wofl.h>
#include <vector>

#define DEFUALT_LINE_HEIGHT 30

extern std::vector<std::string> SplitLines(const std::string& FullText, int Width);

class Textbox : public WoflSprite
{
public:
	
	Textbox(const char* BackgroundImage, float X, float Y, float SizeX, float SizeY, int Tag, bool bClickToAdvance, bool bClickToEnd, WColor Color=WColor::White, int InLineHeight=DEFUALT_LINE_HEIGHT);

	void SetInterfaceDelegate(class IInterfaceChangingStateDelegate* Delegate)
	{
		InterfaceDelegate = Delegate;
	}
	
	void SetText(const std::string& InText, bool bNeedsPauseAtEnd=false);
	
	bool NeedsShowMore();

	virtual void CustomRender() override;
	virtual void OnClick() override;
	virtual bool OnKey(const KeyEvent& Event) override;
	
	virtual std::string Describe() override { return std::string("Textbox: ") + FullText; }


protected:

	IInterfaceChangingStateDelegate* InterfaceDelegate;
	
	std::string FullText;
	std::vector<std::string> Lines;
	int FirstLine;
	int NumLinesToRender;
	bool bPauseOnLastPage;
	WColor TextColor;
	
	void UpdateLines();
	
	
	
	int LineHeight;
};
