//
//  ScrollyGame.cpp
//  Wofl
//
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "ScrollyGame.h"
#include "WoflWorld.h"
#include "WoflRenderer.h"
#include "SPlayer.h"

WoflGame* GlobalGameInitialization()
{
	return new ScrollyGame;
}

// construt the world
ScrollyGame::ScrollyGame()
	: WoflGame("Scrolly")
{
	// this just makes background white for now
	Vector ViewSize = WoflRenderer::Renderer->GetViewSize();
	
	WoflSprite* Root = new WoflSprite(0, 0, ViewSize.X, ViewSize.Y, Tag_Level);
//	WoflSprite* Background = new WoflSprite(0, 0, ViewSize.X, ViewSize.Y);
//	WoflImage* Hex = new WoflImage("Hex", 0.5, 0.5, 0.01, 0.01);
//	//WoflImage* Hex = new WoflImage("Font", 0, 0, 1, 1);
//	Background->AddImage(Hex);
//	Background->SetColor(0.7f, 0.2f, 0.2f);
	WoflWorld::Get()->SetRootSprite(Root);
	

	for (int LayerIndex = 0; LayerIndex < NumLayers; LayerIndex++)
	{
		
		float ScrollSpeed;
		switch (LayerIndex)
		{
			case Background:
				ScrollSpeed = 1.0f;
				break;
			case Game:
				ScrollSpeed = 3.0f;
				break;
			case Foreground:
				ScrollSpeed = 3.0f;
				break;
		}

		// make the layers a little bigger than the view
		Layers[LayerIndex] = new Layer(ScrollSpeed, ViewSize + Vector(128, 0));
		Root->AddChild(Layers[LayerIndex]);
		
		if (LayerIndex == Game)
		{
			// make sure to inject the player right after the game
			Player = new SPlayer(50, 32);
			Root->AddChild(Player);
		}
	}

	// add some sprites
	int NumTrees = 3;
	for (int TreeIndex = 0; TreeIndex < NumTrees; TreeIndex++)
	{
		WoflSprite* Tree = new WoflSprite(0 + 200 * TreeIndex, 64, 32, 64, Tag_Level);
		Tree->AddImage(new WoflImage("Tree", 0, 0, 1, 1));
		Layers[Background]->AddChild(Tree);
	}
	
	int NumGrounds = (Layers[Game]->GetSize().X + 31) / 32 + 1;
	for (int GroundIndex = 0; GroundIndex < NumGrounds; GroundIndex++)
	{
		WoflSprite* Ground = new WoflSprite(GroundIndex * 32, 0, 32, 32, Tag_Level);
		//	Ground->SetBoxCollision();
		Ground->AddImage(new WoflImage("Ground", 0, 0, 1, 1));
		Layers[Game]->AddChild(Ground);
	}

	int NumBushes = 6;
	for (int BushIndex = 0; BushIndex < NumBushes; BushIndex++)
	{
		WoflSprite* Bush = new WoflSprite(30 + 100 * BushIndex, 32, 32, 32, Tag_Level);
		Bush->AddImage(new WoflImage("Tree", 0, 0.5, 1, 0.5));
		Layers[Foreground]->AddChild(Bush);
	}
}

void ScrollyGame::Tick(float DeltaTime)
{
	WoflGame::Tick(DeltaTime);
	
	// scroll the layers
	for (int LayerIndex = 0; LayerIndex < NumLayers; LayerIndex++)
	{
		if (Layers[LayerIndex]->GetChild() != NULL)
		{
			WoflWorld::Get()->Visit(true, true, , <#bool bDepthFirst#>, <#bool bForCollision#>, <#const function<bool (WoflSprite *)> &VisitFunction#>)
			for (WoflWorld::Iterator It = WoflWorld::Get()->GetIterator(Layers[LayerIndex]->GetChild()); It; ++It)
			{
				WoflSprite* Sprite = It.Sprite;
				Sprite->SetPosition(Sprite->GetPosition() + Vector(-Layers[LayerIndex]->ScrollSpeed, 0));

				// if it falls off, wrap it around
				if (Sprite->GetPosition().X + Sprite->GetSize().X < Layers[LayerIndex]->GetPosition().X)
				{
					Sprite->SetPosition(Sprite->GetPosition() + Vector(Layers[LayerIndex]->GetSize().X, 0));
				}
			}
		}
	}
}

void ScrollyGame::PostRender()
{
//	WoflRenderer* Renderer = WoflRenderer::Renderer;
}
