//
//  Textbox.cpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#include "PAXBox.h"
#include "Textbox.h"
#include "NeuroState.h" // replace with InterfaceDelegate.h or similar
#include "NeuroGame.h"

// -- COMMANDS --
enum Commands
{
	PAX_Exit = 1,
	PAX_First,
	PAX_Bank,
	PAX_News,
	PAX_Board,
	
	Bank_Exit,
	Bank_Download,
	Bank_Upload,
	Bank_Record,
	
	News_FirstItem,
	News_LastItem = News_FirstItem + 10,
	News_Exit,
	News_More,
	
	Board_Exit,
	Board_ViewMessages,
	Board_SendMessage,
};

// -- PHASES --
enum Phases
{
	Phase_Menu,
	Phase_FirstTime,
	Phase_Bank,
	Phase_News,
	Phase_Board,
	
	BankPhase_Menu,
	BankPhase_Upload,
	BankPhase_Download,
	BankPhase_Record,
	
	NewsPhase_List,
	NewsPhase_Message,
	
	BoardPhase_Menu,
	BoardPhase_Message,
	BoardPhase_SendMessageTo,
	BoardPhase_SendMessageBody,
};


PAXBox::PAXBox(float X, float Y, float SizeX, float SizeY)
	: Gridbox(X, Y, SizeX, SizeY, 0, WColor::Black)
{
}

void PAXBox::CloseMessages()
{
	SubPhase = BoardPhase_Menu;
	Update();
}

void PAXBox::MessageComplete()
{
	if (IsInMessagePhase())
	{
		Gridbox::MessageComplete();
		return;
	}
	
	if (Phase == Phase_FirstTime)
	{
		Phase = Phase_Menu;
	}
	else if (Phase == Phase_News)
	{
		SubPhase = NewsPhase_List;
	}
	Update();

}

void PAXBox::OnTextEntryComplete(const string& Text)
{
	if (Phase == Phase_Bank)
	{
		int AmountEntered = stoi(Text);
		
		if (SubPhase == BankPhase_Download)
		{
			if (AmountEntered <= CurrentBank)
			{
				CurrentMoney += AmountEntered;
				CurrentBank -= AmountEntered;
			}
		}
		else if (SubPhase == BankPhase_Upload)
		{
			if (AmountEntered <= CurrentMoney)
			{
				CurrentMoney -= AmountEntered;
				CurrentBank += AmountEntered;
			}
		}
		InterfaceChangingDelegate->SetIntVariable("money", CurrentMoney);
		InterfaceChangingDelegate->SetIntVariable("bankaccount", CurrentBank);
		
		SubPhase = BankPhase_Menu;
	}
	else if (Phase == Phase_Board)
	{
		if (SubPhase == BoardPhase_SendMessageTo)
		{
			MailTo = Text;
			SubPhase = BoardPhase_SendMessageBody;
		}
	}

	Update();
}

void PAXBox::OnTextEntryCancelled()
{
	if (Phase == Phase_Bank)
	{
		SubPhase = BankPhase_Menu;
	}
	else if (Phase == Phase_Board)
	{
		if (SubPhase == BoardPhase_SendMessageBody)
		{
			InterfaceChangingDelegate->SendMessage(MailTo, Entries[TextEntryIndex].Text);
			// Ssend message!!
		}
		SubPhase = BoardPhase_Menu;
	}

	Update();
}

void PAXBox::OnClickEntry(GridEntry& Entry)
{
	if (Entry.ClickId >= News_FirstItem && Entry.ClickId <= News_LastItem)
	{
		SubPhase = NewsPhase_Message;
		ChosenItem = FirstItem + Entry.ClickId - News_FirstItem;
		Update();
		return;
	}

	switch (Entry.ClickId)
	{
		case PAX_Exit:
			InterfaceChangingDelegate->GridboxClosed();
			break;
		case PAX_First:
			Phase = Phase_FirstTime;
			Update();
			break;
		case PAX_Bank:
			Phase = Phase_Bank;
			SubPhase = BankPhase_Menu;
			Update();
			break;
		case PAX_News:
			Phase = Phase_News;
			SubPhase = NewsPhase_List;
			Update();
			break;
		case PAX_Board:
			Phase = Phase_Board;
			SubPhase = BoardPhase_Menu;
			Update();
			break;
			
		case Bank_Exit:
			Phase = Phase_Menu;
			Update();
			break;
		case Bank_Upload:
			SubPhase = BankPhase_Upload;
			Update();
			break;
		case Bank_Download:
			SubPhase = BankPhase_Download;
			Update();
			break;
		case Bank_Record:
			SubPhase = BankPhase_Record;
			Update();
			break;
			
		case News_Exit:
			Phase = Phase_Menu;
			Update();
			break;
		case News_More:
			FirstItem += NumItemsPerPage;
			if (FirstItem >= (int)CurrentNewsItems.size())
			{
				FirstItem = 0;
			}
			Update();
			break;
		
		case Board_Exit:
			Phase = Phase_Menu;
			Update();
			break;
		case Board_ViewMessages:
			SubPhase = BoardPhase_Message;
			SetupMessages("board", "Bulletin Board");
			break;
		case Board_SendMessage:
			SubPhase = BoardPhase_SendMessageTo;
			Update();
			break;
	}
}

void PAXBox::Open()
{
	Page = 0;
	Phase = Phase_Menu;
	
	CurrentMoney = QueryStateDelegate->GetMoney();
	CurrentBank = QueryStateDelegate->GetIntVariable("bankaccount");
	
	NeuroConfig& Config = ((NeuroGame*)WoflGame::TheGame)->GetConfig();
	CurrentNewsItems.clear();
	for (int NewsIndex : QueryStateDelegate->GetUnlockedNewsItems())
	{
		CurrentNewsItems.push_back(Config.NewsItems[NewsIndex]);
	}
	FirstItem = 0;
	NumItemsPerPage = GridsY - 6;
	
	Update();
}
void PAXBox::Update()
{
	Entries.clear();
	Messagebox->RemoveFromParent();

	if (Phase == Phase_Menu)
	{
		Entries.push_back({"X. Exit System", 0, 0, PAX_Exit, 'x'});
		Entries.push_back({"1. First Time PAX User Info.", 0, 1, PAX_First, '1'});
		Entries.push_back({"2. Access Banking Interlink", 0, 2, PAX_Bank, '2'});
		Entries.push_back({"3. Night City News", 0, 3, PAX_News, '3'});
		Entries.push_back({"4. Bulletin Board", 0, 4, PAX_Board, '4'});
		Entries.push_back({"choose a function", 9, 8, PAX_Board, '4'});
	}
	else if (Phase == Phase_FirstTime)
	{
		Entries.push_back({"FIRST TIME USER INFORMATION", 0, 0});

		// set the message box to the fist time info
		NeuroConfig& Config = ((NeuroGame*)WoflGame::TheGame)->GetConfig();
		Messagebox->SetText(Config.Strings["paxfirsttime"]);
		AddChild(Messagebox);
	}
	else if (Phase == Phase_Bank)
	{
		char Temp[20];
		Entries.push_back({"First Orbital Bank of Switzerland", 3, 0});
		snprintf(Temp, 20, "name: %s", QueryStateDelegate->GetStringVariable("name").c_str());
		Entries.push_back({Temp, 3, 3});
		snprintf(Temp, 20, "chip = %d", QueryStateDelegate->GetMoney());
		Entries.push_back({Temp, 3, 4});
		snprintf(Temp, 20, "BAMA id = %s", QueryStateDelegate->GetStringVariable("bamaid").c_str());
		Entries.push_back({Temp, 24, 3});
		snprintf(Temp, 20, "account = %d", QueryStateDelegate->GetIntVariable("bankaccount"));
		Entries.push_back({Temp, 24, 4});
		if (SubPhase == BankPhase_Menu)
		{
			Entries.push_back({"X. Exit To Main", 0, 6, Bank_Exit, 'x'});
			Entries.push_back({"D. Download credits", 0, 7, Bank_Download, 'd'});
			Entries.push_back({"U. Upload credits", 0, 8, Bank_Upload, 'u'});
			Entries.push_back({"T. Transaction record", 0, 9, Bank_Record, 't'});
		}
		else if (SubPhase == BankPhase_Download || SubPhase == BankPhase_Upload)
		{
			Entries.push_back({"Enter amount : ", 0, 5});
			SetupTextEntry(15, 5, true, false);
		}
		else if (SubPhase == BankPhase_Record)
		{
			
		}
	}
	else if (Phase == Phase_News)
	{
		if (SubPhase == NewsPhase_List)
		{
			Entries.push_back({"Night City News", 7, 0});
			Entries.push_back({"date", 4, 2});
			Entries.push_back({"subject", 13, 2});

			char Line[50];
			for (int Index = FirstItem; Index < FirstItem + NumItemsPerPage && Index < (int)CurrentNewsItems.size(); Index++)
			{
				int LineNumber = Index - FirstItem;
				NewsItem* Item = CurrentNewsItems[Index];
				int Month = Item->Date / 10000;
				int Day = (Item->Date / 100) % 100;
				int Year = Item->Date % 100;
				snprintf(Line, 50, "%d. %02d/%02d/%02d %s", LineNumber + 1, Month, Day, Year, Item->Title.c_str());
				Entries.push_back({Line, 0, LineNumber + 4, News_FirstItem + LineNumber, (char)('1' + LineNumber)});
			}

			Entries.push_back({"exit", 13, GridsY - 1, News_Exit, 'x'});
			if (CurrentNewsItems.size() > NumItemsPerPage)
			{
				Entries.push_back({"more", 18, GridsY - 1, News_More, 'm'});
			}
		}
		else if (SubPhase == NewsPhase_Message)
		{
			NewsItem* Item = CurrentNewsItems[ChosenItem];

			Entries.push_back({Item->Title, 0, 0});
			Messagebox->SetText(Item->Message);
			AddChild(Messagebox);
		}
	}
	else if (Phase == Phase_Board)
	{
		if (SubPhase == BoardPhase_Menu)
		{
			Entries.push_back({"Bulletin Board", 0, 0});
			Entries.push_back({"X. Exit To Main", 0, 2, Board_Exit, 'x'});
			Entries.push_back({"V. View Messages", 0, 3, Board_ViewMessages, 'v'});
			Entries.push_back({"S. Send Message", 0, 4, Board_SendMessage, 's'});
		}
//		else if (SubPhase == BoardPhase_ViewMessages)
//		{
//			Entries.push_back({"Bulletin Board", 0, 0});
//			Entries.push_back({"date", 7, 2});
//			Entries.push_back({"to", 12, 2});
//			Entries.push_back({"from", 25, 2});
//
//			char Line[50];
//			for (int Index = FirstItem; Index < FirstItem + NumItemsPerPage && Index < (int)CurrentBoardItems.size(); Index++)
//			{
//				int LineNumber = Index - FirstItem;
//				BoardItem* Item = CurrentBoardItems[Index];
//				int Month = Item->Date / 10000;
//				int Day = (Item->Date / 100) % 100;
//				int Year = Item->Date % 100;
//				snprintf(Line, 50, "%d. %02d/%02d/%02d %-12s %s", LineNumber + 1, Month, Day, Year, Item->To.c_str(), Item->From.c_str());
//				Entries.push_back({Line, 0, LineNumber + 4, Board_FirstItem + LineNumber, (char)('1' + LineNumber)});
//			}
//
//			Entries.push_back({"exit", 13, GridsY - 1, Board_Exit, 'x'});
//			if (CurrentBoardItems.size() > NumItemsPerPage)
//			{
//				Entries.push_back({"more", 18, GridsY - 1, Board_More, 'm'});
//			}
//		}
//		else if (SubPhase == BoardPhase_Message)
//		{
//			BoardItem* Item = CurrentBoardItems[ChosenItem];
//
//			stringstream Temp;
//			Temp << "TO: " << Item->To << "\nFROM: " << Item->From << "\n" << Item->Message;
//			Newsbox->SetText(Temp.str());
//			AddChild(Newsbox);
//		}
		else if (SubPhase == BoardPhase_SendMessageTo)
		{
			Entries.push_back({"Send Message:", 6, 0});
			Entries.push_back({"date : %datestr%", 0, 4});
			Entries.push_back({"to : ", 0, 5});
			SetupTextEntry(5, 5, false, false);
		}
		else if (SubPhase == BoardPhase_SendMessageBody)
		{
			Entries.push_back({"Send Message:", 6, 0});
			Entries.push_back({"Press Esc to continue", 0, 2});
			Entries.push_back({"date : %datestr%", 0, 4});
			Entries.push_back({"to : ", 0, 5});
			Entries.push_back({MailTo, 5, 5});
			SetupTextEntry(0, 6, false, true);
		}
	}
}
