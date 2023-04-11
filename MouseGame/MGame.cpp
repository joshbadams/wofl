//
//  MGame.cpp
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "MGame.h"
#include "MPlayer.h"
#include "MPeg.h"
#include "WoflWorld.h"
#include "WoflApp.h"
#include "WoflRenderer.h"

WoflGame* GlobalGameInitialization()
{
	return new MGame();
}

// construt the world
MGame::MGame()
	: WoflGame("MouseGame")
	, Score(0)
{
	// make the background
	WoflSprite* Background = new WoflSprite(0, 0, 1000, 1000);
	WoflImage* Tree = new WoflImage("Tree", 0.0, 0.0, 1.0, 1.0);
	Background->AddImage(Tree);
	WoflWorld::Get()->SetRootSprite(Background);
	
	// make the pegs
	for (int Y = 0; Y < 5; Y++)
	{
		for (int X = 0; X < 7; X++)
		{
			MPeg* Peg = new MPeg(X * 50 + 90, Y * 30 + 100);
			Background->AddChild(Peg);
		}
	}
	
	// line collision test
	
	WoflImage* A = new WoflImage("Font", 0.0, 0.0, 0.0703125, 0.1171875);
	WoflImage* B = new WoflImage("Font", 0.0703125, 0.0, 0.0703125, 0.1171875);
	WoflSprite* LineStart = new WoflSprite(0, 200, 32, 32);
	LineStart->AddImage(A);
	Background->AddChild(LineStart);
	WoflSprite* LineEnd = new WoflSprite(200, 75, 32, 32);
	LineStart->AddChild(LineEnd);
	LineEnd->AddImage(B);
	LineStart->SetCollisionLine(LineStart->GetPosition(), LineEnd->GetPosition());

	LineStart = new WoflSprite(450, 200, 32, 32);
	LineStart->AddImage(A);
	Background->AddChild(LineStart);
	LineEnd = new WoflSprite(-200, 75, 32, 32);
	LineStart->AddChild(LineEnd);
	LineEnd->AddImage(B);
	LineStart->SetCollisionLine(LineStart->GetPosition(), LineEnd->GetPosition());

	
	// add the player to the world
	Player = new MPlayer;
	Background->AddChild(Player);
}

void MGame::Tick(float DeltaTime)
{
	WoflGame::Tick(DeltaTime);
	
//	static float Alpha;
//	Alpha += DeltaTime * 0.3;
//	if (Alpha > 1.0f)
//	{
//		Alpha -= 1.0f;
//	}
//	
//	WoflWorld::Get()->SetViewScale(Vector(Alpha, Alpha));
//	WoflWorld::Get()->SetViewOffset(Vector(Alpha * 300, Alpha * 300));
	
//	WoflWorld::Get()->SetViewOffset(-(Player->GetPosition() - WoflRenderer::Renderer->GetViewSize() * 0.5f));
	
		
	//	// get recent touches
	//	vector<TouchEvent> Touches = Utils::Input->GetTouches();
	//
	//	// process each one
	//	for (int Index = 0; Index < Touches.size(); Index++)
	//	{
	//		if (Touches[Index].Type != TouchType::End)
	//		{
	//			// single reusable image
	//			WoflImage* Small = new WoflImage("Tree", 0.0, 0.0, 0.5, 0.5);
	//
	//			WoflSprite* Sprite = new WoflSprite(Touches[Index].X - 50, Touches[Index].Y - 50, 100, 100);
	//			Sprite->AddImage(Small);
	//
	//			// add this to the world (child of root)
	//			RootSprite->AddChild(Sprite);
	//		}
	//	}
	//	Utils::Input->Flush();

}

void MGame::PostRender()
{
	char Str[128];
	sprintf(Str, "Score: %d", Score);
	WoflRenderer::Renderer->DrawString(Str, Vector(0, 0), 0.5f);
}
