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
#include "NeuroScene.h"
#include <algorithm>

WoflGame* GlobalGameInitialization()
{
	return new NeuroGame();
}

NeuroGame::NeuroGame()
	: WoflGame("Neuromancer")
	, State(this)
{
	WLOG("View size is: %f, %f\n", WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y);
		
	WoflAtlases::LoadAtlas("Neuro1");
	//WoflAtlases::LoadAtlas("Neuro2");

	Background = new WoflSprite(0, 0, WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y);
	Background->AddImage(new WoflImage("background"));
	
	ScreenSprite = new NeuroScene(&State, 32, 32, 1213, 447);
	
	MessageBox = new Textbox(nullptr, 693, 539, 556, 230, 0, true, false, WColor::Black);
	MessageBox->SetInterfaceDelegate(&State);
	
	InfoBox = new Textbox(nullptr, 376, 600, 268, 36, 0, false, false, WColor::Black);
	
	
	Background->AddChild(ScreenSprite);
	Background->AddChild(MessageBox);
	Background->AddChild(InfoBox);
	
	DialogBox = new Ninebox(Ninebox::Basic, 0, 0, ScreenSprite->GetSize().X, 150, Tag_Dialog);
	
	int Top = 580;
	int Left = 58;
	int Size = 94;
	WoflButton* InvButton    = new WoflButton(nullptr, "", Left + 0 * Size, Top + 0 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickInventory(); });
	Background->AddChild(InvButton);
	InvButton->SetKeycodeShortcut(WoflKeys::I);

	WoflButton* PAXButton    = new WoflButton(nullptr, "", Left + 1 * Size, Top + 0 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickPAX(); });
	Background->AddChild(PAXButton);
	PAXButton->SetKeycodeShortcut(WoflKeys::P);

	WoflButton* TalkButton   = new WoflButton(nullptr, "", Left + 2 * Size, Top + 0 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickTalk(); });
	Background->AddChild(TalkButton);
	TalkButton->SetKeycodeShortcut(WoflKeys::T);

	WoflButton* SkillButton  = new WoflButton(nullptr, "", Left + 0 * Size, Top + 1 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickSkill(); });
	Background->AddChild(SkillButton);
	SkillButton->SetKeycodeShortcut(WoflKeys::S);

	WoflButton* ChipButton   = new WoflButton(nullptr, "", Left + 1 * Size, Top + 1 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickChip(); });
	Background->AddChild(ChipButton);
	ChipButton->SetKeycodeShortcut(WoflKeys::C);

	WoflButton* SystemButton = new WoflButton(nullptr, "", Left + 2 * Size, Top + 1 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickSystem(); });
	Background->AddChild(SystemButton);
	SystemButton->SetKeycodeShortcut(WoflKeys::Escape);
	
	Top = 672;
	Left = 446;
	int SizeX = 66;
	int SizeY = 46;
	WoflButton* DateButton = new WoflButton(nullptr, "", Left + 0 * SizeX, Top + 0 * SizeY, SizeX, SizeY, 0, [this](WoflButton*) { State.ClickDate(); });
	Background->AddChild(DateButton);
	DateButton->SetKeycodeShortcut(WoflKeys::One);
	
	WoflButton* TimeButton = new WoflButton(nullptr, "", Left + 1 * SizeX, Top + 0 * SizeY, SizeX, SizeY, 0, [this](WoflButton*) { State.ClickTime(); });
	Background->AddChild(TimeButton);
	TimeButton->SetKeycodeShortcut(WoflKeys::Two);
	
	WoflButton* MoneyButton = new WoflButton(nullptr, "", Left + 0 * SizeX, Top + 1 * SizeY, SizeX, SizeY, 0, [this](WoflButton*) { State.ClickMoney(); });
	Background->AddChild(MoneyButton);
	MoneyButton->SetKeycodeShortcut(WoflKeys::Three);
	
	WoflButton* HealthButton = new WoflButton(nullptr, "", Left + 1 * SizeX, Top + 1 * SizeY, SizeX, SizeY, 0, [this](WoflButton*) { State.ClickHealth(); });
	Background->AddChild(HealthButton);
	HealthButton->SetKeycodeShortcut(WoflKeys::Four);

	WoflWorld::Get()->SetRootSprite(Background);
}

void NeuroGame::OpenBoxByName(const char* Name)
{
	LuaRef NewBox;
	State.Lua.GetTableValue("", Name, NewBox);
	
	Gridbox* Box;
	if (BoxCache.size() > 0)
	{
		Box = BoxCache.back();
		BoxCache.pop_back();
	}
	else
	{
		Box = new Gridbox();
		Box->SetDelegates(&State, &State);
	}

	Box->Open(NewBox);
	
	Boxes.push_back(Box);
	Background->AddChild(Box);
}

bool NeuroGame::CloseBoxWithObj(LuaRef BoxObj)
{
	vector<Gridbox*>::iterator FoundPos = std::find_if(Boxes.begin(), Boxes.end(), [BoxObj](Gridbox* B) { return B->MatchesLuaBox(BoxObj); });
	if (FoundPos != Boxes.end())
	{
		(*FoundPos)->RemoveFromParent();
		BoxCache.push_back(*FoundPos);
		Boxes.erase(FoundPos);
	}
	
	return Boxes.size() == 0;
}

bool NeuroGame::AreBoxesShowing()
{
	return Boxes.size() > 0;
}

bool NeuroGame::IsConversationShowing()
{
	return DialogBox->GetParent() != nullptr;
}

bool NeuroGame::IsMessageActive()
{
	return MessageBox->NeedsShowMore();
}

void NeuroGame::RefreshUI()
{
	for (Gridbox* Box : Boxes)
	{
		Box->RefreshUI();
	}
}

void NeuroGame::Invalidate(ZoneType Zone)
{
	if ((Zone & ZoneType::Room) != ZoneType::None)
	{
		ScreenSprite->ClearImages();
		
		string BackgroundImage;
		State.CurrentRoom->LuaSystem->GetStringValue(State.CurrentRoom, "name", BackgroundImage);
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

	if ((Zone & ZoneType::Info) != ZoneType::None)
	{
		InfoBox->SetText(State.GetCurrentInfoText());
	}
	

//	if ((Zone & ZoneType::Inventory) != ZoneType::None)
//	{
//		if (State.IsShowingInventory())
//		{
//			OpenBoxByName("InvBox");
//		}
//	}

//	if ((Zone & ZoneType::PAX) != ZoneType::None)
//	{
//		PAX->RemoveFromParent();
//		if (State.IsShowingPAX())
//		{
//			PAX->Open();
//			Background->AddChild(PAX);
//		}
//	}

//	if ((Zone & ZoneType::Site) != ZoneType::None)
//	{
//		WebSite->RemoveFromParent();
//		if (State.IsShowingSite())
//		{
//			// need to lowercase to look up an object, there's no case insensitive object lookup :|
//			LuaRef Site = State.GetTableValue(State.GetStringValue("currentsite"));
//			WebSite->Open(Site);
//			Background->AddChild(WebSite);
//		}
//	}
}
