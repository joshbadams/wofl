//
//  Textbox.cpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#include "SiteBox.h"
#include "Textbox.h"
#include "NeuroState.h" // replace with InterfaceDelegate.h or similar
#include "NeuroGame.h"

//// -- COMMANDS --
//enum Commands
//{
//	PAX_Exit = 1,
//	PAX_First,
//	PAX_Bank,
//	PAX_News,
//	PAX_Board,
//
//	Bank_Exit,
//	Bank_Download,
//	Bank_Upload,
//	Bank_Record,
//
//	News_FirstItem,
//	News_LastItem = News_FirstItem + 10,
//	News_Exit,
//	News_More,
//
//	Board_FirstItem,
//	Board_LastItem = Board_FirstItem + 10,
//	Board_Exit,
//	Board_More,
//	Board_ViewMessages,
//	Board_SendMessage,
//};
//
// -- PHASES --
enum Phases
{
	Phase_Title,
	Phase_Password,
	Phase_PasswordError,
	Phase_Pages,
	Phase_ListDetails,

//	Phase_Menu,
//	Phase_FirstTime,
//	Phase_Bank,
//	Phase_News,
//	Phase_Board,
//
//	BankPhase_Menu,
//	BankPhase_Upload,
//	BankPhase_Download,
//	BankPhase_Record,
//
//	NewsPhase_List,
//	NewsPhase_Message,
//
//	BoardPhase_Menu,
//	BoardPhase_ViewMessages,
//	BoardPhase_Message,
//	BoardPhase_SendMessageTo,
//	BoardPhase_SendMessageBody,
};


SiteBox::SiteBox(float X, float Y, float SizeX, float SizeY)
	: Gridbox(X, Y, SizeX, SizeY, 0, WColor::Black)
{

}

void SiteBox::MessageComplete()
{
	if (Phase == Phase_Pages)
	{
		if (CurrentPage->Type == "message")
		{
			CurrentPage = CurrentSite->Pages[CurrentPage->ExitDest];
			Update();
		}
	}
}

void SiteBox::OnTextEntryComplete(const string& Text)
{
	if (Phase == Phase_Password)
	{
		// check password
		Phase = Phase_Pages;
		CurrentPage = CurrentSite->Pages["initial"];
	}
	
	Update();
}

void SiteBox::OnTextEntryCancelled()
{
	Update();
}

void SiteBox::CloseMessages()
{
	CurrentPage = CurrentSite->Pages[CurrentPage->ExitDest];
	Update();
}

void SiteBox::OnClickEntry(GridEntry& Entry)
{
	if (Phase == Phase_Pages)
	{
		if (CurrentPage->Type == "menu")
		{
			MenuEntry* MenuItem = CurrentPage->MenuEntries[Entry.ClickId - 1];
			if (MenuItem->Dest == "exit")
			{
				InterfaceChangingDelegate->GridboxClosed();
			}
			else
			{
				CurrentPage = CurrentSite->Pages[MenuItem->Dest];
				Update();
			}
		}
		else if (CurrentPage->Type == "list")
		{
			ActiveListEntry = Entry.ClickId;
			Phase = Phase_ListDetails;
			Update();
		}
	}
}

void SiteBox::OnGenericContinueInput()
{
	if (Phase == Phase_Title)
	{
		Phase = Phase_Password;
		Update();
	}
	else if (Phase == Phase_PasswordError)
	{
		InterfaceChangingDelegate->GridboxClosed();
	}
	else if (Phase == Phase_ListDetails)
	{
		Phase = Phase_Pages;
		Update();
	}
}


void SiteBox::Open(Site* OpenedSite)
{
	Phase = Phase_Title;
	CurrentSite = OpenedSite;
	CurrentPage = nullptr;
	
	Update();
}

void SiteBox::Update()
{
	Entries.clear();
	Messagebox->RemoveFromParent();
	Entries.push_back({CurrentSite->Title, (GridsX - (int)CurrentSite->Title.length()) / 2, 0});

	if (Phase == Phase_Title)
	{
		string Footer = "Click or [space] to continue";
		Entries.push_back({Footer, (GridsX - (int)Footer.length()) / 2, GridsY - 1});
	}
	else if (Phase == Phase_Password)
	{
		string Prompt = "Enter password:";
		Entries.push_back({Prompt, (GridsX - (int)Prompt.length()) / 2, 3});
		SetupTextEntry(Entries[0].X, 5, false, false);
	}
	else if (Phase == Phase_Pages)
	{
		if (CurrentPage->Type == "menu")
		{
			char EntryText[50];
			int EntryIndex = 0;
			for (MenuEntry* Entry : CurrentPage->MenuEntries)
			{
				snprintf(EntryText, 50, "%c. %s", Entry->Key, Entry->Name.c_str());
				Entries.push_back({EntryText, 10, 5 + EntryIndex, EntryIndex + 1, Entry->Key});
				EntryIndex++;
			}
		}
		else if (CurrentPage->Type == "messages")
		{
			SetupMessages(CurrentPage->MessagesID, CurrentSite->Title);
		}
		else if (CurrentPage->Type == "message")
		{
			const NeuroConfig& Config = ((NeuroGame*)WoflGame::TheGame)->GetConfig();
			Messagebox->SetText(Config.Strings.at(CurrentPage->StringID));
			AddChild(Messagebox);
		}
		else if (CurrentPage->Type == "list")
		{
			Entries.push_back({CurrentPage->Header, (GridsX - (int)CurrentPage->Header.length()) / 2, 2});

			char EntryText[50];
			int Column2Widths[] = { (GridsX - 2) * 2 / 3 };
			int Column3Widths[] = { (GridsX - 2) / 2, GridsX * 3 / 4 };
			if (CurrentPage->ListColumns.size() == 2)
			{
				snprintf(EntryText, 50, "   %-*s %s", Column2Widths[0], CurrentPage->ListColumns[0].c_str(), CurrentPage->ListColumns[1].c_str());
				Entries.push_back({EntryText, 0, 3});
				for (int EntryIndex = 0; EntryIndex < (int)CurrentPage->ListEntries.size(); EntryIndex++)
				{
					ListEntry* Entry = CurrentPage->ListEntries[EntryIndex];
					snprintf(EntryText, 50, "%d. %-*s %s", EntryIndex + 1, Column2Widths[0], Entry->Fields[0].c_str(), Entry->Fields[1].c_str());
					Entries.push_back({EntryText, 0, 4 + EntryIndex, EntryIndex + 1, (char)('1' + EntryIndex)});
				}
			}
		}
	}
	else if (Phase == Phase_ListDetails)
	{
		ListEntry* Entry = CurrentPage->ListEntries[ActiveListEntry];
		
		char EntryText[50];
		for (int ColumnIndex = 0; ColumnIndex < (int)CurrentPage->ListColumns.size(); ColumnIndex++)
		{
			snprintf(EntryText, 50, "%s: %s", CurrentPage->ListColumns[ColumnIndex].c_str(), Entry->Fields[ColumnIndex].c_str());
			Entries.push_back({EntryText, 0, 4 + ColumnIndex});
		}
		if (Entry->Details.length() > 0)
		{
			Entries.push_back({Entry->Details, 0, 4 + (int)CurrentPage->ListColumns.size()});
		}
	}
}
