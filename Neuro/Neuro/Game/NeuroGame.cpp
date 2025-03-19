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

//class DialogInputCatcher : public WoflSprite
//{
//	DialogInputCatcher()
//	{
//		
//	}
//	
//	bool OnKey(const KeyEvent& Event) override
//	{
////		if (IsConversationShowing())
//		{
//			bool bReturn;
//			char Str[2] = { Event.Char, 0 };
//			State.CurrentRoom->LuaSystem->CallFunction_Return(State.CurrentRoom, "ConversationKey", Str, (int)Event.KeyCode, (int)Event.Type, bReturn);
//		}
//
//		return true;
//	}
//}
//

class DialogNineBox : public Ninebox
{
public:
	DialogNineBox(NeuroState* InState, const char* Config[], WoflSprite* AlignWith)
		: Ninebox(Config, AlignWith->GetPosition().X, AlignWith->GetPosition().Y, AlignWith->GetSize().X, 150, Tag_Dialog)
		, State(InState)
	{
		SetClickEnabled(true);
		SetFullScreenInput(true);
	}
	
	// RepeatIndex: 0 is first, > 0 is repeat, < 0 is end)
	virtual void OnInput(const Vector& ScreenLocation, int RepeatIndex) override
	{
		WoflKeys FakeKey = WoflKeys::Space;
		const char* FakeChar = " ";
		
		if (Text->HitTest(ScreenLocation))
		{
			FakeKey = WoflKeys::Enter;
			FakeChar = "\n";
		}
		State->Lua.CallFunction_NoReturn(State->CurrentRoom, "ConversationKey", FakeChar, (int)FakeKey, (int)KeyType::Down);

	}

	// called when key events happen, if this returns true, then it won't go up the sprite hierarchy
	virtual bool OnKey(const KeyEvent& Event) override
	{
		// always suck up all presses that get to us
		if (Event.Type == KeyType::Down)
		{
			//function Room:ConversationKey(char, keyCode, type)
			bool bReturn;
			char Str[2] = { Event.Char, 0 };
			State->Lua.CallFunction_Return(State->CurrentRoom, "ConversationKey", Str, (int)Event.KeyCode, (int)Event.Type, bReturn);
			return bReturn;
		}
		
		return true;
	}
	
	virtual std::string Describe() override
	{
		return std::string("DialogBox");
	}

private:
	NeuroState* State;
};


NeuroGame::NeuroGame()
	: WoflGame("Neuromancer")
	, State(this)
{
	WLOG("View size is: %f, %f\n", WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y);
		
	WoflAtlases::LoadAtlas("Neuro1");
	WoflAtlases::LoadAtlas("Neuro2");

	Background = new WoflSprite(0, 0, WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y);
	Background->AddImage(new WoflImage("background"));
	
	ScreenSprite = new NeuroScene(&State, 32, 32, 1213, 447);
	
	MessageBox = new Textbox(nullptr, 693, 539, 556, 230, 0, true, false, WColor::Black);
	MessageBox->SetInterfaceDelegate(&State);
	
	InfoBox = new Textbox(nullptr, 376, 600, 268, 36, 0, false, false, WColor::Black);
	
	DialogInputSorter = new WoflSprite(0, 0, ScreenSprite->GetSize().X, ScreenSprite->GetSize().Y);
	SiteInputSorter = new WoflSprite(0, 0, ScreenSprite->GetSize().X, ScreenSprite->GetSize().Y);

	Background->AddChild(ScreenSprite);
	Background->AddChild(DialogInputSorter);
	
	int Top = 580;
	int Left = 58;
	int Size = 94;
	ButtonContainer = new WoflSprite(Left, Top, Size * 3, Size * 2);
	DialogInputSorter->AddChild(ButtonContainer);
	
	InvButton    = new WoflButton(nullptr, nullptr, 0 * Size, 0 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickInventory(); });
	ButtonContainer->AddChild(InvButton);
	InvButton->SetKeycodeShortcut(WoflKeys::I);

	WoflButton* SkillButton  = new WoflButton(nullptr, nullptr, 0 * Size, 1 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickSkill(); });
	ButtonContainer->AddChild(SkillButton);
	SkillButton->SetKeycodeShortcut(WoflKeys::S);

//	ButtonContainer->AddChild(SiteInputSorter);
//	SiteInputSorter->SetPosition({0,0});

	WoflButton* PAXButton    = new WoflButton(nullptr, nullptr, 1 * Size, 0 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickPAX(); });
	ButtonContainer->AddChild(PAXButton);
	PAXButton->SetKeycodeShortcut(WoflKeys::P);

	WoflButton* TalkButton   = new WoflButton(nullptr, nullptr, 2 * Size, 0 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickTalk(); });
	ButtonContainer->AddChild(TalkButton);
	TalkButton->SetKeycodeShortcut(WoflKeys::T);

	WoflButton* ChipButton   = new WoflButton(nullptr, nullptr, 1 * Size, 1 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickChip(); });
	ButtonContainer->AddChild(ChipButton);
	ChipButton->SetKeycodeShortcut(WoflKeys::C);

	WoflButton* SystemButton = new WoflButton(nullptr, nullptr, 2 * Size, 1 * Size, Size, Size, 0, [this](WoflButton*) { State.ClickSystem(); });
	ButtonContainer->AddChild(SystemButton);
	SystemButton->SetKeycodeShortcut(WoflKeys::D);
	
	Top = 672;
	Left = 446;
	int SizeX = 66;
	int SizeY = 46;
	WoflButton* DateButton = new WoflButton(nullptr, nullptr, Left + 0 * SizeX, Top + 0 * SizeY, SizeX, SizeY, 0, [this](WoflButton*) { State.ClickDate(); });
	Background->AddChild(DateButton);
	DateButton->SetKeycodeShortcut(WoflKeys::One);
	
	WoflButton* TimeButton = new WoflButton(nullptr, nullptr, Left + 1 * SizeX, Top + 0 * SizeY, SizeX, SizeY, 0, [this](WoflButton*) { State.ClickTime(); });
	Background->AddChild(TimeButton);
	TimeButton->SetKeycodeShortcut(WoflKeys::Two);
	
	WoflButton* MoneyButton = new WoflButton(nullptr, nullptr, Left + 0 * SizeX, Top + 1 * SizeY, SizeX, SizeY, 0, [this](WoflButton*) { State.ClickMoney(); });
	Background->AddChild(MoneyButton);
	MoneyButton->SetKeycodeShortcut(WoflKeys::Three);
	
	WoflButton* HealthButton = new WoflButton(nullptr, nullptr, Left + 1 * SizeX, Top + 1 * SizeY, SizeX, SizeY, 0, [this](WoflButton*) { State.ClickHealth(); });
	Background->AddChild(HealthButton);
	HealthButton->SetKeycodeShortcut(WoflKeys::Four);

	Background->AddChild(MessageBox);
	Background->AddChild(InfoBox);

	
	DialogBox = new DialogNineBox(&State, Ninebox::Basic, ScreenSprite);
	ThoughtBox = new DialogNineBox(&State, Ninebox::Thinking, ScreenSprite);

	WoflWorld::Get()->SetRootSprite(Background);
}

void NeuroGame::ResetLua()
{
	vector<class Gridbox*> Copy = Boxes;
	for (Gridbox* Box : Copy)
	{
		CloseBoxWithObj(Box->LuaBox);
	}
	BoxCache.clear();
}

LuaRef NeuroGame::OpenBoxByName(const char* Name)
{
	LuaRef NewBox;
	State.Lua.GetTableValue("", Name, NewBox);
	if (NewBox == nullptr)
	{
		return nullptr;
	}
	
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
	
	Boxes.push_back(Box);
//	if (DialogInputSorter->IsRooted())
//	{
//		DialogInputSorter->AddChild(Box);
//	}
//	else
	{
//		SiteInputSorter->AddChild(Box);
		Background->AddChild(Box);
	}

	Box->Open(NewBox);

	return NewBox;
}

static Gridbox* GetBoxFromObj(LuaRef BoxRef)
{
	void* BoxThis;
	if (BoxRef->LuaSystem->GetUserDataValue(BoxRef, "cppthis", BoxThis))
	{
		return (Gridbox*)BoxThis;
	}
	
	return nullptr;
}

bool NeuroGame::CloseBoxWithObj(LuaRef BoxObj)
{
	Gridbox* Box = GetBoxFromObj(BoxObj);

	Box->RemoveFromParent();
	BoxCache.push_back(Box);
	Boxes.erase(std::find(Boxes.begin(), Boxes.end(), Box));
	
	return Boxes.size() == 0;
}

bool NeuroGame::ReorderBoxWithObj(LuaRef BoxObj, int Mode)
{
	Gridbox* Box = GetBoxFromObj(BoxObj);

	if (Mode == 0)
	{
		Vector AbsPos = InvButton->GetPosition();
		InvButton->RemoveFromParent();
		ButtonContainer->AddChild(InvButton);
		InvButton->SetPosition(AbsPos);
	}
	else if (Mode == 1)
	{
		WLOG("BEFORE:\n");
		WoflWorld::Get()->Visit(false, true, false,	[](WoflSprite* Sprite)
		{
			int D = Sprite->GetDepth();
			for (int i = 0; i < D; i++) WLOG("  ");
			WLOG("%s\n", Sprite->Describe().c_str());
			return true;
		});

		Vector AbsPos = InvButton->GetPosition();
		InvButton->RemoveFromParent();
		Box->AddChild(InvButton);
		InvButton->SetPosition(AbsPos);

		WLOG("AFTER:\n");
		WoflWorld::Get()->Visit(false, true, false,	[](WoflSprite* Sprite)
		{
			int D = Sprite->GetDepth();
			for (int i = 0; i < D; i++) WLOG("  ");
			WLOG("%s\n", Sprite->Describe().c_str());
			return true;
		});

	}
//	Box->RemoveFromParent();
//	BoxCache.push_back(Box);
//	Boxes.erase(std::find(Boxes.begin(), Boxes.end(), Box));
//	
//	return Boxes.size() == 0;
	return true;
}

bool NeuroGame::AreBoxesShowing()
{
	return Boxes.size() > 0;
}

bool NeuroGame::IsConversationShowing()
{
	return !!ThoughtBox->GetParent() || !!DialogBox->GetParent();
//	return DialogInputCatcher->GetParent() != nullptr;
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

bool NeuroGame::OnGlobalKey(const KeyEvent& Event)
{
	if (Event.KeyCode == WoflKeys::F1)
	{
		State.ReloadLua();
		return true;
	}
	
	return false;
	
	
	// some things need to handle key presses outside of a singular sprite
	// like [MORE] message box
	
	// any key while message box needs more iadvances it
	if (IsMessageActive())
	{
		MessageBox->OnClick();
		return true;
	}
	
	return false;
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
		bool bNeedsPause;		
		MessageBox->SetText(State.GetCurrentMessage(bNeedsPause), bNeedsPause);
	}
	
	if ((Zone & ZoneType::Dialog) != ZoneType::None)
	{
//		DialogInputSorter->RemoveFromParent();
		DialogBox->RemoveFromParent();
		ThoughtBox->RemoveFromParent();
		std::string Line;
		int Speaker;
		bool bIsThought;
		bool bHasTextEntry;
		if (State.GetCurrentDialogLine(Line, Speaker, bIsThought, bHasTextEntry))
		{
			if (bHasTextEntry)
			{
				Line += "\n-----------------------";
			}
//			ScreenSprite->AddChild(DialogInputCatcher);
			if (bIsThought)
			{
				ThoughtBox->Text->SetText(Line);
				DialogInputSorter->AddChild(ThoughtBox);
			}
			else
			{
				DialogBox->Text->SetText(Line);
				DialogInputSorter->AddChild(DialogBox);
			}
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
