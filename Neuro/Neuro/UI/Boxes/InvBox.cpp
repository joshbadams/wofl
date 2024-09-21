//
//  Textbox.cpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#include "Invbox.h"
#include "NeuroState.h" // replace with InterfaceDelegate.h or similar
#include "NeuroGame.h"


const int Inv_Next = -1;
const int Inv_Exit = -2;
const int Inv_Use = -3;
const int Inv_Give = -4;
const int Inv_Discard = -5;
const int Inv_Back = -7;
const int Inv_Yes = -8;
const int Inv_No = -9;

enum Phase
{
	Phase_List,
	Phase_Action,
	Phase_Amount,
	Phase_Confirm,
	Phase_Login,
	Phase_LoginError,
};

InvBox::InvBox(float X, float Y, float SizeX, float SizeY)
	: Gridbox(X, Y, SizeX, SizeY, 0, WColor::Black)
{
	NumInvPerPage = GridsY - 2;
}

//void InvBox::OnTextEntryComplete(const string& Text, const string& Tag)
//{
//	if (Phase == Phase_Amount)
//	{
//		int Amount = stoi(Text);
//		if (Amount > QueryStateDelegate->GetMoney())
//		{
//			Update();
//			return;
//		}
//
//		InterfaceChangingDelegate->InventoryUsed(CurrentItem, InvAction::Give, Amount);
//	}
//	else if (Phase == Phase_Login)
//	{
//		int ComLinkVersion = 2;
//		// try to connect, and if it fails it will leave the dialog open
//		if (!InterfaceChangingDelegate->ConnectToSite(Text, ComLinkVersion))
//		{
//			Phase = Phase_LoginError;
//			Update();
//		}
//	}
//}
//
//void InvBox::OnTextEntryCancelled(const string& Tag)
//{
//	if (Phase == Phase_Amount)
//	{
//		Phase = Phase_Action;
//		Update();
//	}
//	else if (Phase == Phase_Login)
//	{
//		InterfaceChangingDelegate->GridboxClosed();
//	}
//}

//void InvBox::OnClickEntry(GridEntry& Entry)
//{
//	int InventoryIndex = Entry.ClickId < 0 ? CurrentItem : Entry.ClickId - 1;
//	
//	// exit
//	if (Entry.ClickId == Inv_Exit)
//	{
//		InterfaceChangingDelegate->InventoryUsed(0, InvAction::Cancel, 0);
//	}
//	// more
//	else if (Entry.ClickId == Inv_Next)
//	{
//		Page = (Page + 1) % NumPages;
//		Update();
//	}
//	else if (Entry.ClickId == Inv_Back)
//	{
////		Page = 0;
//		Phase = Phase_List;
//		Update();
//	}
//	else if (Entry.ClickId == Inv_Use)
//	{
//		NeuroConfig& Config = ((NeuroGame*)WoflGame::TheGame)->GetConfig();
//		Item* UsedItem = Config.Items[CurrentItem];
//		if (UsedItem->Type == "deck")
//		{
//			Phase = Phase_Login;
//			Update();
//		}
//		else
//		{
//			InterfaceChangingDelegate->InventoryUsed(InventoryIndex, InvAction::Use, 0);
//		}
//	}
//	else if (Entry.ClickId == Inv_Give)
//	{
//		if (InventoryIndex == 0)
//		{
//			Phase = Phase_Amount;
//			Update();
//		}
//		else
//		{
//			InterfaceChangingDelegate->InventoryUsed(InventoryIndex, InvAction::Give, 0);
//		}
//	}
//	else if (Entry.ClickId == Inv_Discard)
//	{
//		if (InventoryIndex == 0)
//		{
//			Phase = Phase_List;
//			Update();
//		}
//		else
//		{
//			Phase = Phase_Confirm;
//		}
//	}
//	else if (Entry.ClickId == Inv_Yes)
//	{
//		InterfaceChangingDelegate->InventoryUsed(InventoryIndex, InvAction::Discard, 0);
//	}
//	else if (Entry.ClickId == Inv_No)
//	{
//		Phase = Phase_List;
//		Update();
//	}
//	else
//	{
//		Phase = Phase_Action;
//		CurrentItem = InventoryIndex;
//		Update();
//	}
//}

void InvBox::OnGenericContinueInput()
{
	if (Phase == Phase_LoginError)
	{
		Phase = Phase_Login;
		Update();
	}
}




void InvBox::DescribeItem(int Prefix, int ItemID)
{
//	NeuroConfig& Config = ((NeuroGame*)WoflGame::TheGame)->GetConfig();
//
//	if (Prefix >= 0)
//	{
//		if (ItemID == 0)
//		{
//			snprintf(ItemDesc, 20, "%d.  Credits %d", Prefix, QueryStateDelegate->GetMoney());
//		}
//		else
//		{
//			snprintf(ItemDesc, 20, "%d.  %s", Prefix, Config.Items[ItemID]->Name.c_str());
//		}
//	}
//	else
//	{
//		if (ItemID == 0)
//		{
//			snprintf(ItemDesc, 20, "Credits %d", QueryStateDelegate->GetMoney());
//		}
//		else
//		{
//			snprintf(ItemDesc, 20, "%s", Config.Items[ItemID]->Name.c_str());
//		}
//	}
}




//void InvBox::Update()
//{
//	Entries.clear();
//
//	if (Phase == Phase_List)
//	{
//		Entries.push_back({"Items", GridsX / 2 - 3, 0});
//
//		int ItemIndex = Page * NumInvPerPage;
//		for (int Line = 0; Line < NumInvPerPage; Line++)
//		{
//			if (ItemIndex >= QueryStateDelegate->GetInventory().size())
//			{
//				break;
//			}
//			DescribeItem(Line + 1, QueryStateDelegate->GetInventory()[ItemIndex]);
//			Entries.push_back({ItemDesc, 0, Line + 1, ItemIndex + 1, (char)('0' + Line + 1)});
//			ItemIndex++;
//		}
//
//		Entries.push_back({"exit", 3, GridsY - 1, Inv_Exit, 'x'});
//		if (ItemIndex < QueryStateDelegate->GetInventory().size() - 1)
//		{
//			Entries.push_back({"next", 3, GridsY - 1, Inv_Exit, 'x'});
//		}
//	}
//	else if (Phase == Phase_Action)
//	{
//		DescribeItem(-1, CurrentItem);
//		Entries.push_back({ItemDesc, 0, 0});
//		Entries.push_back({"X. Exit", 0, 1, Inv_Back, 'x'});
//		Entries.push_back({"O. Operate Item", 0, 2, Inv_Use, 'o'});
//		Entries.push_back({"D. Discard Item", 0, 3, Inv_Discard, 'd'});
//		Entries.push_back({"G. Give Item", 0, 4, Inv_Give, 'g'});
//	}
//	else if (Phase == Phase_Amount)
//	{
//		DescribeItem(-1, CurrentItem);
//		Entries.push_back({ItemDesc, 0, 0});
//		Entries.push_back({"Give how much?", 0, 1});
//		Entries.push_back({"> ", 0, 2});
//		SetupTextEntry({"", 2, 2, -1, 0, false, "", true, false});
//	}
//	else if (Phase == Phase_Confirm)
//	{
//		Entries.push_back({"Discoard", GridsX / 2 - 3, 0});
//		DescribeItem(-1, CurrentItem);
//		Entries.push_back({ItemDesc, 0, 1});
//		Entries.push_back({"Are you sure (", 0, 3});
//		Entries.push_back({"Y", 14, 3, Inv_Yes, 'y'});
//		Entries.push_back({"/", 15, 3});
//		Entries.push_back({"N", 16, 3, Inv_No, 'n'});
//		Entries.push_back({")", 17, 3});
//
//	}
//	else if (Phase == Phase_Login)
//	{
//		Entries.push_back({"ComLink", GridsX / 2 - 3, 0});
//		Entries.push_back({"Enter link code:", 0, 1});
//		SetupTextEntry({"", 0, 2, -1, 0, false, "", false, false});
//	}
//	else if (Phase == Phase_LoginError)
//	{
//		Entries.push_back({"ComLink", GridsX / 2 - 3, 0});
//		Entries.push_back({"Unknown link code", 0, 1});
//	}
//}
