//
//  OustGame.cpp
//  Wofl
//
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "OustGame.h"
#include "WoflWorld.h"
#include "WoflRenderer.h"
#include "OustCell.h"

WoflGame* GlobalGameInitialization()
{
	return new OustGame();
}

// construt the world
OustGame::OustGame()
: WoflGame("Oust")
{
	// this just makes background white for now
	Vector ViewSize = WoflRenderer::Renderer->GetViewSize();
	WoflSprite* Background = new WoflSprite(0, 0, ViewSize.X, ViewSize.Y, Tag_Board);
	WoflImage* Hex = new WoflImage("Hex", 0.5, 0.5, 0.01, 0.01);
	//WoflImage* Hex = new WoflImage("Font", 0, 0, 1, 1);
	Background->AddImage(Hex);
	Background->SetColor(WColor(0.7f, 0.2f, 0.2f, 1.0f));
	WoflWorld::World->SetRootSprite(Background);
	
	// @todo: Make a real board frame sprite
	BoardSprite = Background;
	
	
	// game initialization
	NextTurn = 1;
	EdgeSize = 3;
	assert(EdgeSize > 1);
	
	int NumAcross = EdgeSize * 2 - 1;
	
	float BoardWidth = NumAcross * CELL_SIZE;
	float BoardHeight = CELL_SIZE + (NumAcross - 1) * CELL_SIZE * HEX_MULT;
	float LeftEdge = (ViewSize.X - BoardWidth) * 0.5f;// + CELL_SIZE * 0.5f;
	float TopEdge = (ViewSize.Y - BoardHeight) * 0.5f;// + CELL_SIZE * 0.5f;
	
	int CellIndex = 0;
	for (int y = 0; y < NumAcross; y++)
	{
		float YLoc = TopEdge + y * (CELL_SIZE * HEX_MULT);
		
		float XOffset = LeftEdge;
		int OffsetFromCenter = 0;
		if (y < EdgeSize - 1)
		{
			OffsetFromCenter = (EdgeSize - 1) - y;
		}
		else if (y > EdgeSize - 1)
		{
			OffsetFromCenter = y - (EdgeSize - 1);
		}
		
		XOffset += 0.5f * OffsetFromCenter * CELL_SIZE;
		int NumItems = NumAcross - OffsetFromCenter;
		
		for (int x = 0; x < NumItems; x++)
		{
			
			float XLoc = XOffset + x * CELL_SIZE;
			
			OustCell* NewCell = new OustCell(XLoc, YLoc, CellIndex++, x, y, EdgeSize, NumItems, NumAcross);
			BoardSprite->AddChild(NewCell);
		}
	}
}

void OustGame::Tick(float DeltaTime)
{
	WoflGame::Tick(DeltaTime);
	
	// get recent touches
	vector<TouchEvent> Touches = Utils::Input->GetTouches();
	
	// process each one
	for (int Index = 0; Index < Touches.size(); Index++)
	{
		if (Touches[Index].Type != TouchType::End)
		{
			WoflSprite* HitCell = WoflWorld::World->HitTest(Vector(Touches[Index].X, Touches[Index].Y));
			if (HitCell != NULL && HitCell->GetTag() == Tag_Cell)
			{
				// this is a safe typecast, for now! maybe add tag or something for casting?
				OustCell* Cell = (OustCell*)HitCell;
				
				EPlayType PlayType = Cell->AttemptCapture(NextTurn);
				printf("Play type was = %d\n", PlayType);

				// only in the case NonCapturing do we let the next player go
				if (PlayType == NonCapturing)
				{
					NextTurn = NextTurn == 1 ? 2 : 1;
				}
			}
		}
	}
}

void OustGame::PostRender()
{
	WoflRenderer* Renderer = WoflRenderer::Renderer;
	
	float Scale = 5.0f;
	Vector TitleSize = Renderer->GetStringSize("OUST", Scale);
	Vector Loc((Renderer->GetViewSize().X - TitleSize.X) / 2.0f, Renderer->GetViewSize().Y - TitleSize.Y - 5);
	WoflRenderer::Renderer->DrawString("OUST", Loc, Scale);

	char Desc[32];
	sprintf(Desc, "Current Player: %s", NextTurn == 1 ? "Red" : "Blue");
	Vector StringSize = Renderer->GetStringSize(Desc);
	Loc.X = 0;
	Loc.Y -= StringSize.Y + 5;
	WoflRenderer::Renderer->DrawString(Desc, Loc);
}
