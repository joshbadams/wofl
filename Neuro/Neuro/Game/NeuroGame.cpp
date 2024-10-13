//
//  NeuroGame.cpp
//  Neuro
//
//  Created by Josh Adams on 4/9/23.
//

#include "NeuroGame.h"
#include "Textbox.h"
#include "Ninebox.h"
#include "Gridbox.h"
#include "Boxes\InvBox.h"
#include "Boxes\SiteBox.h"
#include "NeuroConfig.h"
#include "NeuroScene.h"

WoflGame* GlobalGameInitialization()
{
	return new NeuroGame();
}

NeuroGame::NeuroGame()
	: WoflGame("Neuromancer")
	, State(&Config, this)
{
	WLOG("View size is: %f, %f\n", WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y);
		
	WoflAtlases::LoadAtlas("Neuro1");
	
	Background = new WoflSprite(0, 0, WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y);
	Background->AddImage(new WoflImage("background"));
	
	ScreenSprite = new NeuroScene(&State, 32, 32, 1213, 447);
	
	MessageBox = new Textbox(nullptr, 693, 539, 556, 230, 0, true, false, WColor::Black);
	MessageBox->SetInterfaceDelegate(&State);
	
	Background->AddChild(ScreenSprite);
	Background->AddChild(MessageBox);
	
	DialogBox = new Ninebox(Ninebox::Basic, 0, 0, ScreenSprite->GetSize().X, 150, Tag_Dialog);
	
	Inventory = new InvBox(150, 480, 500, 280);
	Inventory->SetDelegates(&State, &State);
	
//	PAX = new PAXBox(100, 40, 1000, 424);
//	PAX->SetDelegates(&State, &State);
	
	WebSite = new SiteBox(100, 40, 1000, 600);
	WebSite->SetDelegates(&State, &State);
	
	int Top = 580;
	int Left = 58;
	int Size = 94;
	WoflButton* InvButton    = new WoflButton(nullptr, "", Left + 0 * Size, Top + 0 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickInventory(); });
	Background->AddChild(InvButton);
	InvButton->SetCharShortcut('i');

	WoflButton* PAXButton    = new WoflButton(nullptr, "", Left + 1 * Size, Top + 0 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickPAX(); });
	Background->AddChild(PAXButton);
	PAXButton->SetCharShortcut('p');

	WoflButton* TalkButton   = new WoflButton(nullptr, "", Left + 2 * Size, Top + 0 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickTalk(); });
	Background->AddChild(TalkButton);
	TalkButton->SetCharShortcut('t');

	WoflButton* SkillButton  = new WoflButton(nullptr, "", Left + 0 * Size, Top + 1 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickSkill(); });
	Background->AddChild(SkillButton);
	SkillButton->SetCharShortcut('s');

	WoflButton* ChipButton   = new WoflButton(nullptr, "", Left + 1 * Size, Top + 1 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickChip(); });
	Background->AddChild(ChipButton);
	ChipButton->SetCharShortcut('c');

	WoflButton* SystemButton = new WoflButton(nullptr, "", Left + 2 * Size, Top + 1 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickSystem(); });
	Background->AddChild(SystemButton);
	SystemButton->SetCharShortcut(53);

	WoflWorld::Get()->SetRootSprite(Background);
}


void NeuroGame::Invalidate(ZoneType Zone)
{
	if ((Zone & ZoneType::Room) != ZoneType::None)
	{
		ScreenSprite->ClearImages();
		
		string BackgroundImage;
		State.CurrentRoom->LuaSystem->GetStringValue(State.CurrentRoom, "background", BackgroundImage);
		ScreenSprite->AddImage(new WoflImage(BackgroundImage.c_str()));
	}
	
	if ((Zone & ZoneType::Message) != ZoneType::None)
	{
		MessageBox->SetText(State.GetCurrentMessage());
	}
	
	if ((Zone & ZoneType::Dialog) != ZoneType::None)
	{
		DialogBox->RemoveFromParent();
		std::string Dialog = State.GetCurrentDialogLine();
		if (Dialog.length() > 0)
		{
			DialogBox->Text->SetText(Dialog);
			ScreenSprite->AddChild(DialogBox);
		}
	}
	
	if ((Zone & ZoneType::Inventory) != ZoneType::None)
	{
		Inventory->RemoveFromParent();
		if (State.IsShowingInventory())
		{
			Inventory->Open(State.GetTableValue("InvBox"));
			Background->AddChild(Inventory);
		}
	}

//	if ((Zone & ZoneType::PAX) != ZoneType::None)
//	{
//		PAX->RemoveFromParent();
//		if (State.IsShowingPAX())
//		{
//			PAX->Open();
//			Background->AddChild(PAX);
//		}
//	}

	if ((Zone & ZoneType::Site) != ZoneType::None)
	{
		WebSite->RemoveFromParent();
		if (State.IsShowingSite())
		{
			// need to lowercase to look up an object, there's no case insensitive object lookup :|
			LuaRef Site = State.GetTableValue(State.GetStringValue("currentsite"));
			WebSite->Open(Site);
			Background->AddChild(WebSite);
		}
	}
}
