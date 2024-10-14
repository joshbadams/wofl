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
	int ClickId = -1;
	char Key=0;
	bool bWrapText=false;
	
	std::string EntryTag;
	bool bNumericEntry;
	bool bMultilineEntry;

	void FromLua(LuaRef Ref);
	LuaRef LuaEntry;
};

class Gridbox : public Ninebox, public ITextboxDelegate
{
public:
	
	Gridbox();
	Gridbox(float X, float Y, float SizeX, float SizeY, int Tag, WColor Color=WColor::Black);

	void Open(LuaRef Box);
	void RefreshUI();
	bool MatchesLuaBox(LuaRef Box);

	void SetDelegates(class IQueryStateDelegate* InQueryStateDelegate, class IInterfaceChangingStateDelegate* InInterfaceChangingDelegate)
	{
		QueryStateDelegate = InQueryStateDelegate;
		InterfaceChangingDelegate = InInterfaceChangingDelegate;
	}

	virtual void CustomPostChildrenRender() override;
	virtual void OnInput(const Vector& ScreenLocation, int RepeatIndex) override;
	virtual bool OnKey(const KeyEvent& Event) override;
	
	virtual void MessageComplete() override;

protected:
	void Init();

	virtual void OnGenericContinueInput();
	virtual void OnTextEntryComplete(const std::string& Text, const std::string& Tag);
	virtual void OnTextEntryCancelled(const std::string& Tag);
	virtual void Update();
	virtual void OnClickEntry(GridEntry& Entry);


	void SetupTextEntry(const GridEntry& Entry);
	
	void SetupMessages(std::string MessageSourceID, std::string Title);
	bool IsInMessagePhase() { return bIsShowingMessageList || bIsShowingMessage; }
	
	void OnClickMessageEntry(GridEntry& Entry);


	virtual void CloseMessages() {}

	IQueryStateDelegate* QueryStateDelegate;
	IInterfaceChangingStateDelegate* InterfaceChangingDelegate;
		
	LuaRef LuaBox;
	
	vector<GridEntry> Entries;
	Textbox* Messagebox = nullptr;
	
	std::string FullText;
	std::vector<std::string> Lines;
	WColor TextColor;
	
	int GridsX, GridsY;
	
	int TextEntryIndex;
	bool bIgnoreUntilNextUp;

private:
	
	// list of unlocked messages from the active message source
	std::vector<class Message*> CurrentMessages;
	class Message* ChosenMessage;
	std::string MessagesTitle;
	bool bIsShowingMessageList;
	bool bIsShowingMessage;
	int FirstMessage;
	int NumMessagesPerPage;
};

