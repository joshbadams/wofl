//
//  Textbox.cpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#include "Gridbox.h"
#include "Textbox.h"
#include "NeuroState.h" // replace with InterfaceDelegate.h or similar

const int Message_Exit = -1;
const int Message_More = -2;

enum KeyCodes
{
	Key_Enter = 36,
	Key_Delete = 51,
	Key_Escape = 53,
};

Gridbox::Gridbox(float X, float Y, float SizeX, float SizeY, int Tag, WColor Color)
	: Ninebox(Ninebox::Basic, X, Y, SizeX, SizeY, Tag, Color)
	, TextColor(Color)
	, TextEntryIndex(-1)
	, bNumericEntry(false)
	, bIgnoreUntilNextUp(false)
	, bIsShowingMessageList(false)
	, bIsShowingMessage(false)
{
	Vector ClientLocation;
	Vector ClientSize;
	GetClientGeometry(ClientLocation, ClientSize);

	GridsX = ClientSize.X / GRID_X;
	GridsY = ClientSize.Y / GRID_Y;
	SetClickEnabled(true);
	
	// skip one line
	Messagebox = new Textbox(nullptr, ClientLocation.X, ClientLocation.Y + GRID_Y, ClientSize.X, ClientSize.Y - (ClientLocation.Y + GRID_Y), 0, true, true, WColor::Black, GRID_Y);
	Messagebox->SetInterfaceDelegate(this);
}

void Gridbox::CustomPostChildrenRender()
{
	Vector ClientLocation;
	Vector ClientSize;
	GetClientGeometry(ClientLocation, ClientSize);

	Vector BaseLoc = GetPosition() + ClientLocation;
	
	for (GridEntry& Entry : Entries)
	{
		WoflRenderer::Renderer->DrawString(Entry.Text.c_str(), BaseLoc + Vector(Entry.X * GRID_X, Entry.Y * GRID_Y), 1.0f, TextColor);
	}
}

void Gridbox::SetupTextEntry(int X, int Y, bool bIsNumeric, bool bIsMultiLine, string InitialText)
{
	bNumericEntry = bIsNumeric;
	bMultiLineEntry = bIsMultiLine;
	TextEntryIndex = (int)Entries.size();
	Entries.push_back({InitialText, X, Y});
}


void Gridbox::OnInput(const Vector& ScreenLocation, int RepeatIndex)
{
	Vector ClientLocation;
	Vector ClientSize;
	GetClientGeometry(ClientLocation, ClientSize);

	Vector GridLocation = ScreenLocation - (GetPosition() + ClientLocation);
	int X = GridLocation.X / GRID_X;
	int Y = GridLocation.Y / GRID_Y;

//	WLOG("Grid: %d, %d\n", X, Y);
	
	bool bWasHandled = false;
	for (GridEntry& Entry : Entries)
	{
		if (Entry.ClickId != 0 && Y == Entry.Y && X >= Entry.X && X < Entry.X + Entry.Text.length())
		{
			if (IsInMessagePhase())
			{
				OnClickMessageEntry(Entry);
			}
			else
			{
				OnClickEntry(Entry);
			}
			bWasHandled = true;
			break;
		}
	}
	
	// allow for full-widget click/space to continue type things
	if (!bWasHandled)
	{
		this->OnGenericContinueInput();
	}
}

bool Gridbox::OnKey(const KeyEvent& Event)
{
	if (bIgnoreUntilNextUp)
	{
		if (Event.Type == KeyType::Up)
		{
			bIgnoreUntilNextUp = false;
		}
		return true;
	}
	

	// we only want to handle char events and keydown of some special keycodes
	if (Event.Type == KeyType::Up)
	{
		return true;
	}
	if (Event.Char == 0 && Event.KeyCode != Key_Enter && Event.KeyCode != Key_Delete && Event.KeyCode != Key_Escape)
	{
		return true;
	}
	
	if (TextEntryIndex != -1)
	{
		if ((Event.Char >= '0' && Event.Char <= '9') || (!bNumericEntry && isprint(Event.Char)))
		{
			Entries[TextEntryIndex].Text += Event.Char;
		}
		// enter
		else if (Event.KeyCode == Key_Enter)
		{
			if (bMultiLineEntry)
			{
			
			}
			else
			{
				int Index = TextEntryIndex;
				TextEntryIndex = -1;
				OnTextEntryComplete(Entries[Index].Text);
				bIgnoreUntilNextUp = true;
			}
		}
		// delete
		else if (Event.KeyCode == Key_Delete)
		{
			if (Entries[TextEntryIndex].Text.length() > 0)
			{
				Entries[TextEntryIndex].Text = Entries[TextEntryIndex].Text.substr(0, Entries[TextEntryIndex].Text.size() - 1);
			}
		}
		// escape
		else if (Event.KeyCode == Key_Escape)
		{
			OnTextEntryCancelled();
			bIgnoreUntilNextUp = true;
			TextEntryIndex = -1;
		}
	}
	else if (Event.Type == KeyType::Down)
	{
		if (Event.Char != 0)
		{
			for (GridEntry& Entry : Entries)
			{
				if (Entry.Key == tolower(Event.Char))
				{
					if (IsInMessagePhase())
					{
						OnClickMessageEntry(Entry);
					}
					else
					{
						OnClickEntry(Entry);
					}
					bIgnoreUntilNextUp = true;
					return true;
				}
			}
		}
	}
	
	if (Event.Type == KeyType::Down && (Event.KeyCode == Key_Enter || Event.Char == ' ' || Event.KeyCode == Key_Escape))
	{
		OnGenericContinueInput();
	}

	return true;
}


void Gridbox::SetupMessages(string MessageSourceID, string Title)
{
	CurrentMessages = QueryStateDelegate->GetUnlockedMessages(MessageSourceID);
	MessagesTitle = Title;
	
	FirstMessage = 0;
	NumMessagesPerPage = GridsY - 6;
	bIsShowingMessageList = true;
	bIsShowingMessage = false;

	UpdateMessages();
}

void Gridbox::MessageComplete()
{
	bIsShowingMessageList = true;
	bIsShowingMessage = false;
	UpdateMessages();
}

void Gridbox::UpdateMessages()
{
	Entries.clear();
	Messagebox->RemoveFromParent();
	
	if (bIsShowingMessageList)
	{
		Entries.push_back({MessagesTitle, 0, 0});
		Entries.push_back({"date", 7, 2});
		Entries.push_back({"to", 12, 2});
		Entries.push_back({"from", 25, 2});

		char Line[50];
		for (int Index = FirstMessage; Index < FirstMessage + NumMessagesPerPage && Index < (int)CurrentMessages.size(); Index++)
		{
			int LineNumber = Index - FirstMessage;
			Message* Item = CurrentMessages[Index];
			int Month = Item->Date / 10000;
			int Day = (Item->Date / 100) % 100;
			int Year = Item->Date % 100;
			snprintf(Line, 50, "%d. %02d/%02d/%02d %-12s %s", LineNumber + 1, Month, Day, Year, Item->To.c_str(), Item->From.c_str());
			Entries.push_back({Line, 0, LineNumber + 4, Index + 1, (char)('1' + LineNumber)});
		}

		Entries.push_back({"exit", 13, GridsY - 1, Message_Exit, 'x'});
		if (CurrentMessages.size() > NumMessagesPerPage)
		{
			Entries.push_back({"more", 18, GridsY - 1, Message_More, 'm'});
		}
	}
	else if (bIsShowingMessage)
	{
		stringstream Temp;
		Temp << "TO: " << ChosenMessage->To << "\nFROM: " << ChosenMessage->From << "\n" << ChosenMessage->Message;
		Messagebox->SetText(Temp.str());
		AddChild(Messagebox);
	}
}

void Gridbox::OnClickMessageEntry(GridEntry& Entry)
{
	if (Entry.ClickId > 0)
	{
		ChosenMessage = CurrentMessages[Entry.ClickId - 1];
		
		bIsShowingMessage = true;
		bIsShowingMessageList = false;
		UpdateMessages();
	}
	else if (Entry.ClickId == Message_More)
	{
		FirstMessage += NumMessagesPerPage;
		if (FirstMessage >= (int)CurrentMessages.size())
		{
			FirstMessage = 0;
		}
		
		UpdateMessages();
	}
	else if (Entry.ClickId == Message_Exit)
	{
		bIsShowingMessage = false;
		bIsShowingMessageList = false;

		CloseMessages();
	}
	

//	case Board_Exit:
//		Phase = Phase_Menu;
//		Update();
//		break;
//	case Board_ViewMessages:
//		SubPhase = BoardPhase_ViewMessages;
//		Update();
//		break;
//	case Board_More:
//		FirstItem += NumItemsPerPage;
//		if (FirstItem >= (int)CurrentBoardItems.size())
//		{
//			FirstItem = 0;
//		}
//		Update();
//		break;
//	case Board_SendMessage:
//		SubPhase = BoardPhase_SendMessageTo;
//		Update();
//		break;
//
//	}
}