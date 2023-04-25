//
//  NeuroGame.cpp
//  Neuro
//
//  Created by Josh Adams on 4/9/23.
//

#include "NeuroGame.h"
#include "Textbox.h"
#include "Ninebox.h"
#include "NeuroConfig.h"
#include "NeuroScene.h"

NeuroGame::NeuroGame()
	: WoflGame("Neuromancer")
	, State(&Config, this)
{
	WLOG("View size is: %f, %f\n", WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y);
		
	WoflAtlases::LoadAtlas("Neuro1");
	
	WoflSprite* Background = new WoflSprite(0, 0, WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y);
	Background->AddImage(new WoflImage("background"));
	
	ScreenSprite = new NeuroScene(&State, 32, 32, 1213, 447);
	
	MessageBox = new Textbox(nullptr, 693, 539, 556, 230, 0, true, WColor::Black);
	MessageBox->SetInterfaceDelegate(this);
	
	Background->AddChild(ScreenSprite);
	Background->AddChild(MessageBox);
	
	DialogBox = new Ninebox(Ninebox::Basic, 0, 0, ScreenSprite->GetSize().X, 150, 0);
	
	WoflWorld::Get()->SetRootSprite(Background);
}


void NeuroGame::Invalidate(ZoneType Zone)
{
	if ((Zone & ZoneType::Room) != ZoneType::None)
	{
		ScreenSprite->ClearImages();
		ScreenSprite->AddImage(new WoflImage(State.CurrentRoom->BackgroundImage));
	}
	
	if ((Zone & ZoneType::Message) != ZoneType::None)
	{
		MessageBox->SetText(State.GetCurrentMessage());
	}
	
	if ((Zone & ZoneType::Dialog) != ZoneType::None)
	{
		DialogBox->RemoveFromParent();
		string Dialog = State.GetCurrentDialogLine();
		if (Dialog.length() > 0)
		{
			DialogBox->Text->SetText(Dialog);
			ScreenSprite->AddChild(DialogBox);
		}
	}
}
