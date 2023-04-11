//
//  ScrollyGame.cpp
//  Wofl
//
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "WoflWorld.h"
#include "WoflRenderer.h"
#include "WoflAtlases.h"
#include "BTGame.h"
#include "BTPlayer.h"
#include "BTLevel.h"

WoflGame* GlobalGameInitialization()
{
	return new BTGame;
}

// construt the world
BTGame::BTGame()
	: WoflGame("BurgerThyme")
{
	//load up the atlas for the sprites
	WoflAtlases::LoadAtlas("BurgerThymeAtlas");

	// level is root object
	BTLevel* Level = new BTLevel();
	WoflWorld::Get()->SetRootSprite(Level);
	
	// scale the view to make the level take the whole screen
	Vector ViewSize = WoflRenderer::Renderer->GetViewSize();
	float Scale = ViewSize.Y / Level->GetSize().Y;
	WoflWorld::Get()->SetViewScale(Vector(Scale, Scale));
}

void BTGame::Tick(float DeltaTime)
{
	WoflGame::Tick(DeltaTime);
	
//	// scroll the layers
//	for (int LayerIndex = 0; LayerIndex < NumLayers; LayerIndex++)
//	{
//		if (Layers[LayerIndex]->GetChild() != NULL)
//		{
//			WoflWorld::Get()->Visit(true, true, , <#bool bDepthFirst#>, <#bool bForCollision#>, <#const function<bool (WoflSprite *)> &VisitFunction#>)
//			for (WoflWorld::Iterator It = WoflWorld::Get()->GetIterator(Layers[LayerIndex]->GetChild()); It; ++It)
//			{
//				WoflSprite* Sprite = It.Sprite;
//				Sprite->SetPosition(Sprite->GetPosition() + Vector(-Layers[LayerIndex]->ScrollSpeed, 0));
//
//				// if it falls off, wrap it around
//				if (Sprite->GetPosition().X + Sprite->GetSize().X < Layers[LayerIndex]->GetPosition().X)
//				{
//					Sprite->SetPosition(Sprite->GetPosition() + Vector(Layers[LayerIndex]->GetSize().X, 0));
//				}
//			}
//		}
//	}
}

void BTGame::PostRender()
{
//	WoflRenderer* Renderer = WoflRenderer::Renderer;
}
