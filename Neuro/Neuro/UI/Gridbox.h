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
	string Text;
	int X, Y;
	int ClickId = -1;
	char Key=0;
	bool bWrapText=false;
	
//	GridEntry(string& InText)
//	{
//		
//	}
};

class Gridbox : public Ninebox, public ITextboxDelegate
{
public:
	
	Gridbox(float X, float Y, float SizeX, float SizeY, int Tag, WColor Color=WColor::Black);

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

	virtual void OnGenericContinueInput() { }
	virtual void OnClickEntry(GridEntry& Entry) { }
	virtual void OnTextEntryComplete(const string& Text) { }
	virtual void OnTextEntryCancelled() { }


	void SetupTextEntry(int X, int Y, bool bIsNumeric, bool bIsMultiLine, string InitialText="");
	
	void SetupMessages(string MessageSourceID, string Title);
	bool IsInMessagePhase() { return bIsShowingMessageList || bIsShowingMessage; }
	
	void OnClickMessageEntry(GridEntry& Entry);
	void UpdateMessages();
	
	virtual void CloseMessages() {}

	IQueryStateDelegate* QueryStateDelegate;
	IInterfaceChangingStateDelegate* InterfaceChangingDelegate;
	
	vector<GridEntry> Entries;
	Textbox* Messagebox;
	
	string FullText;
	vector<string> Lines;
	WColor TextColor;
	
	int GridsX, GridsY;
	
	int TextEntryIndex;
	bool bNumericEntry;
	bool bMultiLineEntry;
	bool bIgnoreUntilNextUp;

private:
	
	// list of unlocked messages from the active message source
	vector<class Message*> CurrentMessages;
	class Message* ChosenMessage;
	string MessagesTitle;
	bool bIsShowingMessageList;
	bool bIsShowingMessage;
	int FirstMessage;
	int NumMessagesPerPage;
};

