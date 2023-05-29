//
//  Textbox.hpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#ifndef Textbox_hpp
#define Textbox_hpp

#include <Wofl/Wofl.h>

#define DEFUALT_LINE_HEIGHT 30


class Textbox : public WoflSprite
{
public:
	
	Textbox(const char* BackgroundImage, float X, float Y, float SizeX, float SizeY, int Tag, bool bClickToAdvance, bool bClickToEnd, WColor Color=WColor::White, int InLineHeight=DEFUALT_LINE_HEIGHT);

	void SetInterfaceDelegate(class IInterfaceChangingStateDelegate* Delegate)
	{
		InterfaceDelegate = Delegate;
	}
	
	void SetText(const string& InText);
	
	
	virtual void CustomRender() override;
	virtual void OnClick() override;

protected:

	IInterfaceChangingStateDelegate* InterfaceDelegate;
	
	string FullText;
	vector<string> Lines;
	int FirstLine;
	int NumLinesToRender;
	bool bPauseOnLastPage;
	WColor TextColor;
	
	bool NeedsMore();
	void UpdateLines();
	
	
	
	int LineHeight;
};

#endif /* Textbox_hpp */
