//
//  NeuroGame.cpp
//  Neuro
//
//  Created by Josh Adams on 4/9/23.
//

#include "NeuroGame.h"
#include "Textbox.h"

NeuroGame::NeuroGame()
	: WoflGame("Neuromancer")
{
	WLOG("View size is: %f, %f\n", WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y);

	WoflAtlases::LoadAtlas("Resources/Neuro1");

	WoflSprite* Background = new WoflSprite(0, 0, WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y);
	Background->AddImage(new WoflImage("background"));
	
	WoflSprite* Screen = new WoflSprite(32, 32, 1213, 447);
	Screen->AddImage(new WoflImage("Chiba"));
	
	Textbox* Text = new Textbox(nullptr, 693, 539, 556, 230, 0, true, WColor::Black);
	Text->SetText("You've just spent the night sleeping face-down in a pile of synth-spagetti in a bar called Chatsubo. After rubbint the sauce out of your eyes, you can see Chiba sky through the window, the color of television tuned to a dead channel.\nA PAX booth is on the wall. Ratz's prosthetic Russin arm whines as he wipes the bar. His teeth are a webwork of East Eurpoean steel and brown decay.");

	Background->AddChild(Screen);
	Background->AddChild(Text);

	WoflWorld::Get()->SetRootSprite(Background);
}
