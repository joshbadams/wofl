//
//  Textbox.hpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#pragma once

#include <Wofl/Wofl.h>
#include "Ninebox.h"
#include "NeuroState.h"

const int GRID_X = 18;
const int GRID_Y = 35;

struct GridEntry
{
	std::string Text;
	int X, Y;
	int WrapWidth;
	int ClickId = -1;
	WoflKeys Key = WoflKeys::None;
	bool bWrapText=false;
	bool bFlash = false;
	
	std::string EntryTag;
	bool bNumericEntry;
	bool bMultilineEntry;

	LuaRef OnClick;
	LuaRef OnClickEntry;

	void FromLua(LuaRef Ref);
	LuaRef LuaEntry;

};

class Gridbox : public Ninebox, public ITextboxDelegate
{
public:
	
	Gridbox();
	Gridbox(float X, float Y, float SizeX, float SizeY, int Tag, WColor Color=WColor::Black);
	Gridbox(int Tag, WColor Color=WColor::Black);

	void Open(LuaRef Box, const char* Tag, bool bOverlayDialog);
	void RefreshUI();
	bool MatchesLuaBox(LuaRef Box);

	void SetDelegates(class IQueryStateDelegate* InQueryStateDelegate, class IInterfaceChangingStateDelegate* InInterfaceChangingDelegate)
	{
		QueryStateDelegate = InQueryStateDelegate;
		InterfaceChangingDelegate = InInterfaceChangingDelegate;
	}
	
	void Reorder(int Mode);

	virtual void CustomPostChildrenRender() override;
	virtual void OnInput(const Vector& ScreenLocation, int RepeatIndex) override;
	virtual bool OnKey(const KeyEvent& Event) override;
	
	virtual void MessageComplete() override;
	
	virtual void Tick(float DeltaTime) override;

	virtual std::string Describe() override
	{
		return std::string("Gridbox");
	}

protected:
	void Init(const char* Tag);

	virtual void OnGenericContinueInput();
	virtual void OnTextEntryComplete(const std::string& Text, const std::string& Tag);
	virtual void OnTextEntryCancelled(const std::string& Tag);
	virtual void Update();
	virtual void OnClickEntry(GridEntry& Entry);


	void SetupTextEntry(const GridEntry& Entry);
	
	void OnClickMessageEntry(GridEntry& Entry);


	virtual void CloseMessages() {}

	IQueryStateDelegate* QueryStateDelegate;
	IInterfaceChangingStateDelegate* InterfaceChangingDelegate;

	friend class NeuroGame;
	LuaRef LuaBox;
	
	vector<GridEntry> Entries;
	Textbox* Messagebox = nullptr;
	
	std::string FullText;
	std::vector<std::string> Lines;
	WColor TextColor;
	
	int GridsX, GridsY;
	
	int ActivatingClickId = 0;
	float ActivatingCountdown = 0;
	int TextEntryIndex;
	bool bIgnoreUntilNextUp;
};

