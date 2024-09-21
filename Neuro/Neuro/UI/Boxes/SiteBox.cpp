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

void SiteBox::CloseMessages()
{
	Update();
}

void SiteBox::OnClickEntry(GridEntry& Entry)
{
	LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, "HandleClickedEntry", Entry.ClickId);
	Update();
}

void SiteBox::OnGenericContinueInput()
{
//	if (Phase == Phase_Title)
//	{
//		Phase = Phase_Password;
//		Update();
//	}
//	else if (Phase == Phase_PasswordError)
//	{
//		InterfaceChangingDelegate->GridboxClosed();
//	}
//	else if (Phase == Phase_ListDetails)
//	{
//		Phase = Phase_Pages;
//		Update();
//	}
}

